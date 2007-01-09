From: akpm@osdl.org
Subject: + forcedeth-dma-access.patch added to -mm tree
Date: Tue, 09 Jan 2007 13:36:32 -0800
Message-ID: <200701092136.l09LaWnE016055@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45831 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402AbXAIVgk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 16:36:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aabdulla@nvidia.com


The patch titled
     forcedeth: dma access
has been added to the -mm tree.  Its filename is
     forcedeth-dma-access.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: forcedeth: dma access
From: Ayaz Abdulla <aabdulla@nvidia.com>

Allow the hardware to fetch the tx and rx ring descriptors with 64 bytes per
access instead of 32 bytes.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/forcedeth.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/forcedeth.c~forcedeth-dma-access drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-dma-access
+++ a/drivers/net/forcedeth.c
@@ -304,8 +304,8 @@ enum {
 #define NVREG_TXRXCTL_RESET	0x0010
 #define NVREG_TXRXCTL_RXCHECK	0x0400
 #define NVREG_TXRXCTL_DESC_1	0
-#define NVREG_TXRXCTL_DESC_2	0x02100
-#define NVREG_TXRXCTL_DESC_3	0x02200
+#define NVREG_TXRXCTL_DESC_2	0x002100
+#define NVREG_TXRXCTL_DESC_3	0xc02200
 #define NVREG_TXRXCTL_VLANSTRIP 0x00040
 #define NVREG_TXRXCTL_VLANINS	0x00080
 	NvRegTxRingPhysAddrHigh = 0x148,
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

origin.patch
forcedeth-dma-access.patch
forcedeth-ring-access.patch
forcedeth-tx-locking.patch
forcedeth-rx-skb-recycle.patch
forcedeth-optimized-routines.patch
forcedeth-tx-limiting.patch
forcedeth-tx-data-path-optimization.patch
forcedeth-rx-data-path-optimization.patch
forcedeth-irq-data-path-optimization.patch
forcedeth-tx-max-work.patch
forcedeth-statistics-supported.patch
forcedeth-statistics-optimization.patch
