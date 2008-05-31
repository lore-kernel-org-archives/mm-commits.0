From: akpm@linux-foundation.org
Subject: - cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler.patch removed from -mm tree
Date: Fri, 30 May 2008 17:13:59 -0700
Message-ID: <200805310013.m4V0DxCW018694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753758AbYEaAPE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 20:15:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, pj@sgi.com, rientjes@google.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cgroup files: turn attach_task_by_pid directly into a cgroup write handler
has been removed from the -mm tree.  Its filename was
     cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler.patch

This patch was dropped because it is obsolete

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
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   67 ++--------------------------------------------
 1 file changed, 3 insertions(+), 64 deletions(-)

diff -puN kernel/cgroup.c~cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler kernel/cgroup.c
--- a/kernel/cgroup.c~cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler
+++ a/kernel/cgroup.c
@@ -503,10 +503,6 @@ static struct css_set *find_css_set(
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
@@ -1280,15 +1276,11 @@ int cgroup_attach_task(struct cgroup *cg
  * Attach task with pid 'pid' to cgroup 'cgrp'. Call with
  * cgroup_mutex, may take task_lock of task
  */
-static int attach_task_by_pid(struct cgroup *cgrp, char *pidbuf)
+static int attach_task_by_pid(struct cgroup *cgrp, struct cftype *cft, u64 pid)
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
@@ -1400,60 +1392,6 @@ static ssize_t cgroup_write_X64(struct c
 	}
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
 static ssize_t cgroup_file_write(struct file *file, const char __user *userbuf,
 						size_t nbytes, loff_t *ppos)
 {
@@ -2288,8 +2226,9 @@ static struct cftype files[] = {
 		.name = "tasks",
 		.open = cgroup_tasks_open,
 		.read = cgroup_tasks_read,
-		.write = cgroup_common_file_write,
+		.write_u64 = attach_task_by_pid,
 		.release = cgroup_tasks_release,
+		.lockmode = CFT_LOCK_ATTACH,
 		.private = FILE_TASKLIST,
 	},
 
_

Patches currently in -mm which might be from menage@google.com are

call_usermodehelper-increase-reliability.patch
cgroup-use-read-lock-to-guard-find_existing_css_set.patch
mark-res_counter_charge_locked-with-__must_check.patch
cgroup-dont-call-vfs_mkdir.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
make-cgroup_seqfile_release-static.patch
add-a-refcount-check-in-dput.patch

