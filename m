Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4D1349B0D
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 17:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763488294; cv=none; b=Ym7FzWrkU+70SfT6pPFzzN8AvRF8VfKCacOXEDDEVA16NcjnJTgfyIGVpuAJAucJF8b4EFd/4+QNsvHKb0+OvW6+VTM4kHvm4JnR0t9nkeDXnbJdy9sK9WN6B6y/1Joufn2gUL47F+ljdx++Ttwx1w5k8PgEhg8CriEAIMQbZII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763488294; c=relaxed/simple;
	bh=Iv86hYflswGE4kgULDstDwOvY/hlVb59ELse5iFcoEI=;
	h=Date:To:From:Subject:Message-Id; b=ZpK/Jjt27YfL2TxFC4ZjPIp41D/bVmXDnRC+d6ivhfuwk0WN24r9Uoq7HDTrCC40eT99w7a+CK2rompImgPrj8ORr0wVJy73Cpm3xKj14mSniZpNptY7v/Oh5RKutiwV186q0iPcrUVCyRKlnKzsODBBvUNAX5wX5BzUPAfHICc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qb1O0EV5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qb1O0EV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F84C4CEFB;
	Tue, 18 Nov 2025 17:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763488292;
	bh=Iv86hYflswGE4kgULDstDwOvY/hlVb59ELse5iFcoEI=;
	h=Date:To:From:Subject:From;
	b=Qb1O0EV5VhvriwaJZ8boZEgLBrxuGbixDt2I9Z64eHha1xGWIR8aUWOme1jO41ODW
	 O8RqEJJL9SPsR1H+vpAivx+YksYdVhhNZqmZwcK4rXwP9YhQSCEzrvmY0b8O2aX9Ay
	 jyKA1iRstXBiIv3Fk0fPJplJmKD59He6smF7DLus=
Date: Tue, 18 Nov 2025 09:51:30 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,robh@kernel.org,peterx@redhat.com,paul.walmsley@sifive.com,palmer@dabbelt.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jack@suse.cz,debug@rivosinc.com,david@redhat.com,conor@kernel.org,conor.dooley@microchip.com,brauner@kernel.org,axelrasmussen@google.com,arnd@arndb.de,aou@eecs.berkeley.edu,alexghiti@rivosinc.com,alex@ghiti.fr,ajones@ventanamicro.com,zhangchunyan@iscas.ac.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-softdirty-add-pgtable_supports_soft_dirty.patch added to mm-new branch
Message-Id: <20251118175131.E9F84C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: softdirty: add pgtable_supports_soft_dirty()
has been added to the -mm mm-new branch.  Its filename is
     mm-softdirty-add-pgtable_supports_soft_dirty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-softdirty-add-pgtable_supports_soft_dirty.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Subject: mm: softdirty: add pgtable_supports_soft_dirty()
Date: Thu, 13 Nov 2025 15:28:01 +0800

Patch series "mm: Add soft-dirty and uffd-wp support for RISC-V", v15.

This patchset adds support for Svrsw60t59b [1] extension which is ratified
now, also add soft dirty and userfaultfd write protect tracking for
RISC-V.

The patches 1 and 2 add macros to allow architectures to define their own
checks if the soft-dirty / uffd_wp PTE bits are available, in other words
for RISC-V, the Svrsw60t59b extension is supported on which device the
kernel is running.  Also patch1-2 are removing "ifdef
CONFIG_MEM_SOFT_DIRTY" "ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP" and "ifdef
CONFIG_PTE_MARKER_UFFD_WP" in favor of checks which if not overridden by
the architecture, no change in behavior is expected.

This patchset has been tested with kselftest mm suite in which soft-dirty,
madv_populate, test_unmerge_uffd_wp, and uffd-unit-tests run and pass, and
no regressions are observed in any of the other tests.


This patch (of 6):

Some platforms can customize the PTE PMD entry soft-dirty bit making it
unavailable even if the architecture provides the resource.

Add an API which architectures can define their specific implementations
to detect if soft-dirty bit is available on which device the kernel is
running.

This patch is removing "ifdef CONFIG_MEM_SOFT_DIRTY" in favor of
pgtable_supports_soft_dirty() checks that defaults to
IS_ENABLED(CONFIG_MEM_SOFT_DIRTY), if not overridden by the architecture,
no change in behavior is expected.

