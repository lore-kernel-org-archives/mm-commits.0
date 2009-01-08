From: akpm@linux-foundation.org
Subject: - cgroups-make-cgroup_path-rcu-safe.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:47:50 -0800
Message-ID: <200901082247.n08Mlo8F027257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761057AbZAHWvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: make cgroup_path() RCU-safe
has been removed from the -mm tree.  Its filename was
     cgroups-make-cgroup_path-rcu-safe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: make cgroup_path() RCU-safe
From: Paul Menage <menage@google.com>

Fix races between /proc/sched_debug by freeing cgroup objects via an RCU
callback.  Thus any cgroup reference obtained from an RCU-safe source will
remain valid during the RCU section.  Since dentries are also RCU-safe,
this allows us to traverse up the tree safely.

Additionally, make cgroup_path() check for a NULL cgrp->dentry to avoid
trying to report a path for a partially-created cgroup.

[lizf@cn.fujitsu.com: call deactive_super() in cgroup_diput()]
Signed-off-by: Paul Menage <menage@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    5 ++++-
 kernel/cgroup.c        |   30 +++++++++++++++++++++---------
 2 files changed, 25 insertions(+), 10 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-make-cgroup_path-rcu-safe include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-make-cgroup_path-rcu-safe
+++ a/include/linux/cgroup.h
@@ -116,7 +116,7 @@ struct cgroup {
 	struct list_head children;	/* my children */
 
 	struct cgroup *parent;	/* my parent */
-	struct dentry *dentry;	  	/* cgroup fs entry */
+	struct dentry *dentry;	  	/* cgroup fs entry, RCU protected */
 
 	/* Private pointers for each registered subsystem */
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
@@ -145,6 +145,9 @@ struct cgroup {
 	int pids_use_count;
 	/* Length of the current tasks_pids array */
 	int pids_length;
+
+	/* For RCU-protected deletion */
+	struct rcu_head rcu_head;
 };
 
 /* A css_set is a structure holding pointers to a set of
diff -puN kernel/cgroup.c~cgroups-make-cgroup_path-rcu-safe kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-make-cgroup_path-rcu-safe
+++ a/kernel/cgroup.c
@@ -271,7 +271,7 @@ static void __put_css_set(struct css_set
 
 	rcu_read_lock();
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-		struct cgroup *cgrp = cg->subsys[i]->cgroup;
+		struct cgroup *cgrp = rcu_dereference(cg->subsys[i]->cgroup);
 		if (atomic_dec_and_test(&cgrp->count) &&
 		    notify_on_release(cgrp)) {
 			if (taskexit)
@@ -594,6 +594,13 @@ static void cgroup_call_pre_destroy(stru
 	return;
 }
 
+static void free_cgroup_rcu(struct rcu_head *obj)
+{
+	struct cgroup *cgrp = container_of(obj, struct cgroup, rcu_head);
+
+	kfree(cgrp);
+}
+
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 {
 	/* is dentry a directory ? if so, kfree() associated cgroup */
@@ -619,11 +626,13 @@ static void cgroup_diput(struct dentry *
 		cgrp->root->number_of_cgroups--;
 		mutex_unlock(&cgroup_mutex);
 
-		/* Drop the active superblock reference that we took when we
-		 * created the cgroup */
+		/*
+		 * Drop the active superblock reference that we took when we
+		 * created the cgroup
+		 */
 		deactivate_super(cgrp->root->sb);
 
-		kfree(cgrp);
+		call_rcu(&cgrp->rcu_head, free_cgroup_rcu);
 	}
 	iput(inode);
 }
@@ -1134,14 +1143,16 @@ static inline struct cftype *__d_cft(str
  * @buf: the buffer to write the path into
  * @buflen: the length of the buffer
  *
- * Called with cgroup_mutex held. Writes path of cgroup into buf.
- * Returns 0 on success, -errno on error.
+ * Called with cgroup_mutex held or else with an RCU-protected cgroup
+ * reference.  Writes path of cgroup into buf.  Returns 0 on success,
+ * -errno on error.
  */
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 {
 	char *start;
+	struct dentry *dentry = rcu_dereference(cgrp->dentry);
 
-	if (cgrp == dummytop) {
+	if (!dentry || cgrp == dummytop) {
 		/*
 		 * Inactive subsystems have no dentry for their root
 		 * cgroup
@@ -1154,13 +1165,14 @@ int cgroup_path(const struct cgroup *cgr
 
 	*--start = '\0';
 	for (;;) {
-		int len = cgrp->dentry->d_name.len;
+		int len = dentry->d_name.len;
 		if ((start -= len) < buf)
 			return -ENAMETOOLONG;
 		memcpy(start, cgrp->dentry->d_name.name, len);
 		cgrp = cgrp->parent;
 		if (!cgrp)
 			break;
+		dentry = rcu_dereference(cgrp->dentry);
 		if (!cgrp->parent)
 			continue;
 		if (--start < buf)
@@ -1663,7 +1675,7 @@ static int cgroup_create_dir(struct cgro
 	if (!error) {
 		dentry->d_fsdata = cgrp;
 		inc_nlink(parent->d_inode);
-		cgrp->dentry = dentry;
+		rcu_assign_pointer(cgrp->dentry, dentry);
 		dget(dentry);
 	}
 	dput(dentry);
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
add-a-refcount-check-in-dput.patch

