Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F19C677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjASBUb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjASBS6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8A96C565
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F0E7B81FC2
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E693FC433F1;
        Thu, 19 Jan 2023 01:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090961;
        bh=oIrB2kdrDDrd6JripQ2ihEd2AKP79bjnUjntwG4e7p8=;
        h=Date:To:From:Subject:From;
        b=DwV7v9iRytpCmExX2lItdYYAwoJ2L1TijFsVZ7XAX7eKZw8lBMkeZrdYBgMLizcBH
         XOtrGNxrsG+gsTy9W54cuE8GRtGFTLydumfPRPT9mbVaCyTvviwbCLmZb6ld27XVzu
         x2bfTo8G/QroTlvwW86lZNMDnu3TZQUxEPEUUjhQ=
Date:   Wed, 18 Jan 2023 17:16:00 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sj@kernel.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-convert-hugetlb-related-functions-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230119011600.E693FC433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/vaddr: convert hugetlb related functions to use a folio
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-convert-hugetlb-related-functions-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm/damon/vaddr: convert hugetlb related functions to use a folio
Date: Fri, 30 Dec 2022 15:08:49 +0800

Convert damon_hugetlb_mkold() and damon_young_hugetlb_entry() to
use a folio.

Link: https://lkml.kernel.org/r/20221230070849.63358-9-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-convert-hugetlb-related-functions-to-use-a-folio
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
mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch

