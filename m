From: akpm@linux-foundation.org
Subject: - readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch removed from -mm tree
Date: Tue, 08 May 2007 01:13:32 -0700
Message-ID: <200705080813.l488DWsi018921@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934616AbXEHIOW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:14:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead: add look-ahead support to __do_page_cache_readahead()
has been removed from the -mm tree.  Its filename was
     readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: add look-ahead support to __do_page_cache_readahead()
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

Add look-ahead support to __do_page_cache_readahead().

It works by
	- mark the Nth backwards page with PG_readahead,
	(which instructs the page's first reader to invoke readahead)
	- and only do the marking for newly allocated pages.
	(to prevent blindly doing readahead on already cached pages)

Look-ahead is a technique to achieve I/O pipelining:
	While the application is working through a chunk of cached pages,
	the kernel reads-ahead the next chunk of pages _before_ time of need.
	It effectively hides low level I/O latencies to high level
	applications.

Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/readahead.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN mm/readahead.c~readahead-add-look-ahead-support-to-__do_page_cache_readahead mm/readahead.c
--- a/mm/readahead.c~readahead-add-look-ahead-support-to-__do_page_cache_readahead
+++ a/mm/readahead.c
@@ -267,7 +267,8 @@ out:
  */
 static int
 __do_page_cache_readahead(struct address_space *mapping, struct file *filp,
-			pgoff_t offset, unsigned long nr_to_read)
+			pgoff_t offset, unsigned long nr_to_read,
+			unsigned long lookahead_size)
 {
 	struct inode *inode = mapping->host;
 	struct page *page;
@@ -280,7 +281,7 @@ __do_page_cache_readahead(struct address
 	if (isize == 0)
 		goto out;
 
- 	end_index = ((isize - 1) >> PAGE_CACHE_SHIFT);
+	end_index = ((isize - 1) >> PAGE_CACHE_SHIFT);
 
 	/*
 	 * Preallocate as many pages as we will need.
@@ -303,6 +304,8 @@ __do_page_cache_readahead(struct address
 			break;
 		page->index = page_offset;
 		list_add(&page->lru, &page_pool);
+		if (page_idx == nr_to_read - lookahead_size)
+			SetPageReadahead(page);
 		ret++;
 	}
 	read_unlock_irq(&mapping->tree_lock);
@@ -339,7 +342,7 @@ int force_page_cache_readahead(struct ad
 		if (this_chunk > nr_to_read)
 			this_chunk = nr_to_read;
 		err = __do_page_cache_readahead(mapping, filp,
-						offset, this_chunk);
+						offset, this_chunk, 0);
 		if (err < 0) {
 			ret = err;
 			break;
@@ -386,7 +389,7 @@ int do_page_cache_readahead(struct addre
 	if (bdi_read_congested(mapping->backing_dev_info))
 		return -1;
 
-	return __do_page_cache_readahead(mapping, filp, offset, nr_to_read);
+	return __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
 }
 
 /*
@@ -406,7 +409,7 @@ blockable_page_cache_readahead(struct ad
 	if (!block && bdi_read_congested(mapping->backing_dev_info))
 		return 0;
 
-	actual = __do_page_cache_readahead(mapping, filp, offset, nr_to_read);
+	actual = __do_page_cache_readahead(mapping, filp, offset, nr_to_read, 0);
 
 	return check_ra_success(ra, nr_to_read, actual);
 }
@@ -451,7 +454,7 @@ static int make_ahead_window(struct addr
  * @req_size: hint: total size of the read which the caller is performing in
  *            PAGE_CACHE_SIZE units
  *
- * page_cache_readahead() is the main function.  If performs the adaptive
+ * page_cache_readahead() is the main function.  It performs the adaptive
  * readahead window size management and submits the readahead I/O.
  *
  * Note that @filp is purely used for passing on to the ->readpage[s]()
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-insert-cond_resched-calls.patch
readahead-minmax_ra_pages.patch
readahead-events-accounting.patch
readahead-rescue_pages.patch
readahead-sysctl-parameters.patch
readahead-min-max-sizes.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method.patch
readahead-state-based-method-check-node-id.patch
readahead-state-based-method-decouple-readahead_ratio-from-growth_limit.patch
readahead-state-based-method-cancel-lookahead-gracefully.patch
readahead-context-based-method.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-thrashing-recovery-method-check-unbalanced-aging.patch
readahead-thrashing-recovery-method-refill-holes.patch
readahead-call-scheme.patch
readahead-call-scheme-cleanup.patch
readahead-call-scheme-catch-thrashing-on-lookahead-time.patch
readahead-call-scheme-doc-fixes-for-readahead.patch
readahead-laptop-mode.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-remove-parameter-ra_max-from-thrashing_recovery_readahead.patch
readahead-remove-parameter-ra_max-from-adjust_rala.patch
readahead-state-based-method-protect-against-tiny-size.patch
readahead-rename-state_based_readahead-to-clock_based_readahead.patch
readahead-account-i-o-block-times-for-stock-readahead.patch
readahead-rescue_pages-updates.patch
readahead-remove-noaction-shrink-events.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
readahead-turn-on-by-default.patch
