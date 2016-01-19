From: akpm@linux-foundation.org
Subject: [merged] mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:13:42 -0800
Message-ID: <569e98f6.xsZtn/twmv5aFLBr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbcASUNn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave@sr71.net, viro@zeniv.linux.org.uk, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax: convert vmf_insert_pfn_pmd() to pfn_t
has been removed from the -mm tree.  Its filename was
     mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm, dax: convert vmf_insert_pfn_pmd() to pfn_t

Similar to the conversion of vm_insert_mixed() use pfn_t in the
vmf_insert_pfn_pmd() to tag the resulting pte with _PAGE_DEVICE when the
pfn is backed by a devm_memremap_pages() mapping.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    5 +++++
 arch/x86/mm/pat.c              |    5 +++--
 fs/dax.c                       |    2 +-
 include/asm-generic/pgtable.h  |    6 ++++--
 include/linux/huge_mm.h        |    2 +-
 include/linux/pfn_t.h          |    8 ++++++++
 mm/huge_memory.c               |   11 +++++++----
 mm/memory.c                    |    2 +-
 8 files changed, 30 insertions(+), 11 deletions(-)

diff -puN arch/x86/include/asm/pgtable.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/arch/x86/include/asm/pgtable.h
@@ -286,6 +286,11 @@ static inline pmd_t pmd_mkdirty(pmd_t pm
 	return pmd_set_flags(pmd, _PAGE_DIRTY | _PAGE_SOFT_DIRTY);
 }
 
+static inline pmd_t pmd_mkdevmap(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_DEVMAP);
+}
+
 static inline pmd_t pmd_mkhuge(pmd_t pmd)
 {
 	return pmd_set_flags(pmd, _PAGE_PSE);
diff -puN arch/x86/mm/pat.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t arch/x86/mm/pat.c
--- a/arch/x86/mm/pat.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/arch/x86/mm/pat.c
@@ -12,6 +12,7 @@
 #include <linux/debugfs.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/pfn_t.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
@@ -949,7 +950,7 @@ int track_pfn_remap(struct vm_area_struc
 }
 
 int track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
-		     unsigned long pfn)
+		     pfn_t pfn)
 {
 	enum page_cache_mode pcm;
 
@@ -957,7 +958,7 @@ int track_pfn_insert(struct vm_area_stru
 		return 0;
 
 	/* Set prot based on lookup */
-	pcm = lookup_memtype((resource_size_t)pfn << PAGE_SHIFT);
+	pcm = lookup_memtype(pfn_t_to_phys(pfn));
 	*prot = __pgprot((pgprot_val(vma->vm_page_prot) & (~_PAGE_CACHE_MASK)) |
 			 cachemode2protval(pcm));
 
diff -puN fs/dax.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t fs/dax.c
--- a/fs/dax.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/fs/dax.c
@@ -693,7 +693,7 @@ int __dax_pmd_fault(struct vm_area_struc
 		dax_unmap_atomic(bdev, &dax);
 
 		result |= vmf_insert_pfn_pmd(vma, address, pmd,
-				pfn_t_to_pfn(dax.pfn), write);
+				dax.pfn, write);
 	}
 
  out:
diff -puN include/asm-generic/pgtable.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/include/asm-generic/pgtable.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_GENERIC_PGTABLE_H
 #define _ASM_GENERIC_PGTABLE_H
 
+#include <linux/pfn.h>
+
 #ifndef __ASSEMBLY__
 #ifdef CONFIG_MMU
 
@@ -549,7 +551,7 @@ static inline int track_pfn_remap(struct
  * by vm_insert_pfn().
  */
 static inline int track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
-				   unsigned long pfn)
+				   pfn_t pfn)
 {
 	return 0;
 }
@@ -584,7 +586,7 @@ extern int track_pfn_remap(struct vm_are
 			   unsigned long pfn, unsigned long addr,
 			   unsigned long size);
 extern int track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
