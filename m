From: akpm@linux-foundation.org
Subject: + block-prep-work-for-batch-completion-fix-3.patch added to -mm tree
Date: Tue, 26 Mar 2013 14:27:07 -0700
Message-ID: <20130326212707.D83065A409A@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:55009 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3CZV1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Mar 2013 17:27:09 -0400
Received: by mail-qe0-f74.google.com with SMTP id 7so476648qeb.5
        for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2013 14:27:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, koverstreet@google.com, neilb@suse.de


The patch titled
     Subject: block-prep-work-for-batch-completion-fix-3
has been added to the -mm tree.  Its filename is
     block-prep-work-for-batch-completion-fix-3.patch

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
@@ -133,7 +133,8 @@ static uint64_t btree_csum_set(struct bt
 	return crc ^ 0xffffffffffffffff;
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
 
@@ -199,7 +200,8 @@ static void bch_bio_submit_split_done(st
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
@@ -202,7 +202,8 @@ err:
 	return err;
 }
 
-static void write_bdev_super_endio(struct bio *bio, int error)
+static void write_bdev_super_endio(struct bio *bio, int error,
+				   struct batch_complete *batch)
 {
 	struct cached_dev *dc = bio->bi_private;
 	/* XXX: error checking */
@@ -263,7 +264,8 @@ void bch_write_bdev_super(struct cached_
 	closure_return(cl);
 }
 
-static void write_super_endio(struct bio *bio, int error)
+static void write_super_endio(struct bio *bio, int error,
+			      struct batch_complete *batch)
 {
 	struct cache *ca = bio->bi_private;
 
@@ -304,7 +306,7 @@ void bcache_write_super(struct cache_set
 
 /* UUID io */
 
-static void uuid_endio(struct bio *bio, int error)
+static void uuid_endio(struct bio *bio, int error, struct batch_complete *batch)
 {
 	struct closure *cl = bio->bi_private;
 	struct cache_set *c = container_of(cl, struct cache_set, uuid_write.cl);
@@ -468,7 +470,8 @@ static struct uuid_entry *uuid_find_empt
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
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mips-define-kvm_user_mem_slots.patch
revert-ipc-dont-allocate-a-copy-larger-than-max.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
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
init-mainc-convert-to-pr_foo.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
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
aio-dont-include-aioh-in-schedh-fix.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
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