We make sure to never set VM_SOFTDIRTY if !pgtable_supports_soft_dirty(),
so we will never run into VM_SOFTDIRTY checks.

Link: https://lkml.kernel.org/r/20251113072806.795029-1-zhangchunyan@iscas.ac.cn
Link: https://lkml.kernel.org/r/20251113072806.795029-2-zhangchunyan@iscas.ac.cn
Link: https://github.com/riscv-non-isa/riscv-iommu/pull/543 [1]
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Conor Dooley <conor@kernel.org>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andrew Jones <ajones@ventanamicro.com>
Cc: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |   15 ++++++---------
 include/linux/mm.h      |    3 +++
 include/linux/pgtable.h |   12 ++++++++++++
 mm/debug_vm_pgtable.c   |   10 +++++-----
 mm/huge_memory.c        |   13 +++++++------
 mm/internal.h           |    2 +-
 mm/mmap.c               |    6 ++++--
 mm/mremap.c             |   13 +++++++------
 mm/userfaultfd.c        |   10 ++++------
 mm/vma.c                |    6 ++++--
 mm/vma_exec.c           |    5 ++++-
 11 files changed, 57 insertions(+), 38 deletions(-)

--- a/fs/proc/task_mmu.c~mm-softdirty-add-pgtable_supports_soft_dirty
+++ a/fs/proc/task_mmu.c
@@ -1584,8 +1584,6 @@ struct clear_refs_private {
 	enum clear_refs_types type;
 };
 
