From: akpm@linux-foundation.org
Subject: + cgroups-fix-pid-namespace-bug.patch added to -mm tree
Date: Thu, 02 Jul 2009 16:20:51 -0700
Message-ID: <200907022320.n62NKpKO022860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbZGBXVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 19:21:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, balbir@in.ibm.com, menage@google.com, serue@us.ibm.com


The patch titled
     cgroups: fix pid namespace bug
has been added to the -mm tree.  Its filename is
     cgroups-fix-pid-namespace-bug.patch

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
Subject: cgroups: fix pid namespace bug
From: Li Zefan <lizf@cn.fujitsu.com>

The bug was introduced by commit cc31edceee04a7b87f2be48f9489ebb72d264844
("cgroups: convert tasks file to use a seq_file with shared pid array").

We cache a pid array for all threads that are opening the same "tasks"
file, but the pids in the array are always from the namespace of the
last process that opened the file, so all other threads will read pids
from that namespace instead of their own namespaces.

To fix it, we maintain a list of pid arrays, which is keyed by pid_ns.
The list will be of length 1 at most time.

Reported-by: Paul Menage <menage@google.com>
Idea-by: Paul Menage <menage@google.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: Serge Hallyn <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   11 +---
 kernel/cgroup.c        |   94 +++++++++++++++++++++++++++++----------
 2 files changed, 74 insertions(+), 31 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-fix-pid-namespace-bug include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-fix-pid-namespace-bug
+++ a/include/linux/cgroup.h
@@ -179,14 +179,11 @@ struct cgroup {
 	 */
 	struct list_head release_list;
 
-	/* pids_mutex protects the fields below */
+	/* pids_mutex protects pids_list and cached pid arrays. */
 	struct rw_semaphore pids_mutex;
-	/* Array of process ids in the cgroup */
-	pid_t *tasks_pids;
-	/* How many files are using the current tasks_pids array */
-	int pids_use_count;
-	/* Length of the current tasks_pids array */
-	int pids_length;
+
+	/* Linked list of struct cgroup_pids */
+	struct list_head pids_list;
 
 	/* For RCU-protected deletion */
 	struct rcu_head rcu_head;
diff -puN kernel/cgroup.c~cgroups-fix-pid-namespace-bug kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-fix-pid-namespace-bug
+++ a/kernel/cgroup.c
@@ -47,6 +47,7 @@
 #include <linux/hash.h>
 #include <linux/namei.h>
 #include <linux/smp_lock.h>
+#include <linux/pid_namespace.h>
 
 #include <asm/atomic.h>
 
@@ -961,6 +962,7 @@ static void init_cgroup_housekeeping(str
 	INIT_LIST_HEAD(&cgrp->children);
 	INIT_LIST_HEAD(&cgrp->css_sets);
 	INIT_LIST_HEAD(&cgrp->release_list);
+	INIT_LIST_HEAD(&cgrp->pids_list);
 	init_rwsem(&cgrp->pids_mutex);
 }
 static void init_cgroup_root(struct cgroupfs_root *root)
@@ -2202,12 +2204,30 @@ err:
 	return ret;
 }
 
+/*
+ * Cache pids for all threads in the same pid namespace that are
+ * opening the same "tasks" file.
+ */
+struct cgroup_pids {
+	/* The node in cgrp->pids_list */
+	struct list_head list;
+	/* The cgroup those pids belong to */
+	struct cgroup *cgrp;
+	/* The namepsace those pids belong to */
+	struct pid_namespace *pid_ns;
+	/* Array of process ids in the cgroup */
+	pid_t *tasks_pids;
+	/* How many files are using the this tasks_pids array */
+	int pids_use_count;
+	/* Length of the current tasks_pids array */
+	int pids_length;
+};
+
 static int cmppid(const void *a, const void *b)
 {
 	return *(pid_t *)a - *(pid_t *)b;
 }
 
-
 /*
  * seq_file methods for the "tasks" file. The seq_file position is the
  * next pid to display; the seq_file iterator is a pointer to the pid
@@ -2222,45 +2242,47 @@ static void *cgroup_tasks_start(struct s
 	 * after a seek to the start). Use a binary-search to find the
 	 * next pid to display, if any
 	 */
-	struct cgroup *cgrp = s->private;
+	struct cgroup_pids *cp = s->private;
+	struct cgroup *cgrp = cp->cgrp;
 	int index = 0, pid = *pos;
 	int *iter;
 
 	down_read(&cgrp->pids_mutex);
 	if (pid) {
-		int end = cgrp->pids_length;
+		int end = cp->pids_length;
 
 		while (index < end) {
 			int mid = (index + end) / 2;
-			if (cgrp->tasks_pids[mid] == pid) {
+			if (cp->tasks_pids[mid] == pid) {
 				index = mid;
 				break;
-			} else if (cgrp->tasks_pids[mid] <= pid)
+			} else if (cp->tasks_pids[mid] <= pid)
 				index = mid + 1;
 			else
 				end = mid;
 		}
 	}
 	/* If we're off the end of the array, we're done */
