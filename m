Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21549C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C67A82224D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709157;
	bh=2XgXJOKulkWHd6Tl7Qz7RiE5x75QFIf2z55fT4kLEgo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tkB1KB+khEFdDex73c8MwuNlSDIC5gUErM8Ks5HQczqh0S0UWxIWRyz+GIbz18p/5
	 r1yRzmBmsrRiWxWG/otkDuQzHzXhXvh5gBbDiTBaGDSgFFJM4H9kkTXpBoaRLUaIET
	 U3i2Mjisy7ReSDiNgA8WIjRZDCLMzSaiVZK0HXLE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389505AbgJNU7R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389499AbgJNU7R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:17 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A045C20725;
        Wed, 14 Oct 2020 20:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709154;
        bh=2XgXJOKulkWHd6Tl7Qz7RiE5x75QFIf2z55fT4kLEgo=;
        h=Date:From:To:Subject:From;
        b=hpSEwMJtKM3FuqTZO0hGjF5Bq3PpGQ7K9MRnuqveCoba0qeTkumNR7VQikSxJ3hQP
         t8fdjXMMnhPkFIkK8c4Ev+ieVxPO0/rCx7ZzbfA2BQyDDielPl9/SuITrEVYA3BNdu
         2N+rHk80+JPX6Tuxk/p4US5b4jrVdz32d83nmzA4=
Date:   Wed, 14 Oct 2020 13:59:14 -0700
From:   akpm@linux-foundation.org
To:     kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [merged] mm-filemap-fix-filemap_map_pages-for-thp.patch
 removed from -mm tree
Message-ID: <20201014205914.9e--coS7e%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: fix filemap_map_pages for THP
has been removed from the -mm tree.  Its filename was
     mm-filemap-fix-filemap_map_pages-for-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap: fix filemap_map_pages for THP

We dereference page->mapping and page->index directly after calling
find_subpage() and these fields are not valid for tail pages.  While
commit 4101196b19d7 ("mm: page cache: store only head pages in i_pages")
introduced the call to find_subpage(), the problem existed prior to this;
I'm going to suggest all the way back to when THPs first existed.

The user-visible effects of this are almost negligible.  To hit it, you
have to mmap a tmpfs file at an unaligned address and then it's only a
disabled optimisation causing page faults to happen more frequently than
they otherwise would.

Fix this by keeping both head and page pointers and checking the
appropriate one.  We could use page_mapping() and page_to_index(), but
that's higher overhead.

Link: https://lkml.kernel.org/r/20200911012532.24761-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/mm/filemap.c~mm-filemap-fix-filemap_map_pages-for-thp
+++ a/mm/filemap.c
@@ -2793,42 +2793,42 @@ void filemap_map_pages(struct vm_fault *
 	pgoff_t last_pgoff = start_pgoff;
 	unsigned long max_idx;
 	XA_STATE(xas, &mapping->i_pages, start_pgoff);
-	struct page *page;
+	struct page *head, *page;
 	unsigned int mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
 
 	rcu_read_lock();
-	xas_for_each(&xas, page, end_pgoff) {
-		if (xas_retry(&xas, page))
+	xas_for_each(&xas, head, end_pgoff) {
+		if (xas_retry(&xas, head))
 			continue;
-		if (xa_is_value(page))
+		if (xa_is_value(head))
 			goto next;
 
 		/*
 		 * Check for a locked page first, as a speculative
 		 * reference may adversely influence page migration.
 		 */
-		if (PageLocked(page))
+		if (PageLocked(head))
 			goto next;
-		if (!page_cache_get_speculative(page))
+		if (!page_cache_get_speculative(head))
 			goto next;
 
 		/* Has the page moved or been split? */
-		if (unlikely(page != xas_reload(&xas)))
+		if (unlikely(head != xas_reload(&xas)))
 			goto skip;
-		page = find_subpage(page, xas.xa_index);
+		page = find_subpage(head, xas.xa_index);
 
-		if (!PageUptodate(page) ||
+		if (!PageUptodate(head) ||
 				PageReadahead(page) ||
 				PageHWPoison(page))
 			goto skip;
-		if (!trylock_page(page))
+		if (!trylock_page(head))
 			goto skip;
 
-		if (page->mapping != mapping || !PageUptodate(page))
+		if (head->mapping != mapping || !PageUptodate(head))
 			goto unlock;
 
 		max_idx = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
-		if (page->index >= max_idx)
+		if (xas.xa_index >= max_idx)
 			goto unlock;
 
 		if (mmap_miss > 0)
@@ -2840,12 +2840,12 @@ void filemap_map_pages(struct vm_fault *
 		last_pgoff = xas.xa_index;
 		if (alloc_set_pte(vmf, page))
 			goto unlock;
-		unlock_page(page);
+		unlock_page(head);
 		goto next;
 unlock:
-		unlock_page(page);
+		unlock_page(head);
 skip:
-		put_page(page);
+		put_page(head);
 next:
 		/* Huge page is mapped? No need to proceed. */
 		if (pmd_trans_huge(*vmf->pmd))
_

Patches currently in -mm which might be from willy@infradead.org are

xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
xarray-add-xas_split-fix-2.patch
xarray-add-xas_split-fix-3patch.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size-fix.patch
mm-page_owner-change-split_page_owner-to-take-a-count.patch
mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size.patch
mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size.patch
mm-rmap-fix-assumptions-of-thp-size.patch
mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch
mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch
mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out.patch
fs-add-a-filesystem-flag-for-thps.patch
fs-do-not-update-nr_thps-for-mappings-which-support-thps.patch
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
mm-rename-page_order-to-buddy_order.patch
ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch
harden-autofs-ioctl-table.patch
mm-update-the-documentation-for-vfree.patch

