From: akpm@linux-foundation.org
Subject: - b44-increase-wait-loop.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:15:06 -0800
Message-ID: <200702180215.l1I2F6mJ008357@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55653 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993101AbXBRCPK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:15:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zambrano@broadcom.com, mm-commits@vger.kernel.org


The patch titled
     B44: increase wait loop
has been removed from the -mm tree.  Its filename was
     b44-increase-wait-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: B44: increase wait loop
From: "Gary Zambrano" <zambrano@broadcom.com>

The b44 Enet control disable bit may take longer to clear on some systems,
so the loop count is increased with this patch.  Functionality is not
compromised, but a debug message can be seen when the bit is not cleared
within the count value.  Thanks to Vasileios Lourdas who reported the
problem.

Signed-off by: Gary Zambrano <zambrano@broadcom.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/b44.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/b44.c~b44-increase-wait-loop drivers/net/b44.c
--- a/drivers/net/b44.c~b44-increase-wait-loop
+++ a/drivers/net/b44.c
@@ -1289,7 +1289,7 @@ static void b44_chip_reset(struct b44 *b
 	if (ssb_is_core_up(bp)) {
 		bw32(bp, B44_RCV_LAZY, 0);
 		bw32(bp, B44_ENET_CTRL, ENET_CTRL_DISABLE);
-		b44_wait_bit(bp, B44_ENET_CTRL, ENET_CTRL_DISABLE, 100, 1);
+		b44_wait_bit(bp, B44_ENET_CTRL, ENET_CTRL_DISABLE, 200, 1);
 		bw32(bp, B44_DMATX_CTRL, 0);
 		bp->tx_prod = bp->tx_cons = 0;
 		if (br32(bp, B44_DMARX_STAT) & DMARX_STAT_EMASK) {
_

Patches currently in -mm which might be from zambrano@broadcom.com are

arm-dma-mappingh.patch
avr32-dma-mappingh.patch
git-netdev-all.patch
