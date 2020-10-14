Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADB15C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DA522224E
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709133;
	bh=ghopP/8gMrm1R/CmkdHiD28qoM3CQxbxVLFdyUkeDPc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=f88KcyagfNEoQ1qyaY8ncYTgeeaH0x1o4lOL52LbJ1wQNpQfTJ2mKdu4MDzSo9Z7s
	 bMOWVS/5ljQ1T9MFD/Yx8QNeE6og9XzjwsqBmHZ6FElUoXVDbzxvF7js0UZnokuSMy
	 E4VneDil6ngXRzHS5x4N/QjQe0wK+KrYvRcCjCBs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389211AbgJNU6x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:58:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388163AbgJNU6w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:58:52 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A26820725;
        Wed, 14 Oct 2020 20:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709130;
        bh=ghopP/8gMrm1R/CmkdHiD28qoM3CQxbxVLFdyUkeDPc=;
        h=Date:From:To:Subject:From;
        b=eLCkCj57zlQGwb1tDiLWjnN5NLbJulwhEx+l9dzonjgFFQnYx/qyWKg32SnasfyCl
         R5N8pG/VS3EQrMq7Rx5IAXdkGTKduCAlzRhwG8qJk9jeJX/ff1N8ufUuGc/R/yAVgJ
         9Jee9Hvnynq3187x/XI5dXF3WkDsgNzYGO4MoCik=
Date:   Wed, 14 Oct 2020 13:58:48 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, chris@chris-wilson.co.uk, hannes@cmpxchg.org,
        hughd@google.com, jani.nikula@linux.intel.com,
        matthew.auld@intel.com, mm-commits@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org,
        ying.huang@intel.com
Subject:  [merged] mm-use-find_get_incore_page-in-memcontrol.patch
 removed from -mm tree
Message-ID: <20201014205848.nDeoOrB9m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use find_get_incore_page in memcontrol
has been removed from the -mm tree.  Its filename was
     mm-use-find_get_incore_page-in-memcontrol.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use find_get_incore_page in memcontrol

The current code does not protect against swapoff of the underlying
swap device, so this is a bug fix as well as a worthwhile reduction in
code complexity.

Link: https://lkml.kernel.org/r/20200910183318.20139-3-willy@infradead.org
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

 mm/memcontrol.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

--- a/mm/memcontrol.c~mm-use-find_get_incore_page-in-memcontrol
+++ a/mm/memcontrol.c
@@ -5539,35 +5539,15 @@ static struct page *mc_handle_swap_pte(s
 static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
 			unsigned long addr, pte_t ptent, swp_entry_t *entry)
 {
-	struct page *page = NULL;
-	struct address_space *mapping;
-	pgoff_t pgoff;
-
 	if (!vma->vm_file) /* anonymous vma */
 		return NULL;
 	if (!(mc.flags & MOVE_FILE))
 		return NULL;
 
-	mapping = vma->vm_file->f_mapping;
-	pgoff = linear_page_index(vma, addr);
-
 	/* page is moved even if it's not RSS of this task(page-faulted). */
-#ifdef CONFIG_SWAP
 	/* shmem/tmpfs may report page out on swap: account for that too. */
-	if (shmem_mapping(mapping)) {
-		page = find_get_entry(mapping, pgoff);
-		if (xa_is_value(page)) {
-			swp_entry_t swp = radix_to_swp_entry(page);
-			*entry = swp;
-			page = find_get_page(swap_address_space(swp),
-					     swp_offset(swp));
-		}
-	} else
-		page = find_get_page(mapping, pgoff);
-#else
-	page = find_get_page(mapping, pgoff);
-#endif
-	return page;
+	return find_get_incore_page(vma->vm_file->f_mapping,
+			linear_page_index(vma, addr));
 }
 
 /**
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

