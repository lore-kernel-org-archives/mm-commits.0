From: akpm@linux-foundation.org
Subject: + proc-implement-proc_single_file_operations.patch added to -mm tree
Date: Mon, 19 Nov 2007 16:59:20 -0800
Message-ID: <200711200059.lAK0xKeS005539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59019 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbXKTBBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 20:01:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@gmail.com, oleg@tv-sign.ru


The patch titled
     proc: implement proc_single_file_operations
has been added to the -mm tree.  Its filename is
     proc-implement-proc_single_file_operations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc: implement proc_single_file_operations
From: Eric W. Biederman <ebiederm@xmission.com>

Currently many /proc/pid files use a crufty precursor to the current seq_file
api, and they don't have direct access to the pid_namespace or the pid of for
which they are displaying data.

So implement proc_single_file_operations to make the seq_file routines easy to
use, and to give access to the full state of the pid of we are displaying data
for.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c          |   43 ++++++++++++++++++++++++++++++++++++++
 include/linux/proc_fs.h |    3 ++
 2 files changed, 46 insertions(+)

diff -puN fs/proc/base.c~proc-implement-proc_single_file_operations fs/proc/base.c
--- a/fs/proc/base.c~proc-implement-proc_single_file_operations
+++ a/fs/proc/base.c
@@ -121,6 +121,10 @@ struct pid_entry {
 	NOD(NAME, (S_IFREG|(MODE)), 			\
 		NULL, &proc_info_file_operations,	\
 		{ .proc_read = &proc_##OTYPE } )
+#define ONE(NAME, MODE, OTYPE)				\
+	NOD(NAME, (S_IFREG|(MODE)), 			\
+		NULL, &proc_single_file_operations,	\
+		{ .proc_show = &proc_##OTYPE } )
 
 int maps_protect;
 EXPORT_SYMBOL(maps_protect);
@@ -567,6 +571,45 @@ static const struct file_operations proc
 	.read		= proc_info_read,
 };
 
+static int proc_single_show(struct seq_file *m, void *v)
+{
+	struct inode *inode = m->private;
+	struct pid_namespace *ns;
+	struct pid *pid;
+	struct task_struct *task;
+	int ret;
+
+	ns = inode->i_sb->s_fs_info;
+	pid = proc_pid(inode);
+	task = get_pid_task(pid, PIDTYPE_PID);
+	if (!task)
+		return -ESRCH;
+
+	ret = PROC_I(inode)->op.proc_show(m, ns, pid, task);
+
+	put_task_struct(task);
+	return ret;
+}
+
+static int proc_single_open(struct inode *inode, struct file *filp)
+{
+	int ret;
+	ret = single_open(filp, proc_single_show, NULL);
+	if (!ret) {
+		struct seq_file *m = filp->private_data;
+
+		m->private = inode;
+	}
+	return ret;
+}
+
+static const struct file_operations proc_single_file_operations = {
+	.open		= proc_single_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int mem_open(struct inode* inode, struct file* file)
 {
 	file->private_data = (void*)((long)current->self_exec_id);
diff -puN include/linux/proc_fs.h~proc-implement-proc_single_file_operations include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~proc-implement-proc_single_file_operations
+++ a/include/linux/proc_fs.h
@@ -257,6 +257,9 @@ extern void kclist_add(struct kcore_list
 union proc_op {
 	int (*proc_get_link)(struct inode *, struct path *);
 	int (*proc_read)(struct task_struct *task, char *page);
+	int (*proc_show)(struct seq_file *m,
+		struct pid_namespace *ns, struct pid *pid,
+		struct task_struct *task);
 };
 
 struct proc_inode {
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
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
