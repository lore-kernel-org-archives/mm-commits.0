Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D02D5E7D0A1
	for <mm-commits@archiver.kernel.org>; Fri, 22 Sep 2023 00:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbjIVAgp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Sep 2023 20:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbjIVAgd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Sep 2023 20:36:33 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CC2CC4
        for <mm-commits@vger.kernel.org>; Thu, 21 Sep 2023 17:36:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C375C433C9;
        Fri, 22 Sep 2023 00:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695342978;
        bh=aESgJwEx6QvurdLlJhrKV44JtUak6nEqoSYZRQv/9OY=;
        h=Date:To:From:Subject:From;
        b=gbOvRVFHmagmpfx+1mX8wdzXz2491xkhXrkDWdwXCd4USLxiRGvgfFQoUuR50z552
         340fUj5pPX6wAt0An4EX8wlcDXKOdRQPsoVJ4dMzndXwSuQ3r+ajcjIdwgu10HWfBZ
         fhw+QFrxenkQerHJQkwDhfrf72nPLqBlpJbuE2Ko=
Date:   Thu, 21 Sep 2023 17:36:17 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        will@kernel.org, urezki@gmail.com, svens@linux.ibm.com,
        sj@kernel.org, peterx@redhat.com, paul.walmsley@sifive.com,
        palmer@dabbelt.com, npiggin@gmail.com, muchun.song@linux.dev,
        mike.kravetz@oracle.com, lstoakes@gmail.com,
        James.Bottomley@HansenPartnership.com, hch@infradead.org,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, deller@gmx.de, davem@davemloft.net,
        christophe.leroy@csgroup.eu, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, axelrasmussen@google.com, arnd@arndb.de,
        aou@eecs.berkeley.edu, anshuman.khandual@arm.com,
        agordeev@linux.ibm.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-convert-set_huge_pte_at-to-take-vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20230922003618.3C375C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: convert set_huge_pte_at() to take vma
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-convert-set_huge_pte_at-to-take-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-convert-set_huge_pte_at-to-take-vma.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: hugetlb: convert set_huge_pte_at() to take vma
Date: Thu, 21 Sep 2023 17:20:05 +0100

In order to fix a bug, arm64 needs access to the vma inside it's
implementation of set_huge_pte_at(). Provide for this by converting the
mm parameter to be a vma. Any implementations that require the mm can
access it via vma->vm_mm.

This commit makes the required modifications to the core mm. Separate
commits update the arches, before the actual bug is fixed in arm64.

No behavioral changes intended.

Link: https://lkml.kernel.org/r/20230921162007.1630149-7-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/hugetlb.h |    6 +++---
 include/linux/hugetlb.h       |    6 +++---
 mm/damon/vaddr.c              |    2 +-
 mm/hugetlb.c                  |   30 +++++++++++++++---------------
 mm/migrate.c                  |    2 +-
 mm/rmap.c                     |   10 +++++-----
 mm/vmalloc.c                  |    5 ++++-
 7 files changed, 32 insertions(+), 29 deletions(-)

--- a/include/asm-generic/hugetlb.h~mm-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/include/asm-generic/hugetlb.h
@@ -75,10 +75,10 @@ static inline void hugetlb_free_pgd_rang
 #endif
 
 #ifndef __HAVE_ARCH_HUGE_SET_HUGE_PTE_AT
-static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
-		pte_t *ptep, pte_t pte)
+static inline void set_huge_pte_at(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t pte)
 {
-	set_pte_at(mm, addr, ptep, pte);
+	set_pte_at(vma->vm_mm, addr, ptep, pte);
 }
 #endif
 
--- a/include/linux/hugetlb.h~mm-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/include/linux/hugetlb.h
@@ -984,7 +984,7 @@ static inline void huge_ptep_modify_prot
 						unsigned long addr, pte_t *ptep,
 						pte_t old_pte, pte_t pte)
 {
-	set_huge_pte_at(vma->vm_mm, addr, ptep, pte);
+	set_huge_pte_at(vma, addr, ptep, pte);
 }
 #endif
 
