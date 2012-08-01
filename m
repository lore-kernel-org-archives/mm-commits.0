From: akpm@linux-foundation.org
Subject: + mm-x86-pat-rework-linear-pfn-mmap-tracking.patch added to -mm tree
Date: Wed, 01 Aug 2012 15:28:34 -0700
Message-ID: <20120801222834.E97F5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:59553 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab2HAW2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 18:28:37 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5494219obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 15:28:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, a.p.zijlstra@chello.nl, cmetcalf@tilera.com, cotte@de.ibm.com, eparis@redhat.com, gorcunov@openvz.org, hpa@zytor.com, hughd@google.com, james.l.morris@oracle.com, jbaron@redhat.com, matthltc@us.ibm.com, mingo@redhat.com, npiggin@kernel.dk, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, robert.richter@amd.com, suresh.b.siddha@intel.com, takedakn@nttdata.co.jp, torvalds@linux-foundation.org, venki@google.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: mm, x86, pat: rework linear pfn-mmap tracking
has been added to the -mm tree.  Its filename is
     mm-x86-pat-rework-linear-pfn-mmap-tracking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm, x86, pat: rework linear pfn-mmap tracking

Replace the generic vma-flag VM_PFN_AT_MMAP with x86-only VM_PAT.

We can toss mapping address from remap_pfn_range() into
track_pfn_vma_new(), and collect all PAT-related logic together in
arch/x86/.

This patch also restores orignal frustration-free is_cow_mapping() check
in remap_pfn_range(), as it was before commit v2.6.28-rc8-88-g3c8bb73
("x86: PAT: store vm_pgoff for all linear_over_vma_region mappings - v3")

is_linear_pfn_mapping() checks can be removed from mm/huge_memory.c,
because it already handled by VM_PFNMAP in VM_NO_THP bit-mask.

[suresh.b.siddha@intel.com: Reset the VM_PAT flag as part of untrack_pfn_vma()]
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Carsten Otte <cotte@de.ibm.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Eric Paris <eparis@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Venkatesh Pallipadi <venki@google.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pat.c             |   17 ++++++++++++-----
 include/asm-generic/pgtable.h |    6 ++++--
 include/linux/mm.h            |   20 +-------------------
 mm/huge_memory.c              |   19 +++----------------
 mm/memory.c                   |   26 ++++++++++----------------
 5 files changed, 30 insertions(+), 58 deletions(-)

diff -puN arch/x86/mm/pat.c~mm-x86-pat-rework-linear-pfn-mmap-tracking arch/x86/mm/pat.c
--- a/arch/x86/mm/pat.c~mm-x86-pat-rework-linear-pfn-mmap-tracking
+++ a/arch/x86/mm/pat.c
@@ -677,7 +677,7 @@ int track_pfn_copy(struct vm_area_struct
 	unsigned long vma_size = vma->vm_end - vma->vm_start;
 	pgprot_t pgprot;
 
-	if (is_linear_pfn_mapping(vma)) {
+	if (vma->vm_flags & VM_PAT) {
 		/*
 		 * reserve the whole chunk covered by vma. We need the
 		 * starting address and protection from pte.
@@ -699,14 +699,20 @@ int track_pfn_copy(struct vm_area_struct
  * single reserve_pfn_range call.
  */
 int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
-		    unsigned long pfn, unsigned long size)
+		    unsigned long pfn, unsigned long addr, unsigned long size)
 {
 	resource_size_t paddr = (resource_size_t)pfn << PAGE_SHIFT;
 	unsigned long flags;
 
 	/* reserve the whole chunk starting from paddr */
-	if (is_linear_pfn_mapping(vma))
-		return reserve_pfn_range(paddr, size, prot, 0);
+	if (addr == vma->vm_start && size == (vma->vm_end - vma->vm_start)) {
+		int ret;
+
+		ret = reserve_pfn_range(paddr, size, prot, 0);
+		if (!ret)
+			vma->vm_flags |= VM_PAT;
+		return ret;
+	}
 
 	if (!pat_enabled)
 		return 0;
@@ -758,7 +764,7 @@ void untrack_pfn(struct vm_area_struct *
 	resource_size_t paddr;
 	unsigned long prot;
 
-	if (!is_linear_pfn_mapping(vma))
+	if (!(vma->vm_flags & VM_PAT))
 		return;
 
 	/* free the chunk starting from pfn or the whole chunk */
@@ -772,6 +778,7 @@ void untrack_pfn(struct vm_area_struct *
 		size = vma->vm_end - vma->vm_start;
 	}
 	free_pfn_range(paddr, size);
+	vma->vm_flags &= ~VM_PAT;
 }
 
 pgprot_t pgprot_writecombine(pgprot_t prot)
diff -puN include/asm-generic/pgtable.h~mm-x86-pat-rework-linear-pfn-mmap-tracking include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-x86-pat-rework-linear-pfn-mmap-tracking
+++ a/include/asm-generic/pgtable.h
@@ -391,7 +391,8 @@ static inline void ptep_modify_prot_comm
  * by remap_pfn_range() for physical range indicated by pfn and size.
  */
 static inline int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
-				  unsigned long pfn, unsigned long size)
+				  unsigned long pfn, unsigned long addr,
+				  unsigned long size)
 {
 	return 0;
 }
