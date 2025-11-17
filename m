Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B91212554
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343184; cv=none; b=aw7lDwPSePADhKX8uUEP0WY7pUup+Am9q4aWQvi4MIMme5TfBnkJTvMWqg9luBiWXJ7XNgFnpZuGi1fEtmyIpkSOMgwiogc1+oekHPy798M5K3TfPLPAJLBVA73cvoWtn8w8NbbzAjo9M5XAWmIhSFpC1AYsHwH7DeFJcLoLgso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343184; c=relaxed/simple;
	bh=cYG3v1ur2Yx02/YMj5uDUwZo8HyoOsUXMhBPU3oFghY=;
	h=Date:To:From:Subject:Message-Id; b=QSUTkW69ZmApQ54xEPSoUh2ZvcVHtqhTKEw8Y4qTZR7B/Br+nnehkLpQBedfWmIKbIcm2prUCukkA1kU+c5yWNqBgmTcCD+j0Ti3v4sVxh/e1i4+Smchq8TdKrclHbi36upt7iOZ3fD98GOGtLPqxHUDRyCM8uW3fKxHzYrVTio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D2u8mSCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D2u8mSCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CC7C16AAE;
	Mon, 17 Nov 2025 01:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343184;
	bh=cYG3v1ur2Yx02/YMj5uDUwZo8HyoOsUXMhBPU3oFghY=;
	h=Date:To:From:Subject:From;
	b=D2u8mSCMDJOCBEKm2o+teU0j9FBuNRg0VElGAjd9tpw71EQ1s7BcbOVDcxrSm9Ug/
	 DpsL8x8vl8UgQpPCixVLMOLpkj26zLZ3pmmhzigotmwQ339D3FW9buYZZa4IiWE2Fn
	 cg9TYCdh14oRrP0XxtEzb535kGjls9ps628LntAg=
Date: Sun, 16 Nov 2025 17:33:03 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,viro@zeniv.linux.org.uk,vgoyal@redhat.com,vbabka@suse.cz,urezki@gmail.com,tsbogend@alpha.franken.de,tony.luck@intel.com,svens@linux.ibm.com,surenb@google.com,sumanthk@linux.ibm.com,rppt@kernel.org,robin.murphy@arm.com,reinette.chatre@intel.com,pfalcato@suse.de,osalvador@suse.de,nico@fluxnic.net,muchun.song@linux.dev,mhocko@suse.com,liam.howlett@oracle.com,kevin.tian@intel.com,jgg@nvidia.com,jannh@google.com,james.morse@arm.com,jack@suse.cz,hughd@google.com,hca@linux.ibm.com,guoren@kernel.org,gregkh@linuxfoundation.org,gor@linux.ibm.com,dyoung@redhat.com,dvyukov@google.com,david@redhat.com,davem@davemloft.net,dave.martin@arm.com,dave.jiang@intel.com,dan.j.williams@intel.com,corbet@lwn.net,brauner@kernel.org,borntraeger@linux.ibm.com,bhe@redhat.com,baolin.wang@linux.alibaba.com,arnd@arndb.de,andreyknvl@gmail.com,andreas@gaisler.com,almaz.alexandrovich@paragon-software.com,agordeev@linux.ibm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch removed from -mm tree
Message-Id: <20251117013303.E9CC7C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add remap_pfn_range_prepare(), remap_pfn_range_complete()
has been removed from the -mm tree.  Its filename was
     mm-add-remap_pfn_range_prepare-remap_pfn_range_complete.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: add remap_pfn_range_prepare(), remap_pfn_range_complete()
Date: Mon, 20 Oct 2025 13:11:24 +0100

We need the ability to split PFN remap between updating the VMA and
performing the actual remap, in order to do away with the legacy f_op->mmap
hook.

To do so, update the PFN remap code to provide shared logic, and also make
remap_pfn_range_notrack() static, as its one user, io_mapping_map_user()
was removed in commit 9a4f90e24661 ("mm: remove mm/io-mapping.c").

Then, introduce remap_pfn_range_prepare(), which accepts VMA descriptor
and PFN parameters, and remap_pfn_range_complete() which accepts the same
parameters as remap_pfn_rangte().

remap_pfn_range_prepare() will set the cow vma->vm_pgoff if necessary, so
it must be supplied with a correct PFN to do so.

While we're here, also clean up the duplicated #ifdef
__HAVE_PFNMAP_TRACKING check and put into a single #ifdef/#else block.

We keep these internal to mm as they should only be used by internal
helpers.

Link: https://lkml.kernel.org/r/75b55de63249b3aa0fd5b3b08ed1d3ff19255d0d.1760959442.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chatre, Reinette <reinette.chatre@intel.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dave Martin <dave.martin@arm.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guo Ren <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   22 +++++--
 mm/internal.h      |    4 +
 mm/memory.c        |  132 ++++++++++++++++++++++++++++---------------
 3 files changed, 110 insertions(+), 48 deletions(-)

