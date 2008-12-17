From: akpm@linux-foundation.org
Subject: + cgroups-make-cgroup_path-rcu-safe.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:42:26 -0800
Message-ID: <200812172242.mBHMgQCC019271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbYLQWml (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:42:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com


The patch titled
     cgroups: make cgroup_path() RCU-safe
has been added to the -mm tree.  Its filename is
     cgroups-make-cgroup_path-rcu-safe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Paul Menage <menage@google.com>
Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
Tested-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   11 ++++++++++-
 kernel/cgroup.c        |   33 ++++++++++++++++++++++-----------
 2 files changed, 32 insertions(+), 12 deletions(-)

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
@@ -305,6 +308,12 @@ int cgroup_add_files(struct cgroup *cgrp
 
 int cgroup_is_removed(const struct cgroup *cgrp);
 
+/*
+ * cgroup_path() fills in a filesystem-like path for the given cgroup
+ * into "buf", up to "buflen" characters. Should be called with
+ * cgroup_mutex held, or else in an RCU section with an RCU-protected
+ * cgroup reference
+ */
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
 
 int cgroup_task_count(const struct cgroup *cgrp);
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
@@ -595,6 +595,18 @@ static void cgroup_call_pre_destroy(stru
 	return;
 }
 
+static void free_cgroup_rcu(struct rcu_head *obj)
+{
+	struct cgroup *cgrp = container_of(obj, struct cgroup, rcu_head);
+	/*
+	 * Drop the active superblock reference that we took when we
+	 * created the cgroup
+	 */
+	deactivate_super(cgrp->root->sb);
+
+	kfree(cgrp);
+}
+
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 {
 	/* is dentry a directory ? if so, kfree() associated cgroup */
@@ -620,11 +632,7 @@ static void cgroup_diput(struct dentry *
 		cgrp->root->number_of_cgroups--;
 		mutex_unlock(&cgroup_mutex);
 
-		/* Drop the active superblock reference that we took when we
-		 * created the cgroup */
-		deactivate_super(cgrp->root->sb);
-
-		kfree(cgrp);
+		call_rcu(&cgrp->rcu_head, free_cgroup_rcu);
 	}
 	iput(inode);
 }
@@ -1134,14 +1142,16 @@ static inline struct cftype *__d_cft(str
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
@@ -1154,13 +1164,14 @@ int cgroup_path(const struct cgroup *cgr
 
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
@@ -1663,7 +1674,7 @@ static int cgroup_create_dir(struct cgro
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
linux-next.patch
cpuacct-refactoring-cpuusage_read-cpuusage_write.patch
cpuacct-export-percpu-cpuacct-cgroup-stats.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed.patch
oom-print-triggering-tasks-cpuset-and-mems-allowed-fix.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
cgroups-make-cgroup-config-a-submenu.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch
cgroups-fix-cgroup_iter_next-bug.patch
cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch
cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch
cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch
cgroups-remove-rcu_read_lock-in-cgroupstats_build.patch
cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list-fix.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch
cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup-checkpatch-fixes.patch
cgroups-make-cgroup_path-rcu-safe.patch
devcgroup-use-list_for_each_entry_rcu.patch
devices-cgroup-allow-mkfifo.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch
cgroups-add-a-per-subsystem-hierarchy_mutex.patch
cgroups-use-hierarchy_mutex-in-memory-controller.patch
cgroups-add-css_tryget.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch
add-a-refcount-check-in-dput.patch

