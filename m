Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62EA2CCA485
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbiGRASO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbiGRARR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:17:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC9213CDF
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:17:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FDE460F0B
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DBEC385A5;
        Mon, 18 Jul 2022 00:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103431;
        bh=eS98tXDT63rzJS+blBSpz4ersjvBv37Q8HEyqW2i9V8=;
        h=Date:To:From:Subject:From;
        b=S1ANFN61d0sVITnaO6wfJkTydw8zCawSu4neZuF66f9GxFJuBAtshvD2MqtkUGYJO
         xsTeG0cZdWLHTdmhR0xs0W2lvyKOjn8xZVAQQ5omA8K6/cjtKyA6a9rIHydXZxWOyc
         PNfFEvmiEP4R1RgZplk2JcJGeI5n41gnKBtO8WFM=
Date:   Sun, 17 Jul 2022 17:17:10 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        songmuchun@bytedance.com, sfr@canb.auug.org.au, peterx@redhat.com,
        paul.walmsley@sifive.com, naoya.horiguchi@linux.dev,
        mhocko@suse.com, lkp@intel.com, jthoughton@google.com,
        eike-kernel@sf-tec.de, david@redhat.com, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, baolin.wang@linux.alibaba.com,
        anshuman.khandual@arm.com, aneesh.kumar@linux.vnet.ibm.com,
        almasrymina@google.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-do-not-update-address-in-huge_pmd_unshare.patch removed from -mm tree
Message-Id: <20220718001710.E0DBEC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: do not update address in huge_pmd_unshare
has been removed from the -mm tree.  Its filename was
     hugetlb-do-not-update-address-in-huge_pmd_unshare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[sfr@canb.auug.org.au: fix an unused variable warning/error]
  Link: https://lkml.kernel.org/r/20220622171117.70850960@canb.auug.org.au
Link: https://lkml.kernel.org/r/20220621235620.291305-4-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
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
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 +--
 mm/hugetlb.c            |   44 ++++++++++++++------------------------
 mm/rmap.c               |    4 +--
 3 files changed, 21 insertions(+), 31 deletions(-)

--- a/include/linux/hugetlb.h~hugetlb-do-not-update-address-in-huge_pmd_unshare
+++ a/include/linux/hugetlb.h
@@ -196,7 +196,7 @@ pte_t *huge_pte_offset(struct mm_struct
 		       unsigned long addr, unsigned long sz);
 unsigned long hugetlb_mask_last_page(struct hstate *h);
 int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
-				unsigned long *addr, pte_t *ptep);
+				unsigned long addr, pte_t *ptep);
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end);
 struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
@@ -243,7 +243,7 @@ static inline struct address_space *huge
 
 static inline int huge_pmd_unshare(struct mm_struct *mm,
 					struct vm_area_struct *vma,
-					unsigned long *addr, pte_t *ptep)
+					unsigned long addr, pte_t *ptep)
 {
 	return 0;
 }
--- a/mm/hugetlb.c~hugetlb-do-not-update-address-in-huge_pmd_unshare
+++ a/mm/hugetlb.c
@@ -4935,7 +4935,6 @@ int move_hugetlb_page_tables(struct vm_a
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long old_end = old_addr + len;
 	unsigned long last_addr_mask;
-	unsigned long old_addr_copy;
 	pte_t *src_pte, *dst_pte;
 	struct mmu_notifier_range range;
 	bool shared_pmd = false;
@@ -4963,14 +4962,10 @@ int move_hugetlb_page_tables(struct vm_a
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
 
@@ -5035,10 +5030,11 @@ static void __unmap_hugepage_range(struc
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
 
@@ -6327,7 +6323,7 @@ unsigned long hugetlb_change_protection(
 			continue;
 		}
 		ptl = huge_pte_lock(h, mm, ptep);
-		if (huge_pmd_unshare(mm, vma, &address, ptep)) {
+		if (huge_pmd_unshare(mm, vma, address, ptep)) {
 			/*
 			 * When uffd-wp is enabled on the vma, unshare
 			 * shouldn't happen at all.  Warn about it if it
@@ -6337,6 +6333,7 @@ unsigned long hugetlb_change_protection(
 			pages++;
 			spin_unlock(ptl);
 			shared_pmd = true;
+			address |= last_addr_mask;
 			continue;
 		}
 		pte = huge_ptep_get(ptep);
@@ -6759,11 +6756,11 @@ out:
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
@@ -6773,14 +6770,6 @@ int huge_pmd_unshare(struct mm_struct *m
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
 
@@ -6792,7 +6781,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 }
 
 int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
-				unsigned long *addr, pte_t *ptep)
+				unsigned long addr, pte_t *ptep)
 {
 	return 0;
 }
@@ -6899,6 +6888,10 @@ unsigned long hugetlb_mask_last_page(str
 /* See description above.  Architectures can provide their own version. */
 __weak unsigned long hugetlb_mask_last_page(struct hstate *h)
 {
+#ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
+	if (huge_page_size(h) == PMD_SIZE)
+		return PUD_SIZE - PMD_SIZE;
+#endif
 	return 0UL;
 }
 
@@ -7125,14 +7118,11 @@ void hugetlb_unshare_all_pmds(struct vm_
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
@@ -1920,7 +1920,7 @@ static bool try_to_migrate_one(struct fo
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


