From: akpm@linux-foundation.org
Subject: [merged] ptrace-introduce-user_single_step_siginfo-helper.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:00 -0800
Message-ID: <200912162038.nBGKc08c013389@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964835AbZLPUi2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@elte.hu, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     ptrace: introduce user_single_step_siginfo() helper
has been removed from the -mm tree.  Its filename was
     ptrace-introduce-user_single_step_siginfo-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
mm-introduce-coredump-parameter-structure.patch
linux-next.patch
posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch

