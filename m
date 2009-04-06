From: akpm@linux-foundation.org
Subject: [merged] xtensa-use-correct-stack-pointer-for-stack-traces.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:48 -0700
Message-ID: <200904061939.n36JdmTl014052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216AbZDFUPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jw@emlix.com, chris@zankel.net, os@emlix.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: use correct stack pointer for stack traces
has been removed from the -mm tree.  Its filename was
     xtensa-use-correct-stack-pointer-for-stack-traces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: use correct stack pointer for stack traces
From: Johannes Weiner <jw@emlix.com>

Right now, the xtensa stacktrace code reads the _current_ kernel stack
pointer if nothing is supplied.  With debugging facilities like sysrq this
means that the backtrace of the sysrq-handler is printed instead of a
trace of the given task's stack.

When no stack pointer is specified in show_trace() and show_stack(), use
the stack pointer that comes with the handed in task descriptor to make
stack traces more useful.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/traps.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN arch/xtensa/kernel/traps.c~xtensa-use-correct-stack-pointer-for-stack-traces arch/xtensa/kernel/traps.c
--- a/arch/xtensa/kernel/traps.c~xtensa-use-correct-stack-pointer-for-stack-traces
+++ a/arch/xtensa/kernel/traps.c
@@ -374,11 +374,10 @@ void show_trace(struct task_struct *task
 	unsigned long a0, a1, pc;
 	unsigned long sp_start, sp_end;
 
-	a1 = (unsigned long)sp;
-
-	if (a1 == 0)
-		__asm__ __volatile__ ("mov %0, a1\n" : "=a"(a1));
-
+	if (sp)
+		a1 = (unsigned long)sp;
+	else
+		a1 = task->thread.sp;
 
 	sp_start = a1 & ~(THREAD_SIZE-1);
 	sp_end = sp_start + THREAD_SIZE;
@@ -420,9 +419,8 @@ void show_stack(struct task_struct *task
 	int i = 0;
 	unsigned long *stack;
 
-	if (sp == 0)
-		__asm__ __volatile__ ("mov %0, a1\n" : "=a"(sp));
