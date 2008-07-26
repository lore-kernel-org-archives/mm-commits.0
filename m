From: akpm@linux-foundation.org
Subject: - tracehook-vfork-done.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:16:43 -0700
Message-ID: <200807262116.m6QLGh6L019855@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757730AbYGZVRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:17:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     tracehook: vfork-done
has been removed from the -mm tree.  Its filename was
     tracehook-vfork-done.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: vfork-done
From: Roland McGrath <roland@redhat.com>

This moves the PTRACE_EVENT_VFORK_DONE tracing into a tracehook.h inline,
tracehook_report_vfork_done().  The change has no effect, just clean-up.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   18 ++++++++++++++++++
 kernel/fork.c             |    5 +----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff -puN include/linux/tracehook.h~tracehook-vfork-done include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-vfork-done
+++ a/include/linux/tracehook.h
@@ -210,4 +210,22 @@ static inline void tracehook_report_clon
 		ptrace_event(0, trace, pid);
 }
 
+/**
+ * tracehook_report_vfork_done - vfork parent's child has exited or exec'd
+ * @child:		child task, already running
+ * @pid:		new child's PID in the parent's namespace
+ *
+ * Called after a %CLONE_VFORK parent has waited for the child to complete.
+ * The clone/vfork system call will return immediately after this.
+ * The @child pointer may be invalid if a self-reaping child died and
+ * tracehook_report_clone() took no action to prevent it from self-reaping.
+ *
+ * Called with no locks held.
+ */
+static inline void tracehook_report_vfork_done(struct task_struct *child,
+					       pid_t pid)
+{
+	ptrace_event(PT_TRACE_VFORK_DONE, PTRACE_EVENT_VFORK_DONE, pid);
+}
+
 #endif	/* <linux/tracehook.h> */
diff -puN kernel/fork.c~tracehook-vfork-done kernel/fork.c
--- a/kernel/fork.c~tracehook-vfork-done
+++ a/kernel/fork.c
@@ -1414,10 +1414,7 @@ long do_fork(unsigned long clone_flags,
 			freezer_do_not_count();
 			wait_for_completion(&vfork);
 			freezer_count();
-			if (unlikely (current->ptrace & PT_TRACE_VFORK_DONE)) {
-				current->ptrace_message = nr;
-				ptrace_notify ((PTRACE_EVENT_VFORK_DONE << 8) | SIGTRAP);
-			}
+			tracehook_report_vfork_done(p, nr);
 		}
 	} else {
 		nr = PTR_ERR(p);
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

