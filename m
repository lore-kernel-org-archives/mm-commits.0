Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A825D4AC141
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679399; cv=none; b=qfnDRqyOfjnLUaIL4ATH3jaJuDT2ssprHvMFvsorc7ReUXrucKUk2QNUDNEhXDxTOAMyNVU8gVLdmQIW+nFkfqeuLEAOracBCr/kCV390lWFgy1M6fwZlxUi7ytCI68Mta+0q3i7++JBWSrdnOoI4Oh/kJ36RRtGG+vMIVKU+Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679399; c=relaxed/simple;
	bh=HvVtL2BMtcwtIQw0gqAHTvd/DmkgbOUTcsamKC1VOpI=;
	h=Date:To:From:Subject:Message-Id; b=j4w9m8/yp8fo0RaCwA2xogeGhMumPrW5dnx6ec8G2r09XspyiH13DOKaMU7t6+5ZKdPMLWrHkati8Vq/ScmzVLD8Uh04mtM6Qr78qiXxXC8US+mC3e3ImYlD6gl6DgTM8tpxPpbS7/DQK0k1mcWFQG8PzAkU8GwOk9WZ3z8MFq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s0b5lRKX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s0b5lRKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB031F0089A;
	Thu, 17 Sep 2026 21:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679395;
	bh=TsxxRk2rsD4P2agekDbPZY1+bsN/QvQNzQco8LQcvlE=;
	h=Date:To:From:Subject;
	b=s0b5lRKXV3ny40K0e4xcyPN1u0sWxy+FjpKTxssD8+PU+bAKd50JzQ7shM3ngtbYR
	 TYCK3yaNMzA4i8ZzeJYhlpsg9CHqqKCxlDV5HuNEkbyO3HqCGweR4HRuvKk9hhA0eO
	 pKe+cnl4bnn5Rzi5tTNtT1DM2fb0wvr6++y97AX0=
Date: Thu, 17 Sep 2026 14:09:54 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-consistently-validate-vma-state-after-mmap-hooks.patch removed from -mm tree
Message-Id: <20260917210955.3DB031F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: consistently validate VMA state after mmap[_prepare] hooks
has been removed from the -mm tree.  Its filename was
     mm-consistently-validate-vma-state-after-mmap-hooks.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: consistently validate VMA state after mmap[_prepare] hooks
Date: Mon, 14 Sep 2026 15:57:24 +0100

When the f_op->mmap_prepare or deprecated f_op->mmap hooks are invoked,
the driver might have done something crazy that is not permitted by the
kernel.

Currently we check for three such cases in __mmap_new_file_vma(), but only
if the legacy f_op->mmap hook is used:

* Did sparc ADI result in invalid flags?

* Did the driver alter vma->vm_start?

* Did the driver make a file-backed mapping on a read-only file writable?

Generalise these checks for both mmap_prepare and mmap and apply to all
invocations of mmap_file(), the f_op->mmap and f_op->mmap_prepare handling
in the core VMA code and the mmap_prepare compatibility layer.

We also WARN_ON_ONCE() on these conditions as they are things that should
simply not occur in the kernel and it's important to call it out when it
does.

We invoke mmap_prepare_validate() after mmap_action_prepare(), as mmap
actions often manipulate state in the descriptor thus providing the final
state the VMA will be derived from.

Also call mmap_validate_vma_flags() in insert_vm_struct() to ensure that
special regions which are inserted (such as a VDSO or VVAR) also satisfy
the sanity checks.

This way every VMA established through an mmap hook, whether via mmap() or
the compatibility layer, or inserted via insert_vm_struct(), has been
validated.  brk() VMAs never pass through a driver hook and so need no
such check.

While we're here, also fixup a couple disjoint blocks of #ifdef
CONFIG_MMU.

Finally, update the VMA userland tests to reflect the change.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-4-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h                   |   49 +++++++++------
 mm/util.c                       |   19 ++++-
 mm/vma.c                        |   96 +++++++++++++++++++++++++-----
 mm/vma.h                        |   24 ++++++-
 tools/testing/vma/include/dup.h |   10 +++
 5 files changed, 156 insertions(+), 42 deletions(-)

--- a/mm/internal.h~mm-consistently-validate-vma-state-after-mmap-hooks
+++ a/mm/internal.h
@@ -214,6 +214,24 @@ static inline void *folio_raw_mapping(co
 }
 
 /*
+ * If the VMA has a close hook then close it, and since closing it might leave
+ * it in an inconsistent state which makes the use of any hooks suspect, clear
+ * them down by installing dummy empty hooks.
+ */
+static inline void vma_close(struct vm_area_struct *vma)
+{
+	if (vma->vm_ops && vma->vm_ops->close) {
+		vma->vm_ops->close(vma);
+
+		/*
+		 * The mapping is in an inconsistent state, and no further hooks
+		 * may be invoked upon it.
+		 */
+		vma->vm_ops = &vma_dummy_vm_ops;
+	}
+}
+
+/*
  * This is a file-backed mapping, and is about to be memory mapped - invoke its
  * mmap hook and safely handle error conditions. On error, VMA hooks will be
  * mutated.
@@ -225,8 +243,11 @@ static inline void *folio_raw_mapping(co
  */
 static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
-	int err = vfs_mmap(file, vma);
+	const unsigned long prev_start = vma->vm_start;
+	const vma_flags_t prev_flags = vma->flags;
+	int err;
 
+	err = vfs_mmap(file, vma);
 	/*
 	 * Either we tried to call the file hook for mmap() and an error arose
 	 * or a driver set vma->vm_ops = NULL intending there to be no VMA
@@ -239,26 +260,16 @@ static inline int mmap_file(struct file
 	 */
 	if (unlikely(err || !vma->vm_ops))
 		vma->vm_ops = &vma_dummy_vm_ops;
+	if (unlikely(err))
+		return err;
 
-	return err;
-}
-
-/*
- * If the VMA has a close hook then close it, and since closing it might leave
- * it in an inconsistent state which makes the use of any hooks suspect, clear
- * them down by installing dummy empty hooks.
- */
-static inline void vma_close(struct vm_area_struct *vma)
-{
-	if (vma->vm_ops && vma->vm_ops->close) {
-		vma->vm_ops->close(vma);
-
-		/*
-		 * The mapping is in an inconsistent state, and no further hooks
-		 * may be invoked upon it.
-		 */
-		vma->vm_ops = &vma_dummy_vm_ops;
+	err = mmap_hook_validate(prev_start, &prev_flags, vma);
+	if (unlikely(err)) {
+		vma->vm_start = prev_start;
+		vma_close(vma);
 	}
+
+	return err;
 }
 
 /* unmap_vmas is in mm/memory.c */
--- a/mm/util.c~mm-consistently-validate-vma-state-after-mmap-hooks
+++ a/mm/util.c
@@ -1224,19 +1224,28 @@ EXPORT_SYMBOL(compat_set_desc_from_vma);
 int __compat_vma_mmap(struct vm_area_desc *desc,
 		      struct vm_area_struct *vma)
 {
+	struct vm_area_desc prev_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&prev_desc, desc->file, vma);
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
-	if (err) {
-		if (desc->vm_file != vma->vm_file)
-			fput(desc->vm_file);
-		return err;
-	}
+	if (err)
+		goto err_put;
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&prev_desc, desc);
+	if (err)
+		goto err_put;
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
 	return mmap_action_complete(vma, &desc->action, /*is_compat=*/true);
+
+err_put:
+	if (desc->vm_file != vma->vm_file)
+		fput(desc->vm_file);
+	return err;
 }
 EXPORT_SYMBOL(__compat_vma_mmap);
 
--- a/mm/vma.c~mm-consistently-validate-vma-state-after-mmap-hooks
+++ a/mm/vma.c
@@ -2623,16 +2623,6 @@ static int __mmap_new_file_vma(struct mm
 		return error;
 	}
 
-	/* Drivers cannot alter the address of the VMA. */
-	WARN_ON_ONCE(map->addr != vma->vm_start);
-	/*
-	 * Drivers should not permit writability when previously it was
-	 * disallowed.
-	 */
-	VM_WARN_ON_ONCE(!vma_flags_same_pair(&map->vma_flags, &vma->flags) &&
-			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
-			vma_test(vma, VMA_MAYWRITE_BIT));
-
 	map->vma_flags = vma->flags;
 
 	return 0;
@@ -2710,11 +2700,6 @@ static int __mmap_new_vma(struct mmap_st
 		vma->flags = map->vma_flags;
 	}
 
-#ifdef CONFIG_SPARC64
-	/* TODO: Fix SPARC ADI! */
-	WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
-#endif
-
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
@@ -2777,6 +2762,76 @@ static void __mmap_complete(struct mmap_
 	vma_set_page_prot(vma);
 }
 
+/* Check to ensure that the VMA flags of a newly mapped VMA are sane. */
+static int mmap_validate_vma_flags(const vma_flags_t *flags)
+{
+#ifdef CONFIG_SPARC64
+	const vm_flags_t legacy_flags = vma_flags_to_legacy(*flags);
+
+	/* TODO: Fix SPARC ADI! */
+	if (WARN_ON_ONCE(!arch_validate_flags(legacy_flags)))
+		return -EINVAL;
+#endif
+
+	return 0;
+}
+
+/* Check to ensure a driver hasn't done something crazy. */
+static int mmap_validate(unsigned long prev_start,
+			 unsigned long curr_start,
+			 const vma_flags_t *prev_flags,
+			 const vma_flags_t *curr_flags)
+{
+	bool was_maywrite, is_maywrite;
+
+	/* Drivers cannot alter the address of the VMA. */
+	if (WARN_ON_ONCE(prev_start != curr_start))
+		return -EINVAL;
+
+	was_maywrite = vma_flags_test(prev_flags, VMA_MAYWRITE_BIT);
+	is_maywrite = vma_flags_test(curr_flags, VMA_MAYWRITE_BIT);
+
+	/* A driver may not make a previously unwritable mapping writable. */
+	if (WARN_ON_ONCE(!was_maywrite && is_maywrite))
+		return -EINVAL;
+
+	return mmap_validate_vma_flags(curr_flags);
+}
+
+/**
+ * mmap_prepare_validate() - Ensure the driver hasn't violated invariants in its
+ * f_op->mmap_prepare hook.
+ * @prev_desc: The VMA descriptor prior to the mmap_prepare hook being called.
+ * @desc: The VMA descriptor after the mmap_prepare hook has been called.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+			  const struct vm_area_desc *desc)
+{
+	return mmap_validate(prev_desc->start, desc->start,
+			     &prev_desc->vma_flags, &desc->vma_flags);
+}
+
+/**
+ * mmap_hook_validate() - Ensure the driver hasn't violated invariants in
+ * its f_op->mmap hook.
+ * @prev_start: The start of the mapping prior to the mmap hook.
+ * @prev_flags: The VMA flags set for the VMA prior to the mmap hook.
+ * @vma: The VMA after the hook has been applied.
+ *
+ * Returns: 0 on success, otherwise an error.
+ */
+int mmap_hook_validate(unsigned long prev_start,
+		       const vma_flags_t *prev_flags,
+		       const struct vm_area_struct *vma)
+{
+	const unsigned long start = vma->vm_start;
+	const vma_flags_t *flags = &vma->flags;
+
+	return mmap_validate(prev_start, start, prev_flags, flags);
+}
+
 static int call_action_prepare(struct mmap_state *map,
 			       struct vm_area_desc *desc)
 {
@@ -2803,6 +2858,7 @@ static int call_action_prepare(struct mm
 static int call_mmap_prepare(struct mmap_state *map,
 		struct vm_area_desc *desc)
 {
+	const struct vm_area_desc prev_desc = *desc;
 	int err;
 
 	/* Invoke the hook. */
@@ -2828,6 +2884,11 @@ static int call_mmap_prepare(struct mmap
 	if (err)
 		return err;
 
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&prev_desc, desc);
+	if (err)
+		return err;
+
 	/*
 	 * MAP_PRIVATE-/dev/zero mappings are an ancient way of getting
 	 * anonymous mappings. Rather than allowing these mappings to be odd
@@ -3455,10 +3516,15 @@ int __vm_munmap(unsigned long start, siz
 int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	unsigned long charged = vma_pages(vma);
+	int err;
 
 	if (find_vma_intersection(mm, vma->vm_start, vma->vm_end))
 		return -ENOMEM;
 
+	err = mmap_validate_vma_flags(&vma->flags);
+	if (err)
+		return err;
+
 	if (vma_test(vma, VMA_ACCOUNT_BIT) &&
 	     security_vm_enough_memory_mm(mm, charged))
 		return -ENOMEM;
--- a/mm/vma.h~mm-consistently-validate-vma-state-after-mmap-hooks
+++ a/mm/vma.h
@@ -782,14 +782,19 @@ struct vm_area_struct *vm_area_alloc(str
 struct vm_area_struct *vm_area_dup(struct vm_area_struct *orig);
 void vm_area_free(struct vm_area_struct *vma);
 
-/* vma_exec.c */
 #ifdef CONFIG_MMU
+int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+			  const struct vm_area_desc *desc);
+
+int mmap_hook_validate(unsigned long prev_start,
+		       const vma_flags_t *prev_flags,
+		       const struct vm_area_struct *vma);
+
+/* vma_exec.c */
 int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 			  unsigned long *top_mem_p);
 int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
-#endif
 
-#ifdef CONFIG_MMU
 /*
  * Denies creating a writable executable mapping or gaining executable permissions.
  *
@@ -838,6 +843,19 @@ static inline bool map_deny_write_exec(c
 
 	return false;
 }
+#else
+static inline int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+					const struct vm_area_desc *desc)
+{
+	return 0;
+}
+
+static inline int mmap_hook_validate(unsigned long prev_start,
+				     const vma_flags_t *prev_flags,
+				     const struct vm_area_struct *vma)
+{
+	return 0;
+}
 #endif
 
 struct vm_area_struct *__install_special_mapping(struct mm_struct *mm,
--- a/tools/testing/vma/include/dup.h~mm-consistently-validate-vma-state-after-mmap-hooks
+++ a/tools/testing/vma/include/dup.h
@@ -1359,15 +1359,25 @@ static inline int vfs_mmap_prepare(struc
 	return file->f_op->mmap_prepare(desc);
 }
 
+int mmap_prepare_validate(const struct vm_area_desc *prev_desc,
+			  const struct vm_area_desc *desc);
+
 static inline int __compat_vma_mmap(struct vm_area_desc *desc,
 		struct vm_area_struct *vma)
 {
+	struct vm_area_desc prev_desc;
 	int err;
 
+	/* Derive state prior to mmap_prepare hook. */
+	compat_set_desc_from_vma(&prev_desc, desc->file, vma);
 	/* Perform any preparatory tasks for mmap action. */
 	err = mmap_action_prepare(desc);
 	if (err)
 		return err;
+	/* Check the caller did nothing crazy. */
+	err = mmap_prepare_validate(&prev_desc, desc);
+	if (err)
+		return err;
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-huge_memory-zap-deposited-page-tables-after-an-rcu-grace-period.patch
mm-enable-mmu_gather_rcu_table_free-for-most-2-level-architectures.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-riscv.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch
mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc64.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch
mm-enable-mmu_gather_rcu_table_free-for-sh-x2.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch
mm-make-userland-page-table-freeing-rcu-safe.patch
mm-change-the-contract-for-free_pgtables-update-docs.patch
mm-vma-ensure-mmap_prepare-doesnt-set-actions-on-a-mergeable-vma.patch
mm-make-map_kernel_pages_-internal-and-unexported.patch
mm-vma-tidy-up-map-kernel-pages-enum-values.patch
mm-add-mmap-action-for-discontiguous-kernel-page-mapping.patch
docs-filesystems-update-mmap_prepare-docs-for-discontig-kernel-pgs.patch
drivers-usb-mon-update-to-use-mmap_prepare-map-kernel-pages.patch
infiniband-update-hfi1-to-use-remap_vmalloc_range.patch
selinux-reject-writable-opens-of-policy-file-drop-mmap-shared-write-check.patch
alsa-pcm-use-vm_insert_page-to-map-pcm-status-page.patch
bpf-arena-mark-arena_map_mmap-mappings-vm_mixedmap.patch
mm-vma-add-vma_is_kernel_owned-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-kernel-owned.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-only-kernel-owned-mappings-may-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_kernel_owned.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch
mm-vma-introduce-vma_is_persistent.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-introduce-and-use-vma_can_gup.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch

