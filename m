From: akpm@linux-foundation.org
Subject: - forcedeth-fix-cpu-irq-mask.patch removed from -mm tree
Date: Thu, 24 May 2007 15:05:18 -0700
Message-ID: <200705242205.l4OM5I5k004376@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877AbXEXWFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 18:05:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aabdulla@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     forcedeth: fix cpu irq mask
has been removed from the -mm tree.  Its filename was
     forcedeth-fix-cpu-irq-mask.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: forcedeth: fix cpu irq mask
From: Ayaz Abdulla <aabdulla@nvidia.com>

This patch fixes the cpu irq mask define to include the timer irq.  Another
flag check was setting up the timer bit in all cases so we didn't notice the
issue.

Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/forcedeth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/forcedeth.c~forcedeth-fix-cpu-irq-mask drivers/net/forcedeth.c
--- a/drivers/net/forcedeth.c~forcedeth-fix-cpu-irq-mask
+++ a/drivers/net/forcedeth.c
@@ -195,7 +195,7 @@ enum {
 #define NVREG_IRQ_TX_FORCED		0x0100
 #define NVREG_IRQ_RECOVER_ERROR		0x8000
 #define NVREG_IRQMASK_THROUGHPUT	0x00df
-#define NVREG_IRQMASK_CPU		0x0040
+#define NVREG_IRQMASK_CPU		0x0060
 #define NVREG_IRQ_TX_ALL		(NVREG_IRQ_TX_ERR|NVREG_IRQ_TX_OK|NVREG_IRQ_TX_FORCED)
 #define NVREG_IRQ_RX_ALL		(NVREG_IRQ_RX_ERROR|NVREG_IRQ_RX|NVREG_IRQ_RX_NOBUF|NVREG_IRQ_RX_FORCED)
 #define NVREG_IRQ_OTHER			(NVREG_IRQ_TIMER|NVREG_IRQ_LINK|NVREG_IRQ_RECOVER_ERROR)
_

Patches currently in -mm which might be from aabdulla@nvidia.com are

forcedeth-fix-cpu-irq-mask.patch
forcedeth-version-bump.patch