-	if (index >= cgrp->pids_length)
+	if (index >= cp->pids_length)
 		return NULL;
 	/* Update the abstract position to be the actual pid that we found */
-	iter = cgrp->tasks_pids + index;
+	iter = cp->tasks_pids + index;
 	*pos = *iter;
 	return iter;
 }
 
 static void cgroup_tasks_stop(struct seq_file *s, void *v)
 {
-	struct cgroup *cgrp = s->private;
+	struct cgroup_pids *cp = s->private;
+	struct cgroup *cgrp = cp->cgrp;
 	up_read(&cgrp->pids_mutex);
 }
 
 static void *cgroup_tasks_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct cgroup *cgrp = s->private;
+	struct cgroup_pids *cp = s->private;
 	int *p = v;
-	int *end = cgrp->tasks_pids + cgrp->pids_length;
+	int *end = cp->tasks_pids + cp->pids_length;
 
 	/*
 	 * Advance to the next pid in the array. If this goes off the
@@ -2287,26 +2309,32 @@ static struct seq_operations cgroup_task
 	.show = cgroup_tasks_show,
 };
 
-static void release_cgroup_pid_array(struct cgroup *cgrp)
+static void release_cgroup_pid_array(struct cgroup_pids *cp)
 {
+	struct cgroup *cgrp = cp->cgrp;
+
 	down_write(&cgrp->pids_mutex);
-	BUG_ON(!cgrp->pids_use_count);
-	if (!--cgrp->pids_use_count) {
-		kfree(cgrp->tasks_pids);
-		cgrp->tasks_pids = NULL;
-		cgrp->pids_length = 0;
+	BUG_ON(!cp->pids_use_count);
+	if (!--cp->pids_use_count) {
+		list_del(&cp->list);
+		kfree(cp->tasks_pids);
+		kfree(cp);
 	}
 	up_write(&cgrp->pids_mutex);
 }
 
 static int cgroup_tasks_release(struct inode *inode, struct file *file)
 {
-	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
+	struct seq_file *seq;
+	struct cgroup_pids *cp;
 
 	if (!(file->f_mode & FMODE_READ))
 		return 0;
 
-	release_cgroup_pid_array(cgrp);
+	seq = file->private_data;
+	cp = seq->private;
+
+	release_cgroup_pid_array(cp);
 	return seq_release(inode, file);
 }
 
@@ -2325,6 +2353,8 @@ static struct file_operations cgroup_tas
 static int cgroup_tasks_open(struct inode *unused, struct file *file)
 {
 	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
+	struct pid_namespace *pid_ns = task_active_pid_ns(current);
+	struct cgroup_pids *cp;
 	pid_t *pidarray;
 	int npids;
 	int retval;
@@ -2351,20 +2381,36 @@ static int cgroup_tasks_open(struct inod
 	 * array if necessary
 	 */
 	down_write(&cgrp->pids_mutex);
-	kfree(cgrp->tasks_pids);
-	cgrp->tasks_pids = pidarray;
-	cgrp->pids_length = npids;
-	cgrp->pids_use_count++;
+
+	list_for_each_entry(cp, &cgrp->pids_list, list) {
+		if (pid_ns == cp->pid_ns)
+			goto found;
+	}
+
+	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
+	if (!cp) {
+		up_write(&cgrp->pids_mutex);
+		kfree(pidarray);
+		return -ENOMEM;
+	}
+	cp->cgrp = cgrp;
+	cp->pid_ns = pid_ns;
+	list_add(&cp->list, &cgrp->pids_list);
+found:
+	kfree(cp->tasks_pids);
+	cp->tasks_pids = pidarray;
+	cp->pids_length = npids;
+	cp->pids_use_count++;
 	up_write(&cgrp->pids_mutex);
 
 	file->f_op = &cgroup_tasks_operations;
 
 	retval = seq_open(file, &cgroup_tasks_seq_operations);
 	if (retval) {
-		release_cgroup_pid_array(cgrp);
+		release_cgroup_pid_array(cp);
 		return retval;
 	}
-	((struct seq_file *)file->private_data)->private = cgrp;
+	((struct seq_file *)file->private_data)->private = cp;
 	return 0;
 }
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch
cgroups-fix-pid-namespace-bug.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch

