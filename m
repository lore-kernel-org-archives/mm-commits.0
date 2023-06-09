Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4079AC7EE29
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 23:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjFIXfB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 19:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232521AbjFIXdZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 19:33:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86B049E5
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 16:30:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D03363E4A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 23:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66334C433D2;
        Fri,  9 Jun 2023 23:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686353427;
        bh=j/jACdA6cYMnIUJOeSR3HwHnu0hUN+dcSK0DXp5pTe8=;
        h=Date:To:From:Subject:From;
        b=q2oNkUqndW/WNeBBos+39IOJgkmdzRdhl3kqiXfsne6QYcrzGEGZPkSZkQjzcAhnz
         PL0ir4aFi0MBLY2mIjEgOSU30qVHa5geubWEqt7fiw1AfIxhBflJEit41wfInCYXB0
         ewY6HRddV97epve+poFHadySwfttQoQ6VY/CIT6U=
Date:   Fri, 09 Jun 2023 16:30:26 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        willy@infradead.org, urezki@gmail.com, sj@kernel.org,
        rppt@kernel.org, lstoakes@gmail.com,
        kirill.shutemov@linux.intel.com, hch@lst.de, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-ops-common-refactor-to-use-ptepmdp_clear_young_notify.patch removed from -mm tree
Message-Id: <20230609233027.66334C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/ops-common: refactor to use {pte|pmd}p_clear_young_notify()
has been removed from the -mm tree.  Its filename was
     mm-damon-ops-common-refactor-to-use-ptepmdp_clear_young_notify.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm/damon/ops-common: refactor to use {pte|pmd}p_clear_young_notify()
Date: Fri, 2 Jun 2023 10:29:48 +0100

With the fix in place to atomically test and clear young on ptes and pmds,
simplify the code to handle the clearing for both the primary mmu and the
mmu notifier with a single API call.

Link: https://lkml.kernel.org/r/20230602092949.545577-4-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |   22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-refactor-to-use-ptepmdp_clear_young_notify
+++ a/mm/damon/ops-common.c
@@ -39,21 +39,12 @@ struct folio *damon_get_folio(unsigned l
 
 void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr)
 {
-	bool referenced = false;
 	struct folio *folio = damon_get_folio(pte_pfn(*pte));
 
 	if (!folio)
 		return;
 
-	if (ptep_test_and_clear_young(vma, addr, pte))
-		referenced = true;
-
-#ifdef CONFIG_MMU_NOTIFIER
-	if (mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE))
-		referenced = true;
-#endif /* CONFIG_MMU_NOTIFIER */
-
-	if (referenced)
+	if (ptep_clear_young_notify(vma, addr, pte))
 		folio_set_young(folio);
 
 	folio_set_idle(folio);
@@ -63,21 +54,12 @@ void damon_ptep_mkold(pte_t *pte, struct
 void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	bool referenced = false;
 	struct folio *folio = damon_get_folio(pmd_pfn(*pmd));
 
 	if (!folio)
 		return;
 
-	if (pmdp_test_and_clear_young(vma, addr, pmd))
-		referenced = true;
-
-#ifdef CONFIG_MMU_NOTIFIER
-	if (mmu_notifier_clear_young(vma->vm_mm, addr, addr + HPAGE_PMD_SIZE))
-		referenced = true;
-#endif /* CONFIG_MMU_NOTIFIER */
-
-	if (referenced)
+	if (pmdp_clear_young_notify(vma, addr, pmd))
 		folio_set_young(folio);
 
 	folio_set_idle(folio);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


