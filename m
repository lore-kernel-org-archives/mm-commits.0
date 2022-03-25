Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B72B5C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236914AbiCYBQ0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357245AbiCYBQB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:16:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103136D879
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:13:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FBE861888
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2BEC340ED;
        Fri, 25 Mar 2022 01:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170837;
        bh=1evT2eQQK0ThbMbghwf298P0VZ2eXQH+JPFKLTQBAPk=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=nYYC90o/a3u6d9nt+UnXHEmcMNTwqAEJXEMn3o0oZFYvkNb9sd212l+Fb1IecUqR9
         S9xggDOT2IzRY9TGaNp8c6qLNQFvJd5x2J57yrPHsxvngBKTv/zvEomjBpPpBjEL4d
         21qnw3EX9CVD0CtC1WunRA0kAdOSN2UILp0F4vjA=
Date:   Thu, 24 Mar 2022 18:13:56 -0700
To:     zhangliang5@huawei.com, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, shakeelb@google.com, rppt@linux.ibm.com,
        roman.gushchin@linux.dev, rientjes@google.com, riel@surriel.com,
        peterx@redhat.com, oleg@redhat.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        jgg@nvidia.com, jannh@google.com, jack@suse.cz, hughd@google.com,
        hch@lst.de, ddutile@redhat.com, aarcange@redhat.com,
        david@redhat.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 107/114] mm/huge_memory: remove stale locking logic from __split_huge_pmd()
Message-Id: <20220325011356.EB2BEC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: remove stale locking logic from __split_huge_pmd()

Let's remove the stale logic that was required for reuse_swap_page().

[akpm@linux-foundation.org: simplification, per Yang Shi]
Link: https://lkml.kernel.org/r/20220131162940.210846-10-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   40 ++++------------------------------------
 1 file changed, 4 insertions(+), 36 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd
+++ a/mm/huge_memory.c
@@ -2133,8 +2133,6 @@ void __split_huge_pmd(struct vm_area_str
 {
 	spinlock_t *ptl;
 	struct mmu_notifier_range range;
-	bool do_unlock_folio = false;
-	pmd_t _pmd;
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
 				address & HPAGE_PMD_MASK,
@@ -2153,42 +2151,12 @@ void __split_huge_pmd(struct vm_area_str
 			goto out;
 	}
 
-repeat:
-	if (pmd_trans_huge(*pmd)) {
-		if (!folio) {
-			folio = page_folio(pmd_page(*pmd));
-			/*
-			 * An anonymous page must be locked, to ensure that a
-			 * concurrent reuse_swap_page() sees stable mapcount;
-			 * but reuse_swap_page() is not used on shmem or file,
-			 * and page lock must not be taken when zap_pmd_range()
-			 * calls __split_huge_pmd() while i_mmap_lock is held.
-			 */
-			if (folio_test_anon(folio)) {
-				if (unlikely(!folio_trylock(folio))) {
-					folio_get(folio);
-					_pmd = *pmd;
-					spin_unlock(ptl);
-					folio_lock(folio);
-					spin_lock(ptl);
-					if (unlikely(!pmd_same(*pmd, _pmd))) {
-						folio_unlock(folio);
-						folio_put(folio);
-						folio = NULL;
-						goto repeat;
-					}
-					folio_put(folio);
-				}
-				do_unlock_folio = true;
-			}
-		}
-	} else if (!(pmd_devmap(*pmd) || is_pmd_migration_entry(*pmd)))
-		goto out;
-	__split_huge_pmd_locked(vma, pmd, range.start, freeze);
+	if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd) ||
+	    is_pmd_migration_entry(*pmd))
+		__split_huge_pmd_locked(vma, pmd, range.start, freeze);
+
 out:
 	spin_unlock(ptl);
-	if (do_unlock_folio)
-		folio_unlock(folio);
 	/*
 	 * No need to double call mmu_notifier->invalidate_range() callback.
 	 * They are 3 cases to consider inside __split_huge_pmd_locked():
_
