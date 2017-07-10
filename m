From: akpm@linux-foundation.org
Subject: [patch 001/115] swap: add block io poll in swapin path
Date: Mon, 10 Jul 2017 15:47:11 -0700
Message-ID: <20170710224711.oOEcYMEM5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41988 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754106AbdGJWrM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:47:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@fb.com, hughd@google.com, mm-commits@vger.kernel.org, shli@fb.com, tim.c.chen@intel.com, torvalds@linux-foundation.org, ying.huang@intel.com

From: Shaohua Li <shli@fb.com>
Subject: swap: add block io poll in swapin path

For fast flash disk, async IO could introduce overhead because of context
switch.  block-mq now supports IO poll, which improves performance and
latency a lot.  swapin is a good place to use this technique, because the
task is waitting for the swapin page to continue execution.

In my virtual machine, directly read 4k data from a NVMe with iopoll is
about 60% better than that without poll.  With iopoll support in swapin
patch, my microbenchmark (a task does random memory write) is about 10% ~
25% faster.  CPU utilization increases a lot though, 2x and even 3x CPU
utilization.  This will depend on disk speed though.  While iopoll in
swapin isn't intended for all usage cases, it's a win for latency
sensistive workloads with high speed swap disk.  block layer has knob to
control poll in runtime.  If poll isn't enabled in block layer, there
should be no noticeable change in swapin.

I got a chance to run the same test in a NVMe with DRAM as the media.  In
simple fio IO test, blkpoll boosts 50% performance in single thread test
and ~20% in 8 threads test.  So this is the base line.  In above swap
test, blkpoll boosts ~27% performance in single thread test.  blkpoll uses
2x CPU time though.  If we enable hybid polling, the performance gain has
very slight drop but CPU time is only 50% worse than that without blkpoll.
Also we can adjust parameter of hybid poll, with it, the CPU time
penality is reduced further.  In 8 threads test, blkpoll doesn't help
though.  The performance is similar to that without blkpoll, but cpu
utilization is similar too.  There is lock contention in swap path.  The
cpu time spending on blkpoll isn't high.  So overall, blkpoll swapin isn't
worse than that without it.

The swapin readahead might read several pages in in the same time and form
a big IO request.  Since the IO will take longer time, it doesn't make
sense to do poll, so the patch only does iopoll for single page swapin.

[akpm@linux-foundation.org: coding-style fixes]
Link: http://lkml.kernel.org/r/070c3c3e40b711e7b1390002c991e86a-b5408f0@7511894063d3764ff01ea8111f5a004d7dd700ed078797c204a24e620ddb965c
Signed-off-by: Shaohua Li <shli@fb.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    5 +++--
 mm/madvise.c         |    4 ++--
 mm/page_io.c         |   23 +++++++++++++++++++++--
 mm/swap_state.c      |   10 ++++++----
 mm/swapfile.c        |    2 +-
 5 files changed, 33 insertions(+), 11 deletions(-)

diff -puN include/linux/swap.h~swap-add-block-io-poll-in-swapin-path include/linux/swap.h
--- a/include/linux/swap.h~swap-add-block-io-poll-in-swapin-path
+++ a/include/linux/swap.h
@@ -331,7 +331,7 @@ extern void kswapd_stop(int nid);
 #include <linux/blk_types.h> /* for bio_end_io_t */
 
 /* linux/mm/page_io.c */
-extern int swap_readpage(struct page *);
+extern int swap_readpage(struct page *page, bool do_poll);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
 extern void end_swap_bio_write(struct bio *bio);
 extern int __swap_writepage(struct page *page, struct writeback_control *wbc,
@@ -362,7 +362,8 @@ extern void free_page_and_swap_cache(str
 extern void free_pages_and_swap_cache(struct page **, int);
 extern struct page *lookup_swap_cache(swp_entry_t);
 extern struct page *read_swap_cache_async(swp_entry_t, gfp_t,
-			struct vm_area_struct *vma, unsigned long addr);
+			struct vm_area_struct *vma, unsigned long addr,
+			bool do_poll);
 extern struct page *__read_swap_cache_async(swp_entry_t, gfp_t,
 			struct vm_area_struct *vma, unsigned long addr,
 			bool *new_page_allocated);
diff -puN mm/madvise.c~swap-add-block-io-poll-in-swapin-path mm/madvise.c
--- a/mm/madvise.c~swap-add-block-io-poll-in-swapin-path
+++ a/mm/madvise.c
@@ -205,7 +205,7 @@ static int swapin_walk_pmd_entry(pmd_t *
 			continue;
 
 		page = read_swap_cache_async(entry, GFP_HIGHUSER_MOVABLE,
-								vma, index);
+							vma, index, false);
 		if (page)
 			put_page(page);
 	}
@@ -246,7 +246,7 @@ static void force_shm_swapin_readahead(s
 		}
 		swap = radix_to_swp_entry(page);
 		page = read_swap_cache_async(swap, GFP_HIGHUSER_MOVABLE,
-								NULL, 0);
+							NULL, 0, false);
 		if (page)
 			put_page(page);
 	}
diff -puN mm/page_io.c~swap-add-block-io-poll-in-swapin-path mm/page_io.c
--- a/mm/page_io.c~swap-add-block-io-poll-in-swapin-path
+++ a/mm/page_io.c
@@ -117,6 +117,7 @@ static void swap_slot_free_notify(struct
 static void end_swap_bio_read(struct bio *bio)
 {
 	struct page *page = bio->bi_io_vec[0].bv_page;
+	struct task_struct *waiter = bio->bi_private;
 
 	if (bio->bi_status) {
 		SetPageError(page);
@@ -132,7 +133,9 @@ static void end_swap_bio_read(struct bio
 	swap_slot_free_notify(page);
 out:
 	unlock_page(page);
+	WRITE_ONCE(bio->bi_private, NULL);
 	bio_put(bio);
+	wake_up_process(waiter);
 }
 
 int generic_swapfile_activate(struct swap_info_struct *sis,
@@ -329,11 +332,13 @@ out:
 	return ret;
 }
 
-int swap_readpage(struct page *page)
+int swap_readpage(struct page *page, bool do_poll)
 {
 	struct bio *bio;
 	int ret = 0;
 	struct swap_info_struct *sis = page_swap_info(page);
+	blk_qc_t qc;
+	struct block_device *bdev;
 
 	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
@@ -372,9 +377,23 @@ int swap_readpage(struct page *page)
 		ret = -ENOMEM;
 		goto out;
 	}
+	bdev = bio->bi_bdev;
+	bio->bi_private = current;
 	bio_set_op_attrs(bio, REQ_OP_READ, 0);
 	count_vm_event(PSWPIN);
-	submit_bio(bio);
+	bio_get(bio);
+	qc = submit_bio(bio);
+	while (do_poll) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (!READ_ONCE(bio->bi_private))
+			break;
+
+		if (!blk_mq_poll(bdev_get_queue(bdev), qc))
+			break;
+	}
+	__set_current_state(TASK_RUNNING);
+	bio_put(bio);
+
 out:
 	return ret;
 }
diff -puN mm/swap_state.c~swap-add-block-io-poll-in-swapin-path mm/swap_state.c
--- a/mm/swap_state.c~swap-add-block-io-poll-in-swapin-path
+++ a/mm/swap_state.c
@@ -412,14 +412,14 @@ struct page *__read_swap_cache_async(swp
  * the swap entry is no longer in use.
  */
 struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
-			struct vm_area_struct *vma, unsigned long addr)
+		struct vm_area_struct *vma, unsigned long addr, bool do_poll)
 {
 	bool page_was_allocated;
 	struct page *retpage = __read_swap_cache_async(entry, gfp_mask,
 			vma, addr, &page_was_allocated);
 
 	if (page_was_allocated)
-		swap_readpage(retpage);
+		swap_readpage(retpage, do_poll);
 
 	return retpage;
 }
@@ -496,11 +496,13 @@ struct page *swapin_readahead(swp_entry_
 	unsigned long start_offset, end_offset;
 	unsigned long mask;
 	struct blk_plug plug;
+	bool do_poll = true;
 
 	mask = swapin_nr_pages(offset) - 1;
 	if (!mask)
 		goto skip;
 
+	do_poll = false;
 	/* Read a page_cluster sized and aligned cluster around offset. */
 	start_offset = offset & ~mask;
 	end_offset = offset | mask;
@@ -511,7 +513,7 @@ struct page *swapin_readahead(swp_entry_
 	for (offset = start_offset; offset <= end_offset ; offset++) {
 		/* Ok, do the async read-ahead now */
 		page = read_swap_cache_async(swp_entry(swp_type(entry), offset),
-						gfp_mask, vma, addr);
+						gfp_mask, vma, addr, false);
 		if (!page)
 			continue;
 		if (offset != entry_offset && likely(!PageTransCompound(page)))
@@ -522,7 +524,7 @@ struct page *swapin_readahead(swp_entry_
 
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 skip:
-	return read_swap_cache_async(entry, gfp_mask, vma, addr);
+	return read_swap_cache_async(entry, gfp_mask, vma, addr, do_poll);
 }
 
 int init_swap_address_space(unsigned int type, unsigned long nr_pages)
diff -puN mm/swapfile.c~swap-add-block-io-poll-in-swapin-path mm/swapfile.c
--- a/mm/swapfile.c~swap-add-block-io-poll-in-swapin-path
+++ a/mm/swapfile.c
@@ -1868,7 +1868,7 @@ int try_to_unuse(unsigned int type, bool
 		swap_map = &si->swap_map[i];
 		entry = swp_entry(type, i);
 		page = read_swap_cache_async(entry,
-					GFP_HIGHUSER_MOVABLE, NULL, 0);
+					GFP_HIGHUSER_MOVABLE, NULL, 0, false);
 		if (!page) {
 			/*
 			 * Either swap_duplicate() failed because entry
_
