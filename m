From: akpm@linux-foundation.org
Subject: + cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array.patch added to -mm tree
Date: Mon, 08 Sep 2008 14:16:41 -0700
Message-ID: <200809082116.m88LGfDX010738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754038AbYIHVRb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 17:17:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, laijs@cn.fujitsu.com, serue@us.ibm.com


The patch titled
     cgroups: convert tasks file to use a seq_file with shared pid array
has been added to the -mm tree.  Its filename is
     cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: convert tasks file to use a seq_file with shared pid array
From: Paul Menage <menage@google.com>

Rather than pre-generating the entire text for the "tasks" file each
time the file is opened, we instead just generate/update the array of
process ids and use a seq_file to report these to userspace.  All open
file handles on the same "tasks" file can share a pid array, which may
be updated any time that no thread is actively reading the array.  By
sharing the array, the potential for userspace to DoS the system by
opening many handles on the same "tasks" file is removed.

[Based on a patch by Lai Jiangshan, extended to use seq_file]

Signed-off-by: Paul Menage <menage@google.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |   10 +
 kernel/cgroup.c        |  226 ++++++++++++++++++++++++---------------
 2 files changed, 151 insertions(+), 85 deletions(-)

diff -puN include/linux/cgroup.h~cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array
+++ a/include/linux/cgroup.h
@@ -15,6 +15,7 @@
 #include <linux/rcupdate.h>
 #include <linux/cgroupstats.h>
 #include <linux/prio_heap.h>
+#include <linux/rwsem.h>
 
 #ifdef CONFIG_CGROUPS
 
@@ -137,6 +138,15 @@ struct cgroup {
 	 * release_list_lock
 	 */
 	struct list_head release_list;
+
+	/* pids_mutex protects the fields below */
+	struct rw_semaphore pids_mutex;
+	/* Array of process ids in the cgroup */
+	pid_t *tasks_pids;
+	/* How many files are using the current tasks_pids array */
+	int pids_use_count;
+	/* Length of the current tasks_pids array */
+	int pids_length;
 };
 
 /* A css_set is a structure holding pointers to a set of
diff -puN kernel/cgroup.c~cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array
+++ a/kernel/cgroup.c
@@ -888,6 +888,14 @@ static struct super_operations cgroup_op
 	.remount_fs = cgroup_remount,
 };
 
+static void init_cgroup_housekeeping(struct cgroup *cgrp)
+{
+	INIT_LIST_HEAD(&cgrp->sibling);
+	INIT_LIST_HEAD(&cgrp->children);
+	INIT_LIST_HEAD(&cgrp->css_sets);
+	INIT_LIST_HEAD(&cgrp->release_list);
+	init_rwsem(&cgrp->pids_mutex);
+}
 static void init_cgroup_root(struct cgroupfs_root *root)
 {
 	struct cgroup *cgrp = &root->top_cgroup;
@@ -896,10 +904,7 @@ static void init_cgroup_root(struct cgro
 	root->number_of_cgroups = 1;
 	cgrp->root = root;
 	cgrp->top_cgroup = cgrp;
-	INIT_LIST_HEAD(&cgrp->sibling);
-	INIT_LIST_HEAD(&cgrp->children);
-	INIT_LIST_HEAD(&cgrp->css_sets);
-	INIT_LIST_HEAD(&cgrp->release_list);
+	init_cgroup_housekeeping(cgrp);
 }
 
 static int cgroup_test_super(struct super_block *sb, void *data)
@@ -2018,16 +2023,7 @@ int cgroup_scan_tasks(struct cgroup_scan
  * but we cannot guarantee that the information we produce is correct
  * unless we produce it entirely atomically.
  *
- * Upon tasks file open(), a struct ctr_struct is allocated, that
- * will have a pointer to an array (also allocated here).  The struct
- * ctr_struct * is stored in file->private_data.  Its resources will
- * be freed by release() when the file is closed.  The array is used
- * to sprintf the PIDs and then used by read().
  */
-struct ctr_struct {
-	char *buf;
-	int bufsz;
-};
 
 /*
  * Load into 'pidarray' up to 'npids' of the tasks using cgroup
@@ -2109,42 +2105,132 @@ static int cmppid(const void *a, const v
 	return *(pid_t *)a - *(pid_t *)b;
 }
 
+
 /*
- * Convert array 'a' of 'npids' pid_t's to a string of newline separated
- * decimal pids in 'buf'.  Don't write more than 'sz' chars, but return
- * count 'cnt' of how many chars would be written if buf were large enough.
+ * seq_file methods for the "tasks" file. The seq_file position is the
+ * next pid to display; the seq_file iterator is a pointer to the pid
+ * in the cgroup->tasks_pids array.
  */
