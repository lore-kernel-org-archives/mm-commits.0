From: akpm@linux-foundation.org
Subject: [merged]
 ptrace-ptrace_detach-can-no-longer-race-with-sigkill.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:19:31 -0700
Message-ID: <55355143.sqYCZgkSJ81M5dTi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40357 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbbDTTNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, labath@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ptrace: ptrace_detach() can no longer race with SIGKILL
has been removed from the -mm tree.  Its filename was
     ptrace-ptrace_detach-can-no-longer-race-with-sigkill.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: ptrace: ptrace_detach() can no longer race with SIGKILL

ptrace_detach() re-checks ->ptrace under tasklist lock and calls
release_task() if __ptrace_detach() returns true.  This was needed because
the __TASK_TRACED tracee could be killed/untraced, and it could even pass
exit_notify() before we take tasklist_lock.

But this is no longer possible after 9899d11f6544 "ptrace: ensure
arch_ptrace/ptrace_request can never race with SIGKILL".  We can turn
these checks into WARN_ON() and remove release_task().

While at it, document the setting of child->exit_code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Labath <labath@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN kernel/ptrace.c~ptrace-ptrace_detach-can-no-longer-race-with-sigkill kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-ptrace_detach-can-no-longer-race-with-sigkill
+++ a/kernel/ptrace.c
@@ -456,8 +456,6 @@ static bool __ptrace_detach(struct task_
 
 static int ptrace_detach(struct task_struct *child, unsigned int data)
 {
-	bool dead = false;
-
 	if (!valid_signal(data))
 		return -EIO;
 
@@ -467,18 +465,19 @@ static int ptrace_detach(struct task_str
 
 	write_lock_irq(&tasklist_lock);
 	/*
-	 * This child can be already killed. Make sure de_thread() or
-	 * our sub-thread doing do_wait() didn't do release_task() yet.
+	 * We rely on ptrace_freeze_traced(). It can't be killed and
+	 * untraced by another thread, it can't be a zombie.
+	 */
+	WARN_ON(!child->ptrace || child->exit_state);
+	/*
+	 * tasklist_lock avoids the race with wait_task_stopped(), see
+	 * the comment in ptrace_resume().
 	 */
-	if (child->ptrace) {
-		child->exit_code = data;
-		dead = __ptrace_detach(current, child);
-	}
+	child->exit_code = data;
+	__ptrace_detach(current, child);
 	write_unlock_irq(&tasklist_lock);
 
 	proc_ptrace_connector(child, PTRACE_DETACH);
-	if (unlikely(dead))
-		release_task(child);
 
 	return 0;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch

