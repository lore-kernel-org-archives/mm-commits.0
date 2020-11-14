Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2437C55ABD
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7999422265
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="I+HfYh+Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgKNBp1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:45:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgKNBp1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 20:45:27 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA87222261;
        Sat, 14 Nov 2020 01:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605318326;
        bh=lKY/o8r5CEeK/tjF4RiLOQYNcPvS47vH0XOUH743biM=;
        h=Date:From:To:Subject:From;
        b=I+HfYh+Q66ruYEeidtAxue4SVrYDrAEXC32aU1hFSM6H4NjRORANVnd637IRbj8x5
         ZnsUo5Wsb2Eu7cJoXaavd35gbKqdGEpwgmTetuXnljr9XyUHZbaeCQI+ja9Jp2oO2v
         5XxWcNcXw4L9fiCb6VbO/VRwrKUjR17jfcMFRyfo=
Date:   Fri, 13 Nov 2020 17:45:25 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  + mm-filemap-add-helper-for-finding-pages.patch added to
 -mm tree
Message-ID: <20201114014525.vjLorVoIq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: add helper for finding pages
has been added to the -mm tree.  Its filename is
     mm-filemap-add-helper-for-finding-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-add-helper-for-finding-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-add-helper-for-finding-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: add helper for finding pages

There is a lot of common code in find_get_entries(),
find_get_pages_range() and find_get_pages_range_tag().  Factor out
find_get_entry() which simplifies all three functions.

Link: https://lkml.kernel.org/r/20201112212641.27837-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   98 +++++++++++++++++++++----------------------------
 1 file changed, 43 insertions(+), 55 deletions(-)

--- a/mm/filemap.c~mm-filemap-add-helper-for-finding-pages
+++ a/mm/filemap.c
@@ -1829,6 +1829,43 @@ no_page:
 }
 EXPORT_SYMBOL(pagecache_get_page);
 
+static inline struct page *find_get_entry(struct xa_state *xas, pgoff_t max,
+		xa_mark_t mark)
+{
+	struct page *page;
+
+retry:
+	if (mark == XA_PRESENT)
+		page = xas_find(xas, max);
+	else
+		page = xas_find_marked(xas, max, mark);
+
+	if (xas_retry(xas, page))
+		goto retry;
+	/*
+	 * A shadow entry of a recently evicted page, a swap
+	 * entry from shmem/tmpfs or a DAX entry.  Return it
+	 * without attempting to raise page count.
+	 */
+	if (!page || xa_is_value(page))
+		return page;
+
+	if (!page_cache_get_speculative(page))
+		goto reset;
+
+	/* Has the page moved or been split? */
+	if (unlikely(page != xas_reload(xas))) {
+		put_page(page);
+		goto reset;
+	}
+	VM_BUG_ON_PAGE(!thp_contains(page, xas->xa_index), page);
+
+	return page;
+reset:
+	xas_reset(xas);
+	goto retry;
+}
+
 /**
  * find_get_entries - gang pagecache lookup
  * @mapping:	The address_space to search
@@ -1868,42 +1905,21 @@ unsigned find_get_entries(struct address
 		return 0;
 
 	rcu_read_lock();
-	xas_for_each(&xas, page, ULONG_MAX) {
-		if (xas_retry(&xas, page))
-			continue;
-		/*
-		 * A shadow entry of a recently evicted page, a swap
-		 * entry from shmem/tmpfs or a DAX entry.  Return it
-		 * without attempting to raise page count.
-		 */
-		if (xa_is_value(page))
-			goto export;
-
-		if (!page_cache_get_speculative(page))
-			goto retry;
-
-		/* Has the page moved or been split? */
-		if (unlikely(page != xas_reload(&xas)))
-			goto put_page;
-
+	while ((page = find_get_entry(&xas, ULONG_MAX, XA_PRESENT))) {
 		/*
 		 * Terminate early on finding a THP, to allow the caller to
 		 * handle it all at once; but continue if this is hugetlbfs.
 		 */
-		if (PageTransHuge(page) && !PageHuge(page)) {
+		if (!xa_is_value(page) && PageTransHuge(page) &&
+				!PageHuge(page)) {
 			page = find_subpage(page, xas.xa_index);
 			nr_entries = ret + 1;
 		}
-export:
+
 		indices[ret] = xas.xa_index;
 		entries[ret] = page;
 		if (++ret == nr_entries)
 			break;
-		continue;
-put_page:
-		put_page(page);
-retry:
-		xas_reset(&xas);
 	}
 	rcu_read_unlock();
 	return ret;
@@ -1942,30 +1958,16 @@ unsigned find_get_pages_range(struct add
 		return 0;
 
 	rcu_read_lock();
-	xas_for_each(&xas, page, end) {
-		if (xas_retry(&xas, page))
-			continue;
+	while ((page = find_get_entry(&xas, end, XA_PRESENT))) {
 		/* Skip over shadow, swap and DAX entries */
 		if (xa_is_value(page))
 			continue;
 
-		if (!page_cache_get_speculative(page))
-			goto retry;
-
-		/* Has the page moved or been split? */
-		if (unlikely(page != xas_reload(&xas)))
-			goto put_page;
-
 		pages[ret] = find_subpage(page, xas.xa_index);
 		if (++ret == nr_pages) {
 			*start = xas.xa_index + 1;
 			goto out;
 		}
-		continue;
-put_page:
-		put_page(page);
-retry:
-		xas_reset(&xas);
 	}
 
 	/*
@@ -2065,9 +2067,7 @@ unsigned find_get_pages_range_tag(struct
 		return 0;
 
 	rcu_read_lock();
-	xas_for_each_marked(&xas, page, end, tag) {
-		if (xas_retry(&xas, page))
-			continue;
+	while ((page = find_get_entry(&xas, end, tag))) {
 		/*
 		 * Shadow entries should never be tagged, but this iteration
 		 * is lockless so there is a window for page reclaim to evict
@@ -2076,23 +2076,11 @@ unsigned find_get_pages_range_tag(struct
 		if (xa_is_value(page))
 			continue;
 
-		if (!page_cache_get_speculative(page))
-			goto retry;
-
-		/* Has the page moved or been split? */
-		if (unlikely(page != xas_reload(&xas)))
-			goto put_page;
-
 		pages[ret] = page;
 		if (++ret == nr_pages) {
 			*index = page->index + thp_nr_pages(page);
 			goto out;
 		}
-		continue;
-put_page:
-		put_page(page);
-retry:
-		xas_reset(&xas);
 	}
 
 	/*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-fix-readahead_page_batch-for-retry-entries.patch
mm-fix-madvise-willneed-performance-problem.patch
mm-page-flags-fix-comment.patch
mm-page_alloc-add-__free_pages-documentation.patch
mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-mapping_seek_hole_data.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch
mm-truncateshmem-handle-truncates-that-split-thps.patch
mm-filemap-return-only-head-pages-from-find_get_entries.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch

