From: akpm@linux-foundation.org
Subject: - uml-an-idle-system-should-have-zero-load-average.patch removed from -mm tree
Date: Tue, 08 May 2007 19:43:49 -0700
Message-ID: <200705090243.l492hnaK008513@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967990AbXEICnw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:43:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: an idle system should have zero load average
has been removed from the -mm tree.  Its filename was
     uml-an-idle-system-should-have-zero-load-average.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: an idle system should have zero load average
From: Jeff Dike <jdike@addtoit.com>

The ever-vigilant users of linode.com noticed that an idle 2.6 UML has a
persistent load average of ~.4.

It turns out that because the UML timer handler processed softirqs before
actually delivering the tick, the tick was counted in the context of the idle
thread about half the time.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/time.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/um/kernel/time.c~uml-an-idle-system-should-have-zero-load-average arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-an-idle-system-should-have-zero-load-average
+++ a/arch/um/kernel/time.c
@@ -177,6 +177,8 @@ int do_settimeofday(struct timespec *tv)
 
 void timer_handler(int sig, union uml_pt_regs *regs)
 {
+	if(current_thread->cpu == 0)
+		timer_irq(regs);
 	local_irq_disable();
 	irq_enter();
 	update_process_times(CHOOSE_MODE(
@@ -184,6 +186,4 @@ void timer_handler(int sig, union uml_pt
 			     (regs)->skas.is_user));
 	irq_exit();
 	local_irq_enable();
-	if(current_thread->cpu == 0)
-		timer_irq(regs);
 }
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-build-breakage.patch
uml-mark-a-tt-only-function.patch
fix-linuxdoc-comment.patch
