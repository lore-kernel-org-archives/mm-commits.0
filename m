Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890B3C4363A
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4830222248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709315;
	bh=NfnLC0uirrJ5J5Lt7pkKRhCUymtrFgh/j3n6+/jWpRc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=DLYi1mNj1cMobf627SX+BZ0FoQbyKmTgpZAuRAGeOPBx8LqRBoFnuJ0jmH90S8Jq4
	 typkXFSB0WTwzZKrd+gB32uWjFUJuV4qneEcK7rU5ijK4vbZcWBVTzlZxoFFtlRFHv
	 i/XURd8rpve1J/VaMiCtXIGlspbITH8T7peOD92c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730487AbgJNVBe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728959AbgJNVBe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:34 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EBF622248;
        Wed, 14 Oct 2020 21:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709271;
        bh=NfnLC0uirrJ5J5Lt7pkKRhCUymtrFgh/j3n6+/jWpRc=;
        h=Date:From:To:Subject:From;
        b=ffvEAGiREE2vXAmdrdTeAVU7sBuQR3B9Y1Sh+zi8Z1WC9VssPHJMzSHN2HEVxChyj
         DSKwJxT3LCajgW2QEytn/0AXX4gUsX2tZLnkJ+0X6nHrMX/Olsc2bwB1qW7PtzT1hi
         pYgNH4wK2M+Z8Y3AzOfycxB+ilFJMsPI5+IHPmHY=
Date:   Wed, 14 Oct 2020 14:01:11 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-simplify-pagedoublemap-with-pf_second-policy.patch removed from -mm tree
Message-ID: <20201014210111.xrNSH8XON%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify PageDoubleMap with PF_SECOND policy
has been removed from the -mm tree.  Its filename was
     mm-simplify-pagedoublemap-with-pf_second-policy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: simplify PageDoubleMap with PF_SECOND policy

Introduce the new page policy of PF_SECOND which lets us use the normal
pageflags generation machinery to create the various DoubleMap
manipulation functions.

Link: https://lkml.kernel.org/r/20200629151933.15671-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   40 ++++++++---------------------------
 1 file changed, 10 insertions(+), 30 deletions(-)

--- a/include/linux/page-flags.h~mm-simplify-pagedoublemap-with-pf_second-policy
+++ a/include/linux/page-flags.h
@@ -235,6 +235,9 @@ static inline void page_init_poison(stru
  *
  * PF_NO_COMPOUND:
  *     the page flag is not relevant for compound pages.
+ *
+ * PF_SECOND:
+ *     the page flag is stored in the first tail page.
  */
 #define PF_POISONED_CHECK(page) ({					\
 		VM_BUG_ON_PGFLAGS(PagePoisoned(page), page);		\
@@ -250,6 +253,9 @@ static inline void page_init_poison(stru
 #define PF_NO_COMPOUND(page, enforce) ({				\
 		VM_BUG_ON_PGFLAGS(enforce && PageCompound(page), page);	\
 		PF_POISONED_CHECK(page); })
+#define PF_SECOND(page, enforce) ({					\
+		VM_BUG_ON_PGFLAGS(!PageHead(page), page);		\
+		PF_POISONED_CHECK(&page[1]); })
 
 /*
  * Macros to create function definitions for page flags
@@ -688,42 +694,15 @@ static inline int PageTransTail(struct p
  *
  * See also __split_huge_pmd_locked() and page_remove_anon_compound_rmap().
  */
-static inline int PageDoubleMap(struct page *page)
-{
-	return PageHead(page) && test_bit(PG_double_map, &page[1].flags);
-}
-
-static inline void SetPageDoubleMap(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	set_bit(PG_double_map, &page[1].flags);
-}
-
-static inline void ClearPageDoubleMap(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	clear_bit(PG_double_map, &page[1].flags);
-}
-static inline int TestSetPageDoubleMap(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	return test_and_set_bit(PG_double_map, &page[1].flags);
-}
-
-static inline int TestClearPageDoubleMap(struct page *page)
-{
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	return test_and_clear_bit(PG_double_map, &page[1].flags);
-}
-
+PAGEFLAG(DoubleMap, double_map, PF_SECOND)
+	TESTSCFLAG(DoubleMap, double_map, PF_SECOND)
 #else
 TESTPAGEFLAG_FALSE(TransHuge)
 TESTPAGEFLAG_FALSE(TransCompound)
 TESTPAGEFLAG_FALSE(TransCompoundMap)
 TESTPAGEFLAG_FALSE(TransTail)
 PAGEFLAG_FALSE(DoubleMap)
-	TESTSETFLAG_FALSE(DoubleMap)
-	TESTCLEARFLAG_FALSE(DoubleMap)
+	TESTSCFLAG_FALSE(DoubleMap)
 #endif
 
 /*
@@ -888,6 +867,7 @@ static inline int page_has_private(struc
 #undef PF_ONLY_HEAD
 #undef PF_NO_TAIL
 #undef PF_NO_COMPOUND
+#undef PF_SECOND
 #endif /* !__GENERATING_BOUNDS_H */
 
 #endif	/* PAGE_FLAGS_H */
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

