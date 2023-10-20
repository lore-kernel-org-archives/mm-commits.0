Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CF7C004C0
	for <mm-commits@archiver.kernel.org>; Fri, 20 Oct 2023 23:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjJTXuu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Oct 2023 19:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbjJTXuq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Oct 2023 19:50:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857EFD6F
        for <mm-commits@vger.kernel.org>; Fri, 20 Oct 2023 16:50:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A606C433CD;
        Fri, 20 Oct 2023 23:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697845841;
        bh=L5HeR/7NwXsHeGdaWj+voHUjJU5KjPv6NzjyjqAEso4=;
        h=Date:To:From:Subject:From;
        b=2l/NrVqZnMRv5B+fnFwCW7Vkt6b3D9tQJ5D5gL3921cR6c1jOZLR1iv5s0r/a7qAw
         /dIdjJxDiDRYwfi8ou65cpYSKQRoJ6HE4rjVc4tlF+iBN6r9r2kEIOp3mIj/wEL2YS
         QPLuv008GNmsNdyUCt4u9rMFhmfG/pxsICgSON1A=
Date:   Fri, 20 Oct 2023 16:50:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        wangkefeng.wang@huawei.com, shy828301@gmail.com,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-convert-alloc_charge_hpage-to-use-folios.patch added to mm-unstable branch
Message-Id: <20231020235041.1A606C433CD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: convert alloc_charge_hpage() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-convert-alloc_charge_hpage-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-convert-alloc_charge_hpage-to-use-folios.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/khugepaged: convert alloc_charge_hpage() to use folios
Date: Fri, 20 Oct 2023 11:33:30 -0700

Also remove count_memcg_page_event now that its last caller no longer uses
it and reword hpage_collapse_alloc_page() to hpage_collapse_alloc_folio().

This removes 1 call to compound_head() and helps convert khugepaged to
use folios throughout.

Link: https://lkml.kernel.org/r/20231020183331.10770-5-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   14 --------------
 mm/khugepaged.c            |   17 ++++++++++-------
 2 files changed, 10 insertions(+), 21 deletions(-)

--- a/include/linux/memcontrol.h~mm-khugepaged-convert-alloc_charge_hpage-to-use-folios
+++ a/include/linux/memcontrol.h
@@ -1087,15 +1087,6 @@ static inline void count_memcg_events(st
 	local_irq_restore(flags);
 }
 
-static inline void count_memcg_page_event(struct page *page,
-					  enum vm_event_item idx)
-{
-	struct mem_cgroup *memcg = page_memcg(page);
-
-	if (memcg)
-		count_memcg_events(memcg, idx, 1);
-}
-
 static inline void count_memcg_folio_events(struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
@@ -1598,11 +1589,6 @@ static inline void __count_memcg_events(
 {
 }
 
-static inline void count_memcg_page_event(struct page *page,
-					  int idx)
-{
-}
-
 static inline void count_memcg_folio_events(struct folio *folio,
 		enum vm_event_item idx, unsigned long nr)
 {
--- a/mm/khugepaged.c~mm-khugepaged-convert-alloc_charge_hpage-to-use-folios
+++ a/mm/khugepaged.c
@@ -888,16 +888,16 @@ static int hpage_collapse_find_target_no
 }
 #endif
 
-static bool hpage_collapse_alloc_page(struct page **hpage, gfp_t gfp, int node,
+static bool hpage_collapse_alloc_folio(struct folio **folio, gfp_t gfp, int node,
 				      nodemask_t *nmask)
 {
-	*hpage = __alloc_pages(gfp, HPAGE_PMD_ORDER, node, nmask);
-	if (unlikely(!*hpage)) {
+	*folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, nmask);
+
+	if (unlikely(!*folio)) {
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		return false;
 	}
 
-	folio_prep_large_rmappable((struct folio *)*hpage);
 	count_vm_event(THP_COLLAPSE_ALLOC);
 	return true;
 }
@@ -1064,17 +1064,20 @@ static int alloc_charge_hpage(struct pag
 	int node = hpage_collapse_find_target_node(cc);
 	struct folio *folio;
 
-	if (!hpage_collapse_alloc_page(hpage, gfp, node, &cc->alloc_nmask))
+	if (!hpage_collapse_alloc_folio(&folio, gfp, node, &cc->alloc_nmask)) {
+		*hpage = NULL;
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
+	}
 
-	folio = page_folio(*hpage);
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
 		*hpage = NULL;
 		return SCAN_CGROUP_CHARGE_FAIL;
 	}
-	count_memcg_page_event(*hpage, THP_COLLAPSE_ALLOC);
 
+	count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);
+
+	*hpage = folio_page(folio, 0);
 	return SCAN_SUCCEED;
 }
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-khugepaged-convert-__collapse_huge_page_isolate-to-use-folios.patch
mm-khugepaged-convert-hpage_collapse_scan_pmd-to-use-folios.patch
mm-khugepaged-convert-is_refcount_suitable-to-use-folios.patch
mm-khugepaged-convert-alloc_charge_hpage-to-use-folios.patch
mm-khugepaged-convert-collapse_pte_mapped_thp-to-use-folios.patch

