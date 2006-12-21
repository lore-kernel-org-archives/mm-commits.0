From: akpm@osdl.org
Subject: - __set_irq_handler-bogus-space.patch removed from -mm tree
Date: Thu, 21 Dec 2006 12:10:03 -0800
Message-ID: <200612212010.kBLKA3qa003524@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36520 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423071AbWLUUKN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 15:10:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     __set_irq_handler bogus space
has been removed from the -mm tree.  Its filename was
     __set_irq_handler-bogus-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: __set_irq_handler bogus space
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/irq/chip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/irq/chip.c~__set_irq_handler-bogus-space kernel/irq/chip.c
--- a/kernel/irq/chip.c~__set_irq_handler-bogus-space
+++ a/kernel/irq/chip.c
@@ -519,7 +519,7 @@ __set_irq_handler(unsigned int irq, irq_
 		handle = handle_bad_irq;
 	else if (desc->chip == &no_irq_chip) {
 		printk(KERN_WARNING "Trying to install %sinterrupt handler "
-		       "for IRQ%d\n", is_chained ? "chained " : " ", irq);
+		       "for IRQ%d\n", is_chained ? "chained " : "", irq);
 		/*
 		 * Some ARM implementations install a handler for really dumb
 		 * interrupt hardware without setting an irq_chip. This worked
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch

