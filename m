From: akpm@linux-foundation.org
Subject: + block-prep-work-for-batch-completion-checkpatch-fixes.patch added to -mm tree
Date: Thu, 21 Mar 2013 16:00:50 -0700
Message-ID: <20130321230051.3416C5A4251@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:48004 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab3CUXAw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 19:00:52 -0400
Received: by mail-vb0-f74.google.com with SMTP id r6so312882vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 16:00:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, koverstreet@google.com


The patch titled
     Subject: block-prep-work-for-batch-completion-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     block-prep-work-for-batch-completion-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -937,7 +937,8 @@ static void bm_aio_ctx_destroy(struct kr
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
@@ -166,7 +167,8 @@ static void drbd_endio_write_sec_final(s
 /* writes on behalf of the partner, or resync writes,
  * "submitted" by the receiver.
  */
-void drbd_peer_request_endio(struct bio *bio, int error, struct batch_complete *batch)
+void drbd_peer_request_endio(struct bio *bio, int error,
+			     struct batch_complete *batch)
 {
 	struct drbd_peer_request *peer_req = bio->bi_private;
 	struct drbd_conf *mdev = peer_req->w.mdev;
@@ -202,7 +204,8 @@ void drbd_peer_request_endio(struct bio
 
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
@@ -1740,7 +1740,7 @@ static void shrink_stripes(struct r5conf
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
@@ -5018,7 +5018,8 @@ static unsigned int extract_stripe_index
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

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
printk-provide-a-wake_up_klogd-off-case-fix.patch
mm-hugetlb-fix-total-hugetlbfs-pages-count-when-memory-overcommit-accouting-fix.patch
dma-debug-fix-locking-bug-in-check_unmap-fix.patch
mips-define-kvm_user_mem_slots.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
kernel-sched-schedh-fix-warning.patch
loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes.patch
loop-cleanup-partitions-when-detaching-loop-device-fix.patch
loop-cleanup-partitions-when-detaching-loop-device-fix-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

