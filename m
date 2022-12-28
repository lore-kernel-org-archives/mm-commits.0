Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9FCC4708E
	for <mm-commits@archiver.kernel.org>; Wed, 28 Dec 2022 22:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbiL1WKr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Dec 2022 17:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbiL1WKC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2022 17:10:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448DE17420
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 14:09:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C791D61639
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 22:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228D1C433F0;
        Wed, 28 Dec 2022 22:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672265385;
        bh=AAUGkoOVrs8wCjMnceCyau0om9SyfIG6zyPkee3TATM=;
        h=Date:To:From:Subject:From;
        b=mlA2rh7M/8oDwrV8VAHIUFRbpG//Jjez308IIT4l8XXmRwBLnq61I91zLCCvwGmAq
         PyTemaiR69pdclG5BIetFG5s0RSo4r0B7+vvKjf3SyR7F/Azrf98Kw3mpRGZpDnaKd
         33wp3hDjCKEm4oQEZZ8g/n5KKWxSdfQhbYjot+Ys=
Date:   Wed, 28 Dec 2022 14:09:44 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sj@kernel.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-convert-damon_young_pmd_entry-to-use-folio.patch added to mm-unstable branch
Message-Id: <20221228220945.228D1C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: convert damon_young_pmd_entry() to use folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-convert-damon_young_pmd_entry-to-use-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-convert-damon_young_pmd_entry-to-use-folio.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm/damon/vaddr: convert damon_young_pmd_entry() to use folio
Date: Wed, 28 Dec 2022 19:34:11 +0800

With damon_get_folio(), let's convert damon_young_pmd_entry()
to use folios.

Link: https://lkml.kernel.org/r/20221228113413.10329-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/vaddr.c~mm-damon-vaddr-convert-damon_young_pmd_entry-to-use-folio
+++ a/mm/damon/vaddr.c
@@ -431,7 +431,7 @@ static int damon_young_pmd_entry(pmd_t *
 {
 	pte_t *pte;
 	spinlock_t *ptl;
-	struct page *page;
+	struct folio *folio;
 	struct damon_young_walk_private *priv = walk->private;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -446,16 +446,16 @@ static int damon_young_pmd_entry(pmd_t *
 			spin_unlock(ptl);
 			goto regular_page;
 		}
-		page = damon_get_page(pmd_pfn(*pmd));
-		if (!page)
+		folio = damon_get_folio(pmd_pfn(*pmd));
+		if (!folio)
 			goto huge_out;
-		if (pmd_young(*pmd) || !page_is_idle(page) ||
+		if (pmd_young(*pmd) || !folio_test_idle(folio) ||
 					mmu_notifier_test_young(walk->mm,
 						addr)) {
 			*priv->page_sz = HPAGE_PMD_SIZE;
 			priv->young = true;
 		}
-		put_page(page);
+		folio_put(folio);
 huge_out:
 		spin_unlock(ptl);
 		return 0;
@@ -469,15 +469,15 @@ regular_page:
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	if (!pte_present(*pte))
 		goto out;
-	page = damon_get_page(pte_pfn(*pte));
-	if (!page)
+	folio = damon_get_folio(pte_pfn(*pte));
+	if (!folio)
 		goto out;
-	if (pte_young(*pte) || !page_is_idle(page) ||
+	if (pte_young(*pte) || !folio_test_idle(folio) ||
 			mmu_notifier_test_young(walk->mm, addr)) {
 		*priv->page_sz = PAGE_SIZE;
 		priv->young = true;
 	}
-	put_page(page);
+	folio_put(folio);
 out:
 	pte_unmap_unlock(pte, ptl);
 	return 0;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio.patch
mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree.patch
mm-page_idle-convert-page-idle-to-use-folios.patch
mm-damon-introduce-damon_get_folio.patch
mm-damon-convert-damon_ptep-pmdp_mkold-to-use-folios.patch
mm-damon-paddr-convert-damon_pa_-to-use-folios.patch
mm-damon-vaddr-convert-damon_young_pmd_entry-to-use-folio.patch
mm-damon-remove-unneed-damon_get_page.patch
mm-damon-vaddr-convert-hugetlb-related-function-to-use-folios.patch