@@ -426,7 +427,8 @@ static inline void untrack_pfn(struct vm
 }
 #else
 extern int track_pfn_remap(struct vm_area_struct *vma, pgprot_t *prot,
-			   unsigned long pfn, unsigned long size);
+			   unsigned long pfn, unsigned long addr,
+			   unsigned long size);
 extern int track_pfn_insert(struct vm_area_struct *vma, pgprot_t *prot,
 			    unsigned long pfn);
 extern int track_pfn_copy(struct vm_area_struct *vma);
diff -puN include/linux/mm.h~mm-x86-pat-rework-linear-pfn-mmap-tracking include/linux/mm.h
--- a/include/linux/mm.h~mm-x86-pat-rework-linear-pfn-mmap-tracking
+++ a/include/linux/mm.h
@@ -117,7 +117,7 @@ extern unsigned int kobjsize(const void 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
 #define VM_SAO		0x20000000	/* Strong Access Ordering (powerpc) */
-#define VM_PFN_AT_MMAP	0x40000000	/* PFNMAP vma that is fully mapped at mmap time */
+#define VM_PAT		0x40000000	/* PAT reserves whole VMA at once (x86) */
 #define VM_MERGEABLE	0x80000000	/* KSM may merge identical pages */
 
 /* Bits set in the VMA until the stack is in its final location */
@@ -159,24 +159,6 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_KILLABLE	0x20	/* The fault task is in SIGKILL killable region */
 
 /*
- * This interface is used by x86 PAT code to identify a pfn mapping that is
- * linear over entire vma. This is to optimize PAT code that deals with
- * marking the physical region with a particular prot. This is not for generic
- * mm use. Note also that this check will not work if the pfn mapping is
- * linear for a vma starting at physical address 0. In which case PAT code
- * falls back to slow path of reserving physical range page by page.
- */
-static inline int is_linear_pfn_mapping(struct vm_area_struct *vma)
-{
-	return !!(vma->vm_flags & VM_PFN_AT_MMAP);
-}
-
-static inline int is_pfn_mapping(struct vm_area_struct *vma)
-{
-	return !!(vma->vm_flags & VM_PFNMAP);
-}
-
-/*
  * vm_fault is filled by the the pagefault handler and passed to the vma's
  * ->fault function. The vma's ->fault is responsible for returning a bitmask
  * of VM_FAULT_xxx flags that give details about how the fault was handled.
diff -puN mm/huge_memory.c~mm-x86-pat-rework-linear-pfn-mmap-tracking mm/huge_memory.c
--- a/mm/huge_memory.c~mm-x86-pat-rework-linear-pfn-mmap-tracking
+++ a/mm/huge_memory.c
@@ -1655,11 +1655,7 @@ int khugepaged_enter_vma_merge(struct vm
 	if (vma->vm_ops)
 		/* khugepaged not yet working on file or special mappings */
 		return 0;
-	/*
-	 * If is_pfn_mapping() is true is_learn_pfn_mapping() must be
-	 * true too, verify it here.
-	 */
-	VM_BUG_ON(is_linear_pfn_mapping(vma) || vma->vm_flags & VM_NO_THP);
+	VM_BUG_ON(vma->vm_flags & VM_NO_THP);
 	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 	hend = vma->vm_end & HPAGE_PMD_MASK;
 	if (hstart < hend)
@@ -1913,11 +1909,7 @@ static void collapse_huge_page(struct mm
 		goto out;
 	if (is_vma_temporary_stack(vma))
 		goto out;
-	/*
-	 * If is_pfn_mapping() is true is_learn_pfn_mapping() must be
-	 * true too, verify it here.
-	 */
-	VM_BUG_ON(is_linear_pfn_mapping(vma) || vma->vm_flags & VM_NO_THP);
+	VM_BUG_ON(vma->vm_flags & VM_NO_THP);
 
 	pgd = pgd_offset(mm, address);
 	if (!pgd_present(*pgd))
@@ -2155,12 +2147,7 @@ static unsigned int khugepaged_scan_mm_s
 			goto skip;
 		if (is_vma_temporary_stack(vma))
 			goto skip;
-		/*
-		 * If is_pfn_mapping() is true is_learn_pfn_mapping()
-		 * must be true too, verify it here.
-		 */
-		VM_BUG_ON(is_linear_pfn_mapping(vma) ||
-			  vma->vm_flags & VM_NO_THP);
+		VM_BUG_ON(vma->vm_flags & VM_NO_THP);
 
 		hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 		hend = vma->vm_end & HPAGE_PMD_MASK;
diff -puN mm/memory.c~mm-x86-pat-rework-linear-pfn-mmap-tracking mm/memory.c
--- a/mm/memory.c~mm-x86-pat-rework-linear-pfn-mmap-tracking
+++ a/mm/memory.c
@@ -1055,7 +1055,7 @@ int copy_page_range(struct mm_struct *ds
 	if (is_vm_hugetlb_page(vma))
 		return copy_hugetlb_page_range(dst_mm, src_mm, vma);
 
-	if (unlikely(is_pfn_mapping(vma))) {
+	if (unlikely(vma->vm_flags & VM_PFNMAP)) {
 		/*
 		 * We do not free on error cases below as remove_vma
 		 * gets called on error from higher level routine
@@ -1327,7 +1327,7 @@ static void unmap_single_vma(struct mmu_
 	if (vma->vm_file)
 		uprobe_munmap(vma, start, end);
 
-	if (unlikely(is_pfn_mapping(vma)))
+	if (unlikely(vma->vm_flags & VM_PFNMAP))
 		untrack_pfn(vma, 0, 0);
 
 	if (start != end) {
@@ -2299,26 +2299,20 @@ int remap_pfn_range(struct vm_area_struc
 	 * There's a horrible special case to handle copy-on-write
 	 * behaviour that some programs depend on. We mark the "original"
 	 * un-COW'ed pages by matching them up with "vma->vm_pgoff".
+	 * See vm_normal_page() for details.
 	 */
-	if (addr == vma->vm_start && end == vma->vm_end) {
+	if (is_cow_mapping(vma->vm_flags)) {
+		if (addr != vma->vm_start || end != vma->vm_end)
+			return -EINVAL;
 		vma->vm_pgoff = pfn;
-		vma->vm_flags |= VM_PFN_AT_MMAP;
-	} else if (is_cow_mapping(vma->vm_flags))
+	}
+
+	err = track_pfn_remap(vma, &prot, pfn, addr, PAGE_ALIGN(size));
+	if (err)
 		return -EINVAL;
 
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 
-	err = track_pfn_remap(vma, &prot, pfn, PAGE_ALIGN(size));
-	if (err) {
-		/*
-		 * To indicate that track_pfn related cleanup is not
-		 * needed from higher level routine calling unmap_vmas
-		 */
-		vma->vm_flags &= ~(VM_IO | VM_RESERVED | VM_PFNMAP);
-		vma->vm_flags &= ~VM_PFN_AT_MMAP;
-		return -EINVAL;
-	}
