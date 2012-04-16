From: akpm@linux-foundation.org
Subject: [merged] cred-copy_process-should-clear-child-replacement_session_keyring.patch removed from -mm tree
Date: Mon, 16 Apr 2012 13:15:16 -0700
Message-ID: <20120416201516.956A4A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:38496 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab2DPUPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 16:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dhowells@redhat.com, jmorris@namei.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cred: copy_process() should clear child->replacement_session_keyring
has been removed from the -mm tree.  Its filename was
     cred-copy_process-should-clear-child-replacement_session_keyring.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: cred: copy_process() should clear child->replacement_session_keyring

keyctl_session_to_parent(task) sets ->replacement_session_keyring, it
should be processed and cleared by key_replace_session_keyring().

However, this task can fork before it notices TIF_NOTIFY_RESUME and the
new child gets the bogus ->replacement_session_keyring copied by
dup_task_struct().  This is obviously wrong and, if nothing else, this
leads to put_cred(already_freed_cred).

change copy_creds() to clear this member.  If copy_process() fails before
this point the wrong ->replacement_session_keyring doesn't matter,
exit_creds() won't be called.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cred.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/cred.c~cred-copy_process-should-clear-child-replacement_session_keyring kernel/cred.c
--- a/kernel/cred.c~cred-copy_process-should-clear-child-replacement_session_keyring
+++ a/kernel/cred.c
@@ -386,6 +386,8 @@ int copy_creds(struct task_struct *p, un
 	struct cred *new;
 	int ret;
 
+	p->replacement_session_keyring = NULL;
+
 	if (
 #ifdef CONFIG_KEYS
 		!p->cred->thread_keyring &&
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-set-task-exit-code-before-complete_vfork_done.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
mips-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
frv-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
kmod-unexport-call_usermodehelper_freeinfo.patch
kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch
kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch
cred-remove-task_is_dead-from-__task_cred-validation.patch
stack-usage-add-pid-to-warning-printk-in-check_stack_usage.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-unify-ptrace_may_access-locking-code.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch

