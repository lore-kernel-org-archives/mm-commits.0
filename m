From: akpm@linux-foundation.org
Subject: - use-write_trylock_irqsave-in-ptrace_attach.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:52:10 -0700
Message-ID: <200707162052.l6GKqAIv001513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42520 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763797AbXGPVb2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:31:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sripathik@in.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     Use write_trylock_irqsave in ptrace_attach
has been removed from the -mm tree.  Its filename was
     use-write_trylock_irqsave-in-ptrace_attach.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use write_trylock_irqsave in ptrace_attach
From: Sripathi Kodi <sripathik@in.ibm.com>

This patch makes ptrace_attach use write_trylock_irqsave().

[akpm@linux-foundation.org: remove unneeded initialisation]
Signed-off-by: Sripathi Kodi <sripathik@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN kernel/ptrace.c~use-write_trylock_irqsave-in-ptrace_attach kernel/ptrace.c
--- a/kernel/ptrace.c~use-write_trylock_irqsave-in-ptrace_attach
+++ a/kernel/ptrace.c
@@ -161,6 +161,7 @@ int ptrace_may_attach(struct task_struct
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
+	unsigned long flags;
 
 	audit_ptrace(task);
 
@@ -181,9 +182,7 @@ repeat:
 	 * cpu's that may have task_lock).
 	 */
 	task_lock(task);
-	local_irq_disable();
-	if (!write_trylock(&tasklist_lock)) {
-		local_irq_enable();
+	if (!write_trylock_irqsave(&tasklist_lock, flags)) {
 		task_unlock(task);
 		do {
 			cpu_relax();
@@ -211,7 +210,7 @@ repeat:
 	force_sig_specific(SIGSTOP, task);
 
 bad:
-	write_unlock_irq(&tasklist_lock);
+	write_unlock_irqrestore(&tasklist_lock, flags);
 	task_unlock(task);
 out:
 	return retval;
_

Patches currently in -mm which might be from sripathik@in.ibm.com are

origin.patch
