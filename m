From: akpm@osdl.org
Subject: + __set_irq_handler-bogus-space.patch added to -mm tree
Date: Wed, 20 Dec 2006 21:38:25 -0800
Message-ID: <200612210538.kBL5cPDX016789@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40141 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422737AbWLUFig (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 00:38:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Geert.Uytterhoeven@sonycom.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     __set_irq_handler bogus space
has been added to the -mm tree.  Its filename is
     __set_irq_handler-bogus-space.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

__set_irq_handler-bogus-space.patch

