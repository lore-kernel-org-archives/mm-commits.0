From: akpm@linux-foundation.org
Subject: - dm9000-use-delayed-work-to-update-mii-phy-state.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:45 -0700
Message-ID: <200805132134.m4DLYjfI000951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759001AbYEMVgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:36:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, enrico.scholz@sigma-chemnitz.de, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     dm9000: use delayed work to update MII PHY state
has been removed from the -mm tree.  Its filename was
     dm9000-use-delayed-work-to-update-mii-phy-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dm9000: use delayed work to update MII PHY state
From: Ben Dooks <ben-linux@fluff.org>

Periodically check the MII PHY status to ensure that the network layer's link
status is updated and the user informed of any changes.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/dm9000.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff -puN drivers/net/dm9000.c~dm9000-use-delayed-work-to-update-mii-phy-state drivers/net/dm9000.c
--- a/drivers/net/dm9000.c~dm9000-use-delayed-work-to-update-mii-phy-state
+++ a/drivers/net/dm9000.c
@@ -117,6 +117,9 @@ typedef struct board_info {
 
 	struct mutex	 addr_lock;	/* phy and eeprom access lock */
 
+	struct delayed_work phy_poll;
+	struct net_device  *ndev;
+
 	spinlock_t lock;
 
 	struct mii_if_info mii;
@@ -297,6 +300,10 @@ static void dm9000_set_io(struct board_i
 	}
 }
 
+static void dm9000_schedule_poll(board_info_t *db)
+{
+	schedule_delayed_work(&db->phy_poll, HZ * 2);
+}
 
 /* Our watchdog timed out. Called by the networking layer */
 static void dm9000_timeout(struct net_device *dev)
@@ -465,6 +472,17 @@ static const struct ethtool_ops dm9000_e
  	.set_eeprom		= dm9000_set_eeprom,
 };
 
+static void
+dm9000_poll_work(struct work_struct *w)
+{
+	struct delayed_work *dw = container_of(w, struct delayed_work, work);
+	board_info_t *db = container_of(dw, board_info_t, phy_poll);
+
+	mii_check_media(&db->mii, netif_msg_link(db), 0);
+
+	if (netif_running(db->ndev))
+		dm9000_schedule_poll(db);
+}
 
 /* dm9000_release_board
  *
@@ -532,10 +550,14 @@ dm9000_probe(struct platform_device *pde
 	memset(db, 0, sizeof (*db));
 
 	db->dev = &pdev->dev;
+	db->ndev = ndev;
 
 	spin_lock_init(&db->lock);
 	mutex_init(&db->addr_lock);
 
+	INIT_DELAYED_WORK(&db->phy_poll, dm9000_poll_work);
+
+
 	if (pdev->num_resources < 2) {
 		ret = -ENODEV;
 		goto out;
@@ -762,6 +784,8 @@ dm9000_open(struct net_device *dev)
 	mii_check_media(&db->mii, netif_msg_link(db), 1);
 	netif_start_queue(dev);
 
+	dm9000_schedule_poll(db);
+
 	return 0;
 }
 
@@ -879,6 +903,8 @@ dm9000_stop(struct net_device *ndev)
 	if (netif_msg_ifdown(db))
 		dev_dbg(db->dev, "shutting down %s\n", ndev->name);
 
+	cancel_delayed_work(&db->phy_poll);
+
 	netif_stop_queue(ndev);
 	netif_carrier_off(ndev);
 
_

Patches currently in -mm which might be from ben-linux@fluff.org are

git-net.patch
dm9000-use-delayed-work-to-update-mii-phy-state-fix.patch
colibri-fix-support-for-dm9000-ethernet-device.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch

