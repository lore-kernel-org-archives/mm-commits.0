From: akpm@linux-foundation.org
Subject: - pnp-workaround-hp-bios-defect-that-leaves-smcf010-device-partly-enabled.patch removed from -mm tree
Date: Tue, 08 May 2007 19:56:44 -0700
Message-ID: <200705090256.l492uiGi010088@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970205AbXEIC6i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:58:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, ambx1@neo.rr.com, castet.matthieu@free.fr, jt@hpl.hp.com, kaos@ocs.com.au, lenb@kernel.org, mjg59@srcf.ucam.org, rmk+serial@arm.linux.org.uk, samuel@sortiz.org, syrjala@sci.fi, mm-commits@vger.kernel.org


The patch titled
     PNP: workaround HP BIOS defect that leaves SMCF010 device partly enabled
has been removed from the -mm tree.  Its filename was
     pnp-workaround-hp-bios-defect-that-leaves-smcf010-device-partly-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PNP: workaround HP BIOS defect that leaves SMCF010 device partly enabled
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Some HP/Compaq firmware reports via ACPI that the SMCF010 IR device is
enabled, but in fact, it leaves the device partly disabled.

HP nw8240 BIOS 68DTV Ver.  F.0F, released 9/15/2005 is one BIOS that has this
problem.

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

 drivers/pnp/quirks.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN drivers/pnp/quirks.c~pnp-workaround-hp-bios-defect-that-leaves-smcf010-device-partly-enabled drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-workaround-hp-bios-defect-that-leaves-smcf010-device-partly-enabled
+++ a/drivers/pnp/quirks.c
@@ -16,6 +16,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/pnp.h>
+#include <linux/io.h>
 #include "base.h"
 
 
@@ -106,6 +107,34 @@ static void quirk_sb16audio_resources(st
 	return;
 }
 
+static void quirk_smc_enable(struct pnp_dev *dev)
+{
+	unsigned int firbase;
+
+	if (!dev->active || !pnp_port_valid(dev, 1))
+		return;
+
+	/*
+	 * On the HP/Compaq nw8240 (and probably other similar machines),
+	 * there is an SMCF010 device with two I/O port regions:
+	 *
+	 *	0x3e8-0x3ef SIR
+	 *	0x100-0x10f FIR
+	 *
+	 * _STA reports the device is enabled, but in fact, the BIOS
+	 * neglects to enable the FIR range.  Fortunately, it does fully
+	 * enable the device if we call _SRS.
+	 */
+	firbase = pnp_port_start(dev, 1);
+	if (inb(firbase + 0x7 /* IRCC_MASTER */) == 0xff) {
+		pnp_err("%s (%s) enabled but not responding, disabling and "
+			"re-enabling", dev->dev.bus_id, pnp_dev_name(dev));
+		pnp_disable_dev(dev);
+		pnp_activate_dev(dev);
+	}
+}
+
+
 /*
  *  PnP Quirks
  *  Cards or devices that need some tweaking due to incomplete resource info
@@ -126,6 +155,7 @@ static struct pnp_fixup pnp_fixups[] = {
 	{ "CTL0043", quirk_sb16audio_resources },
 	{ "CTL0044", quirk_sb16audio_resources },
 	{ "CTL0045", quirk_sb16audio_resources },
+	{ "SMCf010", quirk_smc_enable },
 	{ "" }
 };
 
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

origin.patch
move-free-pages-between-lists-on-steal.patch
use-menuconfig-objects-pnp.patch
