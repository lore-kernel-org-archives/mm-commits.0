From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-add-size-parameter-to-huge_pte_offset.patch removed from -mm
 tree
Date: Fri, 07 Jul 2017 12:10:35 -0700
Message-ID: <20170707191035.SN8sMC-2F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34362 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdGGTKy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:10:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, catalin.marinas@arm.com, cmetcalf@mellanox.com, dalias@libc.org, davem@davemloft.net, deller@gmx.de, fenghua.yu@intel.com, heiko.carstens@de.ibm.com, hillf.zj@alibaba-inc.com, hpa@zytor.com, james.hogan@imgtec.com, jejb@parisc-linux.org, kirill.shutemov@linux.intel.com, mark.rutland@arm.com, mhocko@suse.com, mike.kravetz@oracle.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, n-horiguchi@ah.jp.nec.com, paulus@samba.org, punit.agrawal@arm.com, ralf@linux-mips.org, schwidefsky@de.ibm.com, steve.capper@arm.com, tglx@linutronix.de, tony.luck@intel.com, viro@zeniv.linux.org.uk, will.deacon@arm.com, ysato@users.sourceforge.jp


The patch titled
     Subject: mm/hugetlb: add size parameter to huge_pte_offset()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-size-parameter-to-huge_pte_offset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Punit Agrawal <punit.agrawal@arm.com>
Subject: mm/hugetlb: add size parameter to huge_pte_offset()

A poisoned or migrated hugepage is stored as a swap entry in the page
tables.  On architectures that support hugepages consisting of contiguous
page table entries (such as on arm64) this leads to ambiguity in
determining the page table entry to return in huge_pte_offset() when a
poisoned entry is encountered.

Let's remove the ambiguity by adding a size parameter to convey additional
information about the requested address.  Also fixup the definition/usage
of huge_pte_offset() throughout the tree.

Link: http://lkml.kernel.org/r/20170522133604.11392-4-punit.agrawal@arm.com
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Acked-by: Steve Capper <steve.capper@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: James Hogan <james.hogan@imgtec.com> (odd fixer:METAG ARCHITECTURE)
Cc: Ralf Baechle <ralf@linux-mips.org> (supporter:MIPS)
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/hugetlbpage.c   |    3 ++-
 arch/ia64/mm/hugetlbpage.c    |    4 ++--
 arch/metag/mm/hugetlbpage.c   |    3 ++-
 arch/mips/mm/hugetlbpage.c    |    3 ++-
 arch/parisc/mm/hugetlbpage.c  |    3 ++-
 arch/powerpc/mm/hugetlbpage.c |    2 +-
 arch/s390/mm/hugetlbpage.c    |    3 ++-
 arch/sh/mm/hugetlbpage.c      |    3 ++-
 arch/sparc/mm/hugetlbpage.c   |    3 ++-
 arch/tile/mm/hugetlbpage.c    |    3 ++-
 arch/x86/mm/hugetlbpage.c     |    2 +-
 fs/userfaultfd.c              |    7 +++++--
 include/linux/hugetlb.h       |    5 +++--
 mm/hugetlb.c                  |   23 ++++++++++++++---------
 mm/page_vma_mapped.c          |    3 ++-
 mm/pagewalk.c                 |    3 ++-
 16 files changed, 46 insertions(+), 27 deletions(-)

diff -puN arch/arm64/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset arch/arm64/mm/hugetlbpage.c
--- a/arch/arm64/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -131,7 +131,8 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	return pte;
 }
 
-pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
+pte_t *huge_pte_offset(struct mm_struct *mm,
+		       unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
 	pud_t *pud;
diff -puN arch/ia64/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset arch/ia64/mm/hugetlbpage.c
--- a/arch/ia64/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/arch/ia64/mm/hugetlbpage.c
@@ -44,7 +44,7 @@ huge_pte_alloc(struct mm_struct *mm, uns
 }
 
 pte_t *
-huge_pte_offset (struct mm_struct *mm, unsigned long addr)
+huge_pte_offset (struct mm_struct *mm, unsigned long addr, unsigned long sz)
 {
 	unsigned long taddr = htlbpage_to_page(addr);
 	pgd_t *pgd;
@@ -92,7 +92,7 @@ struct page *follow_huge_addr(struct mm_
 	if (REGION_NUMBER(addr) != RGN_HPAGE)
 		return ERR_PTR(-EINVAL);
 
-	ptep = huge_pte_offset(mm, addr);
+	ptep = huge_pte_offset(mm, addr, HPAGE_SIZE);
 	if (!ptep || pte_none(*ptep))
 		return NULL;
 	page = pte_page(*ptep);
diff -puN arch/metag/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset arch/metag/mm/hugetlbpage.c
--- a/arch/metag/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/arch/metag/mm/hugetlbpage.c
@@ -74,7 +74,8 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	return pte;
 }
 
-pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
+pte_t *huge_pte_offset(struct mm_struct *mm,
+		       unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
 	pud_t *pud;
diff -puN arch/mips/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset arch/mips/mm/hugetlbpage.c
--- a/arch/mips/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/arch/mips/mm/hugetlbpage.c
@@ -36,7 +36,8 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	return pte;
 }
 
-pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
+pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr,
+		       unsigned long sz)
 {
 	pgd_t *pgd;
 	pud_t *pud;
diff -puN arch/parisc/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset arch/parisc/mm/hugetlbpage.c
--- a/arch/parisc/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/arch/parisc/mm/hugetlbpage.c
@@ -69,7 +69,8 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	return pte;
 }
 
-pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
+pte_t *huge_pte_offset(struct mm_struct *mm,
+		       unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
 	pud_t *pud;
diff -puN arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -57,7 +57,7 @@ static unsigned nr_gpages;
 
 #define hugepd_none(hpd)	(hpd_val(hpd) == 0)
 
-pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
+pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr, unsigned long sz)
 {
 	/* Only called for hugetlbfs pages, hence can ignore THP */
 	return __find_linux_pte_or_hugepte(mm->pgd, addr, NULL, NULL);
diff -puN arch/s390/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset arch/s390/mm/hugetlbpage.c
--- a/arch/s390/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/arch/s390/mm/hugetlbpage.c
@@ -180,7 +180,8 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	return (pte_t *) pmdp;
 }
 
-pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
+pte_t *huge_pte_offset(struct mm_struct *mm,
+		       unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgdp;
 	p4d_t *p4dp;
diff -puN arch/sh/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset arch/sh/mm/hugetlbpage.c
--- a/arch/sh/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/arch/sh/mm/hugetlbpage.c
@@ -42,7 +42,8 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	return pte;
 }
 
-pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
+pte_t *huge_pte_offset(struct mm_struct *mm,
+		       unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
 	pud_t *pud;
diff -puN arch/sparc/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset arch/sparc/mm/hugetlbpage.c
--- a/arch/sparc/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/arch/sparc/mm/hugetlbpage.c
@@ -277,7 +277,8 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	return pte;
 }
 
-pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
+pte_t *huge_pte_offset(struct mm_struct *mm,
+		       unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
 	pud_t *pud;
diff -puN arch/tile/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset arch/tile/mm/hugetlbpage.c
--- a/arch/tile/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/arch/tile/mm/hugetlbpage.c
@@ -102,7 +102,8 @@ static pte_t *get_pte(pte_t *base, int i
 	return ptep;
 }
 
-pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
+pte_t *huge_pte_offset(struct mm_struct *mm,
+		       unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
 	pud_t *pud;
diff -puN arch/x86/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/arch/x86/mm/hugetlbpage.c
@@ -33,7 +33,7 @@ follow_huge_addr(struct mm_struct *mm, u
 	if (!vma || !is_vm_hugetlb_page(vma))
 		return ERR_PTR(-EINVAL);
 
-	pte = huge_pte_offset(mm, address);
+	pte = huge_pte_offset(mm, address, vma_mmu_pagesize(vma));
 
 	/* hugetlb should be locked, and hence, prefaulted */
 	WARN_ON(!pte || pte_none(*pte));
diff -puN fs/userfaultfd.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset fs/userfaultfd.c
--- a/fs/userfaultfd.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/fs/userfaultfd.c
@@ -214,6 +214,7 @@ static inline struct uffd_msg userfault_
  * hugepmd ranges.
  */
 static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
+					 struct vm_area_struct *vma,
 					 unsigned long address,
 					 unsigned long flags,
 					 unsigned long reason)
@@ -224,7 +225,7 @@ static inline bool userfaultfd_huge_must
 
 	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
 
-	pte = huge_pte_offset(mm, address);
+	pte = huge_pte_offset(mm, address, vma_mmu_pagesize(vma));
 	if (!pte)
 		goto out;
 
@@ -243,6 +244,7 @@ out:
 }
 #else
 static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
+					 struct vm_area_struct *vma,
 					 unsigned long address,
 					 unsigned long flags,
 					 unsigned long reason)
@@ -448,7 +450,8 @@ int handle_userfault(struct vm_fault *vm
 		must_wait = userfaultfd_must_wait(ctx, vmf->address, vmf->flags,
 						  reason);
 	else
-		must_wait = userfaultfd_huge_must_wait(ctx, vmf->address,
+		must_wait = userfaultfd_huge_must_wait(ctx, vmf->vma,
+						       vmf->address,
 						       vmf->flags, reason);
 	up_read(&mm->mmap_sem);
 
diff -puN include/linux/hugetlb.h~mm-hugetlb-add-size-parameter-to-huge_pte_offset include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/include/linux/hugetlb.h
@@ -137,7 +137,8 @@ extern struct list_head huge_boot_pages;
 
 pte_t *huge_pte_alloc(struct mm_struct *mm,
 			unsigned long addr, unsigned long sz);
-pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr);
+pte_t *huge_pte_offset(struct mm_struct *mm,
+		       unsigned long addr, unsigned long sz);
 int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep);
 struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
 			      int write);