-static int pid_array_to_buf(char *buf, int sz, pid_t *a, int npids)
+
+static void *cgroup_tasks_start(struct seq_file *s, loff_t *pos)
 {
-	int cnt = 0;
-	int i;
+	/*
+	 * Initially we receive a position value that corresponds to
+	 * one more than the last pid shown (or 0 on the first call or
+	 * after a seek to the start). Use a binary-search to find the
+	 * next pid to display, if any
+	 */
+	struct cgroup *cgrp = s->private;
+	int index = 0, pid = *pos;
+	int *iter;
+
+	down_read(&cgrp->pids_mutex);
+	if (pid) {
+		int end = cgrp->pids_length;
+		int i;
+		while (index < end) {
+			int mid = (index + end) / 2;
+			if (cgrp->tasks_pids[mid] == pid) {
+				index = mid;
+				break;
+			} else if (cgrp->tasks_pids[mid] <= pid)
+				index = mid + 1;
+			else
+				end = mid;
+		}
+	}
+	/* If we're off the end of the array, we're done */
+	if (index >= cgrp->pids_length)
+		return NULL;
+	/* Update the abstract position to be the actual pid that we found */
+	iter = cgrp->tasks_pids + index;
+	*pos = *iter;
+	return iter;
+}
+
+static void cgroup_tasks_stop(struct seq_file *s, void *v)
+{
+	struct cgroup *cgrp = s->private;
+	up_read(&cgrp->pids_mutex);
+}
+
+static void *cgroup_tasks_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct cgroup *cgrp = s->private;
+	int *p = v;
+	int *end = cgrp->tasks_pids + cgrp->pids_length;
+
+	/*
+	 * Advance to the next pid in the array. If this goes off the
+	 * end, we're done
+	 */
+	p++;
+	if (p >= end) {
+		return NULL;
+	} else {
+		*pos = *p;
+		return p;
+	}
+}
+
+static int cgroup_tasks_show(struct seq_file *s, void *v)
+{
+	return seq_printf(s, "%d\n", *(int *)v);
+}
 
-	for (i = 0; i < npids; i++)
-		cnt += snprintf(buf + cnt, max(sz - cnt, 0), "%d\n", a[i]);
-	return cnt;
+static struct seq_operations cgroup_tasks_seq_operations = {
+	.start = cgroup_tasks_start,
+	.stop = cgroup_tasks_stop,
+	.next = cgroup_tasks_next,
+	.show = cgroup_tasks_show,
+};
+
+static void release_cgroup_pid_array(struct cgroup *cgrp)
+{
+	down_write(&cgrp->pids_mutex);
+	BUG_ON(!cgrp->pids_use_count);
+	if (!--cgrp->pids_use_count) {
+		kfree(cgrp->tasks_pids);
+		cgrp->tasks_pids = NULL;
+		cgrp->pids_length = 0;
+	}
+	up_write(&cgrp->pids_mutex);
+}
+
+static int cgroup_tasks_release(struct inode *inode, struct file *file)
+{
+	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
+
+	if (!(file->f_mode & FMODE_READ))
+		return 0;
+
+	release_cgroup_pid_array(cgrp);
+	return seq_release(inode, file);
 }
 
+static struct file_operations cgroup_tasks_operations = {
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.write = cgroup_file_write,
+	.release = cgroup_tasks_release,
+};
+
 /*
- * Handle an open on 'tasks' file.  Prepare a buffer listing the
+ * Handle an open on 'tasks' file.  Prepare an array containing the
  * process id's of tasks currently attached to the cgroup being opened.
- *
- * Does not require any specific cgroup mutexes, and does not take any.
  */
+
 static int cgroup_tasks_open(struct inode *unused, struct file *file)
 {
 	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
-	struct ctr_struct *ctr;
 	pid_t *pidarray;
 	int npids;
-	char c;
+	int retval;
 
+	/* Nothing to do for write-only files */
 	if (!(file->f_mode & FMODE_READ))
 		return 0;
 
-	ctr = kmalloc(sizeof(*ctr), GFP_KERNEL);
-	if (!ctr)
-		goto err0;
-
 	/*
 	 * If cgroup gets more users after we read count, we won't have
 	 * enough space - tough.  This race is indistinguishable to the
@@ -2152,57 +2238,31 @@ static int cgroup_tasks_open(struct inod
 	 * show up until sometime later on.
 	 */
 	npids = cgroup_task_count(cgrp);
-	if (npids) {
-		pidarray = kmalloc(npids * sizeof(pid_t), GFP_KERNEL);
-		if (!pidarray)
-			goto err1;
-
-		npids = pid_array_load(pidarray, npids, cgrp);
-		sort(pidarray, npids, sizeof(pid_t), cmppid, NULL);
-
-		/* Call pid_array_to_buf() twice, first just to get bufsz */
-		ctr->bufsz = pid_array_to_buf(&c, sizeof(c), pidarray, npids) + 1;
-		ctr->buf = kmalloc(ctr->bufsz, GFP_KERNEL);
-		if (!ctr->buf)
-			goto err2;
-		ctr->bufsz = pid_array_to_buf(ctr->buf, ctr->bufsz, pidarray, npids);
-
-		kfree(pidarray);
-	} else {
-		ctr->buf = NULL;
-		ctr->bufsz = 0;
-	}
-	file->private_data = ctr;
-	return 0;
-
-err2:
-	kfree(pidarray);
-err1:
-	kfree(ctr);
-err0:
-	return -ENOMEM;
-}
-
-static ssize_t cgroup_tasks_read(struct cgroup *cgrp,
-				    struct cftype *cft,
-				    struct file *file, char __user *buf,
-				    size_t nbytes, loff_t *ppos)
-{
-	struct ctr_struct *ctr = file->private_data;
-
-	return simple_read_from_buffer(buf, nbytes, ppos, ctr->buf, ctr->bufsz);
-}
-
-static int cgroup_tasks_release(struct inode *unused_inode,
-					struct file *file)
-{
-	struct ctr_struct *ctr;
+	pidarray = kmalloc(npids * sizeof(pid_t), GFP_KERNEL);
+	if (!pidarray)
+		return -ENOMEM;
+	npids = pid_array_load(pidarray, npids, cgrp);
+	sort(pidarray, npids, sizeof(pid_t), cmppid, NULL);
 
-	if (file->f_mode & FMODE_READ) {
-		ctr = file->private_data;
-		kfree(ctr->buf);
-		kfree(ctr);
+	/*
+	 * Store the array in the cgroup, freeing the old
+	 * array if necessary
+	 */
+	down_write(&cgrp->pids_mutex);
+	kfree(cgrp->tasks_pids);
+	cgrp->tasks_pids = pidarray;
+	cgrp->pids_length = npids;
+	cgrp->pids_use_count++;
+	up_write(&cgrp->pids_mutex);
+
+	file->f_op = &cgroup_tasks_operations;
+
+	retval = seq_open(file, &cgroup_tasks_seq_operations);
+	if (retval) {
+		release_cgroup_pid_array(cgrp);
+		return retval;
 	}
+	((struct seq_file *)file->private_data)->private = cgrp;
 	return 0;
 }
 
@@ -2231,7 +2291,6 @@ static struct cftype files[] = {
 	{
 		.name = "tasks",
 		.open = cgroup_tasks_open,
-		.read = cgroup_tasks_read,
 		.write_u64 = cgroup_tasks_write,
 		.release = cgroup_tasks_release,
 		.private = FILE_TASKLIST,
@@ -2321,10 +2380,7 @@ static long cgroup_create(struct cgroup 
 
 	mutex_lock(&cgroup_mutex);
 
-	INIT_LIST_HEAD(&cgrp->sibling);
-	INIT_LIST_HEAD(&cgrp->children);
-	INIT_LIST_HEAD(&cgrp->css_sets);
-	INIT_LIST_HEAD(&cgrp->release_list);
+	init_cgroup_housekeeping(cgrp);
 
 	cgrp->parent = parent;
 	cgrp->root = parent->root;
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
cpuset-avoid-changing-cpusets-cpus-when-errno-returned.patch
cpuset-hotplug-documentation-fix.patch
linux-next.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
container-freezer-document-the-cgroup-freezer-subsystem.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array.patch
devcgroup-use-kmemdup.patch
devcgroup-remove-unused-variable.patch
devcgroup-remove-spin_lock.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
add-a-refcount-check-in-dput.patch

