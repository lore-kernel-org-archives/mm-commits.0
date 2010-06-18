From: akpm@linux-foundation.org
Subject: + gcc-46-block-fix-unused-but-set-variables-in-blk-merge.patch added to -mm tree
Date: Fri, 18 Jun 2010 16:31:41 -0700
Message-ID: <201006182331.o5INVfjT029559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121Ab0FRXbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 19:31:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, axboe@kernel.dk


The patch titled
     gcc-4.6: block: fix unused but set variables in blk-merge
has been added to the -mm tree.  Its filename is
     gcc-46-block-fix-unused-but-set-variables-in-blk-merge.patch

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
Subject: gcc-4.6: block: fix unused but set variables in blk-merge
From: Andi Kleen <andi@firstfloor.org>

Just some dead code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-merge.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN block/blk-merge.c~gcc-46-block-fix-unused-but-set-variables-in-blk-merge block/blk-merge.c
--- a/block/blk-merge.c~gcc-46-block-fix-unused-but-set-variables-in-blk-merge
+++ a/block/blk-merge.c
@@ -12,7 +12,6 @@
 static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 					     struct bio *bio)
 {
-	unsigned int phys_size;
 	struct bio_vec *bv, *bvprv = NULL;
 	int cluster, i, high, highprv = 1;
 	unsigned int seg_size, nr_phys_segs;
@@ -24,7 +23,7 @@ static unsigned int __blk_recalc_rq_segm
 	fbio = bio;
 	cluster = test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 	seg_size = 0;
-	phys_size = nr_phys_segs = 0;
+	nr_phys_segs = 0;
 	for_each_bio(bio) {
 		bio_for_each_segment(bv, bio, i) {
 			/*
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
modpost-support-objects-with-more-than-64k-sections.patch
kernelh-add-hw_err-printk-prefix-for-hardware-error-logging.patch
x86-use-hw_err-in-mce-handler.patch
gcc-46-irq-move-alloc_desk_mask-variables-inside-ifdef.patch
gcc-46-x86-avoid-unused-by-set-variables-in-rdmsr.patch
gcc-46-pagemap-avoid-unused-but-set-variable.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
gcc-46-x86-fix-set-but-not-read-variables.patch
gcc-46-kgdb-remove-set-but-unused-newpc.patch
gcc-46-printk-use-stable-variable-to-dump-kmsg-buffer.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
gcc-46-btrfs-clean-up-unused-variables-nonbugs.patch
gcc-46-nfsd-fix-initialized-but-not-read-warnings.patch
gcc-46-acpi-fix-unused-but-set-variables-in-acpi.patch
gcc-46-mm-fix-unused-but-set-warnings.patch
gcc-46-kernel-fix-unused-but-set-warnings.patch
gcc-46-block-fix-unused-but-set-variables-in-blk-merge.patch
gcc-46-fs-fix-unused-but-set-warnings.patch

