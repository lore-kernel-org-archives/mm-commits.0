From: akpm@linux-foundation.org
Subject: + dmfe-fix-link-detection.patch added to -mm tree
Date: Thu, 15 Feb 2007 22:11:28 -0800
Message-ID: <200702160611.l1G6BS6H021590@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52735 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423314AbXBPGLj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 01:11:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maximlevitsky@gmail.com, jeff@garzik.org, val_henson@linux.intel.com


The patch titled
     dmfe: Fix link detection
has been added to the -mm tree.  Its filename is
     dmfe-fix-link-detection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dmfe: Fix link detection
From: Maxim Levitsky <maximlevitsky@gmail.com>

Add link detection

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Valerie Henson <val_henson@linux.intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/dmfe.c |   58 +++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff -puN drivers/net/tulip/dmfe.c~dmfe-fix-link-detection drivers/net/tulip/dmfe.c
--- a/drivers/net/tulip/dmfe.c~dmfe-fix-link-detection
+++ a/drivers/net/tulip/dmfe.c
@@ -248,7 +248,6 @@ struct dmfe_board_info {
 	u8 media_mode;			/* user specify media mode */
 	u8 op_mode;			/* real work media mode */
 	u8 phy_addr;
-	u8 link_failed;			/* Ever link failed */
 	u8 wait_reset;			/* Hardware failed, need to reset */
 	u8 dm910x_chk_mode;		/* Operating mode check */
 	u8 first_in_callback;		/* Flag to record state */
@@ -447,6 +446,7 @@ static int __devinit dmfe_init_one (stru
 	dev->poll_controller = &poll_dmfe;
 #endif
 	dev->ethtool_ops = &netdev_ethtool_ops;
+	netif_carrier_off(dev);
 	spin_lock_init(&db->lock);
 
 	pci_read_config_dword(pdev, 0x50, &pci_pmr);
@@ -541,7 +541,6 @@ static int dmfe_open(struct DEVICE *dev)
 	db->tx_packet_cnt = 0;
 	db->tx_queue_cnt = 0;
 	db->rx_avail_cnt = 0;
-	db->link_failed = 1;
 	db->wait_reset = 0;
 
 	db->first_in_callback = 0;
@@ -1082,6 +1081,7 @@ static void netdev_get_drvinfo(struct ne
 
 static const struct ethtool_ops netdev_ethtool_ops = {
 	.get_drvinfo		= netdev_get_drvinfo,
+	.get_link               = ethtool_op_get_link,
 };
 
 /*
@@ -1097,6 +1097,8 @@ static void dmfe_timer(unsigned long dat
 	struct dmfe_board_info *db = netdev_priv(dev);
  	unsigned long flags;
 
+	int link_ok, link_ok_phy;
+
 	DMFE_DBUG(0, "dmfe_timer()", 0);
 	spin_lock_irqsave(&db->lock, flags);
 
@@ -1168,15 +1170,35 @@ static void dmfe_timer(unsigned long dat
 		(db->chip_revision == 0x02000010)) ) {
 		/* DM9102A Chip */
 		if (tmp_cr12 & 2)
-			tmp_cr12 = 0x0;		/* Link failed */
+			link_ok = 0;
 		else
-			tmp_cr12 = 0x3;	/* Link OK */
+			link_ok = 1;
 	}
+	else
+		/*0x43 is used instead of 0x3 because bit 6 should represent
+			link status of external PHY */
+		link_ok = (tmp_cr12 & 0x43) ? 1 : 0;
+
+
+	/* If chip reports that link is failed it could be because external
+		PHY link status pin is not conected correctly to chip
+		To be sure ask PHY too.
+	*/
+
+	/* need a dummy read because of PHY's register latch*/
+	phy_read (db->ioaddr, db->phy_addr, 1, db->chip_id);
+	link_ok_phy = (phy_read (db->ioaddr,
+		       db->phy_addr, 1, db->chip_id) & 0x4) ? 1 : 0;
+
+	if (link_ok_phy != link_ok) {
+		DMFE_DBUG (0, "PHY and chip report different link status", 0);
+		link_ok = link_ok | link_ok_phy;
+ 	}
 
-	if ( !(tmp_cr12 & 0x3) && !db->link_failed ) {
+	if ( !link_ok && netif_carrier_ok(dev)) {
 		/* Link Failed */
 		DMFE_DBUG(0, "Link Failed", tmp_cr12);
-		db->link_failed = 1;
+		netif_carrier_off(dev);
 
 		/* For Force 10/100M Half/Full mode: Enable Auto-Nego mode */
 		/* AUTO or force 1M Homerun/Longrun don't need */
@@ -1191,19 +1213,19 @@ static void dmfe_timer(unsigned long dat
 			db->cr6_data&=~0x00000200;	/* bit9=0, HD mode */
 			update_cr6(db->cr6_data, db->ioaddr);
 		}
-	} else
-		if ((tmp_cr12 & 0x3) && db->link_failed) {
-			DMFE_DBUG(0, "Link link OK", tmp_cr12);
-			db->link_failed = 0;
-
-			/* Auto Sense Speed */
-			if ( (db->media_mode & DMFE_AUTO) &&
-				dmfe_sense_speed(db) )
-				db->link_failed = 1;
-			dmfe_process_mode(db);
-			/* SHOW_MEDIA_TYPE(db->op_mode); */
+	} else if (!netif_carrier_ok(dev)) {
+
+		DMFE_DBUG(0, "Link link OK", tmp_cr12);
+
+		/* Auto Sense Speed */
+		if ( !(db->media_mode & DMFE_AUTO) || !dmfe_sense_speed(db)) {
+			netif_carrier_on(dev);
+			SHOW_MEDIA_TYPE(db->op_mode);
 		}
 
+		dmfe_process_mode(db);
+	}
+
 	/* HPNA remote command check */
 	if (db->HPNA_command & 0xf00) {
 		db->HPNA_timer--;
@@ -1248,7 +1270,7 @@ static void dmfe_dynamic_reset(struct DE
 	db->tx_packet_cnt = 0;
 	db->tx_queue_cnt = 0;
 	db->rx_avail_cnt = 0;
-	db->link_failed = 1;
+	netif_carrier_off(dev);
 	db->wait_reset = 0;
 
 	/* Re-initilize DM910X board */
_

Patches currently in -mm which might be from maximlevitsky@gmail.com are

dmfe-trivial-spelling-fixes.patch
dmfe-fix-two-bugs.patch
dmfe-fix-link-detection.patch
dmfe-add-support-for-suspend-resume.patch
dmfe-add-support-for-suspend-resume-fix.patch
dmfe-add-support-for-wake-on-lan.patch
