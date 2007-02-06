From: akpm@linux-foundation.org
Subject: + revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch added to -mm tree
Date: Mon, 05 Feb 2007 19:35:58 -0800
Message-ID: <200702060335.l163Zww8009095@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47180 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbXBFDh3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 22:37:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jeff@garzik.org, samuel.thibault@ens-lyon.org, stable@kernel.org, thomas@archlinux.org, val_henson@linux.intel.com


The patch titled
     revert "drivers/net/tulip/dmfe: support basic carrier detection"
has been added to the -mm tree.  Its filename is
     revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: revert "drivers/net/tulip/dmfe: support basic carrier detection"
From: Andrew Morton <akpm@linux-foundation.org>

Revert 7628b0a8c01a02966d2228bdf741ddedb128e8f8.  Thomas Bachler
reports:

  Commit 7628b0a8c01a02966d2228bdf741ddedb128e8f8 (drivers/net/tulip/dmfe:
  support basic carrier detection) breaks networking on my Davicom DM9009. 
  ethtool always reports there is no link.  tcpdump shows incoming packets,
  but TX is disabled.  Reverting the above patch fixes the problem.


Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Valerie Henson <val_henson@linux.intel.com>
Cc: Thomas Bachler <thomas@archlinux.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/dmfe.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN drivers/net/tulip/dmfe.c~revert-drivers-net-tulip-dmfe-support-basic-carrier-detection drivers/net/tulip/dmfe.c
--- a/drivers/net/tulip/dmfe.c~revert-drivers-net-tulip-dmfe-support-basic-carrier-detection
+++ a/drivers/net/tulip/dmfe.c
@@ -187,7 +187,7 @@ struct rx_desc {
 struct dmfe_board_info {
 	u32 chip_id;			/* Chip vendor/Device ID */
 	u32 chip_revision;		/* Chip revision */
-	struct DEVICE *dev;		/* net device */
+	struct DEVICE *next_dev;	/* next device */
 	struct pci_dev *pdev;		/* PCI device */
 	spinlock_t lock;
 
@@ -399,8 +399,6 @@ static int __devinit dmfe_init_one (stru
 	/* Init system & device */
 	db = netdev_priv(dev);
 
-	db->dev = dev;
-
 	/* Allocate Tx/Rx descriptor memory */
 	db->desc_pool_ptr = pci_alloc_consistent(pdev, sizeof(struct tx_desc) * DESC_ALL_CNT + 0x20, &db->desc_pool_dma_ptr);
 	db->buf_pool_ptr = pci_alloc_consistent(pdev, TX_BUF_ALLOC * TX_DESC_CNT + 4, &db->buf_pool_dma_ptr);
@@ -428,7 +426,6 @@ static int __devinit dmfe_init_one (stru
 	dev->poll_controller = &poll_dmfe;
 #endif
 	dev->ethtool_ops = &netdev_ethtool_ops;
-	netif_carrier_off(db->dev);
 	spin_lock_init(&db->lock);
 
 	pci_read_config_dword(pdev, 0x50, &pci_pmr);
@@ -1053,7 +1050,6 @@ static void netdev_get_drvinfo(struct ne
 
 static const struct ethtool_ops netdev_ethtool_ops = {
 	.get_drvinfo		= netdev_get_drvinfo,
-	.get_link               = ethtool_op_get_link,
 };
 
 /*
@@ -1148,7 +1144,6 @@ static void dmfe_timer(unsigned long dat
 		/* Link Failed */
 		DMFE_DBUG(0, "Link Failed", tmp_cr12);
 		db->link_failed = 1;
-		netif_carrier_off(db->dev);
 
 		/* For Force 10/100M Half/Full mode: Enable Auto-Nego mode */
 		/* AUTO or force 1M Homerun/Longrun don't need */
@@ -1171,8 +1166,6 @@ static void dmfe_timer(unsigned long dat
 			if ( (db->media_mode & DMFE_AUTO) &&
 				dmfe_sense_speed(db) )
 				db->link_failed = 1;
-			else
-				netif_carrier_on(db->dev);
 			dmfe_process_mode(db);
 			/* SHOW_MEDIA_TYPE(db->op_mode); */
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

git-libata-all-forward-declare-struct-device.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
knfsd-sunrpc-teach-svc_sendto-to-deal-with-ipv6-addresses-tidy.patch
knfsd-sunrpc-support-ipv6-addresses-in-rpc-servers-udp-receive-path-tidy.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
