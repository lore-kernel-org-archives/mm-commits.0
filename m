Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 662A5C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 10 Nov 2023 19:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbjKJTpI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Nov 2023 14:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236181AbjKJTou (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2023 14:44:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDA7A53E3
        for <mm-commits@vger.kernel.org>; Fri, 10 Nov 2023 10:21:27 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2049EC41679;
        Fri, 10 Nov 2023 18:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699640413;
        bh=vFl4p3qahLE/qgLSoOjHf57qLk7lBkq3qno9ksnhkm4=;
        h=Date:To:From:Subject:From;
        b=umzOLNSCtYxjXY+I75Z+7y9As53ykk+i0XN04zUtz0gsaKSZg9KBsr7olNgRn0afv
         EzjWU3p4T1ysRjUdq1No8/STQa8Kp2xYATDDwJLXJ1SzqBndUAi5D3NSEPh76boNW0
         oGQcoa7gEsvF9EzY8qfWYX5vxtaDHjynKMoDuOnw=
Date:   Fri, 10 Nov 2023 10:20:12 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        gregory.price@memverge.com, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] mm-task_mmu-use-a-folio-in-clear_refs_pte_range.patch removed from -mm tree
Message-Id: <20231110182013.2049EC41679@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: task_mmu: use a folio in clear_refs_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-task_mmu-use-a-folio-in-clear_refs_pte_range.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: task_mmu: use a folio in clear_refs_pte_range()
Date: Fri, 10 Nov 2023 11:33:23 +0800

Use a folio to save two compound_head() calls in clear_refs_pte_range().

Link: https://lkml.kernel.org/r/20231110033324.2455523-7-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gregory.price@memverge.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/proc/task_mmu.c~mm-task_mmu-use-a-folio-in-clear_refs_pte_range
+++ a/fs/proc/task_mmu.c
@@ -1161,7 +1161,7 @@ static int clear_refs_pte_range(pmd_t *p
 	struct vm_area_struct *vma = walk->vma;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
-	struct page *page;
+	struct folio *folio;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
@@ -1173,12 +1173,12 @@ static int clear_refs_pte_range(pmd_t *p
 		if (!pmd_present(*pmd))
 			goto out;
 
-		page = pmd_page(*pmd);
+		folio = page_folio(pmd_page(*pmd));
 
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
-		test_and_clear_page_young(page);
-		ClearPageReferenced(page);
+		folio_test_clear_young(folio);
+		folio_clear_referenced(folio);
 out:
 		spin_unlock(ptl);
 		return 0;
@@ -1200,14 +1200,14 @@ out:
 		if (!pte_present(ptent))
 			continue;
 
-		page = vm_normal_page(vma, addr, ptent);
-		if (!page)
+		folio = vm_normal_folio(vma, addr, ptent);
+		if (!folio)
 			continue;
 
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
-		test_and_clear_page_young(page);
-		ClearPageReferenced(page);
+		folio_test_clear_young(folio);
+		folio_clear_referenced(folio);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

page_idle-kill-page-idle-and-young-wrapper.patch