--- a/include/linux/mm.h~mm-add-remap_pfn_range_prepare-remap_pfn_range_complete
+++ a/include/linux/mm.h
@@ -489,6 +489,21 @@ extern unsigned int kobjsize(const void
  */
 #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
 
+/*
+ * Physically remapped pages are special. Tell the
+ * rest of the world about it:
+ *   VM_IO tells people not to look at these pages
+ *	(accesses can have side effects).
+ *   VM_PFNMAP tells the core MM that the base pages are just
+ *	raw PFN mappings, and do not have a "struct page" associated
+ *	with them.
+ *   VM_DONTEXPAND
+ *      Disable vma merging and expanding with mremap().
+ *   VM_DONTDUMP
+ *      Omit vma from core dump, even when VM_IO turned off.
+ */
+#define VM_REMAP_FLAGS (VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP)
+
 /* This mask prevents VMA from being scanned with khugepaged */
 #define VM_NO_KHUGEPAGED (VM_SPECIAL | VM_HUGETLB)
 
@@ -3634,10 +3649,9 @@ unsigned long change_prot_numa(struct vm
 
 struct vm_area_struct *find_extend_vma_locked(struct mm_struct *,
 		unsigned long addr);
-int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
-			unsigned long pfn, unsigned long size, pgprot_t);
-int remap_pfn_range_notrack(struct vm_area_struct *vma, unsigned long addr,
-		unsigned long pfn, unsigned long size, pgprot_t prot);
+int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
+		    unsigned long pfn, unsigned long size, pgprot_t pgprot);
+
 int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
 int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
 			struct page **pages, unsigned long *num);
--- a/mm/internal.h~mm-add-remap_pfn_range_prepare-remap_pfn_range_complete
+++ a/mm/internal.h
@@ -1677,4 +1677,8 @@ static inline bool reclaim_pt_is_enabled
 void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
 int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
 
+void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn);
+int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t pgprot);
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/memory.c~mm-add-remap_pfn_range_prepare-remap_pfn_range_complete
+++ a/mm/memory.c
@@ -2900,6 +2900,25 @@ static inline int remap_p4d_range(struct
 	return 0;
 }
 
+static int get_remap_pgoff(vm_flags_t vm_flags, unsigned long addr,
+		unsigned long end, unsigned long vm_start, unsigned long vm_end,
+		unsigned long pfn, pgoff_t *vm_pgoff_p)
+{
+	/*
+	 * There's a horrible special case to handle copy-on-write
+	 * behaviour that some programs depend on. We mark the "original"
+	 * un-COW'ed pages by matching them up with "vma->vm_pgoff".
+	 * See vm_normal_page() for details.
+	 */
+	if (is_cow_mapping(vm_flags)) {
+		if (addr != vm_start || end != vm_end)
+			return -EINVAL;
+		*vm_pgoff_p = pfn;
+	}
+
+	return 0;
+}
+
 static int remap_pfn_range_internal(struct vm_area_struct *vma, unsigned long addr,
 		unsigned long pfn, unsigned long size, pgprot_t prot)
 {
@@ -2912,31 +2931,7 @@ static int remap_pfn_range_internal(stru
 	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr)))
 		return -EINVAL;
 
-	/*
-	 * Physically remapped pages are special. Tell the
-	 * rest of the world about it:
-	 *   VM_IO tells people not to look at these pages
-	 *	(accesses can have side effects).
-	 *   VM_PFNMAP tells the core MM that the base pages are just
-	 *	raw PFN mappings, and do not have a "struct page" associated
-	 *	with them.
-	 *   VM_DONTEXPAND
-	 *      Disable vma merging and expanding with mremap().
-	 *   VM_DONTDUMP
-	 *      Omit vma from core dump, even when VM_IO turned off.
-	 *
-	 * There's a horrible special case to handle copy-on-write
-	 * behaviour that some programs depend on. We mark the "original"
-	 * un-COW'ed pages by matching them up with "vma->vm_pgoff".
-	 * See vm_normal_page() for details.
-	 */
-	if (is_cow_mapping(vma->vm_flags)) {
-		if (addr != vma->vm_start || end != vma->vm_end)
-			return -EINVAL;
-		vma->vm_pgoff = pfn;
-	}
-
-	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+	VM_WARN_ON_ONCE((vma->vm_flags & VM_REMAP_FLAGS) != VM_REMAP_FLAGS);
 
 	BUG_ON(addr >= end);
 	pfn -= addr >> PAGE_SHIFT;