@@ -1172,8 +1172,8 @@ static inline pte_t huge_ptep_clear_flus
 #endif
 }
 
-static inline void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
-				   pte_t *ptep, pte_t pte)
+static inline void set_huge_pte_at(struct vm_area_struct *vma,
+				   unsigned long addr, pte_t *ptep, pte_t pte)
 {
 }
 
--- a/mm/damon/vaddr.c~mm-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/mm/damon/vaddr.c
@@ -347,7 +347,7 @@ static void damon_hugetlb_mkold(pte_t *p
 	if (pte_young(entry)) {
 		referenced = true;
 		entry = pte_mkold(entry);
-		set_huge_pte_at(mm, addr, pte, entry);
+		set_huge_pte_at(vma, addr, pte, entry);
 	}
 
 #ifdef CONFIG_MMU_NOTIFIER
--- a/mm/hugetlb.c~mm-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/mm/hugetlb.c
@@ -4988,7 +4988,7 @@ hugetlb_install_folio(struct vm_area_str
 	hugepage_add_new_anon_rmap(new_folio, vma, addr);
 	if (userfaultfd_wp(vma) && huge_pte_uffd_wp(old))
 		newpte = huge_pte_mkuffd_wp(newpte);
-	set_huge_pte_at(vma->vm_mm, addr, ptep, newpte);
+	set_huge_pte_at(vma, addr, ptep, newpte);
 	hugetlb_count_add(pages_per_huge_page(hstate_vma(vma)), vma->vm_mm);
 	folio_set_hugetlb_migratable(new_folio);
 }
@@ -5065,7 +5065,7 @@ again:
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry))) {
 			if (!userfaultfd_wp(dst_vma))
 				entry = huge_pte_clear_uffd_wp(entry);
-			set_huge_pte_at(dst, addr, dst_pte, entry);
+			set_huge_pte_at(dst_vma, addr, dst_pte, entry);
 		} else if (unlikely(is_hugetlb_entry_migration(entry))) {
 			swp_entry_t swp_entry = pte_to_swp_entry(entry);
 			bool uffd_wp = pte_swp_uffd_wp(entry);
@@ -5080,17 +5080,17 @@ again:
 				entry = swp_entry_to_pte(swp_entry);
 				if (userfaultfd_wp(src_vma) && uffd_wp)
 					entry = pte_swp_mkuffd_wp(entry);
-				set_huge_pte_at(src, addr, src_pte, entry);
+				set_huge_pte_at(src_vma, addr, src_pte, entry);
 			}
 			if (!userfaultfd_wp(dst_vma))
 				entry = huge_pte_clear_uffd_wp(entry);
-			set_huge_pte_at(dst, addr, dst_pte, entry);
+			set_huge_pte_at(dst_vma, addr, dst_pte, entry);
 		} else if (unlikely(is_pte_marker(entry))) {
 			pte_marker marker = copy_pte_marker(
 				pte_to_swp_entry(entry), dst_vma);
 
 			if (marker)
-				set_huge_pte_at(dst, addr, dst_pte,
+				set_huge_pte_at(dst_vma, addr, dst_pte,
 						make_pte_marker(marker));
 		} else {
 			entry = huge_ptep_get(src_pte);
@@ -5166,7 +5166,7 @@ again:
 			if (!userfaultfd_wp(dst_vma))
 				entry = huge_pte_clear_uffd_wp(entry);
 
-			set_huge_pte_at(dst, addr, dst_pte, entry);
+			set_huge_pte_at(dst_vma, addr, dst_pte, entry);
 			hugetlb_count_add(npages, dst);
 		}
 		spin_unlock(src_ptl);
@@ -5202,7 +5202,7 @@ static void move_huge_pte(struct vm_area
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 
 	pte = huge_ptep_get_and_clear(mm, old_addr, src_pte);
-	set_huge_pte_at(mm, new_addr, dst_pte, pte);
+	set_huge_pte_at(vma, new_addr, dst_pte, pte);
 
 	if (src_ptl != dst_ptl)
 		spin_unlock(src_ptl);
@@ -5336,7 +5336,7 @@ static void __unmap_hugepage_range(struc
 			 */
 			if (pte_swp_uffd_wp_any(pte) &&
 			    !(zap_flags & ZAP_FLAG_DROP_MARKER))
-				set_huge_pte_at(mm, address, ptep,
+				set_huge_pte_at(vma, address, ptep,
 						make_pte_marker(PTE_MARKER_UFFD_WP));
 			else
 				huge_pte_clear(mm, address, ptep, sz);
@@ -5370,7 +5370,7 @@ static void __unmap_hugepage_range(struc
 		/* Leave a uffd-wp pte marker if needed */
 		if (huge_pte_uffd_wp(pte) &&
 		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
-			set_huge_pte_at(mm, address, ptep,
+			set_huge_pte_at(vma, address, ptep,
 					make_pte_marker(PTE_MARKER_UFFD_WP));
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
 		page_remove_rmap(page, vma, true);
@@ -5676,7 +5676,7 @@ retry_avoidcopy:
 		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
 		if (huge_pte_uffd_wp(pte))
 			newpte = huge_pte_mkuffd_wp(newpte);
-		set_huge_pte_at(mm, haddr, ptep, newpte);
+		set_huge_pte_at(vma, haddr, ptep, newpte);
 		folio_set_hugetlb_migratable(new_folio);
 		/* Make the old page be freed below */
 		new_folio = old_folio;
@@ -5972,7 +5972,7 @@ static vm_fault_t hugetlb_no_page(struct
 	 */
 	if (unlikely(pte_marker_uffd_wp(old_pte)))
 		new_pte = huge_pte_mkuffd_wp(new_pte);
-	set_huge_pte_at(mm, haddr, ptep, new_pte);
+	set_huge_pte_at(vma, haddr, ptep, new_pte);
 
 	hugetlb_count_add(pages_per_huge_page(h), mm);
 	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
@@ -6261,7 +6261,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 		}
 
 		_dst_pte = make_pte_marker(PTE_MARKER_POISONED);
-		set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
+		set_huge_pte_at(dst_vma, dst_addr, dst_pte, _dst_pte);
 
 		/* No need to invalidate - it was non-present before */
 		update_mmu_cache(dst_vma, dst_addr, dst_pte);
@@ -6412,7 +6412,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 	if (wp_enabled)
 		_dst_pte = huge_pte_mkuffd_wp(_dst_pte);
 
-	set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
+	set_huge_pte_at(dst_vma, dst_addr, dst_pte, _dst_pte);
 
 	hugetlb_count_add(pages_per_huge_page(h), dst_mm);
 
@@ -6598,7 +6598,7 @@ long hugetlb_change_protection(struct vm
 			else if (uffd_wp_resolve)
 				newpte = pte_swp_clear_uffd_wp(newpte);
 			if (!pte_same(pte, newpte))
-				set_huge_pte_at(mm, address, ptep, newpte);
+				set_huge_pte_at(vma, address, ptep, newpte);
 		} else if (unlikely(is_pte_marker(pte))) {
 			/* No other markers apply for now. */
 			WARN_ON_ONCE(!pte_marker_uffd_wp(pte));
@@ -6622,7 +6622,7 @@ long hugetlb_change_protection(struct vm
 			/* None pte */
 			if (unlikely(uffd_wp))
 				/* Safe to modify directly (none->non-present). */
-				set_huge_pte_at(mm, address, ptep,
+				set_huge_pte_at(vma, address, ptep,
 						make_pte_marker(PTE_MARKER_UFFD_WP));
 		}
 		spin_unlock(ptl);
--- a/mm/migrate.c~mm-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/mm/migrate.c
@@ -251,7 +251,7 @@ static bool remove_migration_pte(struct
 						       rmap_flags);
 			else
 				page_dup_file_rmap(new, true);
-			set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
+			set_huge_pte_at(vma, pvmw.address, pvmw.pte, pte);
 		} else
 #endif
 		{
--- a/mm/rmap.c~mm-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/mm/rmap.c
@@ -1628,7 +1628,7 @@ static bool try_to_unmap_one(struct foli
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
-				set_huge_pte_at(mm, address, pvmw.pte, pteval);
+				set_huge_pte_at(vma, address, pvmw.pte, pteval);
 			} else {
 				dec_mm_counter(mm, mm_counter(&folio->page));
 				set_pte_at(mm, address, pvmw.pte, pteval);
@@ -2020,7 +2020,7 @@ static bool try_to_migrate_one(struct fo
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
-				set_huge_pte_at(mm, address, pvmw.pte, pteval);
+				set_huge_pte_at(vma, address, pvmw.pte, pteval);
 			} else {
 				dec_mm_counter(mm, mm_counter(&folio->page));
 				set_pte_at(mm, address, pvmw.pte, pteval);
@@ -2044,7 +2044,7 @@ static bool try_to_migrate_one(struct fo
 
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
 				if (folio_test_hugetlb(folio))
-					set_huge_pte_at(mm, address, pvmw.pte, pteval);
+					set_huge_pte_at(vma, address, pvmw.pte, pteval);
 				else
 					set_pte_at(mm, address, pvmw.pte, pteval);
 				ret = false;
@@ -2058,7 +2058,7 @@ static bool try_to_migrate_one(struct fo
 			if (anon_exclusive &&
 			    page_try_share_anon_rmap(subpage)) {
 				if (folio_test_hugetlb(folio))
-					set_huge_pte_at(mm, address, pvmw.pte, pteval);
+					set_huge_pte_at(vma, address, pvmw.pte, pteval);
 				else
 					set_pte_at(mm, address, pvmw.pte, pteval);
 				ret = false;
@@ -2090,7 +2090,7 @@ static bool try_to_migrate_one(struct fo
 			if (pte_uffd_wp(pteval))
 				swp_pte = pte_swp_mkuffd_wp(swp_pte);
 			if (folio_test_hugetlb(folio))
-				set_huge_pte_at(mm, address, pvmw.pte, swp_pte);
+				set_huge_pte_at(vma, address, pvmw.pte, swp_pte);
 			else
 				set_pte_at(mm, address, pvmw.pte, swp_pte);
 			trace_set_migration_pte(address, pte_val(swp_pte),
--- a/mm/vmalloc.c~mm-hugetlb-convert-set_huge_pte_at-to-take-vma
+++ a/mm/vmalloc.c
@@ -94,6 +94,9 @@ static int vmap_pte_range(pmd_t *pmd, un
 			phys_addr_t phys_addr, pgprot_t prot,
 			unsigned int max_page_shift, pgtbl_mod_mask *mask)
 {
+#ifdef CONFIG_HUGETLB_PAGE
+	struct vm_area_struct vma = TLB_FLUSH_VMA(&init_mm, 0);
+#endif
 	pte_t *pte;
 	u64 pfn;
 	unsigned long size = PAGE_SIZE;
@@ -111,7 +114,7 @@ static int vmap_pte_range(pmd_t *pmd, un
 			pte_t entry = pfn_pte(pfn, prot);
 
 			entry = arch_make_huge_pte(entry, ilog2(size), 0);
-			set_huge_pte_at(&init_mm, addr, pte, entry);
+			set_huge_pte_at(&vma, addr, pte, entry);
 			pfn += PFN_DOWN(size);
 			continue;
 		}
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

parisc-hugetlb-convert-set_huge_pte_at-to-take-vma.patch
powerpc-hugetlb-convert-set_huge_pte_at-to-take-vma.patch
riscv-hugetlb-convert-set_huge_pte_at-to-take-vma.patch
s390-hugetlb-convert-set_huge_pte_at-to-take-vma.patch
sparc-hugetlb-convert-set_huge_pte_at-to-take-vma.patch
mm-hugetlb-convert-set_huge_pte_at-to-take-vma.patch
arm64-hugetlb-convert-set_huge_pte_at-to-take-vma.patch
arm64-hugetlb-fix-set_huge_pte_at-to-work-with-all-swap-entries.patch

