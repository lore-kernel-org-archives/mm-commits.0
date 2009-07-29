From: akpm@linux-foundation.org
Subject: [folded] cgroups-fix-pid-namespace-bug-fix.patch removed from -mm tree
Date: Wed, 29 Jul 2009 14:51:11 -0700
Message-ID: <200907292151.n6TLpBNS030330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753253AbZG2Vv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 17:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, menage@google.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: fix pid namespace bug, fix
has been removed from the -mm tree.  Its filename was
     cgroups-fix-pid-namespace-bug-fix.patch

This patch was dropped because it was folded into cgroups-fix-pid-namespace-bug.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: fix pid namespace bug, fix
From: Li Zefan <lizf@cn.fujitsu.com>

- add get_pid_ns()/put_pid_ns()
- remove prefix "pids_"

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Reviewed-by: Serge Hallyn <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff -puN kernel/cgroup.c~cgroups-fix-pid-namespace-bug-fix kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-pid-namespace-bug-fix
+++ a/kernel/cgroup.c
@@ -2214,13 +2214,13 @@ struct cgroup_pids {
 	/* The cgroup those pids belong to */
 	struct cgroup *cgrp;
 	/* The namepsace those pids belong to */
-	struct pid_namespace *pid_ns;
+	struct pid_namespace *ns;
 	/* Array of process ids in the cgroup */
 	pid_t *tasks_pids;
 	/* How many files are using the this tasks_pids array */
-	int pids_use_count;
+	int use_count;
 	/* Length of the current tasks_pids array */
-	int pids_length;
+	int length;
 };
 
 static int cmppid(const void *a, const void *b)
@@ -2249,7 +2249,7 @@ static void *cgroup_tasks_start(struct s
 
 	down_read(&cgrp->pids_mutex);
 	if (pid) {
-		int end = cp->pids_length;
+		int end = cp->length;
 
 		while (index < end) {
 			int mid = (index + end) / 2;
@@ -2263,7 +2263,7 @@ static void *cgroup_tasks_start(struct s
 		}
 	}
 	/* If we're off the end of the array, we're done */
-	if (index >= cp->pids_length)
+	if (index >= cp->length)
 		return NULL;
 	/* Update the abstract position to be the actual pid that we found */
 	iter = cp->tasks_pids + index;
@@ -2282,7 +2282,7 @@ static void *cgroup_tasks_next(struct se
 {
 	struct cgroup_pids *cp = s->private;
 	int *p = v;
-	int *end = cp->tasks_pids + cp->pids_length;
+	int *end = cp->tasks_pids + cp->length;
 
 	/*
 	 * Advance to the next pid in the array. If this goes off the
@@ -2314,9 +2314,10 @@ static void release_cgroup_pid_array(str
 	struct cgroup *cgrp = cp->cgrp;
 
 	down_write(&cgrp->pids_mutex);
-	BUG_ON(!cp->pids_use_count);
-	if (!--cp->pids_use_count) {
+	BUG_ON(!cp->use_count);
+	if (!--cp->use_count) {
 		list_del(&cp->list);
+		put_pid_ns(cp->ns);
 		kfree(cp->tasks_pids);
 		kfree(cp);
 	}
@@ -2353,7 +2354,7 @@ static struct file_operations cgroup_tas
 static int cgroup_tasks_open(struct inode *unused, struct file *file)
 {
 	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
-	struct pid_namespace *pid_ns = task_active_pid_ns(current);
+	struct pid_namespace *ns = current->nsproxy->pid_ns;
 	struct cgroup_pids *cp;
 	pid_t *pidarray;
 	int npids;
@@ -2383,7 +2384,7 @@ static int cgroup_tasks_open(struct inod
 	down_write(&cgrp->pids_mutex);
 
 	list_for_each_entry(cp, &cgrp->pids_list, list) {
-		if (pid_ns == cp->pid_ns)
+		if (ns == cp->ns)
 			goto found;
 	}
 
@@ -2394,13 +2395,14 @@ static int cgroup_tasks_open(struct inod
 		return -ENOMEM;
 	}
 	cp->cgrp = cgrp;
-	cp->pid_ns = pid_ns;
+	cp->ns = ns;
+	get_pid_ns(ns);
 	list_add(&cp->list, &cgrp->pids_list);
 found:
 	kfree(cp->tasks_pids);
 	cp->tasks_pids = pidarray;
-	cp->pids_length = npids;
-	cp->pids_use_count++;
+	cp->length = npids;
+	cp->use_count++;
 	up_write(&cgrp->pids_mutex);
 
 	file->f_op = &cgroup_tasks_operations;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

cgroups-fix-pid-namespace-bug.patch
cgroups-fix-pid-namespace-bug-fix.patch
linux-next.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch

