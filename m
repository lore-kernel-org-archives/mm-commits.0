From: akpm@linux-foundation.org
Subject: [folded-merged] block-prep-work-for-batch-completion-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 07 May 2013 12:44:25 -0700
Message-ID: <20130507194425.AB0FE5A4111@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:50231 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3EGTo0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 15:44:26 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz10so100301vcb.0
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 12:44:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block-prep-work-for-batch-completion-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     block-prep-work-for-batch-completion-checkpatch-fixes.patch

This patch was dropped because it was folded into block-prep-work-for-batch-completion.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: block-prep-work-for-batch-completion-checkpatch-fixes

WARNING: line over 80 characters
#116: FILE: drivers/block/drbd/drbd_bitmap.c:940:
+static void bm_async_io_complete(struct bio *bio, int error, struct batch_complete *batch)

WARNING: line over 80 characters
#128: FILE: drivers/block/drbd/drbd_worker.c:67:
+void drbd_md_io_complete(struct bio *bio, int error, struct batch_complete *batch)

WARNING: line over 80 characters
#137: FILE: drivers/block/drbd/drbd_worker.c:169:
+void drbd_peer_request_endio(struct bio *bio, int error, struct batch_complete *batch)

WARNING: line over 80 characters
#146: FILE: drivers/block/drbd/drbd_worker.c:205:
+void drbd_request_endio(struct bio *bio, int error, struct batch_complete *batch)

ERROR: "foo * bar" should be "foo *bar"
#562: FILE: drivers/md/raid5.c:1743:
+static void raid5_end_read_request(struct bio * bi, int error,

WARNING: line over 80 characters
#946: FILE: fs/btrfs/volumes.c:5021:
+static void btrfs_end_bio(struct bio *bio, int err, struct batch_complete *batch)

WARNING: Avoid CamelCase: <lbmIODone>
#1087: FILE: fs/jfs/jfs_logmgr.c:2157:
+		lbmIODone(bio, 0, NULL);

total: 1 errors, 6 warnings, 1037 lines checked

./patches/block-prep-work-for-batch-completion.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_bitmap.c |    3 ++-
 drivers/block/drbd/drbd_worker.c |    9 ++++++---
 drivers/md/raid5.c               |    2 +-
 fs/btrfs/volumes.c               |    3 ++-
 4 files changed, 11 insertions(+), 6 deletions(-)

diff -puN drivers/block/drbd/drbd_bitmap.c~block-prep-work-for-batch-completion-checkpatch-fixes drivers/block/drbd/drbd_bitmap.c
--- a/drivers/block/drbd/drbd_bitmap.c~block-prep-work-for-batch-completion-checkpatch-fixes
+++ a/drivers/block/drbd/drbd_bitmap.c
@@ -948,7 +948,8 @@ static void bm_aio_ctx_destroy(struct kr
 }
 
 /* bv_page may be a copy, or may be the original */
-static void bm_async_io_complete(struct bio *bio, int error, struct batch_complete *batch)
+static void bm_async_io_complete(struct bio *bio, int error,
+				 struct batch_complete *batch)
 {
 	struct bm_aio_ctx *ctx = bio->bi_private;
 	struct drbd_conf *mdev = ctx->mdev;
diff -puN drivers/block/drbd/drbd_worker.c~block-prep-work-for-batch-completion-checkpatch-fixes drivers/block/drbd/drbd_worker.c
--- a/drivers/block/drbd/drbd_worker.c~block-prep-work-for-batch-completion-checkpatch-fixes
+++ a/drivers/block/drbd/drbd_worker.c
@@ -64,7 +64,8 @@ rwlock_t global_state_lock;
 /* used for synchronous meta data and bitmap IO
  * submitted by drbd_md_sync_page_io()
  */
-void drbd_md_io_complete(struct bio *bio, int error, struct batch_complete *batch)
+void drbd_md_io_complete(struct bio *bio, int error,
+			 struct batch_complete *batch)
 {
 	struct drbd_md_io *md_io;
 	struct drbd_conf *mdev;
@@ -167,7 +168,8 @@ static void drbd_endio_write_sec_final(s
 /* writes on behalf of the partner, or resync writes,
  * "submitted" by the receiver.
  */
-void drbd_peer_request_endio(struct bio *bio, int error, struct batch_complete *batch)
+void drbd_peer_request_endio(struct bio *bio, int error,
+			     struct batch_complete *batch)
 {
 	struct drbd_peer_request *peer_req = bio->bi_private;
 	struct drbd_conf *mdev = peer_req->w.mdev;
@@ -203,7 +205,8 @@ void drbd_peer_request_endio(struct bio
 
 /* read, readA or write requests on R_PRIMARY coming from drbd_make_request
  */
-void drbd_request_endio(struct bio *bio, int error, struct batch_complete *batch)
+void drbd_request_endio(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	unsigned long flags;
 	struct drbd_request *req = bio->bi_private;
diff -puN drivers/md/raid5.c~block-prep-work-for-batch-completion-checkpatch-fixes drivers/md/raid5.c
--- a/drivers/md/raid5.c~block-prep-work-for-batch-completion-checkpatch-fixes
+++ a/drivers/md/raid5.c
@@ -1776,7 +1776,7 @@ static void shrink_stripes(struct r5conf
 	conf->slab_cache = NULL;
 }
 
-static void raid5_end_read_request(struct bio * bi, int error,
+static void raid5_end_read_request(struct bio *bi, int error,
 				   struct batch_complete *batch)
 {
 	struct stripe_head *sh = bi->bi_private;
diff -puN fs/btrfs/volumes.c~block-prep-work-for-batch-completion-checkpatch-fixes fs/btrfs/volumes.c
--- a/fs/btrfs/volumes.c~block-prep-work-for-batch-completion-checkpatch-fixes
+++ a/fs/btrfs/volumes.c
@@ -5029,7 +5029,8 @@ static unsigned int extract_stripe_index
 	return (unsigned int)((uintptr_t)bi_private) & 3;
 }
 
-static void btrfs_end_bio(struct bio *bio, int err, struct batch_complete *batch)
+static void btrfs_end_bio(struct bio *bio, int err,
+			  struct batch_complete *batch)
 {
 	struct btrfs_bio *bbio = extract_bbio_from_bio_private(bio->bi_private);
 	int is_orig_bio = 0;
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
block-prep-work-for-batch-completion-fix-4.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
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

