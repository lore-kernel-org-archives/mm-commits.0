Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6041C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 22 Jun 2022 01:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245332AbiFVBCV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Jun 2022 21:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347111AbiFVBCV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2022 21:02:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7CE31929
        for <mm-commits@vger.kernel.org>; Tue, 21 Jun 2022 18:02:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D020B81BE6
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 01:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382B5C3411C;
        Wed, 22 Jun 2022 01:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655859737;
        bh=MWdlUfIUhAgKomRtEmMHt5rfbK5JNEqiTQd6OrYPdm0=;
        h=Date:To:From:Subject:From;
        b=Kvoxihx2XQsyWvodpeGhcopceDUxEvrNMbTrIXfiL0Sa3CxgJKFomXJWHlbih6IM4
         qdoXHh/wVUzLk30MU++TPZhJYTLNXOOqGyV2/Bur5KW3ad4EOHZi6xQtZgnGipvDXr
         OfSQ6fl27JrHjvFq/6udk95pgJvdkS8FW91OA3ao=
Date:   Tue, 21 Jun 2022 18:02:08 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        songmuchun@bytedance.com, peterx@redhat.com,
        paul.walmsley@sifive.com, naoya.horiguchi@linux.dev,
        mhocko@suse.com, lkp@intel.com, jthoughton@google.com,
        eike-kernel@sf-tec.de, david@redhat.com, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, baolin.wang@linux.alibaba.com,
        anshuman.khandual@arm.com, aneesh.kumar@linux.vnet.ibm.com,
        almasrymina@google.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-do-not-update-address-in-huge_pmd_unshare.patch added to mm-unstable branch
Message-Id: <20220622010215.382B5C3411C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: do not update address in huge_pmd_unshare
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-do-not-update-address-in-huge_pmd_unshare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-do-not-update-address-in-huge_pmd_unshare.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: do not update address in huge_pmd_unshare
Date: Tue, 21 Jun 2022 16:56:19 -0700

As an optimization for loops sequentially processing hugetlb address
ranges, huge_pmd_unshare would update a passed address if it unshared a
pmd.  Updating a loop control variable outside the loop like this is
generally a bad idea.  These loops are now using hugetlb_mask_last_page to
optimize scanning when non-present ptes are discovered.  The same can be
done when huge_pmd_unshare returns 1 indicating a pmd was unshared.

Remove address update from huge_pmd_unshare.  Change the passed argument
type and update all callers.  In loops sequentially processing addresses
use hugetlb_mask_last_page to update address if pmd is unshared.

Link: https://lkml.kernel.org/r/20220621235620.291305-4-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 +--
 mm/hugetlb.c            |   46 +++++++++++++++-----------------------
 mm/rmap.c               |    4 +--
 3 files changed, 23 insertions(+), 31 deletions(-)

--- a/include/linux/hugetlb.h~hugetlb-do-not-update-address-in-huge_pmd_unshare
+++ a/include/linux/hugetlb.h
@@ -199,7 +199,7 @@ pte_t *huge_pte_offset(struct mm_struct
 		       unsigned long addr, unsigned long sz);
 unsigned long hugetlb_mask_last_page(struct hstate *h);
 int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
-				unsigned long *addr, pte_t *ptep);
+				unsigned long addr, pte_t *ptep);
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end);
 struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
@@ -246,7 +246,7 @@ static inline struct address_space *huge
 
 static inline int huge_pmd_unshare(struct mm_struct *mm,
 					struct vm_area_struct *vma,
-					unsigned long *addr, pte_t *ptep)
+					unsigned long addr, pte_t *ptep)
 {
 	return 0;
 }
