From: akpm@linux-foundation.org
Subject: - block-use-arch_kmalloc_minalign-as-the-default-dma-pad-mask.patch removed from -mm tree
Date: Tue, 03 Jun 2008 14:51:08 -0700
Message-ID: <200806032151.m53Lp821021510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164AbYFCVve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 17:51:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, bzolnier@gmail.com, htejun@gmail.com, jens.axboe@oracle.com, tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     block: use ARCH_KMALLOC_MINALIGN as the default dma pad mask
has been removed from the -mm tree.  Its filename was
     block-use-arch_kmalloc_minalign-as-the-default-dma-pad-mask.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: use ARCH_KMALLOC_MINALIGN as the default dma pad mask
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

The goal of this patchset is reverting the commit
22a9189fd073db3d03a4cf8b8c098aa207602de1 (cdrom: use kmalloced buffers
instead of buffers on stack).

http://lkml.org/lkml/2008/4/21/634

The commit is using kmalloced buffers for cdrom packet commands to avoid
stack corruption on non coherent platforms.  But allocating a small buffer
like this is not nice (unnecessary complicity):

+	buffer = kmalloc(8, GFP_KERNEL);

I tried to remove generic_packet() and convert cdrom users to use the
block queue like pkt_generic_packet (as Jens suggested in the thread if I
correctly understand), but it turned out that it needs tricky surgery
(like handling ssleep and retries for packet commands in ide).

Then I found that we can easily handle packet commands on non coherent
platforms.  The diffstat is pretty small except for the revert.  All this
patchset does is just setting the dma_pad_mask to ARCH_KMALLOC_MINALIGN.

Only scsi and ide-cd do DMA generic_packet.  In the case of scsi,
sr_packet uses blk_rq_map_kern (the commit
68154e90c9d1492d570671ae181d9a8f8530da55) post 2.6.25.  So if we set the
dma padding on non coherent platforms, sr_packet uses allocated pages
properly.

In the case of IDE, ide-cd has a mechanism to handle alignment and
padding for SG_IO. So we can easily exploit it for packet commands.

If some architectures can't do DMA on stack, we also need to a new
queue_flag like QUEUE_FLAG_NO_DMA_ON_STACK in addtion of this patchset.



This patch:

This sets the default dma pad mask to ARCH_KMALLOC_MINALIGN in
blk_queue_make_request().  It affects only non-coherent platforms.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-settings.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN block/blk-settings.c~block-use-arch_kmalloc_minalign-as-the-default-dma-pad-mask block/blk-settings.c
--- a/block/blk-settings.c~block-use-arch_kmalloc_minalign-as-the-default-dma-pad-mask
+++ a/block/blk-settings.c
@@ -84,6 +84,11 @@ EXPORT_SYMBOL(blk_queue_softirq_done);
  **/
 void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 {
+#ifndef ARCH_KMALLOC_MINALIGN
+#define ARCH_KMALLOC_MINALIGN 1
+#endif
+	unsigned int min_align = ARCH_KMALLOC_MINALIGN;
+
 	/*
 	 * set defaults
 	 */
@@ -98,6 +103,7 @@ void blk_queue_make_request(struct reque
 	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
 	blk_queue_hardsect_size(q, 512);
 	blk_queue_dma_alignment(q, 511);
+	blk_queue_dma_pad(q, min_align - 1);
 	blk_queue_congestion_threshold(q);
 	q->nr_batching = BLK_BATCH_REQ;
 
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
block-use-arch_kmalloc_minalign-as-the-default-dma-pad-mask.patch
block-add-blk_queue_update_dma_pad.patch
ide-use-the-dma-safe-check-for-req_type_ata_pc.patch
cdrom-revert-commit-22a9189-cdrom-use-kmalloced-buffers-instead-of-buffers-on-stack.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sge-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-svc_rdma-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-sparc32.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch

