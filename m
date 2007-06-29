From: akpm@linux-foundation.org
Subject: - smsc-ircc2-skip-preconfiguration-for-pnp-devices.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:40:24 -0700
Message-ID: <200706292040.l5TKeO7b022426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39602 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754104AbXF2Ulb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:41:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, akpm@linux-foundation.org, ambx1@neo.rr.com, arvidjaar@mail.ru, davem@davemloft.net, linus.walleij@ericsson.com, michal.k.k.piotrowski@gmail.com, samuel@sortiz.org, mm-commits@vger.kernel.org


The patch titled
     smsc-ircc2: skip preconfiguration for PNP devices
has been removed from the -mm tree.  Its filename was
     smsc-ircc2-skip-preconfiguration-for-pnp-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: smsc-ircc2: skip preconfiguration for PNP devices
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

If we rely on the device resources from PNPBIOS, we also have to rely on
the BIOS to configure any bridges on the way to the device.

Using the PNPBIOS resources but changing the configuration of a bridge
behind the back of the firmware is likely to make things inconsistent.

This patch addresses part of the 2.6.22 regression:
    "no irda0 interface (2.6.21 was OK), smsc does not find chip"
It fixes smsc-ircc2 PNP device detection on HP nx5000 laptops.
Other laptops, including HP nc6000, HP nc8000, HP nw8000, and Toshiba
Portege 4000, still need PNP quirks to make this work.

With "smsc-ircc2.nopnp", we do the legacy device probe, including manual
bridge preconfiguration, as before.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Samuel Ortiz <samuel@sortiz.org>
Acked-by: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/smsc-ircc2.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/net/irda/smsc-ircc2.c~smsc-ircc2-skip-preconfiguration-for-pnp-devices drivers/net/irda/smsc-ircc2.c
--- a/drivers/net/irda/smsc-ircc2.c~smsc-ircc2-skip-preconfiguration-for-pnp-devices
+++ a/drivers/net/irda/smsc-ircc2.c
@@ -416,6 +416,13 @@ static int __init smsc_ircc_legacy_probe
 {
 	int ret = 0;
 
+#ifdef CONFIG_PCI
+	if (smsc_ircc_preconfigure_subsystems(ircc_cfg, ircc_fir, ircc_sir, ircc_dma, ircc_irq) < 0) {
+		/* Ignore errors from preconfiguration */
+		IRDA_ERROR("%s, Preconfiguration failed !\n", driver_name);
+	}
+#endif
+
 	if (ircc_fir > 0 && ircc_sir > 0) {
 		IRDA_MESSAGE(" Overriding FIR address 0x%04x\n", ircc_fir);
 		IRDA_MESSAGE(" Overriding SIR address 0x%04x\n", ircc_sir);
@@ -459,13 +466,6 @@ static int __init smsc_ircc_init(void)
 		return ret;
 	}
 
-#ifdef CONFIG_PCI
-	if (smsc_ircc_preconfigure_subsystems(ircc_cfg, ircc_fir, ircc_sir, ircc_dma, ircc_irq) < 0) {
-		/* Ignore errors from preconfiguration */
-		IRDA_ERROR("%s, Preconfiguration failed !\n", driver_name);
-	}
-#endif
-
 	dev_count = 0;
 
 	if (smsc_nopnp || !pnp_platform_devices ||
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
