From: akpm@linux-foundation.org
Subject: [merged] omap-hsmmc-do-not-enable-buffer-ready-interrupt-if-using-dma.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:53:59 -0700
Message-ID: <200909231953.n8NJrxIs032227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753318AbZIWTyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gadiyar@ti.com, drzeus@drzeus.cx, ian@mnementh.co.uk, kishore.kadiyala@ti.com, matt@console-pimps.org, philipl@overt.org, roberto.foglietta@gmail.com, santosh.shilimkar@ti.com, mm-com


The patch titled
     OMAP: HSMMC: do not enable buffer ready interrupt if using DMA
has been removed from the -mm tree.  Its filename was
     omap-hsmmc-do-not-enable-buffer-ready-interrupt-if-using-dma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: OMAP: HSMMC: do not enable buffer ready interrupt if using DMA
From: Anand Gadiyar <gadiyar@ti.com>

This considerably reduces the number of interrupts during a transfer
and ought to result in some power saving.

Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Philip Langdale <philipl@overt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap-hsmmc-do-not-enable-buffer-ready-interrupt-if-using-dma drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap-hsmmc-do-not-enable-buffer-ready-interrupt-if-using-dma
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -70,6 +70,8 @@
 #define DTO_MASK		0x000F0000
 #define DTO_SHIFT		16
 #define INT_EN_MASK		0x307F0033
+#define BWR_ENABLE		(1 << 4)
+#define BRR_ENABLE		(1 << 5)
 #define INIT_STREAM		(1 << 1)
 #define DP_SELECT		(1 << 21)
 #define DDIR			(1 << 4)
@@ -241,7 +243,12 @@ mmc_omap_start_command(struct mmc_omap_h
 	 */
 	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
 	OMAP_HSMMC_WRITE(host->base, ISE, INT_EN_MASK);
-	OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
+
+	if (host->use_dma)
+		OMAP_HSMMC_WRITE(host->base, IE,
+				 INT_EN_MASK & ~(BRR_ENABLE | BWR_ENABLE));
+	else
+		OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
 
 	host->response_busy = 0;
 	if (cmd->flags & MMC_RSP_PRESENT) {
_

Patches currently in -mm which might be from gadiyar@ti.com are

origin.patch
linux-next.patch

