From: akpm@linux-foundation.org
Subject: + cgroups-revert-cgroups-fix-pid-namespace-bug.patch added to -mm tree
Date: Thu, 20 Aug 2009 14:14:06 -0700
Message-ID: <200908202114.n7KLE6GK026114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929AbZHTVTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 17:19:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com, oleg@redhat.com, torvalds@linux-foundation.org


The patch titled
     cgroups: revert "cgroups: fix pid namespace bug"
has been added to the -mm tree.  Its filename is
     cgroups-revert-cgroups-fix-pid-namespace-bug.patch

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
Subject: cgroups: revert "cgroups: fix pid namespace bug"
From: Paul Menage <menage@google.com>

The following series adds a "cgroup.procs" file to each cgroup that
reports unique tgids rather than pids, and allows all threads in a
threadgroup to be atomically moved to a new cgroup.

The subsystem "attach" interface is modified to support attaching whole
threadgroups at a time, which could introduce potential problems if any
subsystem were to need to access the old cgroup of every thread being
moved.  The attach interface may need to be revised if this becomes the
case.

Also added is functionality for read/write locking all CLONE_THREAD
fork()ing within a threadgroup, by means of an rwsem that lives in the
sighand_struct, for per-threadgroup-ness and also for sharing a cacheline
with the sighand's atomic count.  This scheme should introduce no extra
overhead in the fork path when there's no contention.

The final patch reveals potential for a race when forking before a
subsystem's attach function is called - one potential solution in case any
subsystem has this problem is to hang on to the group's fork mutex through
the attach() calls, though no subsystem yet demonstrates need for an
extended critical section.



This patch:

Revert

commit 096b7fe012d66ed55e98bc8022405ede0cc80e96
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed Jul 29 15:04:04 2009 -0700
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Wed Jul 29 19:10:35 2009 -0700

    cgroups: fix pid namespace bug


This is in preparation for some clashing cgroups changes that subsume the
original commit's functionaliy.

The original commit fixed a pid namespace bug which Ben Blum fixed
independently (in the same way, but with different code) as part of a
series of patches.  I played around with trying to reconcile Ben's patch
series with Li's patch, but concluded that it was simpler to just revert
Li's, given that Ben's patch series contained essentially the same fix.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   11 ++--
 kernel/cgroup.c        |   95 +++++++++------------------------------
 2 files changed, 31 insertions(+), 75 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-revert-cgroups-fix-pid-namespace-bug include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-revert-cgroups-fix-pid-namespace-bug
+++ a/include/linux/cgroup.h
@@ -179,11 +179,14 @@ struct cgroup {
 	 */
 	struct list_head release_list;
 
-	/* pids_mutex protects pids_list and cached pid arrays. */
+	/* pids_mutex protects the fields below */
 	struct rw_semaphore pids_mutex;
-
-	/* Linked list of struct cgroup_pids */
-	struct list_head pids_list;
+	/* Array of process ids in the cgroup */
+	pid_t *tasks_pids;
+	/* How many files are using the current tasks_pids array */
+	int pids_use_count;
+	/* Length of the current tasks_pids array */
+	int pids_length;
 
 	/* For RCU-protected deletion */
 	struct rcu_head rcu_head;
diff -puN kernel/cgroup.c~cgroups-revert-cgroups-fix-pid-namespace-bug kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-revert-cgroups-fix-pid-namespace-bug
+++ a/kernel/cgroup.c
@@ -1121,7 +1121,6 @@ static void init_cgroup_housekeeping(str
 	INIT_LIST_HEAD(&cgrp->children);
 	INIT_LIST_HEAD(&cgrp->css_sets);
 	INIT_LIST_HEAD(&cgrp->release_list);
-	INIT_LIST_HEAD(&cgrp->pids_list);
 	init_rwsem(&cgrp->pids_mutex);
 }
 
@@ -2431,30 +2430,12 @@ err:
 	return ret;
 }
 
-/*
- * Cache pids for all threads in the same pid namespace that are
- * opening the same "tasks" file.
- */
-struct cgroup_pids {
-	/* The node in cgrp->pids_list */
-	struct list_head list;
-	/* The cgroup those pids belong to */
-	struct cgroup *cgrp;
-	/* The namepsace those pids belong to */
-	struct pid_namespace *ns;
-	/* Array of process ids in the cgroup */
-	pid_t *tasks_pids;
-	/* How many files are using the this tasks_pids array */
-	int use_count;
-	/* Length of the current tasks_pids array */
-	int length;
-};
-
 static int cmppid(const void *a, const void *b)
 {
 	return *(pid_t *)a - *(pid_t *)b;
 }
 
+
 /*
  * seq_file methods for the "tasks" file. The seq_file position is the
  * next pid to display; the seq_file iterator is a pointer to the pid
@@ -2469,47 +2450,45 @@ static void *cgroup_tasks_start(struct s
 	 * after a seek to the start). Use a binary-search to find the
 	 * next pid to display, if any
 	 */
