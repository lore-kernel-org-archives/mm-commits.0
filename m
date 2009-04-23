From: akpm@linux-foundation.org
Subject: + omap-hsmmc-do-not-enable-buffer-ready-interrupt-if-using-dma.patch added to -mm tree
Date: Thu, 23 Apr 2009 13:36:21 -0700
Message-ID: <200904232036.n3NKaLMr029184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752553AbZDWUkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 16:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gadiyar@ti.com, drzeus@drzeus.cx, kishore.kadiyala@ti.com, santosh.shilimkar@ti.com


The patch titled
     OMAP: HSMMC: do not enable buffer ready interrupt if using DMA
has been added to the -mm tree.  Its filename is
     omap-hsmmc-do-not-enable-buffer-ready-interrupt-if-using-dma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
omap-hsmmc-do-not-enable-buffer-ready-interrupt-if-using-dma.patch

