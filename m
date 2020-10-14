Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5684CC43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A76A2224D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709151;
	bh=xUVfmCoTah064NtUKwfAovma0xbYyCAdxGJHYUWr/30=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=UU98aMoy3h+88DmL8qhIIN8XFxxVPNF65Qk5QIcgl5eKb/toycUEFAVb+g7JhMq4y
	 sSg/wSXwiDp0iN+8HBjX15uTYfP0IugLGffWU0axfmzRpvR2fKYsvh6ibxCktqyM6u
	 zfNt5Vzj5IpVJ01/PbO8rTpp/cABYumtkE79DsMg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388163AbgJNU7K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389499AbgJNU7K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFE8F20725;
        Wed, 14 Oct 2020 20:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709149;
        bh=xUVfmCoTah064NtUKwfAovma0xbYyCAdxGJHYUWr/30=;
        h=Date:From:To:Subject:From;
        b=zTl8WONBo5kFMklTlhgY5sbReex0JWgBij3NcyU2+KD1XQKELTk7wwNr+uifN0Jcr
         1SRjew4G9tDWRFSN4zE4ySUeLh6ZkdTVmGWtqNPLsBtljE1YdbVlhICeZFr5xqn9As
         9y0fWv/8ao/ujfG/TQc91PyTTUYSR7mcoaCqochM=
Date:   Wed, 14 Oct 2020 13:59:08 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, chris@chris-wilson.co.uk, hannes@cmpxchg.org,
        hughd@google.com, jani.nikula@linux.intel.com,
        matthew.auld@intel.com, mm-commits@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org,
        ying.huang@intel.com
Subject:  [merged]
 mm-shmem-return-head-page-from-find_lock_entry.patch removed from -mm tree
Message-ID: <20201014205908.QMChbppQb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: return head page from find_lock_entry
has been removed from the -mm tree.  Its filename was
     mm-shmem-return-head-page-from-find_lock_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/shmem: return head page from find_lock_entry

Convert shmem_getpage_gfp() (the only remaining caller of
find_lock_entry()) to cope with a head page being returned instead of
the subpage for the index.

[willy@infradead.org: fix BUG()s]
  Link https://lore.kernel.org/linux-mm/20200912032042.GA6583@casper.infradead.org/
Link: https://lkml.kernel.org/r/20200910183318.20139-8-willy@infradead.org
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

 include/linux/pagemap.h |    9 +++++++++
 mm/filemap.c            |   25 +++++++++++--------------
 mm/shmem.c              |   19 ++++++++++---------
 3 files changed, 30 insertions(+), 23 deletions(-)

--- a/include/linux/pagemap.h~mm-shmem-return-head-page-from-find_lock_entry
+++ a/include/linux/pagemap.h
@@ -372,6 +372,15 @@ static inline struct page *grab_cache_pa
 			mapping_gfp_mask(mapping));
 }
 
+/* Does this page contain this index? */
+static inline bool thp_contains(struct page *head, pgoff_t index)
+{
+	/* HugeTLBfs indexes the page cache in units of hpage_size */
+	if (PageHuge(head))
+		return head->index == index;
+	return page_index(head) == (index & ~(thp_nr_pages(head) - 1UL));
+}
+
 /*
  * Given the page we found in the page cache, return the page corresponding
  * to this index in the file
--- a/mm/filemap.c~mm-shmem-return-head-page-from-find_lock_entry
+++ a/mm/filemap.c
@@ -1692,37 +1692,34 @@ out:
 }
 
 /**
- * find_lock_entry - locate, pin and lock a page cache entry
- * @mapping: the address_space to search
- * @offset: the page cache index
+ * find_lock_entry - Locate and lock a page cache entry.
+ * @mapping: The address_space to search.
+ * @index: The page cache index.
  *
- * Looks up the page cache slot at @mapping & @offset.  If there is a
- * page cache page, it is returned locked and with an increased
- * refcount.
+ * Looks up the page at @mapping & @index.  If there is a page in the
+ * cache, the head page is returned locked and with an increased refcount.
  *
  * If the slot holds a shadow entry of a previously evicted page, or a
  * swap entry from shmem/tmpfs, it is returned.
  *
- * find_lock_entry() may sleep.
- *
- * Return: the found page or shadow entry, %NULL if nothing is found.
+ * Context: May sleep.
+ * Return: The head page or shadow entry, %NULL if nothing is found.
  */
-struct page *find_lock_entry(struct address_space *mapping, pgoff_t offset)
+struct page *find_lock_entry(struct address_space *mapping, pgoff_t index)
 {
 	struct page *page;
 
 repeat:
-	page = find_get_entry(mapping, offset);
+	page = find_get_entry(mapping, index);
 	if (page && !xa_is_value(page)) {
 		lock_page(page);
 		/* Has the page been truncated? */
-		if (unlikely(page_mapping(page) != mapping)) {
+		if (unlikely(page->mapping != mapping)) {
 			unlock_page(page);
 			put_page(page);
 			goto repeat;
 		}
-		page = find_subpage(page, offset);
-		VM_BUG_ON_PAGE(page_to_pgoff(page) != offset, page);
+		VM_BUG_ON_PAGE(!thp_contains(page, index), page);
 	}
 	return page;
 }
--- a/mm/shmem.c~mm-shmem-return-head-page-from-find_lock_entry
+++ a/mm/shmem.c
@@ -1830,6 +1830,8 @@ repeat:
 		return error;
 	}
 
+	if (page)
+		hindex = page->index;
 	if (page && sgp == SGP_WRITE)
 		mark_page_accessed(page);
 
@@ -1840,11 +1842,10 @@ repeat:
 		unlock_page(page);
 		put_page(page);
 		page = NULL;
+		hindex = index;
 	}
-	if (page || sgp == SGP_READ) {
-		*pagep = page;
-		return 0;
-	}
+	if (page || sgp == SGP_READ)
+		goto out;
 
 	/*
 	 * Fast cache lookup did not find it:
@@ -1969,14 +1970,13 @@ clear:
 	 * it now, lest undo on failure cancel our earlier guarantee.
 	 */
 	if (sgp != SGP_WRITE && !PageUptodate(page)) {
-		struct page *head = compound_head(page);
 		int i;
 
-		for (i = 0; i < compound_nr(head); i++) {
-			clear_highpage(head + i);
-			flush_dcache_page(head + i);
+		for (i = 0; i < compound_nr(page); i++) {
+			clear_highpage(page + i);
+			flush_dcache_page(page + i);
 		}
-		SetPageUptodate(head);
+		SetPageUptodate(page);
 	}
 
 	/* Perhaps the file has been truncated since we checked */
@@ -1992,6 +1992,7 @@ clear:
 		error = -EINVAL;
 		goto unlock;
 	}
+out:
 	*pagep = page + index - hindex;
 	return 0;
 
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

