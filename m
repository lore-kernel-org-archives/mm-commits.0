From: akpm@linux-foundation.org
Subject: - sfc-add-checks-for-heap-allocation-failure.patch removed from -mm tree
Date: Fri, 23 May 2008 11:59:25 -0700
Message-ID: <200805231859.m4NIxPOr004237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718AbYEWS7a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:59:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhutchings@solarflare.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sfc: add checks for heap allocation failure
has been removed from the -mm tree.  Its filename was
     sfc-add-checks-for-heap-allocation-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sfc: add checks for heap allocation failure
From: Ben Hutchings <bhutchings@solarflare.com>

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/selftest.c  |    2 ++
 drivers/net/sfc/tenxpress.c |    2 ++
 drivers/net/sfc/xfp_phy.c   |    2 ++
 3 files changed, 6 insertions(+)

diff -puN drivers/net/sfc/selftest.c~sfc-add-checks-for-heap-allocation-failure drivers/net/sfc/selftest.c
--- a/drivers/net/sfc/selftest.c~sfc-add-checks-for-heap-allocation-failure
+++ a/drivers/net/sfc/selftest.c
@@ -517,6 +517,8 @@ efx_test_loopback(struct efx_tx_queue *t
 		state->packet_count = min(1 << (i << 2), state->packet_count);
 		state->skbs = kzalloc(sizeof(state->skbs[0]) *
 				      state->packet_count, GFP_KERNEL);
+		if (!state->skbs)
+			return -ENOMEM;
 		state->flush = 0;
 
 		EFX_LOG(efx, "TX queue %d testing %s loopback with %d "
diff -puN drivers/net/sfc/tenxpress.c~sfc-add-checks-for-heap-allocation-failure drivers/net/sfc/tenxpress.c
--- a/drivers/net/sfc/tenxpress.c~sfc-add-checks-for-heap-allocation-failure
+++ a/drivers/net/sfc/tenxpress.c
@@ -211,6 +211,8 @@ static int tenxpress_phy_init(struct efx
 	int rc = 0;
 
 	phy_data = kzalloc(sizeof(*phy_data), GFP_KERNEL);
+	if (!phy_data)
+		return -ENOMEM;
 	efx->phy_data = phy_data;
 
 	tenxpress_set_state(efx, TENXPRESS_STATUS_NORMAL);
diff -puN drivers/net/sfc/xfp_phy.c~sfc-add-checks-for-heap-allocation-failure drivers/net/sfc/xfp_phy.c
--- a/drivers/net/sfc/xfp_phy.c~sfc-add-checks-for-heap-allocation-failure
+++ a/drivers/net/sfc/xfp_phy.c
@@ -85,6 +85,8 @@ static int xfp_phy_init(struct efx_nic *
 	int rc;
 
 	phy_data = kzalloc(sizeof(struct xfp_phy_data), GFP_KERNEL);
+	if (!phy_data)
+		return -ENOMEM;
 	efx->phy_data = phy_data;
 
 	EFX_INFO(efx, "XFP: PHY ID reg %x (OUI %x model %x revision"
_

Patches currently in -mm which might be from bhutchings@solarflare.com are

git-net.patch