-#ifdef CONFIG_MEM_SOFT_DIRTY
-
 static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 {
 	struct folio *folio;
@@ -1605,6 +1603,8 @@ static inline bool pte_is_pinned(struct
 static inline void clear_soft_dirty(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *pte)
 {
+	if (!pgtable_supports_soft_dirty())
+		return;
 	/*
 	 * The soft-dirty tracker uses #PF-s to catch writes
 	 * to pages, so write-protect the pte as well. See the
@@ -1630,19 +1630,16 @@ static inline void clear_soft_dirty(stru
 		set_pte_at(vma->vm_mm, addr, pte, ptent);
 	}
 }
-#else
-static inline void clear_soft_dirty(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *pte)
-{
-}
-#endif
 
-#if defined(CONFIG_MEM_SOFT_DIRTY) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE)
 static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
 		unsigned long addr, pmd_t *pmdp)
 {
 	pmd_t old, pmd = *pmdp;
 
+	if (!pgtable_supports_soft_dirty())
+		return;
+
 	if (pmd_present(pmd)) {
 		/* See comment in change_huge_pmd() */
 		old = pmdp_invalidate(vma, addr, pmdp);
--- a/include/linux/mm.h~mm-softdirty-add-pgtable_supports_soft_dirty
+++ a/include/linux/mm.h
@@ -919,6 +919,7 @@ static inline void vma_init(struct vm_ar
 static inline void vm_flags_init(struct vm_area_struct *vma,
 				 vm_flags_t flags)
 {
+	VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
 	vma_flags_clear_all(&vma->flags);
 	vma_flags_overwrite_word(&vma->flags, flags);
 }
@@ -931,6 +932,7 @@ static inline void vm_flags_init(struct
 static inline void vm_flags_reset(struct vm_area_struct *vma,
 				  vm_flags_t flags)
 {
+	VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
 	vma_assert_write_locked(vma);
 	vm_flags_init(vma, flags);
 }
@@ -950,6 +952,7 @@ static inline void vm_flags_reset_once(s
 static inline void vm_flags_set(struct vm_area_struct *vma,
 				vm_flags_t flags)
 {
+	VM_WARN_ON_ONCE(!pgtable_supports_soft_dirty() && (flags & VM_SOFTDIRTY));
 	vma_start_write(vma);
 	vma_flags_set_word(&vma->flags, flags);
 }
--- a/include/linux/pgtable.h~mm-softdirty-add-pgtable_supports_soft_dirty
+++ a/include/linux/pgtable.h
@@ -1553,6 +1553,18 @@ static inline pgprot_t pgprot_modify(pgp
 #define arch_start_context_switch(prev)	do {} while (0)
 #endif
 
+/*
+ * Some platforms can customize the PTE soft-dirty bit making it unavailable
+ * even if the architecture provides the resource.
+ * Adding this API allows architectures to add their own checks for the
+ * devices on which the kernel is running.
+ * Note: When overriding it, please make sure the CONFIG_MEM_SOFT_DIRTY
+ * is part of this macro.
+ */
+#ifndef pgtable_supports_soft_dirty
+#define pgtable_supports_soft_dirty()	IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 #ifndef CONFIG_ARCH_ENABLE_THP_MIGRATION
 static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
--- a/mm/debug_vm_pgtable.c~mm-softdirty-add-pgtable_supports_soft_dirty
+++ a/mm/debug_vm_pgtable.c
@@ -704,7 +704,7 @@ static void __init pte_soft_dirty_tests(
 {
 	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot);
 
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!pgtable_supports_soft_dirty())
 		return;
 
 	pr_debug("Validating PTE soft dirty\n");
@@ -717,7 +717,7 @@ static void __init pte_swap_soft_dirty_t
 	pte_t pte;
 	softleaf_t entry;
 
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!pgtable_supports_soft_dirty())
 		return;
 
 	pr_debug("Validating PTE swap soft dirty\n");
@@ -734,7 +734,7 @@ static void __init pmd_soft_dirty_tests(
 {
 	pmd_t pmd;
 
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!pgtable_supports_soft_dirty())
 		return;
 
 	if (!has_transparent_hugepage())
@@ -750,8 +750,8 @@ static void __init pmd_leaf_soft_dirty_t
 {
 	pmd_t pmd;
 
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY) ||
-		!IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
+	if (!pgtable_supports_soft_dirty() ||
+	    !IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
 		return;
 
 	if (!has_transparent_hugepage())
--- a/mm/huge_memory.c~mm-softdirty-add-pgtable_supports_soft_dirty
+++ a/mm/huge_memory.c
@@ -2427,12 +2427,13 @@ static inline int pmd_move_must_withdraw
 
 static pmd_t move_soft_dirty_pmd(pmd_t pmd)
 {
-#ifdef CONFIG_MEM_SOFT_DIRTY
-	if (unlikely(pmd_is_migration_entry(pmd)))
-		pmd = pmd_swp_mksoft_dirty(pmd);
-	else if (pmd_present(pmd))
-		pmd = pmd_mksoft_dirty(pmd);
-#endif
+	if (pgtable_supports_soft_dirty()) {
+		if (unlikely(pmd_is_migration_entry(pmd)))
+			pmd = pmd_swp_mksoft_dirty(pmd);
+		else if (pmd_present(pmd))
+			pmd = pmd_mksoft_dirty(pmd);
+	}
+
 	return pmd;
 }
 
--- a/mm/internal.h~mm-softdirty-add-pgtable_supports_soft_dirty
+++ a/mm/internal.h
@@ -1554,7 +1554,7 @@ static inline bool vma_soft_dirty_enable
 	 * VM_SOFTDIRTY is defined as 0x0, then !(vm_flags & VM_SOFTDIRTY)
 	 * will be constantly true.
 	 */
-	if (!IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
+	if (!pgtable_supports_soft_dirty())
 		return false;
 
 	/*
--- a/mm/mmap.c~mm-softdirty-add-pgtable_supports_soft_dirty
+++ a/mm/mmap.c
@@ -1448,8 +1448,10 @@ static struct vm_area_struct *__install_
 		return ERR_PTR(-ENOMEM);
 
 	vma_set_range(vma, addr, addr + len, 0);
-	vm_flags_init(vma, (vm_flags | mm->def_flags |
-		      VM_DONTEXPAND | VM_SOFTDIRTY) & ~VM_LOCKED_MASK);
+	vm_flags |= mm->def_flags | VM_DONTEXPAND;
+	if (pgtable_supports_soft_dirty())
+		vm_flags |= VM_SOFTDIRTY;
+	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
 	vma->vm_ops = ops;
--- a/mm/mremap.c~mm-softdirty-add-pgtable_supports_soft_dirty
+++ a/mm/mremap.c
@@ -165,12 +165,13 @@ static pte_t move_soft_dirty_pte(pte_t p
 	 * Set soft dirty bit so we can notice
 	 * in userspace the ptes were moved.
 	 */
-#ifdef CONFIG_MEM_SOFT_DIRTY
-	if (pte_present(pte))
-		pte = pte_mksoft_dirty(pte);
-	else
-		pte = pte_swp_mksoft_dirty(pte);
-#endif
+	if (pgtable_supports_soft_dirty()) {
+		if (pte_present(pte))
+			pte = pte_mksoft_dirty(pte);
+		else
+			pte = pte_swp_mksoft_dirty(pte);
+	}
+
 	return pte;
 }
 
--- a/mm/userfaultfd.c~mm-softdirty-add-pgtable_supports_soft_dirty
+++ a/mm/userfaultfd.c
@@ -1119,9 +1119,8 @@ static long move_present_ptes(struct mm_
 
 		orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
 		/* Set soft dirty bit so userspace can notice the pte was moved */
-#ifdef CONFIG_MEM_SOFT_DIRTY
-		orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
-#endif
+		if (pgtable_supports_soft_dirty())
+			orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
 		if (pte_dirty(orig_src_pte))
 			orig_dst_pte = pte_mkdirty(orig_dst_pte);
 		orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
@@ -1208,9 +1207,8 @@ static int move_swap_pte(struct mm_struc
 	}
 
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
-#ifdef CONFIG_MEM_SOFT_DIRTY
-	orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
-#endif
+	if (pgtable_supports_soft_dirty())
+		orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
--- a/mm/vma.c~mm-softdirty-add-pgtable_supports_soft_dirty
+++ a/mm/vma.c
@@ -2559,7 +2559,8 @@ static void __mmap_complete(struct mmap_
 	 * then new mapped in-place (which must be aimed as
 	 * a completely new data area).
 	 */
-	vm_flags_set(vma, VM_SOFTDIRTY);
+	if (pgtable_supports_soft_dirty())
+		vm_flags_set(vma, VM_SOFTDIRTY);
 
 	vma_set_page_prot(vma);
 }
@@ -2864,7 +2865,8 @@ out:
 	mm->data_vm += len >> PAGE_SHIFT;
 	if (vm_flags & VM_LOCKED)
 		mm->locked_vm += (len >> PAGE_SHIFT);
-	vm_flags_set(vma, VM_SOFTDIRTY);
+	if (pgtable_supports_soft_dirty())
+		vm_flags_set(vma, VM_SOFTDIRTY);
 	return 0;
 
 mas_store_fail:
--- a/mm/vma_exec.c~mm-softdirty-add-pgtable_supports_soft_dirty
+++ a/mm/vma_exec.c
@@ -107,6 +107,7 @@ int relocate_vma_down(struct vm_area_str
 int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 			  unsigned long *top_mem_p)
 {
+	unsigned long flags = VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP;
 	int err;
 	struct vm_area_struct *vma = vm_area_alloc(mm);
 
@@ -137,7 +138,9 @@ int create_init_stack_vma(struct mm_stru
 	BUILD_BUG_ON(VM_STACK_FLAGS & VM_STACK_INCOMPLETE_SETUP);
 	vma->vm_end = STACK_TOP_MAX;
 	vma->vm_start = vma->vm_end - PAGE_SIZE;
-	vm_flags_init(vma, VM_SOFTDIRTY | VM_STACK_FLAGS | VM_STACK_INCOMPLETE_SETUP);
+	if (pgtable_supports_soft_dirty())
+		flags |= VM_SOFTDIRTY;
+	vm_flags_init(vma, flags);
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 
 	err = insert_vm_struct(mm, vma);
_

Patches currently in -mm which might be from zhangchunyan@iscas.ac.cn are

mm-softdirty-add-pgtable_supports_soft_dirty.patch
mm-userfaultfd-add-pgtable_supports_uffd_wp.patch
riscv-add-risc-v-svrsw60t59b-extension-support.patch
riscv-mm-add-soft-dirty-page-tracking-support.patch
riscv-mm-add-userfaultfd-write-protect-support.patch
dt-bindings-riscv-add-svrsw60t59b-extension-description.patch

