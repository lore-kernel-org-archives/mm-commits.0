From: akpm@linux-foundation.org
Subject: - cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:19 -0700
Message-ID: <200807252258.m6PMwJs8003279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44277 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361AbYGYW74 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:59:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, pj@sgi.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroup files: turn attach_task_by_pid directly into a cgroup write handler
has been removed from the -mm tree.  Its filename was
     cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroup files: turn attach_task_by_pid directly into a cgroup write handler
From: Paul Menage <menage@google.com>

This patch changes attach_task_by_pid() to take a u64 rather than a
string; as a result it can be called directly as a control groups
write_u64 handler, and cgroup_common_file_write() can be removed.

Signed-off-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   80 ++++++++--------------------------------------
 1 file changed, 14 insertions(+), 66 deletions(-)

diff -puN kernel/cgroup.c~cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler
+++ a/kernel/cgroup.c
@@ -504,10 +504,6 @@ static struct css_set *find_css_set(
  * knows that the cgroup won't be removed, as cgroup_rmdir()
  * needs that mutex.
  *
- * The cgroup_common_file_write handler for operations that modify
- * the cgroup hierarchy holds cgroup_mutex across the entire operation,
- * single threading all such cgroup modifications across the system.
- *
  * The fork and exit callbacks cgroup_fork() and cgroup_exit(), don't
  * (usually) take cgroup_mutex.  These are the two most performance
  * critical pieces of code here.  The exception occurs on cgroup_exit(),
@@ -1279,18 +1275,14 @@ int cgroup_attach_task(struct cgroup *cg
 }
 
 /*
- * Attach task with pid 'pid' to cgroup 'cgrp'. Call with
- * cgroup_mutex, may take task_lock of task
+ * Attach task with pid 'pid' to cgroup 'cgrp'. Call with cgroup_mutex
+ * held. May take task_lock of task
  */
-static int attach_task_by_pid(struct cgroup *cgrp, char *pidbuf)
+static int attach_task_by_pid(struct cgroup *cgrp, u64 pid)
 {
-	pid_t pid;
 	struct task_struct *tsk;
 	int ret;
 
-	if (sscanf(pidbuf, "%d", &pid) != 1)
-		return -EIO;
-
 	if (pid) {
 		rcu_read_lock();
 		tsk = find_task_by_vpid(pid);
@@ -1316,6 +1308,16 @@ static int attach_task_by_pid(struct cgr
 	return ret;
 }
 
+static int cgroup_tasks_write(struct cgroup *cgrp, struct cftype *cft, u64 pid)
+{
+	int ret;
+	if (!cgroup_lock_live_group(cgrp))
+		return -ENODEV;
+	ret = attach_task_by_pid(cgrp, pid);
+	cgroup_unlock();
+	return ret;
+}
+
 /* The various types of files and directories in a cgroup file system */
 enum cgroup_filetype {
 	FILE_ROOT,
@@ -1434,60 +1436,6 @@ static ssize_t cgroup_write_string(struc
 	return retval;
 }
 
-static ssize_t cgroup_common_file_write(struct cgroup *cgrp,
-					   struct cftype *cft,
-					   struct file *file,
-					   const char __user *userbuf,
-					   size_t nbytes, loff_t *unused_ppos)
-{
-	enum cgroup_filetype type = cft->private;
-	char *buffer;
-	int retval = 0;
-
-	if (nbytes >= PATH_MAX)
-		return -E2BIG;
-
-	/* +1 for nul-terminator */
-	buffer = kmalloc(nbytes + 1, GFP_KERNEL);
-	if (buffer == NULL)
-		return -ENOMEM;
-
-	if (copy_from_user(buffer, userbuf, nbytes)) {
-		retval = -EFAULT;
-		goto out1;
-	}
-	buffer[nbytes] = 0;	/* nul-terminate */
-	strstrip(buffer);	/* strip -just- trailing whitespace */
-
-	mutex_lock(&cgroup_mutex);
-
-	/*
-	 * This was already checked for in cgroup_file_write(), but
-	 * check again now we're holding cgroup_mutex.
-	 */
-	if (cgroup_is_removed(cgrp)) {
-		retval = -ENODEV;
-		goto out2;
-	}
-
-	switch (type) {
-	case FILE_TASKLIST:
-		retval = attach_task_by_pid(cgrp, buffer);
-		break;
-	default:
-		retval = -EINVAL;
-		goto out2;
-	}
-
-	if (retval == 0)
-		retval = nbytes;
-out2:
-	mutex_unlock(&cgroup_mutex);
-out1:
-	kfree(buffer);
-	return retval;
-}
-
 static ssize_t cgroup_file_write(struct file *file, const char __user *buf,
 						size_t nbytes, loff_t *ppos)
 {
@@ -2265,7 +2213,7 @@ static struct cftype files[] = {
 		.name = "tasks",
 		.open = cgroup_tasks_open,
 		.read = cgroup_tasks_read,
-		.write = cgroup_common_file_write,
+		.write_u64 = cgroup_tasks_write,
 		.release = cgroup_tasks_release,
 		.private = FILE_TASKLIST,
 	},
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
make-cgroup_seqfile_release-static.patch
add-a-refcount-check-in-dput.patch