-	struct cgroup_pids *cp = s->private;
-	struct cgroup *cgrp = cp->cgrp;
+	struct cgroup *cgrp = s->private;
 	int index = 0, pid = *pos;
 	int *iter;
 
 	down_read(&cgrp->pids_mutex);
 	if (pid) {
-		int end = cp->length;
+		int end = cgrp->pids_length;
 
 		while (index < end) {
 			int mid = (index + end) / 2;
-			if (cp->tasks_pids[mid] == pid) {
+			if (cgrp->tasks_pids[mid] == pid) {
 				index = mid;
 				break;
-			} else if (cp->tasks_pids[mid] <= pid)
+			} else if (cgrp->tasks_pids[mid] <= pid)
 				index = mid + 1;
 			else
 				end = mid;
 		}
 	}
 	/* If we're off the end of the array, we're done */
-	if (index >= cp->length)
+	if (index >= cgrp->pids_length)
 		return NULL;
 	/* Update the abstract position to be the actual pid that we found */
-	iter = cp->tasks_pids + index;
+	iter = cgrp->tasks_pids + index;
 	*pos = *iter;
 	return iter;
 }
 
 static void cgroup_tasks_stop(struct seq_file *s, void *v)
 {
-	struct cgroup_pids *cp = s->private;
-	struct cgroup *cgrp = cp->cgrp;
+	struct cgroup *cgrp = s->private;
 	up_read(&cgrp->pids_mutex);
 }
 
 static void *cgroup_tasks_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct cgroup_pids *cp = s->private;
+	struct cgroup *cgrp = s->private;
 	int *p = v;
-	int *end = cp->tasks_pids + cp->length;
+	int *end = cgrp->tasks_pids + cgrp->pids_length;
 
 	/*
 	 * Advance to the next pid in the array. If this goes off the
@@ -2536,33 +2515,26 @@ static const struct seq_operations cgrou
 	.show = cgroup_tasks_show,
 };
 
-static void release_cgroup_pid_array(struct cgroup_pids *cp)
+static void release_cgroup_pid_array(struct cgroup *cgrp)
 {
-	struct cgroup *cgrp = cp->cgrp;
-
 	down_write(&cgrp->pids_mutex);
-	BUG_ON(!cp->use_count);
-	if (!--cp->use_count) {
-		list_del(&cp->list);
-		put_pid_ns(cp->ns);
-		kfree(cp->tasks_pids);
-		kfree(cp);
+	BUG_ON(!cgrp->pids_use_count);
+	if (!--cgrp->pids_use_count) {
+		kfree(cgrp->tasks_pids);
+		cgrp->tasks_pids = NULL;
+		cgrp->pids_length = 0;
 	}
 	up_write(&cgrp->pids_mutex);
 }
 
 static int cgroup_tasks_release(struct inode *inode, struct file *file)
 {
-	struct seq_file *seq;
-	struct cgroup_pids *cp;
+	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
 
 	if (!(file->f_mode & FMODE_READ))
 		return 0;
 
-	seq = file->private_data;
-	cp = seq->private;
-
-	release_cgroup_pid_array(cp);
+	release_cgroup_pid_array(cgrp);
 	return seq_release(inode, file);
 }
 
@@ -2581,8 +2553,6 @@ static struct file_operations cgroup_tas
 static int cgroup_tasks_open(struct inode *unused, struct file *file)
 {
 	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
-	struct pid_namespace *ns = current->nsproxy->pid_ns;
-	struct cgroup_pids *cp;
 	pid_t *pidarray;
 	int npids;
 	int retval;
@@ -2609,37 +2579,20 @@ static int cgroup_tasks_open(struct inod
 	 * array if necessary
 	 */
 	down_write(&cgrp->pids_mutex);
-
-	list_for_each_entry(cp, &cgrp->pids_list, list) {
-		if (ns == cp->ns)
-			goto found;
-	}
-
-	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
-	if (!cp) {
-		up_write(&cgrp->pids_mutex);
-		kfree(pidarray);
-		return -ENOMEM;
-	}
-	cp->cgrp = cgrp;
-	cp->ns = ns;
-	get_pid_ns(ns);
-	list_add(&cp->list, &cgrp->pids_list);
-found:
-	kfree(cp->tasks_pids);
-	cp->tasks_pids = pidarray;
-	cp->length = npids;
-	cp->use_count++;
+	kfree(cgrp->tasks_pids);
+	cgrp->tasks_pids = pidarray;
+	cgrp->pids_length = npids;
+	cgrp->pids_use_count++;
 	up_write(&cgrp->pids_mutex);
 
 	file->f_op = &cgroup_tasks_operations;
 
 	retval = seq_open(file, &cgroup_tasks_seq_operations);
 	if (retval) {
-		release_cgroup_pid_array(cp);
+		release_cgroup_pid_array(cgrp);
 		return retval;
 	}
-	((struct seq_file *)file->private_data)->private = cp;
+	((struct seq_file *)file->private_data)->private = cgrp;
 	return 0;
 }
 
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
linux-next.patch
mm-remove-obsoleted-alloc_pages-cpuset-comment.patch
cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
cgroups-revert-cgroups-fix-pid-namespace-bug.patch
cgroups-add-a-read-only-procs-file-similar-to-tasks-that-shows-only-unique-tgids.patch
cgroups-ensure-correct-concurrent-opening-reading-of-pidlists-across-pid-namespaces.patch
cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations.patch
cgroups-change-css_set-freeing-mechanism-to-be-under-rcu.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
cgroups-add-ability-to-move-all-threads-in-a-process-to-a-new-cgroup-atomically.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
add-a-refcount-check-in-dput.patch

