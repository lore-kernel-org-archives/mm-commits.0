From: akpm@linux-foundation.org
Subject: - readahead-call-scheme.patch removed from -mm tree
Date: Tue, 08 May 2007 01:15:03 -0700
Message-ID: <200705080815.l488F3gb019028@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934640AbXEHIP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 04:15:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, efault@gmx.de, mm-commits@vger.kernel.org


The patch titled
     readahead: call scheme
has been removed from the -mm tree.  Its filename was
     readahead-call-scheme.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: readahead: call scheme
From: Wu Fengguang <wfg@mail.ustc.edu.cn>

The read-ahead logic is called when the reading hits
        - a PG_readahead marked page;
        - a non-present page.

ra.prev_page should be properly setup on entrance, and readahead_cache_hit()
should be called on every page reference as a feedback.

This call scheme achieves the following goals:
        - makes all stateful/stateless methods happy;
        - eliminates the cache hit problem naturally;
        - lives in harmony with application managed read-aheads via
          fadvise/madvise.

[efault@gmx.de: fix leak encountered with rpm -qaV]
[akpm@osdl.org: build fixes]
Signed-off-by: Wu Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   30 +++++++++
 mm/filemap.c       |   43 +++++++++++--
 mm/readahead.c     |  141 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 209 insertions(+), 5 deletions(-)

diff -puN include/linux/mm.h~readahead-call-scheme include/linux/mm.h
--- a/include/linux/mm.h~readahead-call-scheme
+++ a/include/linux/mm.h
@@ -1170,6 +1170,36 @@ void handle_ra_miss(struct address_space
 unsigned long max_sane_readahead(unsigned long nr);
 
 #ifdef CONFIG_ADAPTIVE_READAHEAD
+unsigned long
+page_cache_readahead_adaptive(struct address_space *mapping,
+				struct file_ra_state *ra,
+				struct file *filp,
+				struct page *page,
+				pgoff_t offset,
+				unsigned long size);
+#else
+static inline unsigned long
+page_cache_readahead_adaptive(struct address_space *mapping,
+				struct file_ra_state *ra,
+				struct file *filp,
+				struct page *page,
+				pgoff_t offset,
+				unsigned long size)
+{
+	return page_cache_readahead(mapping, ra, filp, offset, size);
+}
+#endif
+
+#if defined(CONFIG_DEBUG_READAHEAD)
+void readahead_cache_hit(struct file_ra_state *ra, struct page *page);
+#else
+static inline void readahead_cache_hit(struct file_ra_state *ra,
+					struct page *page)
+{
+}
+#endif
+
+#ifdef CONFIG_ADAPTIVE_READAHEAD
 extern int readahead_ratio;
 #else
 #define readahead_ratio 1
diff -puN mm/filemap.c~readahead-call-scheme mm/filemap.c
--- a/mm/filemap.c~readahead-call-scheme
+++ a/mm/filemap.c
@@ -928,16 +928,33 @@ void do_generic_mapping_read(struct addr
 		nr = nr - offset;
 
 		cond_resched();
-		if (index == next_index)
+
+		if (!prefer_adaptive_readahead() && index == next_index)
 			next_index = page_cache_readahead(mapping, &ra, filp,
 					index, last_index - index);
 
 find_page:
 		page = find_get_page(mapping, index);
+		if (prefer_adaptive_readahead()) {
+			if (unlikely(page == NULL)) {
+				ra.prev_index = prev_index;
+				page_cache_readahead_adaptive(mapping,
+						&ra, filp, NULL,
+						index, last_index - index);
+				page = find_get_page(mapping, index);
+			} else if (PageReadahead(page)) {
+				ra.prev_index = prev_index;
+				page_cache_readahead_adaptive(mapping,
+						&ra, filp, page,
+						index, last_index - index);
+			}
+		}
 		if (unlikely(page == NULL)) {
-			handle_ra_miss(mapping, &ra, index);
+			if (!prefer_adaptive_readahead())
+				handle_ra_miss(mapping, &ra, index);
 			goto no_cached_page;
 		}
+		readahead_cache_hit(&ra, page);
 		if (!PageUptodate(page))
 			goto page_not_up_to_date;
 page_ok:
@@ -1087,6 +1104,8 @@ no_cached_page:
 
 out:
 	*_ra = ra;
+	if (prefer_adaptive_readahead())
+		_ra->prev_index = prev_index;
 
 	*ppos = ((loff_t) index << PAGE_CACHE_SHIFT) + offset;
 	if (cached_page)
@@ -1376,8 +1395,8 @@ struct page *filemap_fault(struct vm_are
 	unsigned long size;
 	int did_readaround = 0;
 
+	ra->flags |= RA_FLAG_MMAP;
 	fdata->type = VM_FAULT_MINOR;
-
 	BUG_ON(!(vma->vm_flags & VM_CAN_INVALIDATE));
 
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
@@ -1394,7 +1413,7 @@ struct page *filemap_fault(struct vm_are
 	 *
 	 * For sequential accesses, we use the generic readahead logic.
 	 */
-	if (VM_SequentialReadHint(vma))
+	if (!prefer_adaptive_readahead() && VM_SequentialReadHint(vma))
 		page_cache_readahead(mapping, ra, file, fdata->pgoff, 1);
 
 	/*
@@ -1402,11 +1421,22 @@ struct page *filemap_fault(struct vm_are
 	 */
 retry_find:
 	page = find_lock_page(mapping, fdata->pgoff);
+	if (prefer_adaptive_readahead() && VM_SequentialReadHint(vma)) {
+		if (!page) {
+			page_cache_readahead_adaptive(mapping, ra, file, NULL,
+							fdata->pgoff, 1);
+			page = find_lock_page(mapping, fdata->pgoff);
+		} else if (PageReadahead(page)) {
+			page_cache_readahead_adaptive(mapping, ra, file, page,
+							fdata->pgoff, 1);
+		}
+	}
 	if (!page) {
 		unsigned long ra_pages;
 
 		if (VM_SequentialReadHint(vma)) {
-			handle_ra_miss(mapping, ra, fdata->pgoff);
+			if (!prefer_adaptive_readahead())
+				handle_ra_miss(mapping, ra, fdata->pgoff);
 			goto no_cached_page;
 		}
 		ra->mmap_miss++;
@@ -1442,6 +1472,7 @@ retry_find:
 
 	if (!did_readaround)
 		ra->mmap_hit++;
+	readahead_cache_hit(ra, page);
 
 	/*
 	 * We have a locked page in the page cache, now we need to check
@@ -1461,6 +1492,8 @@ retry_find:
 	 * Found the page and have a reference on it.
 	 */
 	mark_page_accessed(page);
+	if (prefer_adaptive_readahead())
+		ra->prev_index = page->index;
 	return page;
 
 outside_data_content:
diff -puN mm/readahead.c~readahead-call-scheme mm/readahead.c
--- a/mm/readahead.c~readahead-call-scheme
+++ a/mm/readahead.c
@@ -1582,8 +1582,149 @@ thrashing_recovery_readahead(struct addr
 	return ra_submit(ra, mapping, filp);
 }
 
+/**
+ * page_cache_readahead_adaptive - thrashing safe adaptive read-ahead
+ * @mapping, @ra, @filp, @offset, @req_size: the same as page_cache_readahead()
+ * @page: the page at @offset, or NULL if non-present
+ *
+ * page_cache_readahead_adaptive() is the entry point of the adaptive
+ * read-ahead logic. It tries a set of methods in turn to determine the
+ * appropriate readahead action and submits the readahead I/O.
+ *
+ * This function is expected to be called on two conditions:
+ * 1. @page == NULL
+ *    A cache miss happened, some pages have to be read in
+ * 2. @page != NULL && PageReadahead(@page)
+ *    A look-ahead mark encountered, this is set by a previous read-ahead
+ *    invocation to instruct the caller to give the function a chance to
+ *    check up and do next read-ahead in advance.
+ */
+unsigned long
+page_cache_readahead_adaptive(struct address_space *mapping,
+				struct file_ra_state *ra, struct file *filp,
+				struct page *page,
+				pgoff_t offset, unsigned long req_size)
+{
+	unsigned long ra_size;
+	unsigned long ra_max;
+	int ret;
+
+	if (page) {
+		ClearPageReadahead(page);
+
+		/*
+		 * Defer read-ahead on IO congestion.
+		 */
+		if (bdi_read_congested(mapping->backing_dev_info)) {
+			ra_account(ra, RA_EVENT_IO_CONGESTION, req_size);
+			return 0;
+		}
+	}
+
+	if (page)
+		ra_account(ra, RA_EVENT_LOOKAHEAD_HIT, ra_lookahead_size(ra));
+	else if (offset)
+		ra_account(ra, RA_EVENT_CACHE_MISS, req_size);
+
+	ra_max = get_max_readahead(ra);
+
+	/* read-ahead disabled? */
+	if (unlikely(!ra_max || !readahead_ratio)) {
+		ra_size = max_sane_readahead(req_size);
+		goto readit;
+	}
+
+	/*
+	 * Start of file.
+	 */
+	if (offset == 0)
+		return initial_readahead(mapping, filp, ra, req_size);
+
+	/*
+	 * State based sequential read-ahead.
+	 */
+	if (offset == ra->prev_index + 1 &&
+	    offset == ra->lookahead_index &&
+					!debug_option(disable_stateful_method))
+		return state_based_readahead(mapping, filp, ra, page,
+						offset, req_size, ra_max);
+
+	/*
+	 * Recover from possible thrashing.
+	 */
+	if (!page && offset - ra->prev_index <= 1 && ra_has_index(ra, offset))
+		return thrashing_recovery_readahead(mapping, filp, ra,
+								offset, ra_max);
+
+	/*
+	 * Backward read-ahead.
+	 */
+	if (!page && try_backward_prefetching(ra, offset, req_size, ra_max))
+		return ra_submit(ra, mapping, filp);
+
+	/*
+	 * Context based sequential read-ahead.
+	 */
+	ret = try_context_based_readahead(mapping, ra, page,
+						offset, req_size, ra_max);
+	if (ret > 0)
+		return ra_submit(ra, mapping, filp);
+	if (ret < 0)
+		return 0;
+
+	/* No action on look-ahead time? */
+	if (page) {
+		ra_account(ra, RA_EVENT_LOOKAHEAD_NOACTION,
+						ra->readahead_index - offset);
+		return 0;
+	}
+
+	/*
+	 * Random read.
+	 */
+	ra_size = min(req_size, ra_max);
+readit:
+	ra_size = __do_page_cache_readahead(mapping, filp, offset, ra_size, 0);
+
+	ra_account(ra, RA_EVENT_RANDOM_READ, ra_size);
+	dprintk("random_read(ino=%lu, req=%lu+%lu) = %lu\n",
+		mapping->host->i_ino, offset, req_size, ra_size);
+
+	return ra_size;
+}
+EXPORT_SYMBOL_GPL(page_cache_readahead_adaptive);
 #endif /* CONFIG_ADAPTIVE_READAHEAD */
 
+#ifdef CONFIG_DEBUG_READAHEAD
+/**
+ * readahead_cache_hit - adaptive read-ahead feedback function
+ * @ra: file_ra_state which holds the readahead state
+ * @page: the page just accessed
+ *
+ * This is the optional feedback route of the adaptive read-ahead logic.
+ * It must be called on every access on the read-ahead pages.
+ */
+void readahead_cache_hit(struct file_ra_state *ra, struct page *page)
+{
+	if (!prefer_adaptive_readahead())
+		return;
+
+	if (PageActive(page) || PageReferenced(page))
+		return;
+
+	if (!PageUptodate(page))
+		ra_account(ra, RA_EVENT_IO_BLOCK, 1);
+
+	if (!ra_has_index(ra, page->index))
+		return;
+
+	if (page->index >= ra->ra_index)
+		ra_account(ra, RA_EVENT_READAHEAD_HIT, 1);
+	else
+		ra_account(ra, RA_EVENT_READAHEAD_HIT, -1);
+}
+#endif /* CONFIG_DEBUG_READAHEAD */
+
 /*
  * Read-ahead events accounting.
  */
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
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
