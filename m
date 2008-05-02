From: akpm@linux-foundation.org
Subject: - block-remove-remaining-__function__-occurances.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:34 -0700
Message-ID: <200805021943.m42JhYN1011300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933456AbYEBToQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:44:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block: remove remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     block-remove-remaining-__function__-occurances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: remove remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-barrier.c  |    3 +--
 block/blk-core.c     |    5 ++---
 block/blk-settings.c |   20 ++++++++++----------
 block/blk-tag.c      |    8 ++++----
 block/bsg.c          |    2 +-
 block/elevator.c     |    5 ++---
 6 files changed, 20 insertions(+), 23 deletions(-)

diff -puN block/blk-barrier.c~block-remove-remaining-__function__-occurances block/blk-barrier.c
--- a/block/blk-barrier.c~block-remove-remaining-__function__-occurances
+++ a/block/blk-barrier.c
@@ -26,8 +26,7 @@ int blk_queue_ordered(struct request_que
 {
 	if (ordered & (QUEUE_ORDERED_PREFLUSH | QUEUE_ORDERED_POSTFLUSH) &&
 	    prepare_flush_fn == NULL) {
-		printk(KERN_ERR "%s: prepare_flush_fn required\n",
-								__FUNCTION__);
+		printk(KERN_ERR "%s: prepare_flush_fn required\n", __func__);
 		return -EINVAL;
 	}
 
diff -puN block/blk-core.c~block-remove-remaining-__function__-occurances block/blk-core.c
--- a/block/blk-core.c~block-remove-remaining-__function__-occurances
+++ a/block/blk-core.c
@@ -136,7 +136,7 @@ static void req_bio_endio(struct request
 
 		if (unlikely(nbytes > bio->bi_size)) {
 			printk(KERN_ERR "%s: want %u bytes done, %u left\n",
-			       __FUNCTION__, nbytes, bio->bi_size);
+			       __func__, nbytes, bio->bi_size);
 			nbytes = bio->bi_size;
 		}
 
@@ -1566,8 +1566,7 @@ static int __end_that_request_first(stru
 			if (unlikely(bio->bi_idx >= bio->bi_vcnt)) {
 				blk_dump_rq_flags(req, "__end_that");
 				printk(KERN_ERR "%s: bio idx %d >= vcnt %d\n",
-						__FUNCTION__, bio->bi_idx,
-						bio->bi_vcnt);
+				       __func__, bio->bi_idx, bio->bi_vcnt);
 				break;
 			}
 
diff -puN block/blk-settings.c~block-remove-remaining-__function__-occurances block/blk-settings.c
--- a/block/blk-settings.c~block-remove-remaining-__function__-occurances
+++ a/block/blk-settings.c
@@ -168,8 +168,8 @@ void blk_queue_max_sectors(struct reques
 {
 	if ((max_sectors << 9) < PAGE_CACHE_SIZE) {
 		max_sectors = 1 << (PAGE_CACHE_SHIFT - 9);
-		printk(KERN_INFO "%s: set to minimum %d\n", __FUNCTION__,
-							max_sectors);
+		printk(KERN_INFO "%s: set to minimum %d\n",
+		       __func__, max_sectors);
 	}
 
 	if (BLK_DEF_MAX_SECTORS > max_sectors)
@@ -196,8 +196,8 @@ void blk_queue_max_phys_segments(struct 
 {
 	if (!max_segments) {
 		max_segments = 1;
-		printk(KERN_INFO "%s: set to minimum %d\n", __FUNCTION__,
-							max_segments);
+		printk(KERN_INFO "%s: set to minimum %d\n",
+		       __func__, max_segments);
 	}
 
 	q->max_phys_segments = max_segments;
@@ -220,8 +220,8 @@ void blk_queue_max_hw_segments(struct re
 {
 	if (!max_segments) {
 		max_segments = 1;
-		printk(KERN_INFO "%s: set to minimum %d\n", __FUNCTION__,
-							max_segments);
+		printk(KERN_INFO "%s: set to minimum %d\n",
+		       __func__, max_segments);
 	}
 
 	q->max_hw_segments = max_segments;
@@ -241,8 +241,8 @@ void blk_queue_max_segment_size(struct r
 {
 	if (max_size < PAGE_CACHE_SIZE) {
 		max_size = PAGE_CACHE_SIZE;
-		printk(KERN_INFO "%s: set to minimum %d\n", __FUNCTION__,
-							max_size);
+		printk(KERN_INFO "%s: set to minimum %d\n",
+		       __func__, max_size);
 	}
 
 	q->max_segment_size = max_size;
@@ -357,8 +357,8 @@ void blk_queue_segment_boundary(struct r
 {
 	if (mask < PAGE_CACHE_SIZE - 1) {
 		mask = PAGE_CACHE_SIZE - 1;
-		printk(KERN_INFO "%s: set to minimum %lx\n", __FUNCTION__,
-							mask);
+		printk(KERN_INFO "%s: set to minimum %lx\n",
+		       __func__, mask);
 	}
 
 	q->seg_boundary_mask = mask;
diff -puN block/blk-tag.c~block-remove-remaining-__function__-occurances block/blk-tag.c
--- a/block/blk-tag.c~block-remove-remaining-__function__-occurances
+++ a/block/blk-tag.c
@@ -112,7 +112,7 @@ init_tag_map(struct request_queue *q, st
 	if (q && depth > q->nr_requests * 2) {
 		depth = q->nr_requests * 2;
 		printk(KERN_ERR "%s: adjusted depth to %d\n",
-				__FUNCTION__, depth);
+		       __func__, depth);
 	}
 
 	tag_index = kzalloc(depth * sizeof(struct request *), GFP_ATOMIC);
@@ -296,13 +296,13 @@ void blk_queue_end_tag(struct request_qu
 
 	if (unlikely(bqt->tag_index[tag] == NULL))
 		printk(KERN_ERR "%s: tag %d is missing\n",
-		       __FUNCTION__, tag);
+		       __func__, tag);
 
 	bqt->tag_index[tag] = NULL;
 
 	if (unlikely(!test_bit(tag, bqt->tag_map))) {
 		printk(KERN_ERR "%s: attempt to clear non-busy tag (%d)\n",
-		       __FUNCTION__, tag);
+		       __func__, tag);
 		return;
 	}
 	/*
@@ -340,7 +340,7 @@ int blk_queue_start_tag(struct request_q
 	if (unlikely((rq->cmd_flags & REQ_QUEUED))) {
 		printk(KERN_ERR
 		       "%s: request %p for device [%s] already tagged %d",
-		       __FUNCTION__, rq,
+		       __func__, rq,
 		       rq->rq_disk ? rq->rq_disk->disk_name : "?", rq->tag);
 		BUG();
 	}
diff -puN block/bsg.c~block-remove-remaining-__function__-occurances block/bsg.c
--- a/block/bsg.c~block-remove-remaining-__function__-occurances
+++ a/block/bsg.c
@@ -57,7 +57,7 @@ enum {
 #undef BSG_DEBUG
 
 #ifdef BSG_DEBUG
-#define dprintk(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ##args)
+#define dprintk(fmt, args...) printk(KERN_ERR "%s: " fmt, __func__, ##args)
 #else
 #define dprintk(fmt, args...)
 #endif
diff -puN block/elevator.c~block-remove-remaining-__function__-occurances block/elevator.c
--- a/block/elevator.c~block-remove-remaining-__function__-occurances
+++ a/block/elevator.c
@@ -650,7 +650,7 @@ void elv_insert(struct request_queue *q,
 
 	default:
 		printk(KERN_ERR "%s: bad insertion point %d\n",
-		       __FUNCTION__, where);
+		       __func__, where);
 		BUG();
 	}
 
@@ -808,8 +808,7 @@ struct request *elv_next_request(struct 
 			rq->cmd_flags |= REQ_QUIET;
 			end_queued_request(rq, 0);
 		} else {
-			printk(KERN_ERR "%s: bad return=%d\n", __FUNCTION__,
-								ret);
+			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);
 			break;
 		}
 	}
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
misc-fix-integer-as-null-pointer-warnings.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
git-net.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
usb-fix-integer-as-null-pointer-sparse-warnings.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
video-fix-integer-as-null-pointer-warnings.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch

