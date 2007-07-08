From: akpm@linux-foundation.org
Subject: - pnp-smcf010-quirk-work-around-toshiba-portege-4000-acpi-issues.patch removed from -mm tree
Date: Sun, 08 Jul 2007 01:11:21 -0700
Message-ID: <200707080811.l688BLfR014764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46228 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751650AbXGHILn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jul 2007 04:11:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, arvidjaar@mail.ru, linus.walleij@ericsson.com, michal.k.k.piotrowski@gmail.com, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     PNP SMCf010 quirk: work around Toshiba Portege 4000 ACPI issues
has been removed from the -mm tree.  Its filename was
     pnp-smcf010-quirk-work-around-toshiba-portege-4000-acpi-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PNP SMCf010 quirk: work around Toshiba Portege 4000 ACPI issues
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

When we enable the SMCf010 IR device, the Toshiba Portege 4000 BIOS claims
the device is working, but it really isn't configured correctly.  The BIOS
*will* configure it, but only if we call _SRS after (1) reversing the order
of the SIR and FIR I/O port regions and (2) changing the IRQ from
active-high to active-low.

This patch addresses the 2.6.22 regression:
    "no irda0 interface (2.6.21 was OK), smsc does not find chip"

I tested this on a Portege 4000.  The smsc-ircc2 driver correctly detects
the device, and "irattach irda0 -s && irdadump" shows transmitted and
received packets.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |   63 +++++++++++++++++++++++++++++++++++------
 1 file changed, 54 insertions(+), 9 deletions(-)

diff -puN drivers/pnp/quirks.c~pnp-smcf010-quirk-work-around-toshiba-portege-4000-acpi-issues drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-smcf010-quirk-work-around-toshiba-portege-4000-acpi-issues
+++ a/drivers/pnp/quirks.c
@@ -136,11 +136,10 @@ static int quirk_smc_fir_enabled(struct 
 
 static void quirk_smc_enable(struct pnp_dev *dev)
 {
-	/*
-	 * If the BIOS left the device disabled, or it is enabled and
-	 * responding correctly, we're in good shape.
-	 */
-	if (!dev->active || quirk_smc_fir_enabled(dev))
+	struct resource fir, sir, irq;
+
+	pnp_activate_dev(dev);
+	if (quirk_smc_fir_enabled(dev))
 		return;
 
 	/*
@@ -152,16 +151,62 @@ static void quirk_smc_enable(struct pnp_
 	 * this.  Fortunately, they do fix things up if we auto-configure
 	 * the device using its _PRS and _SRS methods.
 	 */
-	dev_err(&dev->dev, "%s device not responding, auto-configuring "
-		"resources\n", dev->id->id);
+	dev_err(&dev->dev, "%s not responding at SIR 0x%lx, FIR 0x%lx; "
+		"auto-configuring\n", dev->id->id,
+		(unsigned long) pnp_port_start(dev, 0),
+		(unsigned long) pnp_port_start(dev, 1));
 
 	pnp_disable_dev(dev);
 	pnp_init_resource_table(&dev->res);
 	pnp_auto_config_dev(dev);
 	pnp_activate_dev(dev);
+	if (quirk_smc_fir_enabled(dev)) {
+		dev_err(&dev->dev, "responds at SIR 0x%lx, FIR 0x%lx\n",
+			(unsigned long) pnp_port_start(dev, 0),
+			(unsigned long) pnp_port_start(dev, 1));
+		return;
+	}
+
+	/*
+	 * The Toshiba Portege 4000 _CRS reports the FIR region first,
+	 * followed by the SIR region.  The BIOS will configure the bridge,
+	 * but only if we call _SRS with SIR first, then FIR.  It also
+	 * reports the IRQ as active high, when it is really active low.
+	 */
+	dev_err(&dev->dev, "not responding at SIR 0x%lx, FIR 0x%lx; "
+		"swapping SIR/FIR and reconfiguring\n",
+		(unsigned long) pnp_port_start(dev, 0),
+		(unsigned long) pnp_port_start(dev, 1));
+
+	/*
+	 * Clear IORESOURCE_AUTO so pnp_activate_dev() doesn't reassign
+	 * these resources any more.
+	 */
+	fir = dev->res.port_resource[0];
+	sir = dev->res.port_resource[1];
+	fir.flags &= ~IORESOURCE_AUTO;
+	sir.flags &= ~IORESOURCE_AUTO;
+
+	irq = dev->res.irq_resource[0];
+	irq.flags &= ~IORESOURCE_AUTO;
+	irq.flags &= ~IORESOURCE_BITS;
+	irq.flags |= IORESOURCE_IRQ_LOWEDGE;
+
+	pnp_disable_dev(dev);
+	dev->res.port_resource[0] = sir;
+	dev->res.port_resource[1] = fir;
+	dev->res.irq_resource[0] = irq;
+	pnp_activate_dev(dev);
+
+	if (quirk_smc_fir_enabled(dev)) {
+		dev_err(&dev->dev, "responds at SIR 0x%lx, FIR 0x%lx\n",
+			(unsigned long) pnp_port_start(dev, 0),
+			(unsigned long) pnp_port_start(dev, 1));
+		return;
+	}
 
-	if (!quirk_smc_fir_enabled(dev))
-		dev_err(&dev->dev, "giving up; try \"smsc-ircc2.nopnp\"\n");
+	dev_err(&dev->dev, "giving up; try \"smsc-ircc2.nopnp\" and "
+		"email bjorn.helgaas@hp.com\n");
 }
 
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
serial-assert-dtr-for-serial-console-devices.patch
console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
x86-initial-fixmap-support.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
serial-convert-early_uart-to-earlycon-for-8250-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-ia64-fix.patch
serial-convert-early_uart-to-earlycon-for-8250-fix-3-alias.patch
move-free-pages-between-lists-on-steal.patch
use-menuconfig-objects-pnp.patch
