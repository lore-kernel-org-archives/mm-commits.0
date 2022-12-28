Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C3C9C4167B
	for <mm-commits@archiver.kernel.org>; Wed, 28 Dec 2022 22:11:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiL1WLR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Dec 2022 17:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbiL1WKZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2022 17:10:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEB017895
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 14:09:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5C724CE13CD
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 22:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F79EC433EF;
        Wed, 28 Dec 2022 22:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672265390;
        bh=qFggAxtr7IqNeYANtrygyoXAp8D31YkJYP9PAKKimJg=;
        h=Date:To:From:Subject:From;
        b=cAvBF9TN6qFU/SLr8E7hyQfOLu7vVLWGdGFJ7jBgMp8wmfv8Xlnl2IDicPzlD5MZc
         Xs2mAfhC8Yf/bbpccdiZDbjPPYp4hZoDz2517eNg5tkXi1AgHhuWiDouUc+EYvogRp
         +dcTzlnkpiwKDnR/BGw/s2pS/gHRk1E9R9/vFGU4=
Date:   Wed, 28 Dec 2022 14:09:47 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sj@kernel.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-convert-hugetlb-related-function-to-use-folios.patch added to mm-unstable branch
Message-Id: <20221228220950.5F79EC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/vaddr: convert hugetlb related functions to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-vaddr-convert-hugetlb-related-function-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-convert-hugetlb-related-function-to-use-folios.patch

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
Subject: mm/damon/vaddr: convert hugetlb related functions to use folios
Date: Wed, 28 Dec 2022 19:34:13 +0800

Convert damon_hugetlb_mkold() and damon_young_hugetlb_entry() to use
folios.

Link: https://lkml.kernel.org/r/20221228113413.10329-8-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/vaddr.c~mm-damon-vaddr-convert-hugetlb-related-function-to-use-folios
+++ a/mm/damon/vaddr.c
@@ -335,9 +335,9 @@ static void damon_hugetlb_mkold(pte_t *p
 {
 	bool referenced = false;
 	pte_t entry = huge_ptep_get(pte);
-	struct page *page = pte_page(entry);
+	struct folio *folio = pfn_folio(pte_pfn(entry));
 
-	get_page(page);
+	folio_get(folio);
 
 	if (pte_young(entry)) {
 		referenced = true;
@@ -352,10 +352,10 @@ static void damon_hugetlb_mkold(pte_t *p
 #endif /* CONFIG_MMU_NOTIFIER */
 
 	if (referenced)
-		set_page_young(page);
+		folio_set_young(folio);
 
-	set_page_idle(page);
-	put_page(page);
+	folio_set_idle(folio);
+	folio_put(folio);
 }
 
 static int damon_mkold_hugetlb_entry(pte_t *pte, unsigned long hmask,
@@ -490,7 +490,7 @@ static int damon_young_hugetlb_entry(pte
 {
 	struct damon_young_walk_private *priv = walk->private;
 	struct hstate *h = hstate_vma(walk->vma);
-	struct page *page;
+	struct folio *folio;
 	spinlock_t *ptl;
 	pte_t entry;
 
@@ -499,16 +499,16 @@ static int damon_young_hugetlb_entry(pte
 	if (!pte_present(entry))
 		goto out;
 
-	page = pte_page(entry);
-	get_page(page);
+	folio = pfn_folio(pte_pfn(entry));
+	folio_get(folio);
 
-	if (pte_young(entry) || !page_is_idle(page) ||
+	if (pte_young(entry) || !folio_test_idle(folio) ||
 	    mmu_notifier_test_young(walk->mm, addr)) {
 		*priv->page_sz = huge_page_size(h);
 		priv->young = true;
 	}
 
-	put_page(page);
+	folio_put(folio);
 
 out:
 	spin_unlock(ptl);
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

