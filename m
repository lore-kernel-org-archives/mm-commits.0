Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40DE0C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC82C22248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709142;
	bh=7dXtyZdZwK/86PoeD5PVW5rmS7LBz9NUQgAKUflBOXE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=MfzC7+2eY+AP6QUpBpfQXetj3jebP6yzVxdQEMrSXHkLYv16FB69u6WDL5ans7Xy0
	 uEejOkgW66OUcALoVSSGkD8q6VC8mL33HOWXGEzBtWsDEx1GDTxO9Gp/yJG5uy1+yA
	 aJSu+ZKvhMWKO+8nu3kmQRfbkl5ra6LKLPwIrcVc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389493AbgJNU7C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388163AbgJNU7C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E779120725;
        Wed, 14 Oct 2020 20:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709141;
        bh=7dXtyZdZwK/86PoeD5PVW5rmS7LBz9NUQgAKUflBOXE=;
        h=Date:From:To:Subject:From;
        b=kCRqQ/U2TGuRanP1Wf+p/8noK8l4jqFD8tKWFL6DWGURfbWGyrMVoRfSSPjaeei/z
         tyCNbT2VQOWKnbYqhLmBaSkT6F6O1G2Ft0jsTv38Fsgu7w755myyUesJgpYwXmeTq2
         V7bTc4UGmRlOyIxnK89t/pt4NqafeynlVFFwq9WI=
Date:   Wed, 14 Oct 2020 13:59:00 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, chris@chris-wilson.co.uk, hannes@cmpxchg.org,
        hughd@google.com, jani.nikula@linux.intel.com,
        matthew.auld@intel.com, mm-commits@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org,
        ying.huang@intel.com
Subject:  [merged]
 i915-use-find_lock_page-instead-of-find_lock_entry.patch removed from -mm
 tree
Message-ID: <20201014205900.5BGUAtzUs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: i915: use find_lock_page instead of find_lock_entry
has been removed from the -mm tree.  Its filename was
     i915-use-find_lock_page-instead-of-find_lock_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: i915: use find_lock_page instead of find_lock_entry

i915 does not want to see value entries.  Switch it to use
find_lock_page() instead, and remove the export of find_lock_entry().
Move find_lock_entry() and find_get_entry() to mm/internal.h to discourage
any future use.

Link: https://lkml.kernel.org/r/20200910183318.20139-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    4 ++--
 include/linux/pagemap.h                   |    2 --
 mm/filemap.c                              |    1 -
 mm/internal.h                             |    3 +++
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c~i915-use-find_lock_page-instead-of-find_lock_entry
+++ a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -258,8 +258,8 @@ shmem_writeback(struct drm_i915_gem_obje
 	for (i = 0; i < obj->base.size >> PAGE_SHIFT; i++) {
 		struct page *page;
 
-		page = find_lock_entry(mapping, i);
-		if (!page || xa_is_value(page))
+		page = find_lock_page(mapping, i);
+		if (!page)
 			continue;
 
 		if (!page_mapped(page) && clear_page_dirty_for_io(page)) {
--- a/include/linux/pagemap.h~i915-use-find_lock_page-instead-of-find_lock_entry
+++ a/include/linux/pagemap.h
@@ -385,8 +385,6 @@ static inline struct page *find_subpage(
 	return head + (index & (thp_nr_pages(head) - 1));
 }
 
-struct page *find_get_entry(struct address_space *mapping, pgoff_t offset);
-struct page *find_lock_entry(struct address_space *mapping, pgoff_t offset);
 unsigned find_get_entries(struct address_space *mapping, pgoff_t start,
 			  unsigned int nr_entries, struct page **entries,
 			  pgoff_t *indices);
--- a/mm/filemap.c~i915-use-find_lock_page-instead-of-find_lock_entry
+++ a/mm/filemap.c
@@ -1726,7 +1726,6 @@ repeat:
 	}
 	return page;
 }
-EXPORT_SYMBOL(find_lock_entry);
 
 /**
  * pagecache_get_page - Find and get a reference to a page.
--- a/mm/internal.h~i915-use-find_lock_page-instead-of-find_lock_entry
+++ a/mm/internal.h
@@ -65,6 +65,9 @@ static inline void ra_submit(struct file
 			ra->start, ra->size, ra->async_size);
 }
 
+struct page *find_get_entry(struct address_space *mapping, pgoff_t index);
+struct page *find_lock_entry(struct address_space *mapping, pgoff_t index);
+
 /**
  * page_evictable - test whether a page is evictable
  * @page: the page to test
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

