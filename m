From: akpm@linux-foundation.org
Subject: + block-remove-remaining-__function__-occurances.patch added to -mm tree
Date: Mon, 03 Mar 2008 00:26:07 -0800
Message-ID: <200803030826.m238Q7GR006667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbYCCI0t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 03:26:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, jens.axboe@oracle.com


The patch titled
     block: remove remaining __FUNCTION__ occurences
has been added to the -mm tree.  Its filename is
     block-remove-remaining-__function__-occurances.patch

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
Subject: block: remove remaining __FUNCTION__ occurences
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
@@ -156,7 +156,7 @@ static void req_bio_endio(struct request
 
 		if (unlikely(nbytes > bio->bi_size)) {
 			printk(KERN_ERR "%s: want %u bytes done, %u left\n",
-			       __FUNCTION__, nbytes, bio->bi_size);
+			       __func__, nbytes, bio->bi_size);
 			nbytes = bio->bi_size;
 		}
 
@@ -1575,8 +1575,7 @@ static int __end_that_request_first(stru
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
@@ -169,8 +169,8 @@ void blk_queue_max_sectors(struct reques
 {
 	if ((max_sectors << 9) < PAGE_CACHE_SIZE) {
 		max_sectors = 1 << (PAGE_CACHE_SHIFT - 9);
-		printk(KERN_INFO "%s: set to minimum %d\n", __FUNCTION__,
-							max_sectors);
+		printk(KERN_INFO "%s: set to minimum %d\n",
+		       __func__, max_sectors);
 	}
 
 	if (BLK_DEF_MAX_SECTORS > max_sectors)
@@ -197,8 +197,8 @@ void blk_queue_max_phys_segments(struct 
 {
 	if (!max_segments) {
 		max_segments = 1;
-		printk(KERN_INFO "%s: set to minimum %d\n", __FUNCTION__,
-							max_segments);
+		printk(KERN_INFO "%s: set to minimum %d\n",
+		       __func__, max_segments);
 	}
 
 	q->max_phys_segments = max_segments;
@@ -221,8 +221,8 @@ void blk_queue_max_hw_segments(struct re
 {
 	if (!max_segments) {
 		max_segments = 1;
-		printk(KERN_INFO "%s: set to minimum %d\n", __FUNCTION__,
-							max_segments);
+		printk(KERN_INFO "%s: set to minimum %d\n",
+		       __func__, max_segments);
 	}
 
 	q->max_hw_segments = max_segments;
@@ -242,8 +242,8 @@ void blk_queue_max_segment_size(struct r
 {
 	if (max_size < PAGE_CACHE_SIZE) {
 		max_size = PAGE_CACHE_SIZE;
-		printk(KERN_INFO "%s: set to minimum %d\n", __FUNCTION__,
-							max_size);
+		printk(KERN_INFO "%s: set to minimum %d\n",
+		       __func__, max_size);
 	}
 
 	q->max_segment_size = max_size;
@@ -342,8 +342,8 @@ void blk_queue_segment_boundary(struct r
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
@@ -110,7 +110,7 @@ init_tag_map(struct request_queue *q, st
 	if (q && depth > q->nr_requests * 2) {
 		depth = q->nr_requests * 2;
 		printk(KERN_ERR "%s: adjusted depth to %d\n",
-				__FUNCTION__, depth);
+		       __func__, depth);
 	}
 
 	tag_index = kzalloc(depth * sizeof(struct request *), GFP_ATOMIC);
@@ -294,13 +294,13 @@ void blk_queue_end_tag(struct request_qu
 
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
@@ -338,7 +338,7 @@ int blk_queue_start_tag(struct request_q
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
@@ -58,7 +58,7 @@ enum {
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
@@ -647,7 +647,7 @@ void elv_insert(struct request_queue *q,
 
 	default:
 		printk(KERN_ERR "%s: bad insertion point %d\n",
-		       __FUNCTION__, where);
+		       __func__, where);
 		BUG();
 	}
 
@@ -805,8 +805,7 @@ struct request *elv_next_request(struct 
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
specialixc-fix-possible-double-unlock.patch
git-x86.patch
git-alsa.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
cifs-remove-global_extern-macro.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
git-nfsd.patch
block-fix-shadowed-variable-warning-in-blk-mapc.patch
block-remove-extern-on-function-definition.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-introduce-kprobe_handle_fault-ia64-fix.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch

