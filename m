From: akpm@linux-foundation.org
Subject: - sys_remap_file_pages-fix-vm_file-accounting.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:26:13 -0800
Message-ID: <200802052225.m15MPsI9011581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758849AbYBEW0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:26:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mszeredi@suse.cz, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sys_remap_file_pages: fix ->vm_file accounting
has been removed from the -mm tree.  Its filename was
     sys_remap_file_pages-fix-vm_file-accounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_remap_file_pages: fix ->vm_file accounting
From: Oleg Nesterov <oleg@tv-sign.ru>

Fix ->vm_file accounting, mmap_region() may do do_munmap().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fremap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN mm/fremap.c~sys_remap_file_pages-fix-vm_file-accounting mm/fremap.c
--- a/mm/fremap.c~sys_remap_file_pages-fix-vm_file-accounting
+++ a/mm/fremap.c
@@ -190,10 +190,13 @@ asmlinkage long sys_remap_file_pages(uns
 		 */
 		if (mapping_cap_account_dirty(mapping)) {
 			unsigned long addr;
+			struct file *file = vma->vm_file;
 
 			flags &= MAP_NONBLOCK;
-			addr = mmap_region(vma->vm_file, start, size,
+			get_file(file);
+			addr = mmap_region(file, start, size,
 					flags, vma->vm_flags, pgoff, 1);
+			fput(file);
 			if (IS_ERR_VALUE(addr)) {
 				err = addr;
 			} else {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
use-__set_task_state-for-traced-stopped-tasks.patch
do_wait-remove-one-else-if-branch.patch
proc-implement-proc_single_file_operations.patch
proc-rewrite-do_task_stat-to-correctly-handle-pid-namespaces.patch
proc-seqfile-convert-proc_pid_statm.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
proc-fix-openless-usage-due-to-proc_fops-flip.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
kill-pt_attached.patch
kill-my_ptrace_child.patch
ptrace_check_attach-remove-unneeded-signal-=-null-check.patch
ptrace_stop-fix-the-race-with-ptrace-detachattach.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
do_wait-factor-out-retval-=-0-checks.patch
ptrace_stop-fix-racy-nonstop_code-setting.patch
wait_task_stopped-remove-unneeded-delay_group_leader-check.patch
do_wait-cleanup-delay_group_leader-usage.patch
do_wait-fix-security-checks.patch
do_wait-fix-security-checks-fix.patch
wait_task_continued-zombie-dont-use-task_pid_nr_ns-lockless.patch
wait_task_zombie-remove-exit_state-exit_signal-checks-for-wnowait.patch
sys_setpgid-simplify-pid-ns-interaction.patch
fix-setsid-for-sub-namespace-sbin-init.patch
teach-set_special_pids-to-use-struct-pid.patch
move-daemonized-kernel-threads-into-the-swappers-session.patch
start-the-global-sbin-init-with-00-special-pids.patch
fix-group-stop-with-exit-race.patch
sys_setsid-remove-now-unneeded-session-=-1-check.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
pid-sys_wait-fixes-v2.patch
pid-extend-fix-pid_vnr.patch
sys_getsid-dont-use-nsproxy-directly.patch
pid-fix-mips-irix-emulation-pid-usage.patch
pid-fix-mips-irix-emulation-pid-usage-fix.patch
pid-fix-solaris_procids.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
pidns-make-full-use-of-xxx_vnr-calls.patch
pidns-fix-badly-converted-mqueues-pid-handling.patch
clean-up-the-kill_something_info.patch
get-rid-of-the-kill_pgrp_info-function.patch
