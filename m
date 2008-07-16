From: akpm@linux-foundation.org
Subject: - via-velocity-add-velocity_set_rxbufsize-helper.patch removed from -mm tree
Date: Wed, 16 Jul 2008 14:35:29 -0700
Message-ID: <200807162135.m6GLZTTi014096@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757294AbYGPViT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jul 2008 17:38:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romieu@fr.zoreil.com, mm-commits@vger.kernel.org


The patch titled
     via-velocity: add velocity_set_rxbufsize helper
has been removed from the -mm tree.  Its filename was
     via-velocity-add-velocity_set_rxbufsize-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: via-velocity: add velocity_set_rxbufsize helper
From: Francois Romieu <romieu@fr.zoreil.com>

It removes a dependancy from velocity_init_rd_ring to dev->mtu.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/via-velocity.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/net/via-velocity.c~via-velocity-add-velocity_set_rxbufsize-helper drivers/net/via-velocity.c
--- a/drivers/net/via-velocity.c~via-velocity-add-velocity_set_rxbufsize-helper
+++ a/drivers/net/via-velocity.c
@@ -1207,6 +1207,11 @@ static int velocity_rx_refill(struct vel
 	return done;
 }
 
+static void velocity_set_rxbufsize(struct velocity_info *vptr, int mtu)
+{
+	vptr->rx_buf_sz = (mtu <= ETH_DATA_LEN) ? PKT_BUF_SZ : mtu + 32;
+}
+
 /**
  *	velocity_init_rd_ring	-	set up receive ring
  *	@vptr: velocity to configure
@@ -1217,11 +1222,8 @@ static int velocity_rx_refill(struct vel
 
 static int velocity_init_rd_ring(struct velocity_info *vptr)
 {
-	int mtu = vptr->dev->mtu;
 	int ret = -ENOMEM;
 
-	vptr->rx_buf_sz = (mtu <= ETH_DATA_LEN) ? PKT_BUF_SZ : mtu + 32;
-
 	vptr->rd_info = kcalloc(vptr->options.numrx,
 				sizeof(struct velocity_rd_info), GFP_KERNEL);
 	if (!vptr->rd_info)
@@ -1860,6 +1862,8 @@ static int velocity_open(struct net_devi
 	struct velocity_info *vptr = netdev_priv(dev);
 	int ret;
 
+	velocity_set_rxbufsize(vptr, dev->mtu);
+
 	ret = velocity_init_rings(vptr);
 	if (ret < 0)
 		goto out;
@@ -1941,6 +1945,8 @@ static int velocity_change_mtu(struct ne
 
 		dev->mtu = new_mtu;
 
+		velocity_set_rxbufsize(vptr, new_mtu);
+
 		ret = velocity_init_rd_ring(vptr);
 		if (ret < 0)
 			goto out_unlock;
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

linux-next.patch
via-velocity-give-a-structure-to-the-rx-tx-fields.patch
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch

