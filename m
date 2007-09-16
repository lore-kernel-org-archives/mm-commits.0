From: akpm@linux-foundation.org
Subject: - pnp-remove-smcf010-quirk.patch removed from -mm tree
Date: Sun, 16 Sep 2007 02:25:31 -0700
Message-ID: <200709160925.l8G9PVMg009109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbXIPJZp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 05:25:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, arvidjaar@mail.ru, michal.k.k.piotrowski@gmail.com, mm-commits@vger.kernel.org


The patch titled
     PNP: remove SMCf010 quirk
has been removed from the -mm tree.  Its filename was
     pnp-remove-smcf010-quirk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PNP: remove SMCf010 quirk
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

If the quirk enables the SIR part of the SMCf010 device, the 8250 driver
may claim it as a legacy ttyS device, which makes the legacy probe in the
smsc-ircc2 driver fail.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |  103 -----------------------------------------
 1 files changed, 103 deletions(-)

diff -puN drivers/pnp/quirks.c~pnp-remove-smcf010-quirk drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-remove-smcf010-quirk
+++ a/drivers/pnp/quirks.c
@@ -107,108 +107,6 @@ static void quirk_sb16audio_resources(st
 		       "pnp: SB audio device quirk - increasing port range\n");
 }
 
-static int quirk_smc_fir_enabled(struct pnp_dev *dev)
-{
-	unsigned long firbase;
-	u8 bank, high, low, chip;
-
-	if (!pnp_port_valid(dev, 1))
-		return 0;
-
-	firbase = pnp_port_start(dev, 1);
-
-	/* Select register bank 3 */
-	bank = inb(firbase + 7);
-	bank &= 0xf0;
-	bank |= 3;
-	outb(bank, firbase + 7);
-
-	high = inb(firbase + 0);
-	low = inb(firbase + 1);
-	chip = inb(firbase + 2);
-
-	/* This corresponds to the check in smsc_ircc_present() */
-	if (high == 0x10 && low == 0xb8 && (chip == 0xf1 || chip == 0xf2))
-		return 1;
-
-	return 0;
-}
-
-static void quirk_smc_enable(struct pnp_dev *dev)
-{
-	struct resource fir, sir, irq;
-
-	pnp_activate_dev(dev);
-	if (quirk_smc_fir_enabled(dev))
-		return;
-
-	/*
-	 * Sometimes the BIOS claims the device is enabled, but it reports
-	 * the wrong FIR resources or doesn't properly configure ISA or LPC
-	 * bridges on the way to the device.
-	 *
-	 * HP nc6000 and nc8000/nw8000 laptops have known problems like
-	 * this.  Fortunately, they do fix things up if we auto-configure
-	 * the device using its _PRS and _SRS methods.
-	 */
-	dev_err(&dev->dev, "%s not responding at SIR 0x%lx, FIR 0x%lx; "
-		"auto-configuring\n", dev->id->id,
-		(unsigned long)pnp_port_start(dev, 0),
-		(unsigned long)pnp_port_start(dev, 1));
-
-	pnp_disable_dev(dev);
-	pnp_init_resource_table(&dev->res);
-	pnp_auto_config_dev(dev);
-	pnp_activate_dev(dev);
-	if (quirk_smc_fir_enabled(dev)) {
-		dev_err(&dev->dev, "responds at SIR 0x%lx, FIR 0x%lx\n",
-			(unsigned long)pnp_port_start(dev, 0),
-			(unsigned long)pnp_port_start(dev, 1));
-		return;
-	}
-
-	/*
-	 * The Toshiba Portege 4000 _CRS reports the FIR region first,
-	 * followed by the SIR region.  The BIOS will configure the bridge,
-	 * but only if we call _SRS with SIR first, then FIR.  It also
-	 * reports the IRQ as active high, when it is really active low.
-	 */
-	dev_err(&dev->dev, "not responding at SIR 0x%lx, FIR 0x%lx; "
-		"swapping SIR/FIR and reconfiguring\n",
-		(unsigned long)pnp_port_start(dev, 0),
-		(unsigned long)pnp_port_start(dev, 1));
-
-	/*
-	 * Clear IORESOURCE_AUTO so pnp_activate_dev() doesn't reassign
-	 * these resources any more.
-	 */
-	fir = dev->res.port_resource[0];
-	sir = dev->res.port_resource[1];
-	fir.flags &= ~IORESOURCE_AUTO;
-	sir.flags &= ~IORESOURCE_AUTO;
-
-	irq = dev->res.irq_resource[0];
-	irq.flags &= ~IORESOURCE_AUTO;
-	irq.flags &= ~IORESOURCE_BITS;
-	irq.flags |= IORESOURCE_IRQ_LOWEDGE;
-
-	pnp_disable_dev(dev);
-	dev->res.port_resource[0] = sir;
-	dev->res.port_resource[1] = fir;
-	dev->res.irq_resource[0] = irq;
-	pnp_activate_dev(dev);
-
-	if (quirk_smc_fir_enabled(dev)) {
-		dev_err(&dev->dev, "responds at SIR 0x%lx, FIR 0x%lx\n",
-			(unsigned long)pnp_port_start(dev, 0),
-			(unsigned long)pnp_port_start(dev, 1));
-		return;
-	}
-
-	dev_err(&dev->dev, "giving up; try \"smsc-ircc2.nopnp\" and "
-		"email bjorn.helgaas@hp.com\n");
-}
-
 /*
  *  PnP Quirks
  *  Cards or devices that need some tweaking due to incomplete resource info
@@ -229,7 +127,6 @@ static struct pnp_fixup pnp_fixups[] = {
 	{"CTL0043", quirk_sb16audio_resources},
 	{"CTL0044", quirk_sb16audio_resources},
 	{"CTL0045", quirk_sb16audio_resources},
-	{"SMCf010", quirk_smc_enable},
 	{""}
 };
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
document-the-fact-that-smsc-ircc2-will-not-use-pnp-by-default.patch
serial-keep-the-dtr-setting-for-serial-console.patch
move-free-pages-between-lists-on-steal.patch
convert-ill-defined-log2-to-ilog2.patch
tpm_tis-fix-interrupt-probing.patch
pnp-make-pnpacpi_suspend-handle-errors.patch
pnp-dont-fail-device-init-if-no-dma-channel.patch
