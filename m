From: akpm@linux-foundation.org
Subject: [merged] block-do-not-call-sector_div-with-a-64-bit-divisor.patch removed from -mm tree
Date: Tue, 05 Nov 2013 11:29:05 -0800
Message-ID: <52794701.Yg9ztNXnrMDQdcAD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3KET3G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 14:29:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, axboe@kernel.dk, geert@linux-m68k.org

Subject: [merged] block-do-not-call-sector_div-with-a-64-bit-divisor.patch removed from -mm tree
To: geert@linux-m68k.org,axboe@kernel.dk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 11:29:05 -0800


The patch titled
     Subject: block: do not call sector_div() with a 64-bit divisor
has been removed from the -mm tree.  Its filename was
     block-do-not-call-sector_div-with-a-64-bit-divisor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: block: do not call sector_div() with a 64-bit divisor

do_div() (called by sector_div() if CONFIG_LBDAF=y) is meant for divisions
of 64-bit number by 32-bit numbers.  Passing 64-bit divisor types caused
issues in the past on 32-bit platforms, cfr.  commit ea077b1b96e073ea
("m68k: Truncate base in do_div()").

As queue_limits.max_discard_sectors and .discard_granularity are unsigned
int, max_discard_sectors and granularity should be unsigned int.  As
bdev_discard_alignment() returns int, alignment should be int.  Now 2
calls to sector_div() can be replaced by 32-bit arithmetic:

  - The 64-bit modulo operation can become a 32-bit modulo operation,
  - The 64-bit division and multiplication can be replaced by a 32-bit
    modulo operation and a subtraction.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-lib.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN block/blk-lib.c~block-do-not-call-sector_div-with-a-64-bit-divisor block/blk-lib.c
--- a/block/blk-lib.c~block-do-not-call-sector_div-with-a-64-bit-divisor
+++ a/block/blk-lib.c
@@ -43,8 +43,8 @@ int blkdev_issue_discard(struct block_de
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
 	int type = REQ_WRITE | REQ_DISCARD;
-	sector_t max_discard_sectors;
-	sector_t granularity, alignment;
+	unsigned int max_discard_sectors, granularity;
+	int alignment;
 	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
@@ -58,16 +58,14 @@ int blkdev_issue_discard(struct block_de
 
 	/* Zero-sector (unknown) and one-sector granularities are the same.  */
 	granularity = max(q->limits.discard_granularity >> 9, 1U);
-	alignment = bdev_discard_alignment(bdev) >> 9;
-	alignment = sector_div(alignment, granularity);
+	alignment = (bdev_discard_alignment(bdev) >> 9) % granularity;
 
 	/*
 	 * Ensure that max_discard_sectors is of the proper
 	 * granularity, so that requests stay aligned after a split.
 	 */
 	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
-	sector_div(max_discard_sectors, granularity);
-	max_discard_sectors *= granularity;
+	max_discard_sectors -= max_discard_sectors % granularity;
 	if (unlikely(!max_discard_sectors)) {
 		/* Avoid infinite loop below. Being cautious never hurts. */
 		return -EOPNOTSUPP;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
genirq-correct-fuzzy-and-fragile-irq_retval-definition.patch
scsi-do-not-call-do_div-with-a-64-bit-divisor.patch
syscallsh-use-gcc-alias-instead-of-assembler-aliases-for-syscalls.patch
scripts-mod-modpostc-handle-non-abs-crc-symbols.patch
kernel-sysc-remove-obsolete-include-linux-kexech.patch
init-mainc-remove-prototype-for-softirq_init.patch
inith-document-the-existence-of-__initconst.patch
init-make-init-failures-more-explicit.patch
x86-add-missed-pgtable_pmd_page_ctor-dtor-calls-for-preallocated-pmds.patch
m68k-handle-pgtable_page_ctor-fail.patch
m68k-handle-pgtable_page_ctor-fail-fix.patch
m68k-handle-pgtable_page_ctor-fail-fix-fix.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch

