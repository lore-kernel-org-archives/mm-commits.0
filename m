From: akpm@linux-foundation.org
Subject: [folded-merged] block-prep-work-for-batch-completion-fix-4.patch removed from -mm tree
Date: Tue, 07 May 2013 12:44:31 -0700
Message-ID: <20130507194431.9CF465A4111@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:37457 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3EGToc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 15:44:32 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz10so100215vcb.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 12:44:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, koverstreet@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block-prep-work-for-batch-completion-fix-4
has been removed from the -mm tree.  Its filename was
     block-prep-work-for-batch-completion-fix-4.patch

This patch was dropped because it was folded into block-prep-work-for-batch-completion.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: block-prep-work-for-batch-completion-fix-4

fix it for mm-allow-for-outstanding-swap-writeback-accounting.patch

Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ++++--
 mm/page_io.c         |    3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/swap.h~block-prep-work-for-batch-completion-fix-4 include/linux/swap.h
--- a/include/linux/swap.h~block-prep-work-for-batch-completion-fix-4
+++ a/include/linux/swap.h
@@ -330,9 +330,11 @@ static inline void mem_cgroup_uncharge_s
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
-extern void end_swap_bio_write(struct bio *bio, int err);
+extern void end_swap_bio_write(struct bio *bio, int err,
+			       struct batch_complete *batch);
 extern int __swap_writepage(struct page *page, struct writeback_control *wbc,
-	void (*end_write_func)(struct bio *, int));
+	void (*end_write_func)(struct bio *bio, int err,
+			       struct batch_complete *batch));
 extern int swap_set_page_dirty(struct page *page);
 extern void end_swap_bio_read(struct bio *bio, int err,
 			      struct batch_complete *batch);
diff -puN mm/page_io.c~block-prep-work-for-batch-completion-fix-4 mm/page_io.c
--- a/mm/page_io.c~block-prep-work-for-batch-completion-fix-4
+++ a/mm/page_io.c
@@ -204,7 +204,8 @@ out:
 }
 
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
-	void (*end_write_func)(struct bio *, int))
+	void (*end_write_func)(struct bio *bio, int err,
+			       struct batch_complete *batch))
 {
 	struct bio *bio;
 	int ret = 0, rw = WRITE;
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