@@ -2957,7 +2952,7 @@ static int remap_pfn_range_internal(stru
  * Variant of remap_pfn_range that does not call track_pfn_remap.  The caller
  * must have pre-validated the caching bits of the pgprot_t.
  */
-int remap_pfn_range_notrack(struct vm_area_struct *vma, unsigned long addr,
+static int remap_pfn_range_notrack(struct vm_area_struct *vma, unsigned long addr,
 		unsigned long pfn, unsigned long size, pgprot_t prot)
 {
 	int error = remap_pfn_range_internal(vma, addr, pfn, size, prot);
@@ -3002,23 +2997,9 @@ void pfnmap_track_ctx_release(struct kre
 	pfnmap_untrack(ctx->pfn, ctx->size);
 	kfree(ctx);
 }
-#endif /* __HAVE_PFNMAP_TRACKING */
 
-/**
- * remap_pfn_range - remap kernel memory to userspace
- * @vma: user vma to map to
- * @addr: target page aligned user address to start at
- * @pfn: page frame number of kernel physical memory address
- * @size: size of mapping area
- * @prot: page protection flags for this mapping
- *
- * Note: this is only safe if the mm semaphore is held when called.
- *
- * Return: %0 on success, negative error code otherwise.
- */
-#ifdef __HAVE_PFNMAP_TRACKING
-int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
-		    unsigned long pfn, unsigned long size, pgprot_t prot)
+static int remap_pfn_range_track(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t prot)
 {
 	struct pfnmap_track_ctx *ctx = NULL;
 	int err;
@@ -3054,15 +3035,78 @@ int remap_pfn_range(struct vm_area_struc
 	return err;
 }
 
+static int do_remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t prot)
+{
+	return remap_pfn_range_track(vma, addr, pfn, size, prot);
+}
 #else
-int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
-		    unsigned long pfn, unsigned long size, pgprot_t prot)
+static int do_remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t prot)
 {
 	return remap_pfn_range_notrack(vma, addr, pfn, size, prot);
 }
 #endif
+
+void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn)
+{
+	/*
+	 * We set addr=VMA start, end=VMA end here, so this won't fail, but we
+	 * check it again on complete and will fail there if specified addr is
+	 * invalid.
+	 */
+	get_remap_pgoff(desc->vm_flags, desc->start, desc->end,
+			desc->start, desc->end, pfn, &desc->pgoff);
+	desc->vm_flags |= VM_REMAP_FLAGS;
+}
+
+static int remap_pfn_range_prepare_vma(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size)
+{
+	unsigned long end = addr + PAGE_ALIGN(size);
+	int err;
+
+	err = get_remap_pgoff(vma->vm_flags, addr, end,
+			      vma->vm_start, vma->vm_end,
+			      pfn, &vma->vm_pgoff);
+	if (err)
+		return err;
+
+	vm_flags_set(vma, VM_REMAP_FLAGS);
+	return 0;
+}
+
+/**
+ * remap_pfn_range - remap kernel memory to userspace
+ * @vma: user vma to map to
+ * @addr: target page aligned user address to start at
+ * @pfn: page frame number of kernel physical memory address
+ * @size: size of mapping area
+ * @prot: page protection flags for this mapping
+ *
+ * Note: this is only safe if the mm semaphore is held when called.
+ *
+ * Return: %0 on success, negative error code otherwise.
+ */
+int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
+		    unsigned long pfn, unsigned long size, pgprot_t prot)
+{
+	int err;
+
+	err = remap_pfn_range_prepare_vma(vma, addr, pfn, size);
+	if (err)
+		return err;
+
+	return do_remap_pfn_range(vma, addr, pfn, size, prot);
+}
 EXPORT_SYMBOL(remap_pfn_range);
 
+int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t prot)
+{
+	return do_remap_pfn_range(vma, addr, pfn, size, prot);
+}
+
 /**
  * vm_iomap_memory - remap memory to userspace
  * @vma: user vma to map to
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such-fix.patch
mm-implement-sticky-vma-flags.patch
mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix.patch
tools-testing-vma-add-vma-sticky-userland-tests.patch
tools-testing-selftests-mm-add-madv_collapse-test-case.patch
tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch
mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-softleaf-helpers-instead.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-softleaf_from_pte.patch
mm-rename-walk_page_range_mm.patch
mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-propagate-vm_softdirty-on-merge.patch
testing-selftests-mm-add-soft-dirty-merge-self-test.patch
mm-declare-vma-flags-by-bit.patch
mm-declare-vma-flags-by-bit-fix.patch
mm-declare-vma-flags-by-bit-fix-2.patch
mm-simplify-and-rename-mm-flags-function-for-clarity.patch
tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch
mm-introduce-vma-flags-bitmap-type.patch