-			    unsigned long pfn);
+			    pfn_t pfn);
 extern int track_pfn_copy(struct vm_area_struct *vma);
 extern void untrack_pfn(struct vm_area_struct *vma, unsigned long pfn,
 			unsigned long size);
diff -puN include/linux/huge_mm.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/include/linux/huge_mm.h
@@ -37,7 +37,7 @@ extern int change_huge_pmd(struct vm_are
 			unsigned long addr, pgprot_t newprot,
 			int prot_numa);
 int vmf_insert_pfn_pmd(struct vm_area_struct *, unsigned long addr, pmd_t *,
-			unsigned long pfn, bool write);
+			pfn_t pfn, bool write);
 
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
diff -puN include/linux/pfn_t.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t include/linux/pfn_t.h
--- a/include/linux/pfn_t.h~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/include/linux/pfn_t.h
@@ -77,6 +77,13 @@ static inline pte_t pfn_t_pte(pfn_t pfn,
 }
 #endif
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline pmd_t pfn_t_pmd(pfn_t pfn, pgprot_t pgprot)
+{
+	return pfn_pmd(pfn_t_to_pfn(pfn), pgprot);
+}
+#endif
+
 #ifdef __HAVE_ARCH_PTE_DEVMAP
 static inline bool pfn_t_devmap(pfn_t pfn)
 {
@@ -90,5 +97,6 @@ static inline bool pfn_t_devmap(pfn_t pf
 	return false;
 }
 pte_t pte_mkdevmap(pte_t pte);
+pmd_t pmd_mkdevmap(pmd_t pmd);
 #endif
 #endif /* _LINUX_PFN_T_H_ */
diff -puN mm/huge_memory.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t mm/huge_memory.c
--- a/mm/huge_memory.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/mm/huge_memory.c
@@ -21,6 +21,7 @@
 #include <linux/kthread.h>
 #include <linux/khugepaged.h>
 #include <linux/freezer.h>
+#include <linux/pfn_t.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
 #include <linux/debugfs.h>
@@ -931,14 +932,16 @@ int do_huge_pmd_anonymous_page(struct mm
 }
 
 static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
-		pmd_t *pmd, unsigned long pfn, pgprot_t prot, bool write)
+		pmd_t *pmd, pfn_t pfn, pgprot_t prot, bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t entry;
 	spinlock_t *ptl;
 
 	ptl = pmd_lock(mm, pmd);
-	entry = pmd_mkhuge(pfn_pmd(pfn, prot));
+	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
+	if (pfn_t_devmap(pfn))
+		entry = pmd_mkdevmap(entry);
 	if (write) {
 		entry = pmd_mkyoung(pmd_mkdirty(entry));
 		entry = maybe_pmd_mkwrite(entry, vma);
@@ -949,7 +952,7 @@ static void insert_pfn_pmd(struct vm_are
 }
 
 int vmf_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
-			pmd_t *pmd, unsigned long pfn, bool write)
+			pmd_t *pmd, pfn_t pfn, bool write)
 {
 	pgprot_t pgprot = vma->vm_page_prot;
 	/*
@@ -961,7 +964,7 @@ int vmf_insert_pfn_pmd(struct vm_area_st
 	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
-	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
+	BUG_ON(!pfn_t_devmap(pfn));
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return VM_FAULT_SIGBUS;
diff -puN mm/memory.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t mm/memory.c
--- a/mm/memory.c~mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t
+++ a/mm/memory.c
@@ -1567,7 +1567,7 @@ int vm_insert_pfn(struct vm_area_struct
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (track_pfn_insert(vma, &pgprot, pfn))
+	if (track_pfn_insert(vma, &pgprot, __pfn_to_pfn_t(pfn, PFN_DEV)))
 		return -EINVAL;
 
 	ret = insert_pfn(vma, addr, __pfn_to_pfn_t(pfn, PFN_DEV), pgprot);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-add-support-for-fsync-sync-v6-fix.patch

