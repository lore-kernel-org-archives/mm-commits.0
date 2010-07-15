From: akpm@linux-foundation.org
Subject: + omap_hsmmc-add-erase-capability.patch added to -mm tree
Date: Thu, 15 Jul 2010 12:26:14 -0700
Message-ID: <201007151926.o6FJQFYr014718__26135.6661249467$1279222050$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934473Ab0GOT07 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jul 2010 15:26:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com, axboe@kernel.dk, bengardiner@nanometrics.ca, hch@lst.de, kmpark@infradead.org, linux-mmc@vger.kernel.org, madhu.cr@ti.com


The patch titled
     omap_hsmmc: add erase capability
has been added to the -mm tree.  Its filename is
     omap_hsmmc-add-erase-capability.patch

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
Subject: omap_hsmmc: add erase capability
From: Adrian Hunter <adrian.hunter@nokia.com>

Disable the data (busy) timeout for erases and set the MMC_CAP_ERASE
capability.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kyungmin Park <kmpark@infradead.org>
Cc: Madhusudhan Chikkature <madhu.cr@ti.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-add-erase-capability drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-add-erase-capability
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -28,6 +28,7 @@
 #include <linux/clk.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/core.h>
+#include <linux/mmc/mmc.h>
 #include <linux/io.h>
 #include <linux/semaphore.h>
 #include <linux/gpio.h>
@@ -78,6 +79,7 @@
 #define INT_EN_MASK		0x307F0033
 #define BWR_ENABLE		(1 << 4)
 #define BRR_ENABLE		(1 << 5)
+#define DTO_ENABLE		(1 << 20)
 #define INIT_STREAM		(1 << 1)
 #define DP_SELECT		(1 << 21)
 #define DDIR			(1 << 4)
@@ -523,7 +525,8 @@ static void omap_hsmmc_stop_clock(struct
 		dev_dbg(mmc_dev(host->mmc), "MMC Clock is not stoped\n");
 }
 
-static void omap_hsmmc_enable_irq(struct omap_hsmmc_host *host)
+static void omap_hsmmc_enable_irq(struct omap_hsmmc_host *host,
+				  struct mmc_command *cmd)
 {
 	unsigned int irq_mask;
 
@@ -532,6 +535,10 @@ static void omap_hsmmc_enable_irq(struct
 	else
 		irq_mask = INT_EN_MASK;
 
+	/* Disable timeout for erases */
+	if (cmd->opcode == MMC_ERASE)
+		irq_mask &= ~DTO_ENABLE;
+
 	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
 	OMAP_HSMMC_WRITE(host->base, ISE, irq_mask);
 	OMAP_HSMMC_WRITE(host->base, IE, irq_mask);
@@ -782,7 +789,7 @@ omap_hsmmc_start_command(struct omap_hsm
 		mmc_hostname(host->mmc), cmd->opcode, cmd->arg);
 	host->cmd = cmd;
 
-	omap_hsmmc_enable_irq(host);
+	omap_hsmmc_enable_irq(host, cmd);
 
 	host->response_busy = 0;
 	if (cmd->flags & MMC_RSP_PRESENT) {
@@ -2104,7 +2111,7 @@ static int __init omap_hsmmc_probe(struc
 	mmc->max_seg_size = mmc->max_req_size;
 
 	mmc->caps |= MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED |
-		     MMC_CAP_WAIT_WHILE_BUSY;
+		     MMC_CAP_WAIT_WHILE_BUSY | MMC_CAP_ERASE;
 
 	switch (mmc_slot(host).wires) {
 	case 8:
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

linux-next.patch
mmc-recognize-csd-structure.patch
mmc-recognize-csd-structure-fix.patch
mmc-split-mmc_sd_init_card.patch
mmc-implement-sd-combo-iomem-support.patch
mmc-omap-fix-for-bus-width-which-improves-sd-cards-peformance.patch
sdio-allow-non-standard-sdio-cards.patch
omap_hsmmc-add-init_card-pass-through-callback.patch
omap-pandora-pass-wl1251-information-to-sdio-core.patch
mmc-add-erase-secure-erase-trim-and-secure-trim-operations.patch
mmc_block-add-discard-support.patch
omap_hsmmc-add-erase-capability.patch
block-add-secure-discard.patch
mmc_block-add-support-for-secure-discard.patch

