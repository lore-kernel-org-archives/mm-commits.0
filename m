Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91082C433E2
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C9ED21531
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599937896;
	bh=BdlUvw1LkJcdXEKdRINL+1xTDe0zrq+3XFrDfpQ9G+c=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=T7i/smovtEVvyz7oR44gcNDvjGIE0w82FJnoFUxd9QV7OmQ2YZzG+dm+6nh75CmGR
	 YGwQvrBohbGuwPlxxXSrFgUpzLsla94hep5qx0MehctH46x2E6jp8+W/obwySSYjmi
	 LKNzXaTsD5G5bufLRbJKhyYyUgVSh+5ld5egpVi0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgILTLf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 15:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:32876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgILTLe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 15:11:34 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA1DC207C3;
        Sat, 12 Sep 2020 19:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599937893;
        bh=BdlUvw1LkJcdXEKdRINL+1xTDe0zrq+3XFrDfpQ9G+c=;
        h=Date:From:To:Subject:From;
        b=PNrSUWlGyBTCjx1F3dX+HOghdYAcCmKHW2vWI4nihWjwLwPj1hUEvGZbXISWXtU5c
         fI6ud+rwnmq910Fefe6IPF/8JHnoWbsh+K1FM7hvg9o+zkp2olpmtfCTW9wpky8kCh
         KcVH6Ae9VQjVgmY+J40ePuAdXeTeXvoHvivLx/8U=
Date:   Sat, 12 Sep 2020 12:11:33 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        kirill.shutemov@linux.intel.com, willy@infradead.org
Subject:  +
 mm-page_owner-change-split_page_owner-to-take-a-count.patch added to -mm tree
Message-ID: <20200912191133.2k0xr%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: change split_page_owner to take a count
has been added to the -mm tree.  Its filename is
     mm-page_owner-change-split_page_owner-to-take-a-count.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-change-split_page_owner-to-take-a-count.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-change-split_page_owner-to-take-a-count.patch

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
Subject: mm/page_owner: change split_page_owner to take a count

The implementation of split_page_owner() prefers a count rather than the
old order of the page.  When we support a variable size THP, we won't
have the order at this point, but we will have the number of pages.
So change the interface to what the caller and callee would prefer.

Link: https://lkml.kernel.org/r/20200908195539.25896-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_owner.h |    6 +++---
 mm/huge_memory.c           |    2 +-
 mm/page_owner.c            |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/page_owner.h~mm-page_owner-change-split_page_owner-to-take-a-count
+++ a/include/linux/page_owner.h
@@ -11,7 +11,7 @@ extern struct page_ext_operations page_o
 extern void __reset_page_owner(struct page *page, unsigned int order);
 extern void __set_page_owner(struct page *page,
 			unsigned int order, gfp_t gfp_mask);
-extern void __split_page_owner(struct page *page, unsigned int order);
+extern void __split_page_owner(struct page *page, unsigned int nr);
 extern void __copy_page_owner(struct page *oldpage, struct page *newpage);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
 extern void __dump_page_owner(struct page *page);
@@ -31,10 +31,10 @@ static inline void set_page_owner(struct
 		__set_page_owner(page, order, gfp_mask);
 }
 
-static inline void split_page_owner(struct page *page, unsigned int order)
+static inline void split_page_owner(struct page *page, unsigned int nr)
 {
 	if (static_branch_unlikely(&page_owner_inited))
-		__split_page_owner(page, order);
+		__split_page_owner(page, nr);
 }
 static inline void copy_page_owner(struct page *oldpage, struct page *newpage)
 {
--- a/mm/huge_memory.c~mm-page_owner-change-split_page_owner-to-take-a-count
+++ a/mm/huge_memory.c
@@ -2425,7 +2425,7 @@ static void __split_huge_page(struct pag
 
 	ClearPageCompound(head);
 
-	split_page_owner(head, HPAGE_PMD_ORDER);
+	split_page_owner(head, HPAGE_PMD_NR);
 
 	/* See comment in __split_huge_page_tail() */
 	if (PageAnon(head)) {
--- a/mm/page_owner.c~mm-page_owner-change-split_page_owner-to-take-a-count
+++ a/mm/page_owner.c
@@ -204,7 +204,7 @@ void __set_page_owner_migrate_reason(str
 	page_owner->last_migrate_reason = reason;
 }
 
-void __split_page_owner(struct page *page, unsigned int order)
+void __split_page_owner(struct page *page, unsigned int nr)
 {
 	int i;
 	struct page_ext *page_ext = lookup_page_ext(page);
@@ -213,7 +213,7 @@ void __split_page_owner(struct page *pag
 	if (unlikely(!page_ext))
 		return;
 
-	for (i = 0; i < (1 << order); i++) {
+	for (i = 0; i < nr; i++) {
 		page_owner = get_page_owner(page_ext);
 		page_owner->order = 0;
 		page_ext = page_ext_next(page_ext);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
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

