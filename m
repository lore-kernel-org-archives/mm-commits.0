From: akpm@linux-foundation.org
Subject: [merged]
 mmu_notifier-call-mmu_notifier_invalidate_range-from-vmm.patch removed from -mm tree
Date: Fri, 21 Nov 2014 12:33:21 -0800
Message-ID: <546fa191.6tT3foMlsP1di0Ut%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaKUUdW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Nov 2014 15:33:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jroedel@suse.de, Jay.Cornwall@amd.com, Oded.Gabbay@amd.com, Suravee.Suthikulpanit@amd.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, dwmw2@infradead.org, hughd@google.com, jbarnes@virtuousgeek.org, jglisse@redhat.com, jweiner@redhat.com, mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mmu_notifier: call mmu_notifier_invalidate_range() from V=
MM
has been removed from the -mm tree.  Its filename was
     mmu_notifier-call-mmu_notifier_invalidate_range-from-vmm.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Joerg Roedel <jroedel@suse.de>
Subject: mmu_notifier: call mmu_notifier_invalidate_range() from VMM

Add calls to the new mmu_notifier_invalidate_range() function to all
places in the VMM that need it.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: J=E9r=F4me Glisse <jglisse@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Jay Cornwall <Jay.Cornwall@amd.com>
Cc: Oded Gabbay <Oded.Gabbay@amd.com>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   41 +++++++++++++++++++++++++++++++++
 kernel/events/uprobes.c      |    2 -
 mm/fremap.c                  |    2 -
 mm/huge_memory.c             |    9 ++++---
 mm/hugetlb.c                 |    7 ++++-
 mm/ksm.c                     |    4 +--
 mm/memory.c                  |    3 +-
 mm/migrate.c                 |    3 +-
 mm/rmap.c                    |    2 -
 9 files changed, 61 insertions(+), 12 deletions(-)

diff -puN include/linux/mmu_notifier.h~mmu_notifier-call-mmu_notifier_i=
nvalidate_range-from-vmm include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mmu_notifier-call-mmu_notifier_inval=
idate_range-from-vmm
+++ a/include/linux/mmu_notifier.h
@@ -284,6 +284,44 @@ static inline void mmu_notifier_mm_destr
 	__young;							\
 })
=20
+#define	ptep_clear_flush_notify(__vma, __address, __ptep)		\
+({									\
+	unsigned long ___addr =3D __address & PAGE_MASK;			\
+	struct mm_struct *___mm =3D (__vma)->vm_mm;			\
+	pte_t ___pte;							\
+									\
+	___pte =3D ptep_clear_flush(__vma, __address, __ptep);		\
+	mmu_notifier_invalidate_range(___mm, ___addr,			\
+					___addr + PAGE_SIZE);		\
+									\
+	___pte;								\
+})
+
+#define pmdp_clear_flush_notify(__vma, __haddr, __pmd)			\
+({									\
+	unsigned long ___haddr =3D __haddr & HPAGE_PMD_MASK;		\
+	struct mm_struct *___mm =3D (__vma)->vm_mm;			\
+	pmd_t ___pmd;							\
+									\
+	___pmd =3D pmdp_clear_flush(__vma, __haddr, __pmd);		\
+	mmu_notifier_invalidate_range(___mm, ___haddr,			\
+				      ___haddr + HPAGE_PMD_SIZE);	\
+									\
+	___pmd;								\
+})
+
+#define pmdp_get_and_clear_notify(__mm, __haddr, __pmd)			\
+({									\
+	unsigned long ___haddr =3D __haddr & HPAGE_PMD_MASK;		\
+	pmd_t ___pmd;							\
+									\
+	___pmd =3D pmdp_get_and_clear(__mm, __haddr, __pmd);		\
+	mmu_notifier_invalidate_range(__mm, ___haddr,			\
+				      ___haddr + HPAGE_PMD_SIZE);	\
+									\
+	___pmd;								\
+})
+
 /*
  * set_pte_at_notify() sets the pte _after_ running the notifier.
  * This is safe to start by updating the secondary MMUs, because the p=
rimary MMU
@@ -362,6 +400,9 @@ static inline void mmu_notifier_mm_destr
=20
 #define ptep_clear_flush_young_notify ptep_clear_flush_young
 #define pmdp_clear_flush_young_notify pmdp_clear_flush_young
+#define	ptep_clear_flush_notify ptep_clear_flush
+#define pmdp_clear_flush_notify pmdp_clear_flush
+#define pmdp_get_and_clear_notify pmdp_get_and_clear
 #define set_pte_at_notify set_pte_at
=20
 #endif /* CONFIG_MMU_NOTIFIER */
diff -puN kernel/events/uprobes.c~mmu_notifier-call-mmu_notifier_invali=
date_range-from-vmm kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~mmu_notifier-call-mmu_notifier_invalidate=
_range-from-vmm
+++ a/kernel/events/uprobes.c
@@ -193,7 +193,7 @@ static int __replace_page(struct vm_area
 	}
