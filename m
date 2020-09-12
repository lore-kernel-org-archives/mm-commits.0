Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0475AC433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B253B21531
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599954215;
	bh=qYbyxnvxN0lJa8kTZmD+mch8GHQVFhGDUibgPFOw64c=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=RGm2/0At9krAV7+lBzvFiAXQfHSeGmpuJFciNMoz9m6vEuq4MjOu+0HlU3iM/asxJ
	 gemRFceY9RgE6qCIU7PR3kPS6+NRF3prqxJQmt21RaRQasKdYwb1K08u6kKJSRZm5I
	 7DZ9LOEjtLc5GOLADY2X4uBsjaT6LN5ThVzXJODo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgILXnf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 19:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbgILXne (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 19:43:34 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEDDC20758;
        Sat, 12 Sep 2020 23:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599954214;
        bh=qYbyxnvxN0lJa8kTZmD+mch8GHQVFhGDUibgPFOw64c=;
        h=Date:From:To:Subject:From;
        b=fne5HmLe2ArHPsxIvQWkUkyfNQcu0raHOdMFe7rUS/wdqhGpVpx0ut9jHJzl5booP
         66YuZFh4zew8IJvyCL1sYUAz60h9OP7LwKCL+C2/zY1Wym5sqfwgNXIs732IwMqcch
         xV1N0YXeIU7f6rlegwymMceBUCr0LvEGsmH5MN0s=
Date:   Sat, 12 Sep 2020 16:43:33 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        kirill.shutemov@linux.intel.com, willy@infradead.org
Subject:  + mm-filemap-fix-filemap_map_pages-for-thp.patch added to
 -mm tree
Message-ID: <20200912234333.Z41LB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: fix filemap_map_pages for THP
has been added to the -mm tree.  Its filename is
     mm-filemap-fix-filemap_map_pages-for-thp.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-fix-filemap_map_pages-for-thp.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-fix-filemap_map_pages-for-thp.patch

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
@@ -2691,42 +2691,42 @@ void filemap_map_pages(struct vm_fault *
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
@@ -2738,12 +2738,12 @@ void filemap_map_pages(struct vm_fault *
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

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-factor-find_get_incore_page-out-of-mincore_page.patch
mm-use-find_get_incore_page-in-memcontrol.patch
mm-optimise-madvise-willneed.patch
proc-optimise-smaps-for-shmem-entries.patch
i915-use-find_lock_page-instead-of-find_lock_entry.patch
mm-convert-find_get_entry-to-return-the-head-page.patch
mm-shmem-return-head-page-from-find_lock_entry.patch
mm-add-find_lock_head.patch
mm-filemap-fix-filemap_map_pages-for-thp.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
xarray-add-xas_split-fix-2.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
mm-page_owner-change-split_page_owner-to-take-a-count.patch
mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size.patch
mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size.patch
mm-rmap-fix-assumptions-of-thp-size.patch
mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch
mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch
mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out.patch
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
harden-autofs-ioctl-table.patch

