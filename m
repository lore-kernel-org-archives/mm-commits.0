From: akpm@linux-foundation.org
Subject: + colibri-fix-support-for-dm9000-ethernet-device.patch added to -mm tree
Date: Tue, 06 May 2008 14:27:02 -0700
Message-ID: <200805062127.m46LR2nL028168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933636AbYEFV2P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 17:28:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.abbott@diamond.ac.uk, ben-linux@fluff.org, daniel@caiaq.org, jeff@garzik.org, rmk@arm.linux.org.uk


The patch titled
     colibri: fix support for DM9000 ethernet device
has been added to the -mm tree.  Its filename is
     colibri-fix-support-for-dm9000-ethernet-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: colibri: fix support for DM9000 ethernet device
From: Michael Abbott <michael.abbott@diamond.ac.uk>

Two changes are necessary to enable proper operation of the DM9000 device with
the Colibri PXA 270 board: firstly, the IRQ type needs to be configured for
rising edge interrupts, and secondly this configuration needs to be
communicated through to the DM9000.

Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
Cc: Daniel Mack <daniel@caiaq.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/colibri.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
 
@@ -119,7 +119,7 @@ static void __init colibri_init(void)
 	/* DM9000 LAN */
 	pxa_gpio_mode(GPIO78_nCS_2_MD);
 	pxa_gpio_mode(GPIO_DM9000 | GPIO_IN);
-	set_irq_type(COLIBRI_ETH_IRQ, IRQT_FALLING);
+	set_irq_type(COLIBRI_ETH_IRQ, IRQT_RISING);
 
 	platform_add_devices(colibri_devices, ARRAY_SIZE(colibri_devices));
 }
_

Patches currently in -mm which might be from michael.abbott@diamond.ac.uk are

dm9000-restore-mii-physical-polling-timer.patch
colibri-fix-support-for-dm9000-ethernet-device.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch

