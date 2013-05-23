From: akpm@linux-foundation.org
Subject: [folded-merged] block-prep-work-for-batch-completion-fix-3.patch
 removed from -mm tree
Date: Thu, 23 May 2013 13:49:11 -0700
Message-ID: <519e80c7.18doTNO9hXsi8WwR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758330Ab3EWUtM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 16:49:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, neilb@suse.de, koverstreet@google.com, akpm@linux-foundation.org

Subject: [folded-merged] block-prep-work-for-batch-completion-fix-3.patch removed from -mm tree
To: akpm@linux-foundation.org,koverstreet@google.com,neilb@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 13:49:11 -0700


The patch titled
     Subject: block-prep-work-for-batch-completion-fix-3
has been removed from the -mm tree.  Its filename was
     block-prep-work-for-batch-completion-fix-3.patch

This patch was dropped because it was folded into block-prep-work-for-batch-completion.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: block-prep-work-for-batch-completion-fix-3

Cc: Kent Overstreet <koverstreet@google.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/btree.c     |    3 ++-
 drivers/md/bcache/io.c        |    6 ++++--
 drivers/md/bcache/journal.c   |    9 ++++++---
 drivers/md/bcache/movinggc.c  |    3 ++-
 drivers/md/bcache/request.c   |    9 ++++++---
 drivers/md/bcache/request.h   |    3 +--
 drivers/md/bcache/super.c     |   11 +++++++----
 drivers/md/bcache/writeback.c |    8 +++++---
 8 files changed, 33 insertions(+), 19 deletions(-)

diff -puN drivers/md/bcache/btree.c~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/btree.c
--- a/drivers/md/bcache/btree.c~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/btree.c
@@ -134,7 +134,8 @@ static uint64_t btree_csum_set(struct bt
 	return crc ^ 0xffffffffffffffffULL;
 }
 
-static void btree_bio_endio(struct bio *bio, int error)
+static void btree_bio_endio(struct bio *bio, int error,
+			    struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct btree *b = container_of(cl, struct btree, io.cl);
diff -puN drivers/md/bcache/io.c~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/io.c
--- a/drivers/md/bcache/io.c~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/io.c
@@ -9,7 +9,8 @@
 #include "bset.h"
 #include "debug.h"
 
-static void bch_bi_idx_hack_endio(struct bio *bio, int error)
+static void bch_bi_idx_hack_endio(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	struct bio *p = bio->bi_private;
 
@@ -206,7 +207,8 @@ static void bch_bio_submit_split_done(st
 	mempool_free(s, s->p->bio_split_hook);
 }
 
-static void bch_bio_submit_split_endio(struct bio *bio, int error)
+static void bch_bio_submit_split_endio(struct bio *bio, int error,
+				       struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct bio_split_hook *s = container_of(cl, struct bio_split_hook, cl);
diff -puN drivers/md/bcache/journal.c~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/journal.c
--- a/drivers/md/bcache/journal.c~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/journal.c
@@ -22,7 +22,8 @@
  * bit.
  */
 
-static void journal_read_endio(struct bio *bio, int error)
+static void journal_read_endio(struct bio *bio, int error,
+			       struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	closure_put(cl);
@@ -390,7 +391,8 @@ found:
 
 #define last_seq(j)	((j)->seq - fifo_used(&(j)->pin) + 1)
 
-static void journal_discard_endio(struct bio *bio, int error)
+static void journal_discard_endio(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	struct journal_device *ja =
 		container_of(bio, struct journal_device, discard_bio);
@@ -535,7 +537,8 @@ void bch_journal_next(struct journal *j)
 		pr_debug("journal_pin full (%zu)", fifo_used(&j->pin));
 }
 
-static void journal_write_endio(struct bio *bio, int error)
+static void journal_write_endio(struct bio *bio, int error,
+				struct batch_complete *batch)
 {
 	struct journal_write *w = bio->bi_private;
 
diff -puN drivers/md/bcache/movinggc.c~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/movinggc.c
--- a/drivers/md/bcache/movinggc.c~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/movinggc.c
@@ -61,7 +61,8 @@ static void write_moving_finish(struct c
 	closure_return_with_destructor(cl, moving_io_destructor);
 }
 
-static void read_moving_endio(struct bio *bio, int error)
+static void read_moving_endio(struct bio *bio, int error,
+			      struct batch_complete *batch)
 {
 	struct moving_io *io = container_of(bio->bi_private,
 					    struct moving_io, s.cl);
diff -puN drivers/md/bcache/request.c~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/request.c
--- a/drivers/md/bcache/request.c~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/request.c
@@ -456,7 +456,8 @@ static void bch_insert_data_error(struct
 	bch_journal(cl);
 }
 
-static void bch_insert_data_endio(struct bio *bio, int error)
+static void bch_insert_data_endio(struct bio *bio, int error,
+				  struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct btree_op *op = container_of(cl, struct btree_op, cl);
@@ -621,7 +622,8 @@ void bch_btree_insert_async(struct closu
 
 /* Common code for the make_request functions */
 
-static void request_endio(struct bio *bio, int error)
+static void request_endio(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 
@@ -636,7 +638,8 @@ static void request_endio(struct bio *bi
 	closure_put(cl);
 }
 
-void bch_cache_read_endio(struct bio *bio, int error)
+void bch_cache_read_endio(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct bbio *b = container_of(bio, struct bbio, bio);
 	struct closure *cl = bio->bi_private;
diff -puN drivers/md/bcache/request.h~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/request.h
--- a/drivers/md/bcache/request.h~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/request.h
@@ -29,11 +29,10 @@ struct search {
 	struct btree_op		op;
 };
 
-void bch_cache_read_endio(struct bio *, int);
+void bch_cache_read_endio(struct bio *, int, struct batch_complete *batch);
 int bch_get_congested(struct cache_set *);
 void bch_insert_data(struct closure *cl);
 void bch_btree_insert_async(struct closure *);
-void bch_cache_read_endio(struct bio *, int);
 
 void bch_open_buckets_free(struct cache_set *);
 int bch_open_buckets_alloc(struct cache_set *);
diff -puN drivers/md/bcache/super.c~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/super.c
--- a/drivers/md/bcache/super.c~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/super.c
@@ -224,7 +224,8 @@ err:
 	return err;
 }
 
-static void write_bdev_super_endio(struct bio *bio, int error)
+static void write_bdev_super_endio(struct bio *bio, int error,
+				   struct batch_complete *batch)
 {
 	struct cached_dev *dc = bio->bi_private;
 	/* XXX: error checking */
@@ -285,7 +286,8 @@ void bch_write_bdev_super(struct cached_
 	closure_return(cl);
 }
 
-static void write_super_endio(struct bio *bio, int error)
+static void write_super_endio(struct bio *bio, int error,
+			      struct batch_complete *batch)
 {
 	struct cache *ca = bio->bi_private;
 
@@ -326,7 +328,7 @@ void bcache_write_super(struct cache_set
 
 /* UUID io */
 
-static void uuid_endio(struct bio *bio, int error)
+static void uuid_endio(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct cache_set *c = container_of(cl, struct cache_set, uuid_write.cl);
@@ -490,7 +492,8 @@ static struct uuid_entry *uuid_find_empt
  * disk.
  */
 
-static void prio_endio(struct bio *bio, int error)
+static void prio_endio(struct bio *bio, int error,
+		       struct batch_complete *batch)
 {
 	struct cache *ca = bio->bi_private;
 
diff -puN drivers/md/bcache/writeback.c~block-prep-work-for-batch-completion-fix-3 drivers/md/bcache/writeback.c
--- a/drivers/md/bcache/writeback.c~block-prep-work-for-batch-completion-fix-3
+++ a/drivers/md/bcache/writeback.c
@@ -253,7 +253,8 @@ static void write_dirty_finish(struct cl
 	closure_return_with_destructor(cl, dirty_io_destructor);
 }
 
-static void dirty_endio(struct bio *bio, int error)
+static void dirty_endio(struct bio *bio, int error,
+			struct batch_complete *batch)
 {
 	struct keybuf_key *w = bio->bi_private;
 	struct dirty_io *io = w->private;
@@ -281,7 +282,8 @@ static void write_dirty(struct closure *
 	continue_at(cl, write_dirty_finish, dirty_wq);
 }
 
-static void read_dirty_endio(struct bio *bio, int error)
+static void read_dirty_endio(struct bio *bio, int error,
+			     struct batch_complete *batch)
 {
 	struct keybuf_key *w = bio->bi_private;
 	struct dirty_io *io = w->private;
@@ -289,7 +291,7 @@ static void read_dirty_endio(struct bio
 	bch_count_io_errors(PTR_CACHE(io->dc->disk.c, &w->key, 0),
 			    error, "reading dirty data from cache");
 
-	dirty_endio(bio, error);
+	dirty_endio(bio, error, NULL);
 }
 
 static void read_dirty_submit(struct closure *cl)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
revert-selftest-add-simple-test-for-soft-dirty-bit.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
generic-dynamic-per-cpu-refcounting.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-prep-work-for-batch-completion-fix-4.patch
block-prep-work-for-batch-completion-fix-101.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

