Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEB3C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AA6D2224D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709128;
	bh=cOluyJjlaT+Jvx6luQyArqpHZgzUko3tMXO4eDBuvxE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=zMH5t38EKJQUZ1gfyfivZyQfPe9sc1Z1GgYWlL6FbN6kj9xiFwdyI+7ZmaAlGFXQu
	 T40EoJCyZxbx85pJZsNRvieRRSSFduWO4BKQssBrkWVD9ZBVhnWzcR6UP6lXlQt5ek
	 Cr1qb8M8b3c7Tq8vxsxZRic65nOM4yyzBE5Uay30=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389141AbgJNU6s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388163AbgJNU6s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:58:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61B552068E;
        Wed, 14 Oct 2020 20:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709126;
        bh=cOluyJjlaT+Jvx6luQyArqpHZgzUko3tMXO4eDBuvxE=;
        h=Date:From:To:Subject:From;
        b=bO0lFtefserRpdNcrX+Qm5VQ6rxpqWXRkbtx0zbRnR4T4VEiHe8oeKB/Gy8rPvq45
         RrNcPnYUQtq1aiGvhS/FvQclC/F62cbI54nWwqPuTOBhByhhq81FdC2AQJH4dpFpzP
         bruYe7pP58wbDlD5sZa5xg7IXZVkTsYEKHv1cM4o=
Date:   Wed, 14 Oct 2020 13:58:44 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, chris@chris-wilson.co.uk, hannes@cmpxchg.org,
        hughd@google.com, jani.nikula@linux.intel.com,
        matthew.auld@intel.com, mm-commits@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org,
        ying.huang@intel.com
Subject:  [merged]
 mm-factor-find_get_incore_page-out-of-mincore_page.patch removed from -mm
 tree
Message-ID: <20201014205844.M8VpVXPba%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: factor find_get_incore_page out of mincore_page
has been removed from the -mm tree.  Its filename was
     mm-factor-find_get_incore_page-out-of-mincore_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: factor find_get_incore_page out of mincore_page

Patch series "Return head pages from find_*_entry", v2.

This patch series started out as part of the THP patch set, but it has
some nice effects along the way and it seems worth splitting it out and
submitting separately.

Currently find_get_entry() and find_lock_entry() return the page
corresponding to the requested index, but the first thing most callers do
is find the head page, which we just threw away.  As part of auditing all
the callers, I found some misuses of the APIs and some plain
inefficiencies that I've fixed.

The diffstat is unflattering, but I added more kernel-doc and a new wrapper.


This patch (of 8);

Provide this functionality from the swap cache.  It's useful for
more than just mincore().

Link: https://lkml.kernel.org/r/20200910183318.20139-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20200910183318.20139-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    7 +++++++
 mm/mincore.c         |   28 ++--------------------------
 mm/swap_state.c      |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+), 26 deletions(-)

--- a/include/linux/swap.h~mm-factor-find_get_incore_page-out-of-mincore_page
+++ a/include/linux/swap.h
@@ -427,6 +427,7 @@ extern void free_pages_and_swap_cache(st
 extern struct page *lookup_swap_cache(swp_entry_t entry,
 				      struct vm_area_struct *vma,
 				      unsigned long addr);
+struct page *find_get_incore_page(struct address_space *mapping, pgoff_t index);
 extern struct page *read_swap_cache_async(swp_entry_t, gfp_t,
 			struct vm_area_struct *vma, unsigned long addr,
 			bool do_poll);
@@ -570,6 +571,12 @@ static inline struct page *lookup_swap_c
 	return NULL;
 }
 
+static inline
+struct page *find_get_incore_page(struct address_space *mapping, pgoff_t index)
+{
+	return find_get_page(mapping, index);
+}
+
 static inline int add_to_swap(struct page *page)
 {
 	return 0;
--- a/mm/mincore.c~mm-factor-find_get_incore_page-out-of-mincore_page
+++ a/mm/mincore.c
@@ -48,7 +48,7 @@ static int mincore_hugetlb(pte_t *pte, u
  * and is up to date; i.e. that no page-in operation would be required
  * at this time if an application were to map and access this page.
  */
-static unsigned char mincore_page(struct address_space *mapping, pgoff_t pgoff)
+static unsigned char mincore_page(struct address_space *mapping, pgoff_t index)
 {
 	unsigned char present = 0;
 	struct page *page;
@@ -59,31 +59,7 @@ static unsigned char mincore_page(struct
 	 * any other file mapping (ie. marked !present and faulted in with
 	 * tmpfs's .fault). So swapped out tmpfs mappings are tested here.
 	 */
-#ifdef CONFIG_SWAP
-	if (shmem_mapping(mapping)) {
-		page = find_get_entry(mapping, pgoff);
-		/*
-		 * shmem/tmpfs may return swap: account for swapcache
-		 * page too.
-		 */
-		if (xa_is_value(page)) {
-			swp_entry_t swp = radix_to_swp_entry(page);
-			struct swap_info_struct *si;
-
-			/* Prevent swap device to being swapoff under us */
-			si = get_swap_device(swp);
-			if (si) {
-				page = find_get_page(swap_address_space(swp),
-						     swp_offset(swp));
-				put_swap_device(si);
-			} else
-				page = NULL;
-		}
-	} else
-		page = find_get_page(mapping, pgoff);
-#else
-	page = find_get_page(mapping, pgoff);
-#endif
+	page = find_get_incore_page(mapping, index);
 	if (page) {
 		present = PageUptodate(page);
 		put_page(page);
--- a/mm/swap_state.c~mm-factor-find_get_incore_page-out-of-mincore_page
+++ a/mm/swap_state.c
@@ -21,6 +21,7 @@
 #include <linux/vmalloc.h>
 #include <linux/swap_slots.h>
 #include <linux/huge_mm.h>
+#include <linux/shmem_fs.h>
 #include "internal.h"
 
 /*
@@ -414,6 +415,37 @@ struct page *lookup_swap_cache(swp_entry
 	return page;
 }
 
+/**
+ * find_get_incore_page - Find and get a page from the page or swap caches.
+ * @mapping: The address_space to search.
+ * @index: The page cache index.
+ *
+ * This differs from find_get_page() in that it will also look for the
+ * page in the swap cache.
+ *
+ * Return: The found page or %NULL.
+ */
+struct page *find_get_incore_page(struct address_space *mapping, pgoff_t index)
+{
+	swp_entry_t swp;
+	struct swap_info_struct *si;
+	struct page *page = find_get_entry(mapping, index);
+
+	if (!xa_is_value(page))
+		return page;
+	if (!shmem_mapping(mapping))
+		return NULL;
+
+	swp = radix_to_swp_entry(page);
+	/* Prevent swapoff from happening to us */
+	si = get_swap_device(swp);
+	if (!si)
+		return NULL;
+	page = find_get_page(swap_address_space(swp), swp_offset(swp));
+	put_swap_device(si);
+	return page;
+}
+
 struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 			struct vm_area_struct *vma, unsigned long addr,
 			bool *new_page_allocated)
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

