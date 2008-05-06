From: akpm@linux-foundation.org
Subject: + dm9000-restore-mii-physical-polling-timer.patch added to -mm tree
Date: Tue, 06 May 2008 14:26:58 -0700
Message-ID: <200805062126.m46LQwE9028159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933636AbYEFV2S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 17:28:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.abbott@diamond.ac.uk, ben-linux@fluff.org, daniel@caiaq.org, jeff@garzik.org, rmk@arm.linux.org.uk


The patch titled
     DM9000: restore MII physical polling timer
has been added to the -mm tree.  Its filename is
     dm9000-restore-mii-physical-polling-timer.patch

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
Subject: DM9000: restore MII physical polling timer
From: Michael Abbott <michael.abbott@diamond.ac.uk>

In commit fcfa81aa3e8d885356139122fcb281487b983468 the timer for polling the
MII physical layer was removed because of conflicts with newly added mutexes. 
Unfortunately a side effect of this change is that the corresponding ethernet
layer is permanently reported as down: there is no other way to read the link
status.

This commit restores the timer, but uses the default work queue for polling.

Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
Cc: Daniel Mack <daniel@caiaq.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/dm9000.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN drivers/net/dm9000.c~dm9000-restore-mii-physical-polling-timer drivers/net/dm9000.c
--- a/drivers/net/dm9000.c~dm9000-restore-mii-physical-polling-timer
+++ a/drivers/net/dm9000.c
@@ -43,6 +43,7 @@
 /* Board/System/Debug information/definition ---------------- */
 
 #define DM9000_PHY		0x40	/* PHY address 0x01 */
+#define DM9000_TIMER_WUT	(HZ*2)	/* timer wakeup time : 2 second */
 
 #define CARDNAME "dm9000"
 #define PFX CARDNAME ": "
@@ -117,6 +118,8 @@ typedef struct board_info {
 
 	struct mutex	 addr_lock;	/* phy and eeprom access lock */
 
+	struct delayed_work timer;	/* Interface status timer. */
+
 	spinlock_t lock;
 
 	struct mii_if_info mii;
@@ -144,6 +147,7 @@ static int dm9000_start_xmit(struct sk_b
 static int dm9000_stop(struct net_device *);
 static int dm9000_ioctl(struct net_device *dev, struct ifreq *req, int cmd);
 
+static void dm9000_timer(struct work_struct * work);
 static void dm9000_init_dm9000(struct net_device *);
 
 static irqreturn_t dm9000_interrupt(int, void *);
@@ -762,6 +766,10 @@ dm9000_open(struct net_device *dev)
 	mii_check_media(&db->mii, netif_msg_link(db), 1);
 	netif_start_queue(dev);
 
+	/* Start the media status timer running. */
+	INIT_DELAYED_WORK(&db->timer, dm9000_timer);
+	schedule_delayed_work(&db->timer, DM9000_TIMER_WUT);
+
 	return 0;
 }
 
@@ -876,6 +884,9 @@ dm9000_stop(struct net_device *ndev)
 {
 	board_info_t *db = (board_info_t *) ndev->priv;
 
+	/* Delete the timer and make sure it's not running right now! */
+	cancel_delayed_work_sync(&db->timer);
+
 	if (netif_msg_ifdown(db))
 		dev_dbg(db->dev, "shutting down %s\n", ndev->name);
 
@@ -965,6 +976,16 @@ dm9000_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+
+/* Two second timer to poll the media status -- the DM9000 doesn't provide a
+ * status interrupt, so this has to be polled. */
+static void dm9000_timer(struct work_struct * work)
+{
+	board_info_t *db = container_of(work, board_info_t, timer);
+	mii_check_media(&db->mii, netif_msg_link(db), 0);
+	schedule_delayed_work(&db->timer, DM9000_TIMER_WUT);
+}
+
 struct dm9000_rxhdr {
 	u8	RxPktReady;
 	u8	RxStatus;
_

Patches currently in -mm which might be from michael.abbott@diamond.ac.uk are

dm9000-restore-mii-physical-polling-timer.patch
colibri-fix-support-for-dm9000-ethernet-device.patch
colibri-fix-support-for-dm9000-ethernet-device-fix.patch

