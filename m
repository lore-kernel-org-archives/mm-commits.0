From: akpm@linux-foundation.org
Subject: + pnp-smcf010-quirk-auto-config-device-if-bios-left-it-broken.patch added to -mm tree
Date: Mon, 25 Jun 2007 14:36:13 -0700
Message-ID: <200706252136.l5PLaDaH011337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53863 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949AbXFYVhb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 17:37:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, arvidjaar@mail.ru, linus.walleij@ericsson.com, michal.k.k.piotrowski@gmail.com, samuel@sortiz.org


The patch titled
     PNP SMCf010 quirk: auto-config device if BIOS left it broken
has been added to the -mm tree.  Its filename is
     pnp-smcf010-quirk-auto-config-device-if-bios-left-it-broken.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNP SMCf010 quirk: auto-config device if BIOS left it broken
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Some HP firmware leaves the SMCf010 IRDA device incompletely configured, or
reports the wrong resources in _CRS.  As a workaround, when we find such a
device, try to auto-configure the device.

This ignores the _CRS data, picks a config from _PRS, and runs _SRS to
configure the device.  This makes smsc-ircc2 work correctly with PNP
resources (with no preconfiguration!) on all the machines I tested.

I think Windows does something like this by default for all devices,
so we should consider doing the same thing in Linux.

This patch addresses part of the 2.6.22 regression:
    "no irda0 interface (2.6.21 was OK), smsc does not find chip"
It fixes smsc-ircc2 PNP device detection on HP nc6000, nc6220, nw8000,
nw8240, and possibly other machines.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/quirks.c |   66 +++++++++++++++++++++++++++++------------
 1 files changed, 48 insertions(+), 18 deletions(-)

diff -puN drivers/pnp/quirks.c~pnp-smcf010-quirk-auto-config-device-if-bios-left-it-broken drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-smcf010-quirk-auto-config-device-if-bios-left-it-broken
+++ a/drivers/pnp/quirks.c
@@ -107,31 +107,61 @@ static void quirk_sb16audio_resources(st
 	return;
 }
 
-static void quirk_smc_enable(struct pnp_dev *dev)
+static int quirk_smc_fir_enabled(struct pnp_dev *dev)
 {
-	unsigned int firbase;
+	unsigned long firbase;
+	u8 bank, high, low, chip;
+
+	if (!pnp_port_valid(dev, 1))
+		return 0;
+
+	firbase = pnp_port_start(dev, 1);
 
-	if (!dev->active || !pnp_port_valid(dev, 1))
+	/* Select register bank 3 */
+	bank = inb(firbase + 7);
+	bank &= 0xf0;
+	bank |= 3;
+	outb(bank, firbase + 7);
+
+	high = inb(firbase + 0);
+	low  = inb(firbase + 1);
+	chip = inb(firbase + 2);
+
+	/* This corresponds to the check in smsc_ircc_present() */
+	if (high == 0x10 && low == 0xb8 && (chip == 0xf1 || chip == 0xf2))
+		return 1;
+
+	return 0;
+}
+
+static void quirk_smc_enable(struct pnp_dev *dev)
+{
+	/*
+	 * If the BIOS left the device disabled, or it is enabled and
+	 * responding correctly, we're in good shape.
+	 */
+	if (!dev->active || quirk_smc_fir_enabled(dev))
 		return;
 
 	/*
-	 * On the HP/Compaq nw8240 (and probably other similar machines),
-	 * there is an SMCF010 device with two I/O port regions:
-	 *
-	 *	0x3e8-0x3ef SIR
-	 *	0x100-0x10f FIR
+	 * Sometimes the BIOS claims the device is enabled, but it reports
+	 * the wrong FIR resources or doesn't properly configure ISA or LPC
+	 * bridges on the way to the device.
 	 *
-	 * _STA reports the device is enabled, but in fact, the BIOS
-	 * neglects to enable the FIR range.  Fortunately, it does fully
-	 * enable the device if we call _SRS.
+	 * HP nc6000 and nc8000/nw8000 laptops have known problems like
+	 * this.  Fortunately, they do fix things up if we auto-configure
+	 * the device using its _PRS and _SRS methods.
 	 */
-	firbase = pnp_port_start(dev, 1);
-	if (inb(firbase + 0x7 /* IRCC_MASTER */) == 0xff) {
-		pnp_err("%s (%s) enabled but not responding, disabling and "
-			"re-enabling", dev->dev.bus_id, pnp_dev_name(dev));
-		pnp_disable_dev(dev);
-		pnp_activate_dev(dev);
-	}
+	dev_err(&dev->dev, "%s device not responding, auto-configuring "
+		"resources\n", dev->id->id);
+
+	pnp_disable_dev(dev);
+	pnp_init_resource_table(&dev->res);
+	pnp_auto_config_dev(dev);
+	pnp_activate_dev(dev);
+
+	if (!quirk_smc_fir_enabled(dev))
+		dev_err(&dev->dev, "giving up; try \"smsc-ircc2.nopnp\"\n");
 }
 
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

smsc-ircc2-skip-preconfiguration-for-pnp-devices.patch
pnp-smcf010-quirk-auto-config-device-if-bios-left-it-broken.patch
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
