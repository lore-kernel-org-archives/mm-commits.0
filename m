Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6915C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8B4F21789
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 23:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599953073;
	bh=KKYoyjZmRRmk3B1tHSv40JfbCJUZYhP6dD4ufSkVjhA=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Fv3KtW6eezqLLswcaZQIdmaDjKP+ujKmvDFlzr6QMwt+Lf10rTOYvF0OoLE1r2vEB
	 LgwaGIRrDM8qGIz47sYNCBssH0b3KiegAAtwLPcdXm17yyggJgfmAwcBiWBAOE3RSE
	 U6f0E5xlJsHRv62Rt6H8Z0sXY5Fz8UPvkmFboqgI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgILXYc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 19:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgILXYb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 19:24:31 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A636421531;
        Sat, 12 Sep 2020 23:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599953069;
        bh=KKYoyjZmRRmk3B1tHSv40JfbCJUZYhP6dD4ufSkVjhA=;
        h=Date:From:To:Subject:From;
        b=YWjMYiAZ969pQl/4v/iRdvSRSuI1Bqdlt6X8iLCDBKQ5xdc/jEa4Lr3iV1HtgPKX1
         CiD3Ef7YXgJoteWfmfckweqm9xZl/Ke8eWNkA/+fyIrsFS4JPLntdoCh63ShFGypSl
         lpl1PZpz0zgBG+M1oIYAr80oEmmEVnACD2FS2TSM=
Date:   Sat, 12 Sep 2020 16:24:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        william.kucharski@oracle.com, matthew.auld@intel.com,
        jani.nikula@linux.intel.com, hughd@google.com, hannes@cmpxchg.org,
        chris@chris-wilson.co.uk, adobriyan@gmail.com, willy@infradead.org
Subject:  + mm-add-find_lock_head.patch added to -mm tree
Message-ID: <20200912232429.35aCc%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add find_lock_head
has been added to the -mm tree.  Its filename is
     mm-add-find_lock_head.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-find_lock_head.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-find_lock_head.patch

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
@@ -278,6 +278,7 @@ pgoff_t page_cache_prev_miss(struct addr
 #define FGP_NOFS		0x00000010
 #define FGP_NOWAIT		0x00000020
 #define FGP_FOR_MMAP		0x00000040
+#define FGP_HEAD		0x00000080
 
 struct page *pagecache_get_page(struct address_space *mapping, pgoff_t offset,
 		int fgp_flags, gfp_t cache_gfp_mask);
@@ -309,18 +310,37 @@ static inline struct page *find_get_page
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
@@ -1639,6 +1639,8 @@ repeat:
  *
  * * %FGP_ACCESSED - The page will be marked accessed.
  * * %FGP_LOCK - The page is returned locked.
+ * * %FGP_HEAD - If the page is present and a THP, return the head page
+ *   rather than the exact page specified by the index.
  * * %FGP_CREAT - If no page is present then a new page is allocated using
  *   @gfp_mask and added to the page cache and the VM's LRU list.
  *   The page is returned locked and with an increased refcount.
@@ -1667,7 +1669,6 @@ repeat:
 		page = NULL;
 	if (!page)
 		goto no_page;
-	page = find_subpage(page, index);
 
 	if (fgp_flags & FGP_LOCK) {
 		if (fgp_flags & FGP_NOWAIT) {
@@ -1680,12 +1681,12 @@ repeat:
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
@@ -1695,6 +1696,8 @@ repeat:
 		if (page_is_idle(page))
 			clear_page_idle(page);
 	}
+	if (!(fgp_flags & FGP_HEAD))
+		page = find_subpage(page, index);
 
 no_page:
 	if (!page && (fgp_flags & FGP_CREAT)) {
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

