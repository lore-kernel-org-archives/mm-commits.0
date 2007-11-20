From: akpm@linux-foundation.org
Subject: + proc-remove-races-from-proc_id_readdir.patch added to -mm tree
Date: Mon, 19 Nov 2007 16:51:25 -0800
Message-ID: <200711200051.lAK0pP5A005199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51412 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752144AbXKTAvg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 19:51:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@gmail.com, oleg@tv-sign.ru


The patch titled
     proc: remove races from proc_id_readdir()
has been added to the -mm tree.  Its filename is
     proc-remove-races-from-proc_id_readdir.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc: remove races from proc_id_readdir()
From: "Eric W. Biederman" <ebiederm@xmission.com>

Oleg noticed that the call of task_pid_nr_ns() in proc_pid_readdir
is racy with respect to tasks exiting.

After a bit of examination it also appears that the call itself
is completely unnecessary.

So to fix the problem this patch modifies next_tgid() to return
both a tgid and the task struct in question.

A structure is introduced to return these values because it is
slightly cleaner and easier to optimize, and the resulting code
is a little shorter.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   51 +++++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff -puN fs/proc/base.c~proc-remove-races-from-proc_id_readdir fs/proc/base.c
--- a/fs/proc/base.c~proc-remove-races-from-proc_id_readdir
+++ a/fs/proc/base.c
@@ -2411,19 +2411,23 @@ out:
  * Find the first task with tgid >= tgid
  *
  */
-static struct task_struct *next_tgid(unsigned int tgid,
-		struct pid_namespace *ns)
-{
+struct tgid_iter {
+	unsigned int tgid;
 	struct task_struct *task;
+};
+static struct tgid_iter next_tgid(struct pid_namespace *ns, struct tgid_iter iter)
+{
 	struct pid *pid;
 
+	if (iter.task)
+		put_task_struct(iter.task);
 	rcu_read_lock();
 retry:
-	task = NULL;
-	pid = find_ge_pid(tgid, ns);
+	iter.task = NULL;
+	pid = find_ge_pid(iter.tgid, ns);
 	if (pid) {
-		tgid = pid_nr_ns(pid, ns) + 1;
-		task = pid_task(pid, PIDTYPE_PID);
+		iter.tgid = pid_nr_ns(pid, ns);
+		iter.task = pid_task(pid, PIDTYPE_PID);
 		/* What we to know is if the pid we have find is the
 		 * pid of a thread_group_leader.  Testing for task
 		 * being a thread_group_leader is the obvious thing
@@ -2436,23 +2440,25 @@ retry:
 		 * found doesn't happen to be a thread group leader.
 		 * As we don't care in the case of readdir.
 		 */
-		if (!task || !has_group_leader_pid(task))
+		if (!iter.task || !has_group_leader_pid(iter.task)) {
+			iter.tgid += 1;
 			goto retry;
-		get_task_struct(task);
+		}
+		get_task_struct(iter.task);
 	}
 	rcu_read_unlock();
-	return task;
+	return iter;
 }
 
 #define TGID_OFFSET (FIRST_PROCESS_ENTRY + ARRAY_SIZE(proc_base_stuff))
 
 static int proc_pid_fill_cache(struct file *filp, void *dirent, filldir_t filldir,
-	struct task_struct *task, int tgid)
+	struct tgid_iter iter)
 {
 	char name[PROC_NUMBUF];
-	int len = snprintf(name, sizeof(name), "%d", tgid);
+	int len = snprintf(name, sizeof(name), "%d", iter.tgid);
 	return proc_fill_cache(filp, dirent, filldir, name, len,
-				proc_pid_instantiate, task, NULL);
+				proc_pid_instantiate, iter.task, NULL);
 }
 
 /* for the /proc/ directory itself, after non-process stuff has been done */
@@ -2460,8 +2466,7 @@ int proc_pid_readdir(struct file * filp,
 {
 	unsigned int nr = filp->f_pos - FIRST_PROCESS_ENTRY;
 	struct task_struct *reaper = get_proc_task(filp->f_path.dentry->d_inode);
-	struct task_struct *task;
-	int tgid;
+	struct tgid_iter iter;
 	struct pid_namespace *ns;
 
 	if (!reaper)
@@ -2474,14 +2479,14 @@ int proc_pid_readdir(struct file * filp,
 	}
 
 	ns = filp->f_dentry->d_sb->s_fs_info;
-	tgid = filp->f_pos - TGID_OFFSET;
-	for (task = next_tgid(tgid, ns);
-	     task;
-	     put_task_struct(task), task = next_tgid(tgid + 1, ns)) {
-		tgid = task_pid_nr_ns(task, ns);
-		filp->f_pos = tgid + TGID_OFFSET;
-		if (proc_pid_fill_cache(filp, dirent, filldir, task, tgid) < 0) {
-			put_task_struct(task);
+	iter.task = NULL;
+	iter.tgid = filp->f_pos - TGID_OFFSET;
+	for (iter = next_tgid(ns, iter);
+	     iter.task;
+	     iter.tgid += 1, iter = next_tgid(ns, iter)) {
+		filp->f_pos = iter.tgid + TGID_OFFSET;
+		if (proc_pid_fill_cache(filp, dirent, filldir, iter) < 0) {
+			put_task_struct(iter.task);
 			goto out;
 		}
 	}
_

Patches currently in -mm which might be from ebiederm@xmission.com are

proc-fix-null-i_fop-oops.patch
proc-remove-races-from-proc_id_readdir.patch
git-s390.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
introduce-flags-for-reserve_bootmem.patch
use-bootmem_exclusive-for-kdump.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
mark-net_ns-with-depends-on-namespaces.patch
