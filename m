From: akpm@linux-foundation.org
Subject: + block-use-arch_kmalloc_minalign-as-the-default-dma-pad-mask.patch added to -mm tree
Date: Tue, 20 May 2008 02:33:32 -0700
Message-ID: <200805200933.m4K9XWlg015786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760765AbYETJdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 05:33:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, bzolnier@gmail.com, htejun@gmail.com, jens.axboe@oracle.com, tsbogend@alpha.franken.de


The patch titled
     block: use ARCH_KMALLOC_MINALIGN as the default dma pad mask
has been added to the -mm tree.  Its filename is
     block-use-arch_kmalloc_minalign-as-the-default-dma-pad-mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: use ARCH_KMALLOC_MINALIGN as the default dma pad mask
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

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
dma-mapping-x86-per-device-dma_mapping_ops-support.patch

