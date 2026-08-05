Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8A83C0A1A
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896793; cv=none; b=aBqQ2/MU6ldeGqlIFlngHniPuYvqlLozr+yOacGt8juotxLngDzNbqQn5mpmZYqZBynWQto0wcpcWYl9Ys/aRH1DDapa8tfRMbw8buRDgFAhKbOfB2xWCUJpWSbFb834wZRe8SQifrp0B6ON8+4W8pcDZFo/+mVteHZYMFOFljI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896793; c=relaxed/simple;
	bh=1NFmPOpeQXxm1qJUoFpBM6fOxKv9w4Y18ydh6Fsgvsc=;
	h=Date:To:From:Subject:Message-Id; b=BHlrDtQbezQtYIxsNzi+upkPtIL9eW2k0sh+o+6gCHMqKaP2ipUWq4lwJnQB9JS0M+QG7nXnsroQXDIhoZKTykFUpV9kBuW7bnxVqc1fyIIoFCFDZ+TTmcELBDHsxRnFnuprse6ny6Conf2XQYyCOI6Co2f/Lcni0GEw1yebfC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cJKfsnW4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cJKfsnW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388F61F00A3A;
	Wed,  5 Aug 2026 02:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896792;
	bh=oJwSJWNN7UGUN56Jdy846XJDbRkjJj9sxRuUGSoFLKU=;
	h=Date:To:From:Subject;
	b=cJKfsnW4f30vXT243s2gzipg/FMR5wsjwi1P9/J+YLVxHAWWqL0tzO5IiJJmxY2Q9
	 BtyD2uMwaAbFlwUFEPISiYwPIfvw3LHNAREy17MoyvjsteO1PQmmyzaOF/Spb6dFWA
	 9L/8rKULhEVJg3Zcyhh6FkO68HxwgJPamwgQhEyI=
Date: Tue, 04 Aug 2026 19:26:31 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-introduce-and-use-vma_set_pgoff.patch removed from -mm tree
Message-Id: <20260805022632.388F61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: introduce and use vma_set_pgoff()
has been removed from the -mm tree.  Its filename was
     mm-vma-introduce-and-use-vma_set_pgoff.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: introduce and use vma_set_pgoff()
Date: Fri, 10 Jul 2026 21:17:10 +0100

In order to lay the foundation for work that permits us to track the
virtual page offset of MAP_PRIVATE file-backed mappings, we abstract the
assignment of vma->vm_pgoff to vma_set_pgoff().

We additionally add a lock check here using the newly introduced
vma_assert_can_modify(). This asserts the VMA write lock if the VMA is
attached.

We also assert that, if this is an anonymous VMA and unfaulted, that its
(virtual) page offset is equal to the page offset of the VMA's address.

We must be careful about MAP_PRIVATE-/dev/zero which violates fundamental
assumptions about anonymous memory, so we check for !vma->vm_file after
using vma_is_anonymous() which these mappings satisfy.

Additionally, we only perform the assert if CONFIG_MMU is defined, as nommu
does not set vma->vm_pgoff = addr >> PAGE_SHIFT. This isn't really relevant
to rmap as it has no anon rmap (nor needs it), but we must avoid it
asserting falsely.

All of this logic is kept in assert_sane_pgoff() to keep things clear.

In order to maintain correctness given this assert, we also update
__install_special_mapping() to invoke vma_set_range() after it's set
vma->vm_ops (which determine whether the VMA is anonymous or not).

We do not use vma_set_pgoff() in vm_area_init_from(), as at the point of
forking, we don't necessarily have correct locking state.

Updating vma_set_range() covers most cases, but in addition to this we also
update insert_vm_struct(), compat_set_vma_from_desc() and nommu callers.

We also update vma_add_pgoff() and vma_sub_pgoff() to use vma_set_pgoff().

While we're here, we drop a BUG_ON() and update insert_vm_struct()'s
comment to reflect the fact anonymous mappings can be added here.

