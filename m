From: akpm@linux-foundation.org
Subject: - colibri-fix-support-for-dm9000-ethernet-device.patch removed from -mm tree
Date: Mon, 19 May 2008 02:18:41 -0700
Message-ID: <200805190918.m4J9IfZD025361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752115AbYESJUk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 05:20:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.abbott@diamond.ac.uk, ben-linux@fluff.org, daniel@caiaq.org, jeff@garzik.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     colibri: fix support for DM9000 ethernet device
has been removed from the -mm tree.  Its filename was
     colibri-fix-support-for-dm9000-ethernet-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: colibri: fix support for DM9000 ethernet device
From: Michael Abbott <michael.abbott@diamond.ac.uk>

Two changes are necessary to enable proper operation of the DM9000 device with
the Colibri PXA 270 board: firstly, the IRQ type needs to be configured for
rising edge interrupts, and secondly this configuration needs to be
communicated through to the DM9000.

[akpm@linux-foundation.org: remove set_irq_type() call as per ben-linux request]
Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
Cc: Daniel Mack <daniel@caiaq.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/colibri.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/arm/mach-pxa/colibri.c~colibri-fix-support-for-dm9000-ethernet-device arch/arm/mach-pxa/colibri.c
--- a/arch/arm/mach-pxa/colibri.c~colibri-fix-support-for-dm9000-ethernet-device
+++ a/arch/arm/mach-pxa/colibri.c
@@ -98,7 +98,7 @@ static struct resource dm9000_resources[
 	[2] = {
 		.start	= COLIBRI_ETH_IRQ,
 		.end	= COLIBRI_ETH_IRQ,
-		.flags	= IORESOURCE_IRQ,
+		.flags	= IORESOURCE_IRQ | IRQF_TRIGGER_RISING,
 	},
 };
 
@@ -119,7 +119,6 @@ static void __init colibri_init(void)
 	/* DM9000 LAN */
 	pxa_gpio_mode(GPIO78_nCS_2_MD);
 	pxa_gpio_mode(GPIO_DM9000 | GPIO_IN);
-	set_irq_type(COLIBRI_ETH_IRQ, IRQT_FALLING);
 
 	platform_add_devices(colibri_devices, ARRAY_SIZE(colibri_devices));
 }
_

Patches currently in -mm which might be from michael.abbott@diamond.ac.uk are


