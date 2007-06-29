From: akpm@linux-foundation.org
Subject: - block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:41:46 -0700
Message-ID: <200706292041.l5TKfkjQ022602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754993AbXF2Uuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:50:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: htejun@gmail.com, jens.axboe@oracle.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     block: drop unnecessary bvec rewinding from flush_dry_bio_endio
has been removed from the -mm tree.  Its filename was
     block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: block: drop unnecessary bvec rewinding from flush_dry_bio_endio
From: Tejun Heo <htejun@gmail.com>

Barrier bios are completed twice - once after the barrier write itself
is done and again after the whole sequence is complete.
flush_dry_bio_endio() is for the first completion.  It doesn't really
complete the bio.  It rewinds bvec and resets bio so that it can be
completed again when the whole barrier sequence is complete.

The bvec rewinding code has the following problems.

1. The rewinding code is wrong because filesystems may pass bvec with
   non zero bv_offset.

2. The block layer doesn't guarantee anything about the state of
   bvec array on request completion.  bv_offset and len are updated
   iff __end_that_request_first() completes the bvec partially.

Because of #2, #1 doesn't really matter (nobody cares whether bvec is
re-wound correctly or not) but then again by not doing unwinding at
all, we'll always give back the same bvec to the caller as full bvec
completion doesn't alter bvecs and the final completion is always full
completion.

Drop unnecessary rewinding code.

This is spotted by Neil Brown.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN block/ll_rw_blk.c~block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio
+++ a/block/ll_rw_blk.c
@@ -527,8 +527,6 @@ int blk_do_ordered(request_queue_t *q, s
 static int flush_dry_bio_endio(struct bio *bio, unsigned int bytes, int error)
 {
 	request_queue_t *q = bio->bi_private;
-	struct bio_vec *bvec;
-	int i;
 
 	/*
 	 * This is dry run, restore bio_sector and size.  We'll finish
@@ -540,13 +538,6 @@ static int flush_dry_bio_endio(struct bi
 	if (bio->bi_size)
 		return 1;
 
-	/* Rewind bvec's */
-	bio->bi_idx = 0;
-	bio_for_each_segment(bvec, bio, i) {
-		bvec->bv_len += bvec->bv_offset;
-		bvec->bv_offset = 0;
-	}
-
 	/* Reset bio */
 	set_bit(BIO_UPTODATE, &bio->bi_flags);
 	bio->bi_size = q->bi_size;
_

Patches currently in -mm which might be from htejun@gmail.com are

origin.patch
git-libata-all.patch
pata_acpi-restore-driver.patch
libata-implement-ata_wait_after_reset.patch
libata-add-hts541616j9sa00-to-ncq-blacklist.patch
sata_promise-cleanups.patch
sata_promise-sata-hotplug-support.patch
libata-add-irq_flags-to-struct-pata_platform_info.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-scsi-misc.patch
git-scsi-misc-vs-greg-sysfs-stuff.patch
git-block.patch
update-documentation-block-barriertxt.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
lib-add-idr_for_each.patch
lib-add-idr_for_each-fix.patch
lib-add-idr_remove_all.patch
