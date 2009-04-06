From: akpm@linux-foundation.org
Subject: [merged] ptrace-kill-__ptrace_detach-fix-exit_state-check.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:34 -0700
Message-ID: <200904061935.n36JZYdF012064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757702AbZDFTjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:39:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dvlasenk@redhat.com, jmarchan@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: kill __ptrace_detach(), fix ->exit_state check
has been removed from the -mm tree.  Its filename was
     ptrace-kill-__ptrace_detach-fix-exit_state-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: kill __ptrace_detach(), fix ->exit_state check
From: Oleg Nesterov <oleg@redhat.com>

Move the code from __ptrace_detach() to its single caller and kill this
helper.

Also, fix the ->exit_state check, we shouldn't wake up EXIT_DEAD tasks. 
Actually, I think task_is_stopped_or_traced() makes more sense, but this
needs another patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN kernel/ptrace.c~ptrace-kill-__ptrace_detach-fix-exit_state-check kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-kill-__ptrace_detach-fix-exit_state-check
+++ a/kernel/ptrace.c
@@ -235,16 +235,6 @@ out:
 	return retval;
 }
 
-static inline void __ptrace_detach(struct task_struct *child, unsigned int data)
-{
-	child->exit_code = data;
-	/* .. re-parent .. */
-	__ptrace_unlink(child);
-	/* .. and wake it up. */
-	if (child->exit_state != EXIT_ZOMBIE)
-		wake_up_process(child);
-}
-
 int ptrace_detach(struct task_struct *child, unsigned int data)
 {
 	if (!valid_signal(data))
@@ -254,10 +244,16 @@ int ptrace_detach(struct task_struct *ch
 	ptrace_disable(child);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 
-	write_lock_irq(&tasklist_lock);
 	/* protect against de_thread()->release_task() */
-	if (child->ptrace)
-		__ptrace_detach(child, data);
+	write_lock_irq(&tasklist_lock);
+	if (child->ptrace) {
+		child->exit_code = data;
+
+		__ptrace_unlink(child);
+
+		if (!child->exit_state)
+			wake_up_process(child);
+	}
 	write_unlock_irq(&tasklist_lock);
 
 	return 0;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

