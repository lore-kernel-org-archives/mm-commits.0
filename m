Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D51C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5207321D6C
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599953062;
	bh=wlQqfycMybmH8R6S4AB/wtHfvBwJZA8PS/Trjl1ZOtU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Ju6TWT7vZUIUOVNMMjG2zfGEFprtQa1m6Nbp8OiCtqhj+ssOtzieuz/VTyqFqzzJJ
	 UZDCJ+ojP0UOa1LDPuOjb1yrEu6Sywtej8F9YaZtxmH1UYojxh4YQZwKmrgmZR248I
	 4zmcEVLvFuHmyMhJzWtOcxS8pVJJSFZDxS7eYq7o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgILXYW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 19:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgILXYS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 19:24:18 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8F8A21789;
        Sat, 12 Sep 2020 23:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599953057;
        bh=wlQqfycMybmH8R6S4AB/wtHfvBwJZA8PS/Trjl1ZOtU=;
        h=Date:From:To:Subject:From;
        b=BTk2Mz2FZrRobUz3FOa+5rusWwZDyMcDddqGZ4z+hNCwl/3mHqHPf1CAWpAXTkxwa
         btzH478C9P5Gloqu468uL+nByVp2AvrCwqfjcOsJK0jekmCd4fHwBXoLUSjWLHzdoi
         ipq4K069wo/+TSoSftlr6YINhSupPnwILDyMT9kw=
Date:   Sat, 12 Sep 2020 16:24:17 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        william.kucharski@oracle.com, matthew.auld@intel.com,
        jani.nikula@linux.intel.com, hughd@google.com, hannes@cmpxchg.org,
        chris@chris-wilson.co.uk, adobriyan@gmail.com, willy@infradead.org
Subject:  + mm-optimise-madvise-willneed.patch added to -mm tree
Message-ID: <20200912232417.8JI_-%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: optimise madvise WILLNEED
has been added to the -mm tree.  Its filename is
     mm-optimise-madvise-willneed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-optimise-madvise-willneed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-optimise-madvise-willneed.patch

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
Subject: mm: optimise madvise WILLNEED

Instead of calling find_get_entry() for every page index, use an XArray
iterator to skip over NULL entries, and avoid calling get_page(),
because we only want the swap entries.

Link: https://lkml.kernel.org/r/20200910183318.20139-4-willy@infradead.org
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

 mm/madvise.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/mm/madvise.c~mm-optimise-madvise-willneed
+++ a/mm/madvise.c
@@ -224,25 +224,28 @@ static void force_shm_swapin_readahead(s
 		unsigned long start, unsigned long end,
 		struct address_space *mapping)
 {
-	pgoff_t index;
+	XA_STATE(xas, &mapping->i_pages, linear_page_index(vma, start));
+	pgoff_t end_index = end / PAGE_SIZE;
 	struct page *page;
-	swp_entry_t swap;
 
-	for (; start < end; start += PAGE_SIZE) {
-		index = ((start - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
+	rcu_read_lock();
+	xas_for_each(&xas, page, end_index) {
+		swp_entry_t swap;
 
-		page = find_get_entry(mapping, index);
-		if (!xa_is_value(page)) {
-			if (page)
-				put_page(page);
+		if (!xa_is_value(page))
 			continue;
-		}
+		rcu_read_unlock();
+
 		swap = radix_to_swp_entry(page);
 		page = read_swap_cache_async(swap, GFP_HIGHUSER_MOVABLE,
 							NULL, 0, false);
 		if (page)
 			put_page(page);
+
+		rcu_read_lock();
+		xas_reset(&xas);
 	}
+	rcu_read_unlock();
 
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 }
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