Finally, we update the CONFIG_MMU, CONFIG_PER_VMA_LOCK defines in the VMA
userland tests so IS_ENABLED() will work correctly with them.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-29-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c                       |    2 -
 mm/vma.c                         |   14 +++++------
 mm/vma.h                         |   35 ++++++++++++++++++++++++++---
 tools/testing/vma/vma_internal.h |    4 +--
 4 files changed, 42 insertions(+), 13 deletions(-)

--- a/mm/nommu.c~mm-vma-introduce-and-use-vma_set_pgoff
+++ a/mm/nommu.c
@@ -1062,7 +1062,7 @@ unsigned long do_mmap(struct file *file,
 	region->vm_pgoff = pgoff;
 
 	vm_flags_init(vma, vm_flags);
-	vma->vm_pgoff = pgoff;
+	vma_set_pgoff(vma, pgoff);
 
 	if (file) {
 		region->vm_file = get_file(file);
--- a/mm/vma.c~mm-vma-introduce-and-use-vma_set_pgoff
+++ a/mm/vma.c
@@ -81,7 +81,7 @@ static void vma_set_range(struct vm_area
 			  unsigned long end, pgoff_t pgoff)
 {
 	__vma_set_range(vma, start, end);
-	vma->vm_pgoff = pgoff;
+	vma_set_pgoff(vma, pgoff);
 }
 
 /* Was this VMA ever forked from a parent, i.e. maybe contains CoW mappings? */
@@ -3347,9 +3347,9 @@ int __vm_munmap(unsigned long start, siz
 	return ret;
 }
 
-/* Insert vm structure into process list sorted by address
- * and into the inode's i_mmap tree.  If vm_file is non-NULL
- * then i_mmap_rwsem is taken here.
+/*
+ * Insert vm structure into process list sorted by address
+ * and into the inode's i_mmap tree if file-backed.
  */
 int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
@@ -3375,8 +3375,8 @@ int insert_vm_struct(struct mm_struct *m
 	 * Similarly in do_mmap and in do_brk_flags.
 	 */
 	if (vma_is_anonymous(vma)) {
-		BUG_ON(vma->anon_vma);
-		vma->vm_pgoff = vma->vm_start >> PAGE_SHIFT;
+		WARN_ON_ONCE(vma->anon_vma);
+		vma_set_pgoff(vma, vma->vm_start >> PAGE_SHIFT);
 	}
 
 	if (vma_link(mm, vma)) {
@@ -3422,7 +3422,6 @@ struct vm_area_struct *__install_special
 	if (unlikely(vma == NULL))
 		return ERR_PTR(-ENOMEM);
 
-	vma_set_range(vma, addr, addr + len, 0);
 	vm_flags |= mm->def_flags | VM_DONTEXPAND;
 	if (pgtable_supports_soft_dirty())
 		vm_flags |= VM_SOFTDIRTY;
@@ -3431,6 +3430,7 @@ struct vm_area_struct *__install_special
 
 	vma->vm_ops = ops;
 	vma->vm_private_data = priv;
+	vma_set_range(vma, addr, addr + len, 0);
 
 	ret = insert_vm_struct(mm, vma);
 	if (ret)
--- a/mm/vma.h~mm-vma-introduce-and-use-vma_set_pgoff
+++ a/mm/vma.h
@@ -247,16 +247,45 @@ static inline pgoff_t vmg_end_pgoff(cons
 	return vmg_start_pgoff(vmg) + vmg_pages(vmg);
 }
 
+static inline void assert_sane_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
+{
+	/* nommu doesn't set a virtual pgoff for anon VMAs. */
+	if (!IS_ENABLED(CONFIG_MMU))
+		return;
+	/*
+	 * File-backed VMAs have arbitrary page offset (either page offset into
+	 * file or for pfnmap the PFN of the start of the range or drivers may
+	 * set arbitrary page offset).
+	 */
+	if (!vma_is_anonymous(vma))
+		return;
+	/* MAP_PRIVATE-/dev/zero is anon, non-NULL vm_file, but has file pgoff. */
+	if (vma->vm_file)
+		return;
+	/* If faulted in, could have been remapped. */
+	if (vma->anon_vma)
+		return;
+	/* OK this is really an anon VMA - expect virtual page offset. */
+	VM_WARN_ON_ONCE(pgoff != vma->vm_start >> PAGE_SHIFT);
+}
+
+static inline void vma_set_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
+{
+	vma_assert_can_modify(vma);
+	assert_sane_pgoff(vma, pgoff);
+	vma->vm_pgoff = pgoff;
+}
+
 static inline void vma_add_pgoff(struct vm_area_struct *vma, pgoff_t delta)
 {
 	vma_assert_can_modify(vma);
-	vma->vm_pgoff += delta;
+	vma_set_pgoff(vma, vma_start_pgoff(vma) + delta);
 }
 
 static inline void vma_sub_pgoff(struct vm_area_struct *vma, pgoff_t delta)
 {
 	vma_assert_can_modify(vma);
-	vma->vm_pgoff -= delta;
+	vma_set_pgoff(vma, vma_start_pgoff(vma) - delta);
 }
 
 #define VMG_STATE(name, mm_, vmi_, start_, end_, vma_flags_, pgoff_)	\
@@ -331,7 +360,7 @@ static inline void compat_set_vma_from_d
 	 */
 
 	/* Mutable fields. Populated with initial state. */
-	vma->vm_pgoff = desc->pgoff;
+	vma_set_pgoff(vma, desc->pgoff);
 	if (desc->vm_file != vma->vm_file)
 		vma_set_file(vma, desc->vm_file);
 	vma->flags = desc->vma_flags;
--- a/tools/testing/vma/vma_internal.h~mm-vma-introduce-and-use-vma_set_pgoff
+++ a/tools/testing/vma/vma_internal.h
@@ -14,8 +14,8 @@
 
 #include <stdlib.h>
 
-#define CONFIG_MMU
-#define CONFIG_PER_VMA_LOCK
+#define CONFIG_MMU		1
+#define CONFIG_PER_VMA_LOCK	1
 
 #ifdef __CONCAT
 #undef __CONCAT
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmalloc-acquire-init_mm-lock-on-huge-vmap-to-avoid-ptdump-uaf.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
arm64-remove-redundant-concurrent-ptdump-uaf-mitigation.patch
mm-huge_memory-fix-huge_zero_pfn-race.patch
mm-huge_memory-separate-out-config_persistent_huge_zero_folio-logic.patch
x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch
mm-vma-update-do_mmap-to-use-vma_flags_t.patch
mm-convert-__get_unmapped_area-to-use-vma_flags_t.patch
mm-update-generic_get_unmapped_area-to-use-vma_flags_t.patch
mm-prefer-mm-def_vma_flags-in-mm-logic.patch
mm-vma-convert-vm_pgprot_modify-to-use-vma_flags_t-and-rename.patch
mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch
mm-introduce-vma_get_page_prot-and-use-it.patch
mm-vma-update-create_init_stack_vma-to-use-vma_flags_t.patch
mm-vma-convert-miscellaneous-uses-of-vma-flags-in-core-mm.patch
mm-mlock-convert-mlock-code-to-use-vma_flags_t.patch
mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch
mm-mremap-convert-mremap-code-to-use-vma_flags_t.patch
mm-mseal-remove-superfluous-comments-fix-confusion-around-mm.patch
mm-mseal-limit-scope-of-mseal-address-zero-to-address-zero.patch
mm-mseal-remove-further-superfluous-comments-do_mseal.patch
mm-vma-introduce-vma-virtual-page-offset-field-and-add-helpers.patch
mm-introduce-linear_virt_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-virtual-page-index.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-propagate-vma-virtual-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-walk-is-anonymous.patch
mm-introduce-and-use-linear_folio_page_index.patch
mm-rmap-use-virt-pgoff-for-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-virt-pgoff.patch
tools-testing-selftests-mm-test-virtual-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

