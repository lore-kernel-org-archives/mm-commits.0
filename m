Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5521DC678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjASBUS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjASBSk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96FE6C55C
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:16:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B094B81FB6
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0E2C433EF;
        Thu, 19 Jan 2023 01:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090958;
        bh=kpm5GCiLJ1843w7kDnQol5jJ7K/v43hBsJatoA4Yl84=;
        h=Date:To:From:Subject:From;
        b=vigCXYl/JFoy/EsacLJmH189Hs9dCe6ExXx/AwJrnI4M/zEOSU+bSOs+yvdTVftuR
         Srb0RrN6J/wGHKBm8HwdY8Vb5If2eSB4kuzVffb4CHhAhf+uePpRxQJrmpUDasVLAk
         HMUWazTViCbIjnVLQQVPFrKjjkyw0tTqo0Gb6ALM=
Date:   Wed, 18 Jan 2023 17:15:57 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, sj@kernel.org, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-convert-damon_young_pmd_entry-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230119011558.0A0E2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/vaddr: convert damon_young_pmd_entry() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-convert-damon_young_pmd_entry-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm/damon/vaddr: convert damon_young_pmd_entry() to use a folio
Date: Fri, 30 Dec 2022 15:08:47 +0800

With damon_get_folio(), let's convert damon_young_pmd_entry()
to use a folio.

Link: https://lkml.kernel.org/r/20221230070849.63358-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-convert-damon_young_pmd_entry-to-use-a-folio
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
mm-madvise-use-vm_normal_folio-in-madvise_free_pte_range.patch

