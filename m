From: akpm@linux-foundation.org
Subject: + block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio.patch added to -mm tree
Date: Thu, 07 Jun 2007 15:42:29 -0700
Message-ID: <200706072242.l57MgTGH010432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53809 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932402AbXFGWnN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 18:43:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: htejun@gmail.com, jens.axboe@oracle.com, neilb@suse.de


The patch titled
     block: drop unnecessary bvec rewinding from flush_dry_bio_endio
has been added to the -mm tree.  Its filename is
     block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 9 deletions(-)

diff -puN block/ll_rw_blk.c~block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio
+++ a/block/ll_rw_blk.c
@@ -518,8 +518,6 @@ int blk_do_ordered(request_queue_t *q, s
 static int flush_dry_bio_endio(struct bio *bio, unsigned int bytes, int error)
 {
 	request_queue_t *q = bio->bi_private;
-	struct bio_vec *bvec;
-	int i;
 
 	/*
 	 * This is dry run, restore bio_sector and size.  We'll finish
@@ -531,13 +529,6 @@ static int flush_dry_bio_endio(struct bi
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

sata_promise-use-tf-interface-for-polling-nodata-commands.patch
git-libata-all.patch
pata_acpi-restore-driver.patch
libata-implement-ata_wait_after_reset.patch
drivers-ata-add-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61.patch
git-scsi-misc.patch
update-documentation-block-barriertxt.patch
block-drop-unnecessary-bvec-rewinding-from-flush_dry_bio_endio.patch
dma-mapping-prevent-dma-dependent-code-from-linking-on.patch
lib-add-idr_for_each.patch
lib-add-idr_for_each-fix.patch
lib-add-idr_remove_all.patch
