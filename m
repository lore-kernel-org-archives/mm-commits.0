From: akpm@linux-foundation.org
Subject: [folded-merged] block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 07 May 2013 12:45:11 -0700
Message-ID: <20130507194511.C5F925A419E@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:51971 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab3EGTpN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 15:45:13 -0400
Received: by mail-qa0-f74.google.com with SMTP id i13so124695qae.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 12:45:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch

This patch was dropped because it was folded into block-aio-batch-completion-for-bios-kiocbs.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes

WARNING: line over 80 characters
#155: FILE: block/blk-core.c:2527:
+				   unsigned int nr_bytes, unsigned int bidi_bytes,

WARNING: line over 80 characters
#177: FILE: block/blk-core.c:2643:
+void blk_end_request_all_batch(struct request *rq, int error, struct batch_complete *batch)

WARNING: line over 80 characters
#186: FILE: block/blk-core.c:2651:
+	pending = __blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes, batch);

WARNING: line over 80 characters
#633: FILE: fs/direct-io.c:233:
+static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is_async,

WARNING: line over 80 characters
#652: FILE: fs/direct-io.c:278:
+static void dio_bio_end_aio(struct bio *bio, int error, struct batch_complete *batch)

total: 0 errors, 5 warnings, 740 lines checked

./patches/block-aio-batch-completion-for-bios-kiocbs.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-core.c |    9 ++++++---
 fs/direct-io.c   |    7 ++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -puN block/blk-core.c~block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes block/blk-core.c
--- a/block/blk-core.c~block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes
+++ a/block/blk-core.c
@@ -2509,7 +2509,8 @@ static bool blk_end_bidi_request(struct
  *     %true  - still buffers pending for this request
  **/
 bool __blk_end_bidi_request(struct request *rq, int error,
-				   unsigned int nr_bytes, unsigned int bidi_bytes,
+				   unsigned int nr_bytes,
+				   unsigned int bidi_bytes,
 				   struct batch_complete *batch)
 {
 	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes, batch))
@@ -2625,7 +2626,8 @@ EXPORT_SYMBOL(__blk_end_request);
  * Description:
  *     Completely finish @rq.  Must be called with queue lock held.
  */
-void blk_end_request_all_batch(struct request *rq, int error, struct batch_complete *batch)
+void blk_end_request_all_batch(struct request *rq, int error,
+			       struct batch_complete *batch)
 {
 	bool pending;
 	unsigned int bidi_bytes = 0;
@@ -2633,7 +2635,8 @@ void blk_end_request_all_batch(struct re
 	if (unlikely(blk_bidi_rq(rq)))
 		bidi_bytes = blk_rq_bytes(rq->next_rq);
 
-	pending = __blk_end_bidi_request(rq, error, blk_rq_bytes(rq), bidi_bytes, batch);
+	pending = __blk_end_bidi_request(rq, error, blk_rq_bytes(rq),
+					 bidi_bytes, batch);
 	BUG_ON(pending);
 }
 EXPORT_SYMBOL(blk_end_request_all_batch);
diff -puN fs/direct-io.c~block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes fs/direct-io.c
--- a/fs/direct-io.c~block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes
+++ a/fs/direct-io.c
@@ -230,8 +230,8 @@ static inline struct page *dio_get_page(
  * filesystems can use it to hold additional state between get_block calls and
  * dio_complete.
  */
-static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is_async,
-			    struct batch_complete *batch)
+static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
+			    bool is_async, struct batch_complete *batch)
 {
 	ssize_t transferred = 0;
 
@@ -275,7 +275,8 @@ static int dio_bio_complete(struct dio *
 /*
  * Asynchronous IO callback. 
  */
-static void dio_bio_end_aio(struct bio *bio, int error, struct batch_complete *batch)
+static void dio_bio_end_aio(struct bio *bio, int error,
+			    struct batch_complete *batch)
 {
 	struct dio *dio = bio->bi_private;
 	unsigned long remaining;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-mmh-complete-the-mm_walk-definition.patch
hugetlbfs-fix-mmap-failure-in-unaligned-size-request.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-infiniband-hw-mlx4-madc-rename-random32-to-prandom_u32.patch
mm-vmallocc-add-vfree-comment.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_retry.patch
block-prep-work-for-batch-completion.patch
block-aio-batch-completion-for-bios-kiocbs.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
rapidio-make-enumeration-discovery-configurable-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

