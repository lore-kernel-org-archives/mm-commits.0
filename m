Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97DC9C2D0E0
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 571C621789
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599953073;
	bh=xbt0CRSbsomurf8X9Ql05z0xSSfQG6Wm46fbjcR2Q/M=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Tm84NgRI5b2TIfLPnefvgSNiwl8wnnNHccJNK9bcu19O/73N4QsydRiDRm8igTuke
	 KNDkGDtN8KqE+7rlMlclyMkS58TXaTw3UvtiyuFo+j3lk2Q1u1gR4l8vXELw3L4ezg
	 PJ2V0cAGjHfDR/pX7klwCMzG3QCDv79Wen6eHYB4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgILXYc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 19:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgILXY2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 19:24:28 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA87821789;
        Sat, 12 Sep 2020 23:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599953067;
        bh=xbt0CRSbsomurf8X9Ql05z0xSSfQG6Wm46fbjcR2Q/M=;
        h=Date:From:To:Subject:From;
        b=uYWrWS1h45/abGl4OLRxbee8ti4CzyqBujc3MjXj6NLcy6e/z5yF7/4+aZmGMj7Nc
         Nz9B3Y9SIWJYeurrWp/fZD6aRZmc3cmdg549THJTRB6PtpTUGWfOgq19rdUkcysi8U
         J+utEStF+zDTjLZ5WjziuytIxFlU9JH9VZRw0z5w=
Date:   Sat, 12 Sep 2020 16:24:26 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        william.kucharski@oracle.com, matthew.auld@intel.com,
        jani.nikula@linux.intel.com, hughd@google.com, hannes@cmpxchg.org,
        chris@chris-wilson.co.uk, adobriyan@gmail.com, willy@infradead.org
Subject:  + mm-shmem-return-head-page-from-find_lock_entry.patch
 added to -mm tree
Message-ID: <20200912232426.P61W3%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: return head page from find_lock_entry
has been added to the -mm tree.  Its filename is
     mm-shmem-return-head-page-from-find_lock_entry.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-shmem-return-head-page-from-find_lock_entry.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-shmem-return-head-page-from-find_lock_entry.patch

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
Subject: mm/shmem: return head page from find_lock_entry

Convert shmem_getpage_gfp() (the only remaining caller of
find_lock_entry()) to cope with a head page being returned instead of
the subpage for the index.

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
 mm/shmem.c              |   20 +++++++++-----------
 3 files changed, 29 insertions(+), 25 deletions(-)

--- a/include/linux/pagemap.h~mm-shmem-return-head-page-from-find_lock_entry
+++ a/include/linux/pagemap.h
@@ -371,6 +371,15 @@ static inline struct page *grab_cache_pa
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
@@ -1594,37 +1594,34 @@ out:
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
@@ -1803,7 +1803,7 @@ static int shmem_getpage_gfp(struct inod
 	struct mm_struct *charge_mm;
 	struct page *page;
 	enum sgp_type sgp_huge = sgp;
-	pgoff_t hindex = index;
+	pgoff_t hindex;
 	int error;
 	int once = 0;
 	int alloced = 0;
@@ -1843,10 +1843,8 @@ repeat:
 		put_page(page);
 		page = NULL;
 	}
-	if (page || sgp == SGP_READ) {
-		*pagep = page;
-		return 0;
-	}
+	if (page || sgp == SGP_READ)
+		goto out;
 
 	/*
 	 * Fast cache lookup did not find it:
@@ -1971,14 +1969,13 @@ clear:
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
@@ -1994,7 +1991,8 @@ clear:
 		error = -EINVAL;
 		goto unlock;
 	}
-	*pagep = page + index - hindex;
+out:
+	*pagep = page + index - page->index;
 	return 0;
 
 	/*
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

