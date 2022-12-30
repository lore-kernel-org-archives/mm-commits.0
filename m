Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4249FC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 30 Dec 2022 21:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbiL3Vwt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Dec 2022 16:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235424AbiL3Vwm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Dec 2022 16:52:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AA01CFE1
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 13:52:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6C1561BCE
        for <mm-commits@vger.kernel.org>; Fri, 30 Dec 2022 21:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8D8C433EF;
        Fri, 30 Dec 2022 21:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672437161;
        bh=rochAGGfALj4Clw8dLrqojxHFSO2oczqmnj/E6lPntI=;
        h=Date:To:From:Subject:From;
        b=2eqYAlsP/bIdL+JCk2uKVWwujofHPAPwiDF+mCWcxnAnXQOM0oGMe3WswTzmkyQ7z
         YRD38X8gEjw0ySw0Xq+3ymlcoA0sCAtSmUv6Yz6wGp0UFpeMUuXiha8MG/R8y/lGku
         25oJYIQFPD/UPJaOXnJzfd/m24xV7SSTrHWiDaJc=
Date:   Fri, 30 Dec 2022 13:52:40 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sj@kernel.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-convert-damon_ptep-pmdp_mkold-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20221230215241.0A8D8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: convert damon_ptep/pmdp_mkold() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-convert-damon_ptep-pmdp_mkold-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-convert-damon_ptep-pmdp_mkold-to-use-a-folio.patch

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
Subject: mm/damon: convert damon_ptep/pmdp_mkold() to use a folio
Date: Fri, 30 Dec 2022 15:08:45 +0800

With damon_get_folio(), let's convert damon_ptep_mkold() and
damon_pmdp_mkold() to use a folio.

Link: https://lkml.kernel.org/r/20221230070849.63358-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/damon/ops-common.c~mm-damon-convert-damon_ptep-pmdp_mkold-to-use-a-folio
+++ a/mm/damon/ops-common.c
@@ -40,9 +40,9 @@ struct folio *damon_get_folio(unsigned l
 void damon_ptep_mkold(pte_t *pte, struct mm_struct *mm, unsigned long addr)
 {
 	bool referenced = false;
-	struct page *page = damon_get_page(pte_pfn(*pte));
+	struct folio *folio = damon_get_folio(pte_pfn(*pte));
 
-	if (!page)
+	if (!folio)
 		return;
 
 	if (pte_young(*pte)) {
@@ -56,19 +56,19 @@ void damon_ptep_mkold(pte_t *pte, struct
 #endif /* CONFIG_MMU_NOTIFIER */
 
 	if (referenced)
-		set_page_young(page);
+		folio_set_young(folio);
 
-	set_page_idle(page);
-	put_page(page);
+	folio_set_idle(folio);
+	folio_put(folio);
 }
 
 void damon_pmdp_mkold(pmd_t *pmd, struct mm_struct *mm, unsigned long addr)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	bool referenced = false;
-	struct page *page = damon_get_page(pmd_pfn(*pmd));
+	struct folio *folio = damon_get_folio(pmd_pfn(*pmd));
 
-	if (!page)
+	if (!folio)
 		return;
 
 	if (pmd_young(*pmd)) {
@@ -82,10 +82,10 @@ void damon_pmdp_mkold(pmd_t *pmd, struct
 #endif /* CONFIG_MMU_NOTIFIER */
 
 	if (referenced)
-		set_page_young(page);
+		folio_set_young(folio);
 
-	set_page_idle(page);
-	put_page(page);
+	folio_set_idle(folio);
+	folio_put(folio);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwposion-support-recovery-from-ksm_might_need_to_copy.patch
mm-hwposion-support-recovery-from-ksm_might_need_to_copy-v3.patch
mm-huge_memory-convert-madvise_free_huge_pmd-to-use-a-folio.patch
mm-swap-convert-mark_page_lazyfree-to-folio_mark_lazyfree.patch
mm-huge_memory-convert-split_huge_pages_all-to-use-a-folio.patch
mm-page_idle-convert-page-idle-to-use-a-folio.patch
mm-damon-introduce-damon_get_folio.patch
mm-damon-convert-damon_ptep-pmdp_mkold-to-use-a-folio.patch
mm-damon-paddr-convert-damon_pa_-to-use-a-folio.patch
mm-damon-vaddr-convert-damon_young_pmd_entry-to-use-a-folio.patch
mm-damon-remove-unneeded-damon_get_page.patch
mm-damon-vaddr-convert-hugetlb-related-functions-to-use-a-folio.patch

