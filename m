From: akpm@linux-foundation.org
Subject: + block-prep-work-for-batch-completion-fix.patch added to -mm tree
Date: Mon, 25 Mar 2013 12:58:14 -0700
Message-ID: <20130325195814.669405A4158@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:44413 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3CYT6P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 15:58:15 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so655000vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 12:58:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: koverstreet@google.com


The patch titled
     Subject: block-prep-work-for-batch-completion-checkpatch merge fixes
has been added to the -mm tree.  Its filename is
     block-prep-work-for-batch-completion-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -633,7 +633,8 @@ static void defer_writethrough_bio(struc
 	wake_worker(cache);
 }
 
-static void writethrough_endio(struct bio *bio, int err)
+static void writethrough_endio(struct bio *bio, int err,
+			       struct batch_complete *batch)
 {
 	struct per_bio_data *pb = get_per_bio_data(bio);
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

origin.patch
mm-remove-old-aio-use_mm-comment.patch
aio-remove-dead-code-from-aioh.patch
gadget-remove-only-user-of-aio-retry.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
char-add-aio_readwrite-to-dev-nullzero.patch
aio-kill-return-value-of-aio_complete.patch
aio-add-kiocb_cancel.patch
aio-move-private-stuff-out-of-aioh.patch
aio-dprintk-pr_debug.patch
aio-do-fget-after-aio_get_req.patch
aio-make-aio_put_req-lockless.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-flush_dcache_page.patch
aio-use-cancellation-list-lazily.patch
aio-change-reqs_active-to-include-unreaped-completions.patch
aio-kill-batch-allocation.patch
aio-kill-struct-aio_ring_info.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
aio-reqs_active-reqs_available.patch
aio-percpu-reqs_available.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-percpu-ioctx-refcount.patch
aio-use-xchg-instead-of-completion_lock.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_key.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
virtio-blk-convert-to-batch-completion.patch
mtip32xx-convert-to-batch-completion.patch
aio-fix-kioctx-not-being-freed-after-cancellation-at-exit-time.patch

