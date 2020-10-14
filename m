Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6D3C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 036D62224D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709154;
	bh=hRRzTvzr+X0cXmgxumOQMpfnKkICCw/zL0YsNTb1x+A=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pctaaF/bY92ztJVgy4nrx3ftSMywjNQ1pmrGBTmTGu5g5Gi7srWMkAu2/3q7AV2tp
	 s1JYSUpEWkIfRyrjoles4PYuMLRk21CtQ57t7mU6G+mH5iW7L6VdShxYJ2rRCjBtBs
	 vBTvQvxBpvMYjwaOxngi31h4M+bsooCaxrGikvTw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388503AbgJNU7N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389499AbgJNU7N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:13 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6BD82068E;
        Wed, 14 Oct 2020 20:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709152;
        bh=hRRzTvzr+X0cXmgxumOQMpfnKkICCw/zL0YsNTb1x+A=;
        h=Date:From:To:Subject:From;
        b=Uqz+8sIys4L4laJ4cgoQn/pO7ls6WGSNPaZ6y8nvkdqlF6Ia3mdO4OB81vUr3F6Wh
         89KGRRSfq2OA4xjIWo/fVIuJr5ovIRPoHzvVTMkVmuTH0fRmbo6XbeGQYbx4lWV0XU
         hCzEALl5ImagwQ253pkBMZ2M8P/zjSxz/f9NpAUE=
Date:   Wed, 14 Oct 2020 13:59:11 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, chris@chris-wilson.co.uk, hannes@cmpxchg.org,
        hughd@google.com, jani.nikula@linux.intel.com,
        matthew.auld@intel.com, mm-commits@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org,
        ying.huang@intel.com
Subject:  [merged] mm-add-find_lock_head.patch removed from -mm
 tree
Message-ID: <20201014205911.jLP0q7iF-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add find_lock_head
has been removed from the -mm tree.  Its filename was
     mm-add-find_lock_head.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add find_lock_head

Add a new FGP_HEAD flag which avoids calling find_subpage() and add a
convenience wrapper for it.

Link: https://lkml.kernel.org/r/20200910183318.20139-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   32 ++++++++++++++++++++++++++------
 mm/filemap.c            |    9 ++++++---
 2 files changed, 32 insertions(+), 9 deletions(-)

--- a/include/linux/pagemap.h~mm-add-find_lock_head
+++ a/include/linux/pagemap.h
@@ -279,6 +279,7 @@ pgoff_t page_cache_prev_miss(struct addr
 #define FGP_NOFS		0x00000010
 #define FGP_NOWAIT		0x00000020
 #define FGP_FOR_MMAP		0x00000040
+#define FGP_HEAD		0x00000080
 
 struct page *pagecache_get_page(struct address_space *mapping, pgoff_t offset,
 		int fgp_flags, gfp_t cache_gfp_mask);
@@ -310,18 +311,37 @@ static inline struct page *find_get_page
  * @mapping: the address_space to search
  * @offset: the page index
  *
- * Looks up the page cache slot at @mapping & @offset.  If there is a
+ * Looks up the page cache entry at @mapping & @offset.  If there is a
  * page cache page, it is returned locked and with an increased
  * refcount.
  *
- * Otherwise, %NULL is returned.
- *
- * find_lock_page() may sleep.
+ * Context: May sleep.
+ * Return: A struct page or %NULL if there is no page in the cache for this
+ * index.
  */
 static inline struct page *find_lock_page(struct address_space *mapping,
-					pgoff_t offset)
+					pgoff_t index)
+{
+	return pagecache_get_page(mapping, index, FGP_LOCK, 0);
+}
+
+/**
+ * find_lock_head - Locate, pin and lock a pagecache page.
+ * @mapping: The address_space to search.
+ * @offset: The page index.
+ *
+ * Looks up the page cache entry at @mapping & @offset.  If there is a
+ * page cache page, its head page is returned locked and with an increased
+ * refcount.
+ *
+ * Context: May sleep.
+ * Return: A struct page which is !PageTail, or %NULL if there is no page
+ * in the cache for this index.
+ */
+static inline struct page *find_lock_head(struct address_space *mapping,
+					pgoff_t index)
 {
-	return pagecache_get_page(mapping, offset, FGP_LOCK, 0);
+	return pagecache_get_page(mapping, index, FGP_LOCK | FGP_HEAD, 0);
 }
 
 /**
--- a/mm/filemap.c~mm-add-find_lock_head
+++ a/mm/filemap.c
@@ -1737,6 +1737,8 @@ repeat:
  *
  * * %FGP_ACCESSED - The page will be marked accessed.
  * * %FGP_LOCK - The page is returned locked.
+ * * %FGP_HEAD - If the page is present and a THP, return the head page
+ *   rather than the exact page specified by the index.
  * * %FGP_CREAT - If no page is present then a new page is allocated using
  *   @gfp_mask and added to the page cache and the VM's LRU list.
  *   The page is returned locked and with an increased refcount.
@@ -1765,7 +1767,6 @@ repeat:
 		page = NULL;
 	if (!page)
 		goto no_page;
-	page = find_subpage(page, index);
 
 	if (fgp_flags & FGP_LOCK) {
 		if (fgp_flags & FGP_NOWAIT) {
@@ -1778,12 +1779,12 @@ repeat:
 		}
 
 		/* Has the page been truncated? */
-		if (unlikely(compound_head(page)->mapping != mapping)) {
+		if (unlikely(page->mapping != mapping)) {
 			unlock_page(page);
 			put_page(page);
 			goto repeat;
 		}
-		VM_BUG_ON_PAGE(page->index != index, page);
+		VM_BUG_ON_PAGE(!thp_contains(page, index), page);
 	}
 
 	if (fgp_flags & FGP_ACCESSED)
@@ -1793,6 +1794,8 @@ repeat:
 		if (page_is_idle(page))
 			clear_page_idle(page);
 	}
+	if (!(fgp_flags & FGP_HEAD))
+		page = find_subpage(page, index);
 
 no_page:
 	if (!page && (fgp_flags & FGP_CREAT)) {
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