=20
 	flush_cache_page(vma, addr, pte_pfn(*ptep));
-	ptep_clear_flush(vma, addr, ptep);
+	ptep_clear_flush_notify(vma, addr, ptep);
 	set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));
=20
 	page_remove_rmap(page);
diff -puN mm/fremap.c~mmu_notifier-call-mmu_notifier_invalidate_range-f=
rom-vmm mm/fremap.c
--- a/mm/fremap.c~mmu_notifier-call-mmu_notifier_invalidate_range-from-=
vmm
+++ a/mm/fremap.c
@@ -37,7 +37,7 @@ static void zap_pte(struct mm_struct *mm
=20
 	if (pte_present(pte)) {
 		flush_cache_page(vma, addr, pte_pfn(pte));
-		pte =3D ptep_clear_flush(vma, addr, ptep);
+		pte =3D ptep_clear_flush_notify(vma, addr, ptep);
 		page =3D vm_normal_page(vma, addr, pte);
 		if (page) {
 			if (pte_dirty(pte))
diff -puN mm/huge_memory.c~mmu_notifier-call-mmu_notifier_invalidate_ra=
nge-from-vmm mm/huge_memory.c
--- a/mm/huge_memory.c~mmu_notifier-call-mmu_notifier_invalidate_range-=
from-vmm
+++ a/mm/huge_memory.c
@@ -1035,7 +1035,7 @@ static int do_huge_pmd_wp_page_fallback(
 		goto out_free_pages;
 	VM_BUG_ON_PAGE(!PageHead(page), page);
=20
-	pmdp_clear_flush(vma, haddr, pmd);
+	pmdp_clear_flush_notify(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
=20
 	pgtable =3D pgtable_trans_huge_withdraw(mm, pmd);
@@ -1178,7 +1178,7 @@ alloc:
 		pmd_t entry;
 		entry =3D mk_huge_pmd(new_page, vma->vm_page_prot);
 		entry =3D maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		pmdp_clear_flush(vma, haddr, pmd);
+		pmdp_clear_flush_notify(vma, haddr, pmd);
 		page_add_new_anon_rmap(new_page, vma, haddr);
 		mem_cgroup_commit_charge(new_page, memcg, false);
 		lru_cache_add_active_or_unevictable(new_page, vma);
@@ -1511,7 +1511,7 @@ int change_huge_pmd(struct vm_area_struc
 		pmd_t entry;
 		ret =3D 1;
 		if (!prot_numa) {
-			entry =3D pmdp_get_and_clear(mm, addr, pmd);
+			entry =3D pmdp_get_and_clear_notify(mm, addr, pmd);
 			if (pmd_numa(entry))
 				entry =3D pmd_mknonnuma(entry);
 			entry =3D pmd_modify(entry, newprot);
@@ -1643,6 +1643,7 @@ static int __split_huge_page_splitting(s
 		 * serialize against split_huge_page*.
 		 */
 		pmdp_splitting_flush(vma, address, pmd);
+
 		ret =3D 1;
 		spin_unlock(ptl);
 	}
@@ -2833,7 +2834,7 @@ static void __split_huge_zero_page_pmd(s
 	pmd_t _pmd;
 	int i;
=20
-	pmdp_clear_flush(vma, haddr, pmd);
+	pmdp_clear_flush_notify(vma, haddr, pmd);
 	/* leave pmd empty until pte is filled */
=20
 	pgtable =3D pgtable_trans_huge_withdraw(mm, pmd);
diff -puN mm/hugetlb.c~mmu_notifier-call-mmu_notifier_invalidate_range-=
from-vmm mm/hugetlb.c
--- a/mm/hugetlb.c~mmu_notifier-call-mmu_notifier_invalidate_range-from=
-vmm
+++ a/mm/hugetlb.c
@@ -2598,8 +2598,11 @@ int copy_hugetlb_page_range(struct mm_st
 			}
 			set_huge_pte_at(dst, addr, dst_pte, entry);
 		} else {
-			if (cow)
+			if (cow) {
 				huge_ptep_set_wrprotect(src, addr, src_pte);
+				mmu_notifier_invalidate_range(src, mmun_start,
+								   mmun_end);
+			}
 			entry =3D huge_ptep_get(src_pte);
 			ptepage =3D pte_page(entry);
 			get_page(ptepage);
@@ -2899,6 +2902,7 @@ retry_avoidcopy:
=20
 		/* Break COW */
 		huge_ptep_clear_flush(vma, address, ptep);
+		mmu_notifier_invalidate_range(mm, mmun_start, mmun_end);
 		set_huge_pte_at(mm, address, ptep,
 				make_huge_pte(vma, new_page, 1));
 		page_remove_rmap(old_page);
@@ -3374,6 +3378,7 @@ unsigned long hugetlb_change_protection(
 	 * and that page table be reused and filled with junk.
 	 */
 	flush_tlb_range(vma, start, end);
+	mmu_notifier_invalidate_range(mm, start, end);
 	mutex_unlock(&vma->vm_file->f_mapping->i_mmap_mutex);
 	mmu_notifier_invalidate_range_end(mm, start, end);
=20
diff -puN mm/ksm.c~mmu_notifier-call-mmu_notifier_invalidate_range-from=
-vmm mm/ksm.c
--- a/mm/ksm.c~mmu_notifier-call-mmu_notifier_invalidate_range-from-vmm
+++ a/mm/ksm.c
@@ -892,7 +892,7 @@ static int write_protect_page(struct vm_
 		 * this assure us that no O_DIRECT can happen after the check
 		 * or in the middle of the check.
 		 */
-		entry =3D ptep_clear_flush(vma, addr, ptep);
+		entry =3D ptep_clear_flush_notify(vma, addr, ptep);
 		/*
 		 * Check that no O_DIRECT or similar I/O is in progress on the
 		 * page
@@ -960,7 +960,7 @@ static int replace_page(struct vm_area_s
 	page_add_anon_rmap(kpage, vma, addr);
=20
 	flush_cache_page(vma, addr, pte_pfn(*ptep));
-	ptep_clear_flush(vma, addr, ptep);
+	ptep_clear_flush_notify(vma, addr, ptep);
 	set_pte_at_notify(mm, addr, ptep, mk_pte(kpage, vma->vm_page_prot));
=20
 	page_remove_rmap(page);
diff -puN mm/memory.c~mmu_notifier-call-mmu_notifier_invalidate_range-f=
rom-vmm mm/memory.c
--- a/mm/memory.c~mmu_notifier-call-mmu_notifier_invalidate_range-from-=
vmm
+++ a/mm/memory.c
@@ -238,6 +238,7 @@ static void tlb_flush_mmu_tlbonly(struct
 {
 	tlb->need_flush =3D 0;
 	tlb_flush(tlb);
+	mmu_notifier_invalidate_range(tlb->mm, tlb->start, tlb->end);
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
 	tlb_table_flush(tlb);
 #endif
@@ -2234,7 +2235,7 @@ gotten:
 		 * seen in the presence of one thread doing SMC and another
 		 * thread doing COW.
 		 */
-		ptep_clear_flush(vma, address, page_table);
+		ptep_clear_flush_notify(vma, address, page_table);
 		page_add_new_anon_rmap(new_page, vma, address);
 		mem_cgroup_commit_charge(new_page, memcg, false);
 		lru_cache_add_active_or_unevictable(new_page, vma);
diff -puN mm/migrate.c~mmu_notifier-call-mmu_notifier_invalidate_range-=
from-vmm mm/migrate.c
--- a/mm/migrate.c~mmu_notifier-call-mmu_notifier_invalidate_range-from=
-vmm
+++ a/mm/migrate.c
@@ -1854,7 +1854,7 @@ fail_putback:
 	 */
 	flush_cache_range(vma, mmun_start, mmun_end);
 	page_add_anon_rmap(new_page, vma, mmun_start);
-	pmdp_clear_flush(vma, mmun_start, pmd);
+	pmdp_clear_flush_notify(vma, mmun_start, pmd);
 	set_pmd_at(mm, mmun_start, pmd, entry);
 	flush_tlb_range(vma, mmun_start, mmun_end);
 	update_mmu_cache_pmd(vma, address, &entry);
@@ -1862,6 +1862,7 @@ fail_putback:
 	if (page_count(page) !=3D 2) {
 		set_pmd_at(mm, mmun_start, pmd, orig_entry);
 		flush_tlb_range(vma, mmun_start, mmun_end);
+		mmu_notifier_invalidate_range(mm, mmun_start, mmun_end);
 		update_mmu_cache_pmd(vma, address, &entry);
 		page_remove_rmap(new_page);
 		goto fail_putback;
diff -puN mm/rmap.c~mmu_notifier-call-mmu_notifier_invalidate_range-fro=
m-vmm mm/rmap.c
--- a/mm/rmap.c~mmu_notifier-call-mmu_notifier_invalidate_range-from-vm=
m
+++ a/mm/rmap.c
@@ -1378,7 +1378,7 @@ static int try_to_unmap_cluster(unsigned
=20
 		/* Nuke the page table entry. */
 		flush_cache_page(vma, address, pte_pfn(*pte));
-		pteval =3D ptep_clear_flush(vma, address, pte);
+		pteval =3D ptep_clear_flush_notify(vma, address, pte);
=20
 		/* If nonlinear, store the file page offset in the pte. */
 		if (page->index !=3D linear_page_index(vma, address)) {
_

Patches currently in -mm which might be from jroedel@suse.de are

mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use.patch
iommu-amd-use-handle_mm_fault-directly-v2.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
