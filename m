From: akpm@linux-foundation.org
Subject: + mm-exec-rename-mm-exe_file-to-mm-exe_path.patch added to -mm tree
Date: Tue, 06 Mar 2012 15:13:25 -0800
Message-ID: <20120306231325.D4B26A0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:51954 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031544Ab2CFXN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 18:13:27 -0500
Received: by ghbz15 with SMTP id z15so711234ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 15:13:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, adobriyan@gmail.com, ebiederm@xmission.com, gorcunov@openvz.org, keescook@chromium.org, kosaki.motohiro@jp.fujitsu.com, matthltc@us.ibm.com, tj@kernel.org, xemul@parallels.com


The patch titled
     Subject: mm/exec: rename mm->exe_file to mm->exe_path
has been added to the -mm tree.  Its filename is
     mm-exec-rename-mm-exe_file-to-mm-exe_path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm/exec: rename mm->exe_file to mm->exe_path

Rename mm->exe_file to mm->exe_path.  We only need this member to get the
path - an additional reference to bprm->file makes no sense.

The patch doesn't rename added_exe_file_vma/removed_exe_file_vma and
mm->num_exe_file_vmas, and perhaps we can remove them later.

Also remove the stale comment in include/linux/mm.h.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Tejun Heo <tj@kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                |   20 +++++++++---------
 fs/proc/base.c           |   17 +++++++--------
 include/linux/mm.h       |    5 +---
 include/linux/mm_types.h |    2 -
 kernel/fork.c            |   41 ++++++++++++++++++-------------------
 5 files changed, 42 insertions(+), 43 deletions(-)

diff -puN fs/exec.c~mm-exec-rename-mm-exe_file-to-mm-exe_path fs/exec.c
--- a/fs/exec.c~mm-exec-rename-mm-exe_file-to-mm-exe_path
+++ a/fs/exec.c
@@ -1100,7 +1100,7 @@ int flush_old_exec(struct linux_binprm *
 	if (retval)
 		goto out;
 
-	set_mm_exe_file(bprm->mm, bprm->file);
+	set_mm_exe_path(bprm->mm, &bprm->file->f_path);
 
 	filename_to_taskname(bprm->tcomm, bprm->filename, sizeof(bprm->tcomm));
 	/*
@@ -1674,14 +1674,14 @@ static void cn_escape(char *str)
 			*str = '!';
 }
 
-static int cn_print_exe_file(struct core_name *cn)
+static int cn_print_exe_path(struct core_name *cn)
 {
-	struct file *exe_file;
+	struct path *exe_path;
 	char *pathbuf, *path;
 	int ret;
 
-	exe_file = get_mm_exe_file(current->mm);
-	if (!exe_file) {
+	exe_path = get_mm_exe_path(current->mm);
+	if (!exe_path) {
 		char *commstart = cn->corename + cn->used;
 		ret = cn_printf(cn, "%s (path unknown)", current->comm);
 		cn_escape(commstart);
@@ -1691,10 +1691,10 @@ static int cn_print_exe_file(struct core
 	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
 	if (!pathbuf) {
 		ret = -ENOMEM;
-		goto put_exe_file;
+		goto put_exe_path;
 	}
 
-	path = d_path(&exe_file->f_path, pathbuf, PATH_MAX);
+	path = d_path(exe_path, pathbuf, PATH_MAX);
 	if (IS_ERR(path)) {
 		ret = PTR_ERR(path);
 		goto free_buf;
@@ -1706,8 +1706,8 @@ static int cn_print_exe_file(struct core
 
 free_buf:
 	kfree(pathbuf);
-put_exe_file:
-	fput(exe_file);
+put_exe_path:
+	path_put(exe_path);
 	return ret;
 }
 
@@ -1789,7 +1789,7 @@ static int format_corename(struct core_n
 				break;
 			}
 			case 'E':
-				err = cn_print_exe_file(cn);
+				err = cn_print_exe_path(cn);
 				break;
 			/* core limit size */
 			case 'c':
diff -puN fs/proc/base.c~mm-exec-rename-mm-exe_file-to-mm-exe_path fs/proc/base.c
--- a/fs/proc/base.c~mm-exec-rename-mm-exe_file-to-mm-exe_path
+++ a/fs/proc/base.c
@@ -1400,11 +1400,11 @@ static const struct file_operations proc
 	.release	= single_release,
 };
 
