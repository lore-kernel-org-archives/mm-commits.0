Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E60404BD2
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723648; cv=none; b=RQimCZ+ilwvgjgEJButh2plNKSnexQdS+kR7Uq1Lj/VpmNDRWT5drGQW/2c7aTDtXb3q2jbtt33JQaF588+Xdb3s6bGLAT4q8JgZMJiB01Z7Pa59RTBKbWGmRVECHmSHgqnuzSYx25KD89ajadlz6rJCzS1z8pDt6hkBwnpUJY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723648; c=relaxed/simple;
	bh=0l3zYYID5pyF4GXVnuPkW7Fr9+FkzmZGuHAYZiqvFas=;
	h=Date:To:From:Subject:Message-Id; b=HIldZEqmNeVwCnwylBUvFn/VgyBdAOn1jCFEOmDCEdUCm/HrP7zbkmMPxfoI4nUPRtyXRsm+oIs4zo4GJYm6LHVLlmqxOdjydMjdj7lMFqA5KV8ZjQnUFW4TZCxjGaCN7WqSDU6+4XfAyWNgcxZWXEM7ZAR+X1H/89cX5z+16Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z7TMwBSQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z7TMwBSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511931F000E9;
	Fri, 10 Jul 2026 22:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723646;
	bh=YaBNPS5bMF8dihRab6aVoX6OJSofBIUn0AVbEME1eq4=;
	h=Date:To:From:Subject;
	b=Z7TMwBSQvlJOOjnCgSs0KjkYS71cTnUd3o5bKXQRDDMyvPAL2XL3De+JjNl3SSvIE
	 Xd86UNhc2j+54J1NITqNTQmINTHtJvQ4SvXRPjYrPmcU/Zf6zpcXMxKM7NzlNBDq4y
	 XjIJf/ib5JfxXzXbkL5Ykz98N9roTa1qVX/dvpkk=
Date: Fri, 10 Jul 2026 15:47:25 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-introduce-and-use-vma_set_pgoff.patch added to mm-new branch
Message-Id: <20260710224726.511931F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: introduce and use vma_set_pgoff()
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-introduce-and-use-vma_set_pgoff.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-introduce-and-use-vma_set_pgoff.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
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

mm-move-alloc-tag-to-mm.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion.patch
revert-arm64-enable-vmalloc-huge-with-ptdump.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch

