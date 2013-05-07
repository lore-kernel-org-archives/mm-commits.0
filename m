From: akpm@linux-foundation.org
Subject: [folded-merged] block-prep-work-for-batch-completion-fix.patch removed from -mm tree
Date: Tue, 07 May 2013 12:44:28 -0700
Message-ID: <20130507194428.A3D7531C25C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:40096 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3EGTo3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 15:44:29 -0400
Received: by mail-ye0-f201.google.com with SMTP id m14so100127yen.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 12:44:29 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block-prep-work-for-batch-completion-checkpatch merge fixes
has been removed from the -mm tree.  Its filename was
     block-prep-work-for-batch-completion-fix.patch

This patch was dropped because it was folded into block-prep-work-for-batch-completion.patch

------------------------------------------------------
From: Kent Overstreet <koverstreet@google.com>
Subject: block-prep-work-for-batch-completion-checkpatch merge fixes

Update some new bi_endio functions

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-cache-target.c |    3 ++-
 fs/btrfs/raid56.c            |    9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/md/dm-cache-target.c~block-prep-work-for-batch-completion-fix drivers/md/dm-cache-target.c
--- a/drivers/md/dm-cache-target.c~block-prep-work-for-batch-completion-fix
+++ a/drivers/md/dm-cache-target.c
@@ -652,7 +652,8 @@ static void defer_writethrough_bio(struc
 	wake_worker(cache);
 }
 
-static void writethrough_endio(struct bio *bio, int err)
+static void writethrough_endio(struct bio *bio, int err,
+			       struct batch_complete *batch)
 {
 	struct per_bio_data *pb = get_per_bio_data(bio, PB_DATA_SIZE_WT);
 	bio->bi_end_io = pb->saved_bi_end_io;
diff -puN fs/btrfs/raid56.c~block-prep-work-for-batch-completion-fix fs/btrfs/raid56.c
--- a/fs/btrfs/raid56.c~block-prep-work-for-batch-completion-fix
+++ a/fs/btrfs/raid56.c
@@ -850,7 +850,8 @@ static void rbio_orig_end_io(struct btrf
  * end io function used by finish_rmw.  When we finally
  * get here, we've written a full stripe
  */
-static void raid_write_end_io(struct bio *bio, int err)
+static void raid_write_end_io(struct bio *bio, int err,
+			      struct batch_complete *batch)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
@@ -1384,7 +1385,8 @@ static void set_bio_pages_uptodate(struc
  * This will usually kick off finish_rmw once all the bios are read in, but it
  * may trigger parity reconstruction if we had any errors along the way
  */
-static void raid_rmw_end_io(struct bio *bio, int err)
+static void raid_rmw_end_io(struct bio *bio, int err,
+			    struct batch_complete *batch)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
@@ -1905,7 +1907,8 @@ cleanup_io:
  * This is called only for stripes we've read from disk to
  * reconstruct the parity.
  */
-static void raid_recover_end_io(struct bio *bio, int err)
+static void raid_recover_end_io(struct bio *bio, int err,
+				struct batch_complete *batch)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
_

Patches currently in -mm which might be from koverstreet@google.com are

mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
aio-remove-retry-based-aio.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-add-kiocb_cancel.patch
aio-move-private-stuff-out-of-aioh.patch
aio-dprintk-pr_debug.patch
aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-refcounting-cleanup.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-4.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch
linux-next.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch

