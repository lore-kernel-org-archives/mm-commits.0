Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE45CC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D1EB22248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709148;
	bh=4eWPetkf65UWX/tTXpDptJy/LE1amczZBzlAtDmoxQQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=p8TP+Wl0Gvih5YmAXwBl7EezCWznvTRvG3kN8wZJZ0MGIyJKAZAYcvcVTUmtvCw61
	 xrT4quvmP+koCPuU3uZyUWW4/xX7D7QaizVtwbmM+szDX9VKLeQuQwvhgmSB/Rm7Wj
	 uIyU+KrTOokPKTEZ5zUXzzRn+947VnfAtQnE04K8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389496AbgJNU7I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388163AbgJNU7I (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:08 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 001A62068E;
        Wed, 14 Oct 2020 20:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709145;
        bh=4eWPetkf65UWX/tTXpDptJy/LE1amczZBzlAtDmoxQQ=;
        h=Date:From:To:Subject:From;
        b=0l3ZFUMVr5wLSI78fXkTAt5ZIMIBsEPvgY0qk6GiXhwoFb9igZF2DIarIMwXaVxAL
         SqfAEz7ZrfIzrimj1tLHDWS1u/sgYUNcvtRPBCO+dUtTsABzKQL/pi6ZjK0lrdvpnr
         YykyjJOatgOPO4T8VT/p0f6xwJtUp7xGe0NGoeKw=
Date:   Wed, 14 Oct 2020 13:59:04 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, chris@chris-wilson.co.uk, hannes@cmpxchg.org,
        hughd@google.com, jani.nikula@linux.intel.com,
        matthew.auld@intel.com, mm-commits@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org,
        ying.huang@intel.com
Subject:  [merged]
 mm-convert-find_get_entry-to-return-the-head-page.patch removed from -mm
 tree
Message-ID: <20201014205904.8LgJIS_Mk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert find_get_entry to return the head page
has been removed from the -mm tree.  Its filename was
     mm-convert-find_get_entry-to-return-the-head-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert find_get_entry to return the head page

There are only four callers remaining of find_get_entry().
get_shadow_from_swap_cache() only wants to see shadow entries and doesn't
care about which page is returned.  Push the find_subpage() call into
find_lock_entry(), find_get_incore_page() and pagecache_get_page().

[willy@infradead.org: fix oops]
  Link: https://lkml.kernel.org/r/20200914112738.GM6583@casper.infradead.org
Link: https://lkml.kernel.org/r/20200910183318.20139-7-willy@infradead.org
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

 mm/filemap.c    |   13 +++++++------
 mm/swap_state.c |    4 +++-
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/mm/filemap.c~mm-convert-find_get_entry-to-return-the-head-page
+++ a/mm/filemap.c
@@ -1645,19 +1645,19 @@ EXPORT_SYMBOL(page_cache_prev_miss);
 /**
  * find_get_entry - find and get a page cache entry
  * @mapping: the address_space to search
- * @offset: the page cache index
+ * @index: The page cache index.
  *
  * Looks up the page cache slot at @mapping & @offset.  If there is a
- * page cache page, it is returned with an increased refcount.
+ * page cache page, the head page is returned with an increased refcount.
  *
  * If the slot holds a shadow entry of a previously evicted page, or a
  * swap entry from shmem/tmpfs, it is returned.
  *
- * Return: the found page or shadow entry, %NULL if nothing is found.
+ * Return: The head page or shadow entry, %NULL if nothing is found.
  */
-struct page *find_get_entry(struct address_space *mapping, pgoff_t offset)
+struct page *find_get_entry(struct address_space *mapping, pgoff_t index)
 {
-	XA_STATE(xas, &mapping->i_pages, offset);
+	XA_STATE(xas, &mapping->i_pages, index);
 	struct page *page;
 
 	rcu_read_lock();
@@ -1685,7 +1685,6 @@ repeat:
 		put_page(page);
 		goto repeat;
 	}
-	page = find_subpage(page, offset);
 out:
 	rcu_read_unlock();
 
@@ -1722,6 +1721,7 @@ repeat:
 			put_page(page);
 			goto repeat;
 		}
+		page = find_subpage(page, offset);
 		VM_BUG_ON_PAGE(page_to_pgoff(page) != offset, page);
 	}
 	return page;
@@ -1768,6 +1768,7 @@ repeat:
 		page = NULL;
 	if (!page)
 		goto no_page;
+	page = find_subpage(page, index);
 
 	if (fgp_flags & FGP_LOCK) {
 		if (fgp_flags & FGP_NOWAIT) {
--- a/mm/swap_state.c~mm-convert-find_get_entry-to-return-the-head-page
+++ a/mm/swap_state.c
@@ -431,8 +431,10 @@ struct page *find_get_incore_page(struct
 	struct swap_info_struct *si;
 	struct page *page = find_get_entry(mapping, index);
 
-	if (!xa_is_value(page))
+	if (!page)
 		return page;
+	if (!xa_is_value(page))
+		return find_subpage(page, index);
 	if (!shmem_mapping(mapping))
 		return NULL;
 
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

