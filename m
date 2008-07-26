From: akpm@linux-foundation.org
Subject: - tracehook-exit.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:39 -0700
Message-ID: <200807262116.m6QLGdoG019849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757713AbYGZVRI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: exit
has been removed from the -mm tree.  Its filename was
     tracehook-exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: exit
From: Roland McGrath <roland@redhat.com>

This moves the PTRACE_EVENT_EXIT tracing into a tracehook.h inline,
tracehook_report_exec().  The change has no effect, just clean-up.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   15 +++++++++++++++
 kernel/exit.c             |    6 ++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff -puN include/linux/tracehook.h~tracehook-exit include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-exit
+++ a/include/linux/tracehook.h
@@ -95,4 +95,19 @@ static inline void tracehook_report_exec
 		send_sig(SIGTRAP, current, 0);
 }
 
+/**
+ * tracehook_report_exit - task has begun to exit
+ * @exit_code:		pointer to value destined for @current->exit_code
+ *
+ * @exit_code points to the value passed to do_exit(), which tracing
+ * might change here.  This is almost the first thing in do_exit(),
+ * before freeing any resources or setting the %PF_EXITING flag.
+ *
+ * Called with no locks held.
+ */
+static inline void tracehook_report_exit(long *exit_code)
+{
+	ptrace_event(PT_TRACE_EXIT, PTRACE_EVENT_EXIT, *exit_code);
+}
+
 #endif	/* <linux/tracehook.h> */
diff -puN kernel/exit.c~tracehook-exit kernel/exit.c
--- a/kernel/exit.c~tracehook-exit
+++ a/kernel/exit.c
@@ -46,6 +46,7 @@
 #include <linux/resource.h>
 #include <linux/blkdev.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/tracehook.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -1029,10 +1030,7 @@ NORET_TYPE void do_exit(long code)
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
 
-	if (unlikely(current->ptrace & PT_TRACE_EXIT)) {
-		current->ptrace_message = code;
-		ptrace_notify((PTRACE_EVENT_EXIT << 8) | SIGTRAP);
-	}
+	tracehook_report_exit(&code);
 
 	/*
 	 * We're taking recursive faults here in do_exit. Safest is to just
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

