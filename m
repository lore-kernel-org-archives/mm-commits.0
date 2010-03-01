From: akpm@linux-foundation.org
Subject: + kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limitcleanup.patch added to -mm tree
Date: Mon, 01 Mar 2010 15:25:13 -0800
Message-ID: <201003012325.o21NPDDE005922@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197Ab0CAXZk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Mar 2010 18:25:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, nhorman@tuxdriver.com


The patch titled
     kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function- and-resolve-limit.cleanup
has been added to the -mm tree.  Its filename is
     kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limitcleanup.patch

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
Subject: kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function- and-resolve-limit.cleanup
From: Oleg Nesterov <oleg@redhat.com>

Trivial,
kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
forgot to kill the declaration of call_usermodehelper_stdinpipe() which no
longer exists.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/kmod.h~kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limitcleanup include/linux/kmod.h
--- a/include/linux/kmod.h~kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limitcleanup
+++ a/include/linux/kmod.h
@@ -73,8 +73,6 @@ struct subprocess_info *call_usermodehel
 /* Set various pieces of state into the subprocess_info structure */
 void call_usermodehelper_setkeys(struct subprocess_info *info,
 				 struct key *session_keyring);
-int call_usermodehelper_stdinpipe(struct subprocess_info *sub_info,
-				  struct file **filp);
 void call_usermodehelper_setfns(struct subprocess_info *info,
 		    int (*init)(struct subprocess_info *info),
 		    void (*cleanup)(struct subprocess_info *info),
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
kernel-pidc-update-comment-on-find_task_by_pid_ns.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
coredump-set-group_exit_code-for-other-clone_vm-tasks-too.patch
coredump-suppress-uid-comparison-test-if-core-output-files-are-pipes.patch
ptrace-use-ptrace_request-in-the-remaining-architectures.patch
ptrace-move-user_enable_single_step-co-prototypes-to-linux-ptraceh.patch
alpha-use-generic-ptrace_resume-code.patch
arm-use-generic-ptrace_resume-code.patch
avr32-use-generic-ptrace_resume-code.patch
h8300-use-generic-ptrace_resume-code.patch
m68knommu-use-generic-ptrace_resume-code.patch
microblaze-use-generic-ptrace_resume-code.patch
mips-use-generic-ptrace_resume-code.patch
um-use-generic-ptrace_resume-code.patch
xtensa-use-generic-ptrace_resume-code.patch
cris-arch-v10-use-generic-ptrace_resume-code.patch
cris-arch-v32-use-generic-ptrace_resume-code.patch
m32r-use-generic-ptrace_resume-code.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch
utrace-core-utrace-fix-utrace_maybe_reap-vs-find_matching_engine-race.patch
copy_signal-cleanup-use-zalloc-and-remove-initializations.patch
copy_signal-cleanup-kill-taskstats_tgid_init-and-acct_init_pacct.patch
copy_signal-cleanup-clean-thread_group_cputime_init.patch
copy_signal-cleanup-clean-tty_audit_fork.patch
kmod-add-init-function-to-usermodehelper.patch
kmod-add-init-function-to-usermodehelper-fix.patch
kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch
kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limitcleanup.patch
sysctl-extern-cleanup-signal.patch