@@ -190,7 +191,7 @@ static inline void hugetlb_show_meminfo(
 #define hugetlb_fault(mm, vma, addr, flags)	({ BUG(); 0; })
 #define hugetlb_mcopy_atomic_pte(dst_mm, dst_pte, dst_vma, dst_addr, \
 				src_addr, pagep)	({ BUG(); 0; })
-#define huge_pte_offset(mm, address)	0
+#define huge_pte_offset(mm, address, sz)	0
 static inline int dequeue_hwpoisoned_huge_page(struct page *page)
 {
 	return 0;
diff -puN mm/hugetlb.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/mm/hugetlb.c
@@ -3246,7 +3246,7 @@ int copy_hugetlb_page_range(struct mm_st
 
 	for (addr = vma->vm_start; addr < vma->vm_end; addr += sz) {
 		spinlock_t *src_ptl, *dst_ptl;
-		src_pte = huge_pte_offset(src, addr);
+		src_pte = huge_pte_offset(src, addr, sz);
 		if (!src_pte)
 			continue;
 		dst_pte = huge_pte_alloc(dst, addr, sz);
@@ -3330,7 +3330,7 @@ void __unmap_hugepage_range(struct mmu_g
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	address = start;
 	for (; address < end; address += sz) {
-		ptep = huge_pte_offset(mm, address);
+		ptep = huge_pte_offset(mm, address, sz);
 		if (!ptep)
 			continue;
 
@@ -3548,7 +3548,8 @@ retry_avoidcopy:
 			unmap_ref_private(mm, vma, old_page, address);
 			BUG_ON(huge_pte_none(pte));
 			spin_lock(ptl);
-			ptep = huge_pte_offset(mm, address & huge_page_mask(h));
+			ptep = huge_pte_offset(mm, address & huge_page_mask(h),
+					       huge_page_size(h));
 			if (likely(ptep &&
 				   pte_same(huge_ptep_get(ptep), pte)))
 				goto retry_avoidcopy;
@@ -3587,7 +3588,8 @@ retry_avoidcopy:
 	 * before the page tables are altered
 	 */
 	spin_lock(ptl);
-	ptep = huge_pte_offset(mm, address & huge_page_mask(h));
+	ptep = huge_pte_offset(mm, address & huge_page_mask(h),
+			       huge_page_size(h));
 	if (likely(ptep && pte_same(huge_ptep_get(ptep), pte))) {
 		ClearPagePrivate(new_page);
 
@@ -3874,7 +3876,7 @@ int hugetlb_fault(struct mm_struct *mm,
 
 	address &= huge_page_mask(h);
 
-	ptep = huge_pte_offset(mm, address);
+	ptep = huge_pte_offset(mm, address, huge_page_size(h));
 	if (ptep) {
 		entry = huge_ptep_get(ptep);
 		if (unlikely(is_hugetlb_entry_migration(entry))) {
@@ -4131,7 +4133,8 @@ long follow_hugetlb_page(struct mm_struc
 		 *
 		 * Note that page table lock is not held when pte is null.
 		 */
-		pte = huge_pte_offset(mm, vaddr & huge_page_mask(h));
+		pte = huge_pte_offset(mm, vaddr & huge_page_mask(h),
+				      huge_page_size(h));
 		if (pte)
 			ptl = huge_pte_lock(h, mm, pte);
 		absent = !pte || huge_pte_none(huge_ptep_get(pte));
@@ -4270,7 +4273,7 @@ unsigned long hugetlb_change_protection(
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 	for (; address < end; address += huge_page_size(h)) {
 		spinlock_t *ptl;
-		ptep = huge_pte_offset(mm, address);
+		ptep = huge_pte_offset(mm, address, huge_page_size(h));
 		if (!ptep)
 			continue;
 		ptl = huge_pte_lock(h, mm, ptep);
@@ -4534,7 +4537,8 @@ pte_t *huge_pmd_share(struct mm_struct *
 
 		saddr = page_table_shareable(svma, vma, addr, idx);
 		if (saddr) {
-			spte = huge_pte_offset(svma->vm_mm, saddr);
+			spte = huge_pte_offset(svma->vm_mm, saddr,
+					       vma_mmu_pagesize(svma));
 			if (spte) {
 				get_page(virt_to_page(spte));
 				break;
@@ -4630,7 +4634,8 @@ pte_t *huge_pte_alloc(struct mm_struct *
 	return pte;
 }
 
-pte_t *huge_pte_offset(struct mm_struct *mm, unsigned long addr)
+pte_t *huge_pte_offset(struct mm_struct *mm,
+		       unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
diff -puN mm/page_vma_mapped.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset mm/page_vma_mapped.c
--- a/mm/page_vma_mapped.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/mm/page_vma_mapped.c
@@ -116,7 +116,8 @@ bool page_vma_mapped_walk(struct page_vm
 
 	if (unlikely(PageHuge(pvmw->page))) {
 		/* when pud is not present, pte will be NULL */
-		pvmw->pte = huge_pte_offset(mm, pvmw->address);
+		pvmw->pte = huge_pte_offset(mm, pvmw->address,
+					    PAGE_SIZE << compound_order(page));
 		if (!pvmw->pte)
 			return false;
 
diff -puN mm/pagewalk.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset mm/pagewalk.c
--- a/mm/pagewalk.c~mm-hugetlb-add-size-parameter-to-huge_pte_offset
+++ a/mm/pagewalk.c
@@ -180,12 +180,13 @@ static int walk_hugetlb_range(unsigned l
 	struct hstate *h = hstate_vma(vma);
 	unsigned long next;
 	unsigned long hmask = huge_page_mask(h);
+	unsigned long sz = huge_page_size(h);
 	pte_t *pte;
 	int err = 0;
 
 	do {
 		next = hugetlb_entry_end(h, addr, end);
-		pte = huge_pte_offset(walk->mm, addr & hmask);
+		pte = huge_pte_offset(walk->mm, addr & hmask, sz);
 		if (pte && walk->hugetlb_entry)
 			err = walk->hugetlb_entry(pte, hmask, addr, next, walk);
 		if (err)
_

Patches currently in -mm which might be from punit.agrawal@arm.com are


