From: akpm@linux-foundation.org
Subject: + ptrace-introduce-user_single_step_siginfo-helper.patch added to -mm tree
Date: Thu, 12 Nov 2009 15:17:38 -0800
Message-ID: <200911122317.nACNHcgK030612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754904AbZKLXR7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 18:17:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@elte.hu, roland@redhat.com, tglx@linutronix.de


The patch titled
     ptrace: introduce user_single_step_siginfo() helper
has been added to the -mm tree.  Its filename is
     ptrace-introduce-user_single_step_siginfo-helper.patch

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
Subject: ptrace: introduce user_single_step_siginfo() helper
From: Oleg Nesterov <oleg@redhat.com>

Suggested by Roland.

Currently there is no way to synthesize a single-stepping trap in the
arch-independent manner.  This patch adds the default helper which fills
siginfo_t, arch/ can can override it.

Architetures which implement user_enable_single_step() should add
user_single_step_siginfo() also.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ptrace.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN include/linux/ptrace.h~ptrace-introduce-user_single_step_siginfo-helper include/linux/ptrace.h
--- a/include/linux/ptrace.h~ptrace-introduce-user_single_step_siginfo-helper
+++ a/include/linux/ptrace.h
@@ -273,6 +273,18 @@ static inline void user_enable_block_ste
 }
 #endif	/* arch_has_block_step */
 
+#ifdef ARCH_HAS_USER_SINGLE_STEP_INFO
+extern void user_single_step_siginfo(struct task_struct *tsk,
+				struct pt_regs *regs, siginfo_t *info);
+#else
+static inline void user_single_step_siginfo(struct task_struct *tsk,
+				struct pt_regs *regs, siginfo_t *info)
+{
+	memset(info, 0, sizeof(*info));
+	info->si_signo = SIGTRAP;
+}
+#endif
+
 #ifndef arch_ptrace_stop_needed
 /**
  * arch_ptrace_stop_needed - Decide whether arch_ptrace_stop() should be called
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
itimers-fix-racy-writes-to-cpu_itimer-fields.patch
posix-cpu-timers-optimize-and-document-timer_create-callback.patch
ptrace-cleanup-ptrace_init_task-ptrace_link-path.patch
ptrace-copy_process-should-disable-stepping.patch
ptrace-introduce-user_single_step_siginfo-helper.patch
ptrace-powerpc-implement-user_single_step_siginfo.patch
ptrace-change-tracehook_report_syscall_exit-to-handle-stepping.patch
ptrace-x86-implement-user_single_step_siginfo.patch
ptrace-x86-change-syscall_trace_leave-to-rely-on-tracehook-when-stepping.patch
signals-send_sig_noinfo-should-be-considered-as-si_fromuser.patch
signals-send_signal-use-si_fromuser-to-detect-from_ancestor_ns.patch
signals-cosmetic-collect_signal-use-si_user.patch
signals-kill-force_sig_specific.patch
signals-check-group_stop_count-after-tracehook_get_signal.patch
utrace-core.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

