From: akpm@linux-foundation.org
Subject: + smsc-ircc2-tidy-up-module-parameter-checking.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:21:04 -0700
Message-ID: <200704070021.l370L4EK023676@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40354 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933450AbXDGA3K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:29:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, castet.matthieu@free.fr, jt@hpl.hp.com, kaos@ocs.com.au, lenb@kernel.org, mjg59@srcf.ucam.org, rmk+serial@arm.linux.org.uk, samuel@sortiz.org, syrjala@sci.fi


The patch titled
     smsc-ircc2: tidy up module parameter checking
has been added to the -mm tree.  Its filename is
     smsc-ircc2-tidy-up-module-parameter-checking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: smsc-ircc2: tidy up module parameter checking
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

To determine whether the user specified a module parameter, use some #defines
instead of checking for bare magic numbers.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Keith Owens <kaos@ocs.com.au>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Matthieu CASTET <castet.matthieu@free.fr>
Cc: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Russell King <rmk+serial@arm.linux.org.uk>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/smsc-ircc2.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/net/irda/smsc-ircc2.c~smsc-ircc2-tidy-up-module-parameter-checking drivers/net/irda/smsc-ircc2.c
--- a/drivers/net/irda/smsc-ircc2.c~smsc-ircc2-tidy-up-module-parameter-checking
+++ a/drivers/net/irda/smsc-ircc2.c
@@ -79,11 +79,13 @@ MODULE_AUTHOR("Daniele Peri <peri@csai.u
 MODULE_DESCRIPTION("SMC IrCC SIR/FIR controller driver");
 MODULE_LICENSE("GPL");
 
-static int ircc_dma = 255;
+#define DMA_INVAL 255
+static int ircc_dma = DMA_INVAL;
 module_param(ircc_dma, int, 0);
 MODULE_PARM_DESC(ircc_dma, "DMA channel");
 
-static int ircc_irq = 255;
+#define IRQ_INVAL 255
+static int ircc_irq = IRQ_INVAL;
 module_param(ircc_irq, int, 0);
 MODULE_PARM_DESC(ircc_irq, "IRQ line");
 
@@ -646,7 +648,7 @@ static void smsc_ircc_setup_io(struct sm
 	self->io.fifo_size = SMSC_IRCC2_FIFO_SIZE;
 	self->io.speed = SMSC_IRCC2_C_IRDA_FALLBACK_SPEED;
 
-	if (irq < 255) {
+	if (irq != IRQ_INVAL) {
 		if (irq != chip_irq)
 			IRDA_MESSAGE("%s, Overriding IRQ - chip says %d, using %d\n",
 				     driver_name, chip_irq, irq);
@@ -654,7 +656,7 @@ static void smsc_ircc_setup_io(struct sm
 	} else
 		self->io.irq = chip_irq;
 
-	if (dma < 255) {
+	if (dma != DMA_INVAL) {
 		if (dma != chip_dma)
 			IRDA_MESSAGE("%s, Overriding DMA - chip says %d, using %d\n",
 				     driver_name, chip_dma, dma);
@@ -2836,9 +2838,9 @@ static int __init smsc_ircc_preconfigure
 					tmpconf.fir_io = ircc_fir;
 				if (ircc_sir != 0)
 					tmpconf.sir_io = ircc_sir;
-				if (ircc_dma != 0xff)
+				if (ircc_dma != DMA_INVAL)
 					tmpconf.fir_dma = ircc_dma;
-				if (ircc_irq != 0xff)
+				if (ircc_irq != IRQ_INVAL)
 					tmpconf.fir_irq = ircc_irq;
 
 				IRDA_MESSAGE("Detected unconfigured %s SMSC IrDA chip, pre-configuring device.\n", conf->name);
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

git-ia64.patch
move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set.patch
pnpacpi-sets-pnpdev-devarchdata.patch
pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi.patch
pnp-workaround-hp-bios-defect-that-leaves-smcf010-device-partly-enabled.patch
smsc-ircc2-tidy-up-module-parameter-checking.patch
smsc-ircc2-add-pnp-support.patch
x86-serial-convert-legacy-com-ports-to-platform-devices.patch
