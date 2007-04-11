From: akpm@linux-foundation.org
Subject: - only-send-pdeath_signal-when-getppid-changes.patch removed from -mm tree
Date: Tue, 10 Apr 2007 21:18:13 -0700
Message-ID: <200704110418.l3B4IDGl027893@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58238 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030799AbXDKESx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 00:18:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, acahalan@gmail.com, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Only send pdeath_signal when getppid changes
has been removed from the -mm tree.  Its filename was
     only-send-pdeath_signal-when-getppid-changes.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: Only send pdeath_signal when getppid changes
From: Eric W. Biederman <ebiederm@xmission.com>

Currently each thread can requrest to be notified when it's parent terminates,
and receive a thread specific signal when that occurs.  That we set this on a
per thread granularity and then send it to the whole thread group seems silly,
but whatever.

Currently we send a signal when the results of getppid don't change if our
parent thread dies and we are reparented to a different thread.  This seems
counterintuitive to what I would expect when programming in user space and is
a major maitenance issue to continue doing.

The only users I recall using this have non threaded parents and pdeath_signal
predates CLONE_THREAD so arguably this code has been broken with threaded
parents since the day CLONE_THREAD was introduced and no one ever screamed
loudly enough to get it fixed.

So this patch fixes the pdeath_signal behaviour only sending a signal when the
results of getppid would change.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Albert Cahalan <acahalan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~only-send-pdeath_signal-when-getppid-changes kernel/exit.c
--- a/kernel/exit.c~only-send-pdeath_signal-when-getppid-changes
+++ a/kernel/exit.c
@@ -598,10 +598,6 @@ choose_new_parent(struct task_struct *p,
 static void
 reparent_thread(struct task_struct *p, struct task_struct *father, int traced)
 {
-	if (p->pdeath_signal)
-		/* We already hold the tasklist_lock here.  */
-		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
-
 	/* Move the child from its dying parent to the new one.  */
 	if (unlikely(traced)) {
 		/* Preserve ptrace links if someone else is tracing this child.  */
@@ -637,6 +633,10 @@ reparent_thread(struct task_struct *p, s
 	if (p->exit_signal != -1)
 		p->exit_signal = SIGCHLD;
 
+	if (p->pdeath_signal)
+		/* We already hold the tasklist_lock here.  */
+		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
+
 	/* If we'd notified the old parent about this child's death,
 	 * also notify the new parent.
 	 */
_

Patches currently in -mm which might be from ebiederm@xmission.com are

powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
fix-x86_64-mm-relocatable-kernel-support.patch
account-for-module-percpu-space-separately-from-kernel.patch
i386-irq-kill-irq-compression.patch
i386-relocate-vdso-elf-headers-to-match-mapped-location-with-compat_vdso.patch
i386-make-compat_vdso-runtime-selectable.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
clean-up-elf-note-generation.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch
proc-cleanup-use-seq_release_private-where-appropriate.patch
reduce-reparent_to_init.patch
make-kernel-threads-invisible-to-sbin-init.patch
reparent-kernel-threads-to-swapper.patch
edac-k8-driver-coding-tidy.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
only-send-pdeath_signal-when-getppid-changes.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