-static int proc_exe_link(struct dentry *dentry, struct path *exe_path)
+static int proc_exe_link(struct dentry *dentry, struct path *path)
 {
 	struct task_struct *task;
 	struct mm_struct *mm;
-	struct file *exe_file;
+	struct path *exe_path;
 
 	task = get_proc_task(dentry->d_inode);
 	if (!task)
@@ -1413,15 +1413,14 @@ static int proc_exe_link(struct dentry *
 	put_task_struct(task);
 	if (!mm)
 		return -ENOENT;
-	exe_file = get_mm_exe_file(mm);
+	exe_path = get_mm_exe_path(mm);
 	mmput(mm);
-	if (exe_file) {
-		*exe_path = exe_file->f_path;
-		path_get(&exe_file->f_path);
-		fput(exe_file);
-		return 0;
-	} else
+
+	if (!exe_path)
 		return -ENOENT;
+
+	*path = *exe_path;
+	return 0;
 }
 
 static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
diff -puN include/linux/mm.h~mm-exec-rename-mm-exe_file-to-mm-exe_path include/linux/mm.h
--- a/include/linux/mm.h~mm-exec-rename-mm-exe_file-to-mm-exe_path
+++ a/include/linux/mm.h
@@ -1380,11 +1380,10 @@ extern void exit_mmap(struct mm_struct *
 extern int mm_take_all_locks(struct mm_struct *mm);
 extern void mm_drop_all_locks(struct mm_struct *mm);
 
-/* From fs/proc/base.c. callers must _not_ hold the mm's exe_file_lock */
 extern void added_exe_file_vma(struct mm_struct *mm);
 extern void removed_exe_file_vma(struct mm_struct *mm);
-extern void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
-extern struct file *get_mm_exe_file(struct mm_struct *mm);
+extern void set_mm_exe_path(struct mm_struct *mm, struct path *exe_path);
+extern struct path *get_mm_exe_path(struct mm_struct *mm);
 
 extern int may_expand_vm(struct mm_struct *mm, unsigned long npages);
 extern int install_special_mapping(struct mm_struct *mm,
diff -puN include/linux/mm_types.h~mm-exec-rename-mm-exe_file-to-mm-exe_path include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-exec-rename-mm-exe_file-to-mm-exe_path
+++ a/include/linux/mm_types.h
@@ -377,7 +377,7 @@ struct mm_struct {
 #endif
 
 	/* store ref to file /proc/<pid>/exe symlink points to */
-	struct file *exe_file;
+	struct path *exe_path;
 	unsigned long num_exe_file_vmas;
 #ifdef CONFIG_MMU_NOTIFIER
 	struct mmu_notifier_mm *mmu_notifier_mm;
diff -puN kernel/fork.c~mm-exec-rename-mm-exe_file-to-mm-exe_path kernel/fork.c
--- a/kernel/fork.c~mm-exec-rename-mm-exe_file-to-mm-exe_path
+++ a/kernel/fork.c
@@ -574,7 +574,7 @@ void mmput(struct mm_struct *mm)
 		ksm_exit(mm);
 		khugepaged_exit(mm); /* must run before exit_mmap */
 		exit_mmap(mm);
-		set_mm_exe_file(mm, NULL);
+		set_mm_exe_path(mm, NULL);
 		if (!list_empty(&mm->mmlist)) {
 			spin_lock(&mmlist_lock);
 			list_del(&mm->mmlist);
@@ -601,42 +601,43 @@ void added_exe_file_vma(struct mm_struct
 void removed_exe_file_vma(struct mm_struct *mm)
 {
 	mm->num_exe_file_vmas--;
-	if ((mm->num_exe_file_vmas == 0) && mm->exe_file) {
-		fput(mm->exe_file);
-		mm->exe_file = NULL;
+	if ((mm->num_exe_file_vmas == 0) && mm->exe_path) {
+		path_put(mm->exe_path);
+		mm->exe_path = NULL;
 	}
 
 }
 
-void set_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file)
+void set_mm_exe_path(struct mm_struct *mm, struct path *exe_path)
 {
-	if (new_exe_file)
-		get_file(new_exe_file);
-	if (mm->exe_file)
-		fput(mm->exe_file);
-	mm->exe_file = new_exe_file;
+	if (mm->exe_path)
+		path_put(mm->exe_path);
+	mm->exe_path = exe_path;
+	if (mm->exe_path)
+		path_get(mm->exe_path);
 	mm->num_exe_file_vmas = 0;
 }
 
-struct file *get_mm_exe_file(struct mm_struct *mm)
+struct path *get_mm_exe_path(struct mm_struct *mm)
 {
-	struct file *exe_file;
+	struct path *exe_path;
 
 	/* We need mmap_sem to protect against races with removal of
 	 * VM_EXECUTABLE vmas */
 	down_read(&mm->mmap_sem);
-	exe_file = mm->exe_file;
-	if (exe_file)
-		get_file(exe_file);
+	exe_path = mm->exe_path;
+	if (exe_path)
+		path_get(exe_path);
 	up_read(&mm->mmap_sem);
-	return exe_file;
+
+	return exe_path;
 }
 
-static void dup_mm_exe_file(struct mm_struct *oldmm, struct mm_struct *newmm)
+static void dup_mm_exe_path(struct mm_struct *oldmm, struct mm_struct *newmm)
 {
-	/* It's safe to write the exe_file pointer without exe_file_lock because
+	/* It's safe to write the exe_path pointer without mmap_sem because
 	 * this is called during fork when the task is not yet in /proc */
-	newmm->exe_file = get_mm_exe_file(oldmm);
+	newmm->exe_path = get_mm_exe_path(oldmm);
 }
 
 /**
@@ -811,7 +812,7 @@ struct mm_struct *dup_mm(struct task_str
 	if (init_new_context(tsk, mm))
 		goto fail_nocontext;
 
-	dup_mm_exe_file(oldmm, mm);
+	dup_mm_exe_path(oldmm, mm);
 
 	err = dup_mmap(mm, oldmm);
 	if (err)
_
Subject: Subject: mm/exec: rename mm->exe_file to mm->exe_path

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
arm-use-set_current_blocked-and-block_sigmask.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
powerpc-use-set_current_blocked-and-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
mips-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
xtensa-dont-reimplement-force_sigsegv.patch
xtensa-no-need-to-reset-handler-if-sa_oneshot.patch
xtensa-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
xtensa-use-set_current_blocked-and-block_sigmask.patch
sparc-use-block_sigmask.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps-fix-task_nommu-build-regression-in-linux-next.patch
procfs-mark-thread-stack-correctly-in-proc-pid-fix-rcu-locking-in-vm_is_stack.patch
mm-exec-rename-mm-exe_file-to-mm-exe_path.patch
frv-use-set_current_blocked-and-block_sigmask.patch
sh-no-need-to-reset-handler-if-sa_oneshot.patch
sh-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
alpha-use-set_current_blocked-and-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
c6x-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
um-dont-restore-current-blocked-on-error.patch
um-use-set_current_blocked-and-block_sigmask.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
powerpc-eeh-remove-eeh_event_handler-daemonize.patch
ptrace-the-killed-tracee-should-not-enter-the-syscall.patch
ptrace-dont-send-sigtrap-on-exec-if-seized.patch
ptrace-dont-modify-flags-on-ptrace_setoptions-failure.patch
ptrace-simplify-ptrace_foo-constants-and-ptrace_setoptions-code.patch
ptrace-make-ptrace_seize-set-ptrace-options-specified-in-data-parameter.patch
ptrace-renumber-ptrace_event_stop-so-that-future-new-options-and-events-can-match.patch
ptrace-remove-ptrace_seize_devel-bit.patch
tile-use-set_current_blocked-and-block_sigmask.patch
hexagon-use-set_current_blocked-and-block_sigmask.patch
signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch
signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch
signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch
signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch
usermodehelper-use-umh_wait_proc-consistently.patch
usermodehelper-introduce-umh_completesub_info.patch
usermodehelper-implement-umh_killable.patch
usermodehelper-kill-umh_wait-renumber-umh_-constants.patch
usermodehelper-____call_usermodehelper-doesnt-need-do_exit.patch
kmod-introduce-call_modprobe-helper.patch
kmod-make-__request_module-killable.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall.patch
pidns-add-reboot_pid_ns-to-handle-the-reboot-syscall-fix.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch

