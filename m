From: akpm@linux-foundation.org
Subject: + block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch added to -mm tree
Date: Thu, 21 Mar 2013 16:00:53 -0700
Message-ID: <20130321230053.E4DFC31C121@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:63090 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab3CUXAz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Mar 2013 19:00:55 -0400
Received: by mail-ve0-f201.google.com with SMTP id 14so312463vea.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2013 16:00:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, koverstreet@google.com


The patch titled
     Subject: block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch

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
@@ -2524,7 +2524,8 @@ static bool blk_end_bidi_request(struct
  *     %true  - still buffers pending for this request
  **/
 bool __blk_end_bidi_request(struct request *rq, int error,
-				   unsigned int nr_bytes, unsigned int bidi_bytes,
+				   unsigned int nr_bytes,
+				   unsigned int bidi_bytes,
 				   struct batch_complete *batch)
 {
 	if (blk_update_bidi_request(rq, error, nr_bytes, bidi_bytes, batch))
@@ -2640,7 +2641,8 @@ EXPORT_SYMBOL(__blk_end_request);
  * Description:
  *     Completely finish @rq.  Must be called with queue lock held.
  */
-void blk_end_request_all_batch(struct request *rq, int error, struct batch_complete *batch)
+void blk_end_request_all_batch(struct request *rq, int error,
+			       struct batch_complete *batch)
 {
 	bool pending;
 	unsigned int bidi_bytes = 0;
@@ -2648,7 +2650,8 @@ void blk_end_request_all_batch(struct re
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

