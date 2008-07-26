From: akpm@linux-foundation.org
Subject: - tracehook-force-signal_pending.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:17:03 -0700
Message-ID: <200807262117.m6QLH3sS019901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757884AbYGZVRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: force signal_pending()
has been removed from the -mm tree.  Its filename was
     tracehook-force-signal_pending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: force signal_pending()
From: Roland McGrath <roland@redhat.com>

This defines a new hook tracehook_force_sigpending() that lets tracing
code decide to force TIF_SIGPENDING on in recalc_sigpending().

This is not used yet, so it compiles away to nothing for now.  It lays the
groundwork for new tracing code that can interrupt a task synthetically
without actually sending a signal.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   14 ++++++++++++++
 kernel/signal.c           |    4 +++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff -puN include/linux/tracehook.h~tracehook-force-signal_pending include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-force-signal_pending
+++ a/include/linux/tracehook.h
@@ -423,6 +423,20 @@ static inline int tracehook_consider_fat
 }
 
 /**
+ * tracehook_force_sigpending - let tracing force signal_pending(current) on
+ *
+ * Called when recomputing our signal_pending() flag.  Return nonzero
+ * to force the signal_pending() flag on, so that tracehook_get_signal()
+ * will be called before the next return to user mode.
+ *
+ * Called with @current->sighand->siglock held.
+ */
+static inline int tracehook_force_sigpending(void)
+{
+	return 0;
+}
+
+/**
  * tracehook_get_signal - deliver synthetic signal to traced task
  * @task:		@current
  * @regs:		task_pt_regs(@current)
diff -puN kernel/signal.c~tracehook-force-signal_pending kernel/signal.c
--- a/kernel/signal.c~tracehook-force-signal_pending
+++ a/kernel/signal.c
@@ -134,7 +134,9 @@ void recalc_sigpending_and_wake(struct t
 
 void recalc_sigpending(void)
 {
-	if (!recalc_sigpending_tsk(current) && !freezing(current))
+	if (unlikely(tracehook_force_sigpending()))
+		set_thread_flag(TIF_SIGPENDING);
+	else if (!recalc_sigpending_tsk(current) && !freezing(current))
 		clear_thread_flag(TIF_SIGPENDING);
 
 }
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