--- a/mm/hugetlb.c~hugetlb-do-not-update-address-in-huge_pmd_unshare
+++ a/mm/hugetlb.c
@@ -4945,7 +4945,6 @@ int move_hugetlb_page_tables(struct vm_a
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long old_end = old_addr + len;
 	unsigned long last_addr_mask;
-	unsigned long old_addr_copy;
 	pte_t *src_pte, *dst_pte;
 	struct mmu_notifier_range range;
 	bool shared_pmd = false;
@@ -4973,14 +4972,10 @@ int move_hugetlb_page_tables(struct vm_a
 		if (huge_pte_none(huge_ptep_get(src_pte)))
 			continue;
 
-		/* old_addr arg to huge_pmd_unshare() is a pointer and so the
-		 * arg may be modified. Pass a copy instead to preserve the
-		 * value in old_addr.
-		 */
-		old_addr_copy = old_addr;
-
-		if (huge_pmd_unshare(mm, vma, &old_addr_copy, src_pte)) {
+		if (huge_pmd_unshare(mm, vma, old_addr, src_pte)) {
 			shared_pmd = true;
+			old_addr |= last_addr_mask;
+			new_addr |= last_addr_mask;
 			continue;
 		}
 
@@ -5045,10 +5040,11 @@ static void __unmap_hugepage_range(struc
 		}
 
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, vma, &address, ptep)) {
+		if (huge_pmd_unshare(mm, vma, address, ptep)) {
 			spin_unlock(ptl);
 			tlb_flush_pmd_range(tlb, address & PUD_MASK, PUD_SIZE);
 			force_flush = true;
+			address |= last_addr_mask;
 			continue;
 		}
 
@@ -6337,7 +6333,7 @@ unsigned long hugetlb_change_protection(
 			continue;
 		}
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, vma, &address, ptep)) {
+		if (huge_pmd_unshare(mm, vma, address, ptep)) {
 			/*
 			 * When uffd-wp is enabled on the vma, unshare
 			 * shouldn't happen at all.  Warn about it if it
@@ -6347,6 +6343,7 @@ unsigned long hugetlb_change_protection(
 			pages++;
 			spin_unlock(ptl);
 			shared_pmd = true;
+			address |= last_addr_mask;
 			continue;
 		}
 		pte = huge_ptep_get(ptep);
@@ -6770,11 +6767,11 @@ out:
  *	    0 the underlying pte page is not shared, or it is the last user
  */
 int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
-					unsigned long *addr, pte_t *ptep)
+					unsigned long addr, pte_t *ptep)
 {
-	pgd_t *pgd = pgd_offset(mm, *addr);
-	p4d_t *p4d = p4d_offset(pgd, *addr);
-	pud_t *pud = pud_offset(p4d, *addr);
+	pgd_t *pgd = pgd_offset(mm, addr);
+	p4d_t *p4d = p4d_offset(pgd, addr);
+	pud_t *pud = pud_offset(p4d, addr);
 
 	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
 	BUG_ON(page_count(virt_to_page(ptep)) == 0);
@@ -6784,14 +6781,6 @@ int huge_pmd_unshare(struct mm_struct *m
 	pud_clear(pud);
 	put_page(virt_to_page(ptep));
 	mm_dec_nr_pmds(mm);
-	/*
-	 * This update of passed address optimizes loops sequentially
-	 * processing addresses in increments of huge page size (PMD_SIZE
-	 * in this case).  By clearing the pud, a PUD_SIZE area is unmapped.
-	 * Update address to the 'last page' in the cleared area so that
-	 * calling loop can move to first page past this area.
-	 */
-	*addr |= PUD_SIZE - PMD_SIZE;
 	return 1;
 }
 
@@ -6803,7 +6792,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 }
 
 int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
-				unsigned long *addr, pte_t *ptep)
+				unsigned long addr, pte_t *ptep)
 {
 	return 0;
 }
@@ -6910,6 +6899,12 @@ unsigned long hugetlb_mask_last_page(str
 /* See description above.  Architectures can provide their own version. */
 __weak unsigned long hugetlb_mask_last_page(struct hstate *h)
 {
+	unsigned long hp_size = huge_page_size(h);
+
+#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+	if (hp_size == PMD_SIZE)
+		return PUD_SIZE - PMD_SIZE;
+#endif
 	return 0UL;
 }
 
@@ -7136,14 +7131,11 @@ void hugetlb_unshare_all_pmds(struct vm_
 	mmu_notifier_invalidate_range_start(&range);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 	for (address = start; address < end; address += PUD_SIZE) {
-		unsigned long tmp = address;
-
 		ptep = huge_pte_offset(mm, address, sz);
 		if (!ptep)
 			continue;
 		ptl = huge_pte_lock(h, mm, ptep);
-		/* We don't want 'address' to be changed */
-		huge_pmd_unshare(mm, vma, &tmp, ptep);
+		huge_pmd_unshare(mm, vma, address, ptep);
 		spin_unlock(ptl);
 	}
 	flush_hugetlb_tlb_range(vma, start, end);
--- a/mm/rmap.c~hugetlb-do-not-update-address-in-huge_pmd_unshare
+++ a/mm/rmap.c
@@ -1559,7 +1559,7 @@ static bool try_to_unmap_one(struct foli
 			 * do this outside rmap routines.
 			 */
 			VM_BUG_ON(!anon && !(flags & TTU_RMAP_LOCKED));
-			if (!anon && huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
+			if (!anon && huge_pmd_unshare(mm, vma, address, pvmw.pte)) {
 				flush_tlb_range(vma, range.start, range.end);
 				mmu_notifier_invalidate_range(mm, range.start,
 							      range.end);
@@ -1922,7 +1922,7 @@ static bool try_to_migrate_one(struct fo
 			 * do this outside rmap routines.
 			 */
 			VM_BUG_ON(!anon && !(flags & TTU_RMAP_LOCKED));
-			if (!anon && huge_pmd_unshare(mm, vma, &address, pvmw.pte)) {
+			if (!anon && huge_pmd_unshare(mm, vma, address, pvmw.pte)) {
 				flush_tlb_range(vma, range.start, range.end);
 				mmu_notifier_invalidate_range(mm, range.start,
 							      range.end);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-skip-to-end-of-pt-page-mapping-when-pte-not-present.patch
hugetlb-do-not-update-address-in-huge_pmd_unshare.patch
hugetlb-lazy-page-table-copies-in-fork.patch

