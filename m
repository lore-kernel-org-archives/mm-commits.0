From: akpm@linux-foundation.org
Subject: - tracehook-tif_notify_resume.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:17:05 -0700
Message-ID: <200807262117.m6QLH5rE019904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757946AbYGZVRn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: TIF_NOTIFY_RESUME
has been removed from the -mm tree.  Its filename was
     tracehook-tif_notify_resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: TIF_NOTIFY_RESUME
From: Roland McGrath <roland@redhat.com>

This adds tracehook.h inlines to enable a new arch feature in support of
user debugging/tracing.  This is not used yet, but it lays the groundwork
for a debugger to be able to wrangle a task that's possibly running,
without interrupting its syscalls in progress.

Each arch should define TIF_NOTIFY_RESUME, and in their entry.S code treat
it much like TIF_SIGPENDING.  That is, it causes you to take the slow path
when returning to user mode, where you get the full user-mode state
accessible as for signal handling or ptrace.  The arch code should check
TIF_NOTIFY_RESUME after handling TIF_SIGPENDING.  When it's set, clear it
and then call tracehook_notify_resume().

In future, tracing code will call set_notify_resume() when it wants to get
a callback in tracehook_notify_resume().

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff -puN include/linux/tracehook.h~tracehook-tif_notify_resume include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-tif_notify_resume
+++ a/include/linux/tracehook.h
@@ -537,4 +537,38 @@ static inline void tracehook_report_deat
 {
 }
 
+#ifdef TIF_NOTIFY_RESUME
+/**
+ * set_notify_resume - cause tracehook_notify_resume() to be called
+ * @task:		task that will call tracehook_notify_resume()
+ *
+ * Calling this arranges that @task will call tracehook_notify_resume()
+ * before returning to user mode.  If it's already running in user mode,
+ * it will enter the kernel and call tracehook_notify_resume() soon.
+ * If it's blocked, it will not be woken.
+ */
+static inline void set_notify_resume(struct task_struct *task)
+{
+	if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_RESUME))
+		kick_process(task);
+}
+
+/**
+ * tracehook_notify_resume - report when about to return to user mode
+ * @regs:		user-mode registers of @current task
+ *
+ * This is called when %TIF_NOTIFY_RESUME has been set.  Now we are
+ * about to return to user mode, and the user state in @regs can be
+ * inspected or adjusted.  The caller in arch code has cleared
+ * %TIF_NOTIFY_RESUME before the call.  If the flag gets set again
+ * asynchronously, this will be called again before we return to
+ * user mode.
+ *
+ * Called without locks.
+ */
+static inline void tracehook_notify_resume(struct pt_regs *regs)
+{
+}
+#endif	/* TIF_NOTIFY_RESUME */
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

