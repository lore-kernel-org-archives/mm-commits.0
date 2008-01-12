From: akpm@linux-foundation.org
Subject: + b44-power-down-phy-when-interface-down.patch added to -mm tree
Date: Fri, 11 Jan 2008 17:42:37 -0800
Message-ID: <200801120142.m0C1gbOC008292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756709AbYALBnv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jan 2008 20:43:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mboton@gmail.com, linville@tuxdriver.com, mb@bu3sch.de


The patch titled
     b44: power down PHY when interface down
has been added to the -mm tree.  Its filename is
     b44-power-down-phy-when-interface-down.patch

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
Subject: b44: power down PHY when interface down
From: Miguel Boton <mboton@gmail.com>

This is just this patch (http://lkml.org/lkml/2007/7/1/51) but adapted
to the 'b44' ssb driver.

Signed-off-by: Miguel Boton <mboton@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/b44.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff -puN drivers/net/b44.c~b44-power-down-phy-when-interface-down drivers/net/b44.c
--- a/drivers/net/b44.c~b44-power-down-phy-when-interface-down
+++ a/drivers/net/b44.c
@@ -128,6 +128,8 @@ static void b44_init_rings(struct b44 *)
 #define B44_FULL_RESET		1
 #define B44_FULL_RESET_SKIP_PHY	2
 #define B44_PARTIAL_RESET	3
+#define B44_CHIP_RESET_FULL	4
+#define B44_CHIP_RESET_PARTIAL	5
 
 static void b44_init_hw(struct b44 *, int);
 
@@ -1259,7 +1261,7 @@ static void b44_clear_stats(struct b44 *
 }
 
 /* bp->lock is held. */
-static void b44_chip_reset(struct b44 *bp)
+static void b44_chip_reset(struct b44 *bp, int reset_kind)
 {
 	struct ssb_device *sdev = bp->sdev;
 
@@ -1281,6 +1283,13 @@ static void b44_chip_reset(struct b44 *b
 	ssb_device_enable(bp->sdev, 0);
 	b44_clear_stats(bp);
 
+	/*
+	 * Don't enable PHY if we are doing a partial reset
+	 * we are probably going to power down
+	 */
+	if (reset_kind == B44_CHIP_RESET_PARTIAL)
+		return;
+
 	switch (sdev->bus->bustype) {
 	case SSB_BUSTYPE_SSB:
 		bw32(bp, B44_MDIO_CTRL, (MDIO_CTRL_PREAMBLE |
@@ -1316,7 +1325,14 @@ static void b44_chip_reset(struct b44 *b
 static void b44_halt(struct b44 *bp)
 {
 	b44_disable_ints(bp);
-	b44_chip_reset(bp);
+	/* reset PHY */
+	b44_phy_reset(bp);
+	/* power down PHY */
+	printk(KERN_INFO PFX "%s: powering down PHY\n", bp->dev->name);
+	bw32(bp, B44_MAC_CTRL, MAC_CTRL_PHY_PDOWN);
+	/* now reset the chip, but without enabling the MAC&PHY
+	 * part of it. This has to be done _after_ we shut down the PHY */
+	b44_chip_reset(bp, B44_CHIP_RESET_PARTIAL);
 }
 
 /* bp->lock is held. */
@@ -1365,7 +1381,7 @@ static void b44_init_hw(struct b44 *bp, 
 {
 	u32 val;
 
-	b44_chip_reset(bp);
+	b44_chip_reset(bp, B44_CHIP_RESET_FULL);
 	if (reset_kind == B44_FULL_RESET) {
 		b44_phy_reset(bp);
 		b44_setup_phy(bp);
@@ -1422,7 +1438,7 @@ static int b44_open(struct net_device *d
 	err = request_irq(dev->irq, b44_interrupt, IRQF_SHARED, dev->name, dev);
 	if (unlikely(err < 0)) {
 		napi_disable(&bp->napi);
-		b44_chip_reset(bp);
+		b44_chip_reset(bp, B44_CHIP_RESET_PARTIAL);
 		b44_free_rings(bp);
 		b44_free_consistent(bp);
 		goto out;
@@ -2188,7 +2204,7 @@ static int __devinit b44_init_one(struct
 	/* Chip reset provides power to the b44 MAC & PCI cores, which
 	 * is necessary for MAC register access.
 	 */
-	b44_chip_reset(bp);
+	b44_chip_reset(bp, B44_CHIP_RESET_FULL);
 
 	printk(KERN_INFO "%s: Broadcom 44xx/47xx 10/100BaseT Ethernet %s\n",
 	       dev->name, print_mac(mac, dev->dev_addr));
@@ -2212,6 +2228,7 @@ static void __devexit b44_remove_one(str
 	unregister_netdev(dev);
 	ssb_bus_may_powerdown(sdev->bus);
 	free_netdev(dev);
+	ssb_pcihost_set_power_state(sdev, PCI_D3hot);
 	ssb_set_drvdata(sdev, NULL);
 }
 
@@ -2240,6 +2257,7 @@ static int b44_suspend(struct ssb_device
 		b44_setup_wol(bp);
 	}
 
+	ssb_pcihost_set_power_state(sdev, PCI_D3hot);
 	return 0;
 }
 
_

Patches currently in -mm which might be from mboton@gmail.com are

acpi-remove-duplicated-warning-message.patch
git-netdev-all.patch
ssb-add-ssb_pcihost_set_power_state-function.patch
b44-power-down-phy-when-interface-down.patch
