From: akpm@linux-foundation.org
Subject: - tracehook-tracehook_signal_handler.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:51 -0700
Message-ID: <200807262116.m6QLGpvD019871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757758AbYGZVRX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: tracehook_signal_handler
has been removed from the -mm tree.  Its filename was
     tracehook-tracehook_signal_handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: tracehook_signal_handler
From: Roland McGrath <roland@redhat.com>

This defines tracehook_signal_handler() as a hook for the arch signal
handling code to call.  It gives ptrace the opportunity to stop for a
pseudo-single-step trap immediately after signal handler setup is done.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff -puN include/linux/tracehook.h~tracehook-tracehook_signal_handler include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-tracehook_signal_handler
+++ a/include/linux/tracehook.h
@@ -289,4 +289,27 @@ static inline void tracehook_finish_rele
 	ptrace_release_task(task);
 }
 
+/**
+ * tracehook_signal_handler - signal handler setup is complete
+ * @sig:		number of signal being delivered
+ * @info:		siginfo_t of signal being delivered
+ * @ka:			sigaction setting that chose the handler
+ * @regs:		user register state
+ * @stepping:		nonzero if debugger single-step or block-step in use
+ *
+ * Called by the arch code after a signal handler has been set up.
+ * Register and stack state reflects the user handler about to run.
+ * Signal mask changes have already been made.
+ *
+ * Called without locks, shortly before returning to user mode
+ * (or handling more signals).
+ */
+static inline void tracehook_signal_handler(int sig, siginfo_t *info,
+					    const struct k_sigaction *ka,
+					    struct pt_regs *regs, int stepping)
+{
+	if (stepping)
+		ptrace_notify(SIGTRAP);
+}
+
 #endif	/* <linux/tracehook.h> */
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
tracehook-syscall.patch
tracehook-config_have_arch_tracehook.patch
x86-tracehook_signal_handler.patch
x86-tracehook-syscall.patch
x86-tracehook-asm-syscallh.patch
x86-signals-use-asm-syscallh.patch
x86-tracehook-tif_notify_resume.patch
x86-tracehook-config_have_arch_tracehook.patch

