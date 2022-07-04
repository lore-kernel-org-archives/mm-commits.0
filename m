Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CE8C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jul 2022 01:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbiGDBND (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Jul 2022 21:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbiGDBL5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Jul 2022 21:11:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443426413
        for <mm-commits@vger.kernel.org>; Sun,  3 Jul 2022 18:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D792DB80BD1
        for <mm-commits@vger.kernel.org>; Mon,  4 Jul 2022 01:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE92C341CF;
        Mon,  4 Jul 2022 01:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656897054;
        bh=SONykl/+8SvzyMU6u6bGRM2TO+/0kEmBvhApEgMKjuI=;
        h=Date:To:From:Subject:From;
        b=xF/rOdALBvnjx3ww7sJOJO0wSnMGmPqgcaBGnU/bm51AHW9GkaN2uq7uSg0fTLvAG
         Meg6laj0UF4WAN3PplvZLluv2ErqnmeUZ8YLCIuunkh+vIOzIWjYIwsKnn9acU7RPV
         H8tjt4pqJtMFU+eHnlPO2diRKUnYIy8x3p22+RVA=
Date:   Sun, 03 Jul 2022 18:10:54 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        songmuchun@bytedance.com, mike.kravetz@oracle.com,
        catalin.marinas@arm.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-kill-set_huge_swap_pte_at.patch removed from -mm tree
Message-Id: <20220704011054.8EE92C341CF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb: kill set_huge_swap_pte_at()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-kill-set_huge_swap_pte_at.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: hugetlb: kill set_huge_swap_pte_at()
Date: Sun, 26 Jun 2022 22:57:17 +0800

Commit e5251fd43007 ("mm/hugetlb: introduce set_huge_swap_pte_at()
helper") add set_huge_swap_pte_at() to handle swap entries on
architectures that support hugepages consisting of contiguous ptes.  And
currently the set_huge_swap_pte_at() is only overridden by arm64.

set_huge_swap_pte_at() provide a sz parameter to help determine the number
of entries to be updated.  But in fact, all hugetlb swap entries contain
pfn information, so we can find the corresponding folio through the pfn
recorded in the swap entry, then the folio_size() is the number of entries
that need to be updated.

And considering that users will easily cause bugs by ignoring the
difference between set_huge_swap_pte_at() and set_huge_pte_at().  Let's
handle swap entries in set_huge_pte_at() and remove the
set_huge_swap_pte_at(), then we can call set_huge_pte_at() anywhere, which
simplifies our coding.

Link: https://lkml.kernel.org/r/20220626145717.53572-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/hugetlb.h |    3 --
 arch/arm64/mm/hugetlbpage.c      |   34 ++++++++++++++---------------
 include/linux/hugetlb.h          |   13 -----------
 mm/hugetlb.c                     |    8 ++----
 mm/rmap.c                        |   11 ++-------
 5 files changed, 23 insertions(+), 46 deletions(-)

--- a/arch/arm64/include/asm/hugetlb.h~mm-hugetlb-kill-set_huge_swap_pte_at
+++ a/arch/arm64/include/asm/hugetlb.h
@@ -46,9 +46,6 @@ extern void huge_pte_clear(struct mm_str
 			   pte_t *ptep, unsigned long sz);
 #define __HAVE_ARCH_HUGE_PTEP_GET
 extern pte_t huge_ptep_get(pte_t *ptep);
-extern void set_huge_swap_pte_at(struct mm_struct *mm, unsigned long addr,
-				 pte_t *ptep, pte_t pte, unsigned long sz);
-#define set_huge_swap_pte_at set_huge_swap_pte_at
 
 void __init arm64_hugetlb_cma_reserve(void);
 
--- a/arch/arm64/mm/hugetlbpage.c~mm-hugetlb-kill-set_huge_swap_pte_at
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -238,6 +238,13 @@ static void clear_flush(struct mm_struct
 	flush_tlb_range(&vma, saddr, addr);
 }
 
+static inline struct folio *hugetlb_swap_entry_to_folio(swp_entry_t entry)
+{
+	VM_BUG_ON(!is_migration_entry(entry) && !is_hwpoison_entry(entry));
+
+	return page_folio(pfn_to_page(swp_offset(entry)));
+}
+
 void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 			    pte_t *ptep, pte_t pte)
 {
@@ -247,11 +254,16 @@ void set_huge_pte_at(struct mm_struct *m
 	unsigned long pfn, dpfn;
 	pgprot_t hugeprot;
 
-	/*
-	 * Code needs to be expanded to handle huge swap and migration
-	 * entries. Needed for HUGETLB and MEMORY_FAILURE.
-	 */
-	WARN_ON(!pte_present(pte));
+	if (!pte_present(pte)) {
+		struct folio *folio;
+
+		folio = hugetlb_swap_entry_to_folio(pte_to_swp_entry(pte));
+		ncontig = num_contig_ptes(folio_size(folio), &pgsize);
+
+		for (i = 0; i < ncontig; i++, ptep++)
+			set_pte_at(mm, addr, ptep, pte);
+		return;
+	}
 
 	if (!pte_cont(pte)) {
 		set_pte_at(mm, addr, ptep, pte);
@@ -269,18 +281,6 @@ void set_huge_pte_at(struct mm_struct *m
 		set_pte_at(mm, addr, ptep, pfn_pte(pfn, hugeprot));
 }
 
-void set_huge_swap_pte_at(struct mm_struct *mm, unsigned long addr,
-			  pte_t *ptep, pte_t pte, unsigned long sz)
-{
-	int i, ncontig;
-	size_t pgsize;
-
-	ncontig = num_contig_ptes(sz, &pgsize);
-
-	for (i = 0; i < ncontig; i++, ptep++)
-		set_pte(ptep, pte);
-}
-
 pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, unsigned long sz)
 {
--- a/include/linux/hugetlb.h~mm-hugetlb-kill-set_huge_swap_pte_at
+++ a/include/linux/hugetlb.h
@@ -903,14 +903,6 @@ static inline void hugetlb_count_sub(lon
 	atomic_long_sub(l, &mm->hugetlb_usage);
 }
 
-#ifndef set_huge_swap_pte_at
-static inline void set_huge_swap_pte_at(struct mm_struct *mm, unsigned long addr,
-					pte_t *ptep, pte_t pte, unsigned long sz)
-{
-	set_huge_pte_at(mm, addr, ptep, pte);
-}
-#endif
-
 #ifndef huge_ptep_modify_prot_start
 #define huge_ptep_modify_prot_start huge_ptep_modify_prot_start
 static inline pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma,
@@ -1094,11 +1086,6 @@ static inline void hugetlb_count_sub(lon
 {
 }
 
-static inline void set_huge_swap_pte_at(struct mm_struct *mm, unsigned long addr,
-					pte_t *ptep, pte_t pte, unsigned long sz)
-{
-}
-
 static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 					  unsigned long addr, pte_t *ptep)
 {
--- a/mm/hugetlb.c~mm-hugetlb-kill-set_huge_swap_pte_at
+++ a/mm/hugetlb.c
@@ -4798,12 +4798,11 @@ again:
 				entry = swp_entry_to_pte(swp_entry);
 				if (userfaultfd_wp(src_vma) && uffd_wp)
 					entry = huge_pte_mkuffd_wp(entry);
-				set_huge_swap_pte_at(src, addr, src_pte,
-						     entry, sz);
+				set_huge_pte_at(src, addr, src_pte, entry);
 			}
 			if (!userfaultfd_wp(dst_vma) && uffd_wp)
 				entry = huge_pte_clear_uffd_wp(entry);
-			set_huge_swap_pte_at(dst, addr, dst_pte, entry, sz);
+			set_huge_pte_at(dst, addr, dst_pte, entry);
 		} else if (unlikely(is_pte_marker(entry))) {
 			/*
 			 * We copy the pte marker only if the dst vma has
@@ -6344,8 +6343,7 @@ unsigned long hugetlb_change_protection(
 					newpte = pte_swp_mkuffd_wp(newpte);
 				else if (uffd_wp_resolve)
 					newpte = pte_swp_clear_uffd_wp(newpte);
-				set_huge_swap_pte_at(mm, address, ptep,
-						     newpte, psize);
+				set_huge_pte_at(mm, address, ptep, newpte);
 				pages++;
 			}
 			spin_unlock(ptl);
--- a/mm/rmap.c~mm-hugetlb-kill-set_huge_swap_pte_at
+++ a/mm/rmap.c
@@ -1618,9 +1618,7 @@ static bool try_to_unmap_one(struct foli
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
-				set_huge_swap_pte_at(mm, address,
-						     pvmw.pte, pteval,
-						     vma_mmu_pagesize(vma));
+				set_huge_pte_at(mm, address, pvmw.pte, pteval);
 			} else {
 				dec_mm_counter(mm, mm_counter(&folio->page));
 				set_pte_at(mm, address, pvmw.pte, pteval);
@@ -2004,9 +2002,7 @@ static bool try_to_migrate_one(struct fo
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
-				set_huge_swap_pte_at(mm, address,
-						     pvmw.pte, pteval,
-						     vma_mmu_pagesize(vma));
+				set_huge_pte_at(mm, address, pvmw.pte, pteval);
 			} else {
 				dec_mm_counter(mm, mm_counter(&folio->page));
 				set_pte_at(mm, address, pvmw.pte, pteval);
@@ -2074,8 +2070,7 @@ static bool try_to_migrate_one(struct fo
 			if (pte_uffd_wp(pteval))
 				swp_pte = pte_swp_mkuffd_wp(swp_pte);
 			if (folio_test_hugetlb(folio))
-				set_huge_swap_pte_at(mm, address, pvmw.pte,
-						     swp_pte, vma_mmu_pagesize(vma));
+				set_huge_pte_at(mm, address, pvmw.pte, swp_pte);
 			else
 				set_pte_at(mm, address, pvmw.pte, swp_pte);
 			trace_set_migration_pte(address, pte_val(swp_pte),
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


