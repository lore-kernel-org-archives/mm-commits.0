From: akpm@linux-foundation.org
Subject: - x86-make-poll_idle-behave-more-like-the-other-idle-methods.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:45:12 -0700
Message-ID: <200809130745.m8D7jCpl026749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751581AbYIMHpe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:45:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe.korty@ccur.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: make poll_idle behave more like the other idle methods
has been removed from the -mm tree.  Its filename was
     x86-make-poll_idle-behave-more-like-the-other-idle-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: make poll_idle behave more like the other idle methods
From: Joe Korty <joe.korty@ccur.com>

Currently, poll_idle() returns immediately.  The other idle methods all
wait indefinately for some condition to come true before returning. 
poll_idle should emulate these other methods and also wait for a return
condition, in this case, for need_resched() to become 'true'.

Without this delay the idle loop spends all of its time in the outer loop
that calls poll_idle.  This outer loop, these days, does real work, some
of it under rcu locks.  That work should only be done when idle is entered
and when idle exits, not continuously while idle is spinning.

Signed-off-by: Joe Korty <joe.korty@ccur.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/process.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/process.c~x86-make-poll_idle-behave-more-like-the-other-idle-methods arch/x86/kernel/process.c
--- a/arch/x86/kernel/process.c~x86-make-poll_idle-behave-more-like-the-other-idle-methods
+++ a/arch/x86/kernel/process.c
@@ -185,7 +185,8 @@ static void mwait_idle(void)
 static void poll_idle(void)
 {
 	local_irq_enable();
-	cpu_relax();
+	while(!need_resched())
+		cpu_relax();
 }
 
 /*
_

Patches currently in -mm which might be from joe.korty@ccur.com are

linux-next.patch
forcdeth-increase-max_interrupt_work.patch
message-queues-increase-range-limits.patch
message-queues-increase-range-limits-checkpatch-fixes.patch

