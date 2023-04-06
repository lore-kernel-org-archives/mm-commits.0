Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95087C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 01:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbjDFBEb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 21:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234482AbjDFBE1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 21:04:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D2B768F
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 18:04:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FDE364290
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 01:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B47AC433EF;
        Thu,  6 Apr 2023 01:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680743061;
        bh=QLlqHjM/hC8MymhQEqaunFTGjKaxNrNrcG2DbH11YrU=;
        h=Date:To:From:Subject:From;
        b=T5heohAz0UIFh2qMZRd4+5frbTwmylqVuO9ScDGdPIMNpwzMq0jqqnHtdXfiQIPaT
         Q1tz4aiL44duQVDPPlI1vp80n5mH11sIqQKz2LTwk0J4TKOGIQ5XJQvvWU9Kv1sE5N
         ti/4YeZ6PzqTzGU786w19jOWgT4eofPGpv5rtQZI=
Date:   Wed, 05 Apr 2023 18:04:21 -0700
To:     mm-commits@vger.kernel.org, usama.anjum@collabora.com,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, david@redhat.com,
        axelrasmussen@google.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v2.patch removed from -mm tree
Message-Id: <20230406010421.9B47AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v2
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v2.patch

This patch was dropped because it was folded into mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v2
Date: Tue, 21 Mar 2023 14:58:42 -0400

v2

Link: https://lkml.kernel.org/r/ZBzOqwF2wrHgBVZb@x1n
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v2
+++ a/mm/hugetlb.c
@@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_s
 		       struct folio *pagecache_folio, spinlock_t *ptl)
 {
 	const bool unshare = flags & FAULT_FLAG_UNSHARE;
-	pte_t pte, newpte;
+	pte_t pte = huge_ptep_get(ptep);
 	struct hstate *h = hstate_vma(vma);
 	struct page *old_page;
 	struct folio *new_folio;
@@ -5488,6 +5488,17 @@ static vm_fault_t hugetlb_wp(struct mm_s
 	struct mmu_notifier_range range;
 
 	/*
+	 * Never handle CoW for uffd-wp protected pages.  It should be only
+	 * handled when the uffd-wp protection is removed.
+	 *
+	 * Note that only the CoW optimization path can trigger this and
+	 * got skipped, because hugetlb_fault() will always resolve uffd-wp
+	 * bit first.
+	 */
+	if (huge_pte_uffd_wp(pte))
+		return 0;
+
+	/*
 	 * hugetlb does not support FOLL_FORCE-style write faults that keep the
 	 * PTE mapped R/O such as maybe_mkwrite() would do.
 	 */
@@ -5500,7 +5511,6 @@ static vm_fault_t hugetlb_wp(struct mm_s
 		return 0;
 	}
 
-	pte = huge_ptep_get(ptep);
 	old_page = pte_page(pte);
 
 	delayacct_wpcopy_start();
@@ -5622,10 +5632,8 @@ retry_avoidcopy:
 		mmu_notifier_invalidate_range(mm, range.start, range.end);
 		page_remove_rmap(old_page, vma, true);
 		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
-		newpte = make_huge_pte(vma, &new_folio->page, !unshare);
-		if (huge_pte_uffd_wp(pte))
-			newpte = huge_pte_mkuffd_wp(newpte);
-		set_huge_pte_at(mm, haddr, ptep, newpte);
+		set_huge_pte_at(mm, haddr, ptep,
+				make_huge_pte(vma, &new_folio->page, !unshare));
 		folio_set_hugetlb_migratable(new_folio);
 		/* Make the old page be freed below */
 		new_folio = page_folio(old_page);
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path.patch
mm-hugetlb-fix-uffd-wr-protection-for-cow-optimization-path-v3.patch
mm-khugepaged-check-again-on-anon-uffd-wp-during-isolation.patch
mm-uffd-uffd_feature_wp_unpopulated.patch
mm-uffd-uffd_feature_wp_unpopulated-fix.patch
selftests-mm-smoke-test-uffd_feature_wp_unpopulated.patch

