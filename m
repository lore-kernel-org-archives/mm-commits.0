From: akpm@linux-foundation.org
Subject: - mmc-add-missing-sg_init_table-call.patch removed from -mm tree
Date: Tue, 27 Nov 2007 18:10:07 -0800
Message-ID: <200711280210.lAS2A7A0011036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755639AbXK1CKd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 21:10:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, drzeus-mmc@drzeus.cx, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mmc: add missing sg_init_table() call
has been removed from the -mm tree.  Its filename was
     mmc-add-missing-sg_init_table-call.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mmc: add missing sg_init_table() call
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

mmc_init_queue only initializes the scatterlists with sg_init_table() when
using a bounce buffer.  This leads to a BUG() when CONFIG_DEBUG_SG is set.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/queue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/card/queue.c~mmc-add-missing-sg_init_table-call drivers/mmc/card/queue.c
--- a/drivers/mmc/card/queue.c~mmc-add-missing-sg_init_table-call
+++ a/drivers/mmc/card/queue.c
@@ -180,12 +180,13 @@ int mmc_init_queue(struct mmc_queue *mq,
 		blk_queue_max_hw_segments(mq->queue, host->max_hw_segs);
 		blk_queue_max_segment_size(mq->queue, host->max_seg_size);
 
-		mq->sg = kzalloc(sizeof(struct scatterlist) *
+		mq->sg = kmalloc(sizeof(struct scatterlist) *
 			host->max_phys_segs, GFP_KERNEL);
 		if (!mq->sg) {
 			ret = -ENOMEM;
 			goto cleanup_queue;
 		}
+		sg_init_table(mq->sg, host->max_phys_segs);
 	}
 
 	init_MUTEX(&mq->thread_sem);
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
atmel_spi-labels-gpios-better.patch
atmel_lcdfb-lcdc-startup-fix.patch
dmaengine-correct-invalid-assumptions-in-the-kconfig-text.patch
git-avr32.patch
git-mtd.patch
read_current_time-cleanups.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
generic-gpio-gpio_chip-support.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-avr32.patch
tty-let-architectures-override-the-user-kernel-macros.patch
