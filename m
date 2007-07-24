From: akpm@linux-foundation.org
Subject: - atl1-change-tpd_avail-function-name.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:25:14 -0700
Message-ID: <200707242325.l6ONPEqW006346@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57547 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756660AbXGXXgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:36:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jacliburn@bellsouth.net, mm-commits@vger.kernel.org


The patch titled
     atl1: change tpd_avail function name
has been removed from the -mm tree.  Its filename was
     atl1-change-tpd_avail-function-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atl1: change tpd_avail function name
From: Jay Cliburn <jacliburn@bellsouth.net>

Change tpd_avail() to atl1_tpd_avail().

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/atl1/atl1_main.c~atl1-change-tpd_avail-function-name drivers/net/atl1/atl1_main.c
--- a/drivers/net/atl1/atl1_main.c~atl1-change-tpd_avail-function-name
+++ a/drivers/net/atl1/atl1_main.c
@@ -1422,7 +1422,7 @@ static void atl1_intr_tx(struct atl1_ada
 		netif_wake_queue(adapter->netdev);
 }
 
-static u16 tpd_avail(struct atl1_tpd_ring *tpd_ring)
+static u16 atl1_tpd_avail(struct atl1_tpd_ring *tpd_ring)
 {
 	u16 next_to_clean = atomic_read(&tpd_ring->next_to_clean);
 	u16 next_to_use = atomic_read(&tpd_ring->next_to_use);
@@ -1708,7 +1708,7 @@ static int atl1_xmit_frame(struct sk_buf
 		return NETDEV_TX_LOCKED;
 	}
 
-	if (tpd_avail(&adapter->tpd_ring) < count) {
+	if (atl1_tpd_avail(&adapter->tpd_ring) < count) {
 		/* not enough descriptors */
 		netif_stop_queue(netdev);
 		spin_unlock_irqrestore(&adapter->lock, flags);
_

Patches currently in -mm which might be from jacliburn@bellsouth.net are

git-netdev-all.patch
