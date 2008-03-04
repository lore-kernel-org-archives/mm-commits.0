From: akpm@linux-foundation.org
Subject: - 3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup-update.patch removed from -mm tree
Date: Mon, 03 Mar 2008 20:18:00 -0800
Message-ID: <200803040427.m244RN0k023256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbYCDE2L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 23:28:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rainbow-software.org, bjorn.helgaas@hp.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup update
has been removed from the -mm tree.  Its filename was
     3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup-update.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup update
From: Ondrej Zary <linux@rainbow-software.org>

this patch converts 3c509 driver to isa_driver and pnp_driver. The result is
that autoloading using udev and hibernation works with ISA PnP cards. It also
adds hibernation support for non-PnP ISA cards.

xcvr module parameter was removed as its value was not used.

Tested using 3 ISA cards in various combinations of PnP and non-PnP modes.
EISA and MCA only compile-tested.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c509.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff -puN drivers/net/3c509.c~3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup-update drivers/net/3c509.c
--- a/drivers/net/3c509.c~3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup-update
+++ a/drivers/net/3c509.c
@@ -164,7 +164,7 @@ enum RxFilter {
  */
 #define SKB_QUEUE_SIZE	64
 
-typedef enum { EL3_ISA, EL3_PNP, EL3_MCA, EL3_EISA } el3_cardtype;
+enum el3_cardtype { EL3_ISA, EL3_PNP, EL3_MCA, EL3_EISA };
 
 struct el3_private {
 	struct net_device_stats stats;
@@ -172,7 +172,7 @@ struct el3_private {
 	/* skb send-queue */
 	int head, size;
 	struct sk_buff *queue[SKB_QUEUE_SIZE];
-	el3_cardtype type;
+	enum el3_cardtype type;
 };
 static int id_port;
 static int current_tag;
@@ -188,7 +188,7 @@ static int nopnp;
 #endif
 
 static int __init el3_common_init(struct net_device *dev);
-static void el3_common_remove (struct net_device *dev);
+static void el3_common_remove(struct net_device *dev);
 static ushort id_read_eeprom(int index);
 static ushort read_eeprom(int ioaddr, int index);
 static int el3_open(struct net_device *dev);
@@ -236,7 +236,7 @@ static int el3_isa_id_sequence(__be16 *p
 	/* For the first probe, clear all board's tag registers. */
 	if (current_tag == 0)
 		outb(0xd0, id_port);
-	else				/* Otherwise kill off already-found boards. */
+	else			/* Otherwise kill off already-found boards. */
 		outb(0xd8, id_port);
 	if (id_read_eeprom(7) != 0x6d50)
 		return 1;
@@ -251,7 +251,9 @@ static int el3_isa_id_sequence(__be16 *p
 		   This check is needed in order not to register them twice. */
 		for (i = 0; i < el3_cards; i++) {
 			struct el3_private *lp = netdev_priv(el3_devs[i]);
-			if (lp->type == EL3_PNP && !memcmp(phys_addr, el3_devs[i]->dev_addr, ETH_ALEN)) {
+			if (lp->type == EL3_PNP
+			    && !memcmp(phys_addr, el3_devs[i]->dev_addr,
+				       ETH_ALEN)) {
 				if (el3_debug > 3)
 					printk(KERN_DEBUG "3c509 with address %02x %02x %02x %02x %02x %02x was found by ISAPnP\n",
 						phys_addr[0] & 0xff, phys_addr[0] >> 8,
@@ -269,8 +271,8 @@ static int el3_isa_id_sequence(__be16 *p
 }
 
 static void __devinit el3_dev_fill(struct net_device *dev, __be16 *phys_addr,
-			           int ioaddr, int irq, int if_port,
-			           el3_cardtype type)
+				   int ioaddr, int irq, int if_port,
+				   enum el3_cardtype type)
 {
 	struct el3_private *lp = netdev_priv(dev);
 
@@ -302,7 +304,7 @@ static int __devinit el3_isa_match(struc
 	else
 		isa_irq = id_read_eeprom(9) >> 12;
 
-	dev = alloc_etherdev(sizeof (struct el3_private));
+	dev = alloc_etherdev(sizeof(struct el3_private));
 	if (!dev)
 		return -ENOMEM;
 
@@ -421,7 +423,7 @@ static int __devinit el3_pnp_probe(struc
 	for (i = 0; i < 3; i++)
 		phys_addr[i] = htons(read_eeprom(ioaddr, i));
 	if_port = read_eeprom(ioaddr, 8) >> 14;
-	dev = alloc_etherdev(sizeof (struct el3_private));
+	dev = alloc_etherdev(sizeof(struct el3_private));
 	if (!dev) {
 		release_region(ioaddr, EL3_IO_EXTENT);
 		return -ENOMEM;
@@ -430,11 +432,11 @@ static int __devinit el3_pnp_probe(struc
 	netdev_boot_setup_check(dev);
 
 	el3_dev_fill(dev, phys_addr, ioaddr, irq, if_port, EL3_PNP);
-	pnp_set_drvdata (pdev, dev);
+	pnp_set_drvdata(pdev, dev);
 	err = el3_common_init(dev);
 
 	if (err) {
-		pnp_set_drvdata (pdev, NULL);
+		pnp_set_drvdata(pdev, NULL);
 		free_netdev(dev);
 		return err;
 	}
@@ -1576,7 +1578,7 @@ static void __exit el3_cleanup_module(vo
 		release_region(id_port, 1);
 #ifdef CONFIG_EISA
 	if (eisa_registered)
-		eisa_driver_unregister (&el3_eisa_driver);
+		eisa_driver_unregister(&el3_eisa_driver);
 #endif
 #ifdef CONFIG_MCA
 	if (mca_registered)
_

Patches currently in -mm which might be from linux@rainbow-software.org are

3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup-update.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
de2104x-remove-bug_on-when-changing-media-type.patch

