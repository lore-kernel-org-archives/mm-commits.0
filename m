From: akpm@linux-foundation.org
Subject: + b44-increase-wait-loop.patch added to -mm tree
Date: Fri, 16 Feb 2007 14:01:45 -0800
Message-ID: <200702162201.l1GM1j4M011007@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38304 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946150AbXBPWBv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 17:01:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zambrano@broadcom.com


The patch titled
     B44: increase wait loop
has been added to the -mm tree.  Its filename is
     b44-increase-wait-loop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
b44-increase-wait-loop.patch
