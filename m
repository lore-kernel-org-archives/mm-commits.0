Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DD6372071
	for <mm-commits@vger.kernel.org>; Sun, 27 Sep 2026 21:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546153; cv=none; b=XGPgwQrl+XOc2J5vd3cUb/oDGIvNt/ziwshb8rTfX2/MooiN+wiiBkfal3Yv1Zjk1XrLcMl3blgUyi2V9+zLlWwBc7QmyX+aM9nXLR1IBpEhO2QXUL9xItGkuk9ulDRuizoVmzaTV3KgVuOnqtzvdVHt5INofh0o3D33NyZOFxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546153; c=relaxed/simple;
	bh=gYnRKU1cPd3o+7E8QogxhX3tj1Fw0AUJwQ4i2mYYOXg=;
	h=Date:To:From:Subject:Message-Id; b=OqOT1zG8/5t4pxD4kOKX+uIRI6zyCZ0Qyc08bRqaU9tiAVirP0+wcYTqx6hleXsp6KmbZJWaUvuJptbRcBsNHWA1NFE/mC9h0MZq5L4xWF/Id/9o2RuSQCTdizpPsjm5FLTSzAuW6+S+fLBaDZPJvPUJT6GdXrFvJMQ0nKvmkek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q8LcAhet; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q8LcAhet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123161F000FF;
	Sun, 27 Sep 2026 21:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790546151;
	bh=S1Q/RogLKgQJ4QbOQEEEHFXVO8p7fFA0tnSOA3Hiqfs=;
	h=Date:To:From:Subject;
	b=q8LcAhet7BvYD3T5Ay68dnhp3q8WC5QWOfPtNpH8Lo7/eOqkCFvJE4BcJIJfWE1O8
	 bExIfTNX6/Zyba79XSsgP/T3YGfxjsa9nxHVmjkCYQqOINAIjuePXkSCs+z0OM9gp2
	 waCr2jMXb1nDUnqd75giSEDPvlogYAkVwxONsp7g=
Date: Sun, 27 Sep 2026 14:55:50 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch added to mm-unstable branch
Message-Id: <20260927215551.123161F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
Date: Tue, 08 Sep 2026 12:23:40 +0100

In order to use mmap_prepare() with MAP_PRIVATE mappings of /dev/zero
without the success_hook hack we explicitly permitted mmap_prepare
handlers to set NULL vm_ops.

However this is dangerous and we really only want to allow this for
MAP_PRIVATE-mapped /dev/zero.

Therefore use the newly introduced file_is_dev_zero() to uniquely identify
MAP_PRIVATE-/dev/zero mappings and only permit this behaviour for them.

Then, remove all ability for mmap_prepare or mmap hooks to set a VMA
anonymous and update mmap_zero_prepare() to leave it to the core mmap code
to do so.

Note that this disallows nested MAP_PRIVATE-mappings of /dev/zero regions.
Doing this would be broken in any case.

We therefore do not need to update the mmap_prepare() compatibility layer
to reflect these changes, as the mmap hook check suffices to disallow this
behaviour.

Now we're setting vma->vm_ops to NULL for an mmap_prepare-initialised
MAP_PRIVATE-/dev/zero mapping, we have to avoid a subtle issue when
updating user-defined fields via set_vma_user_defined_fields().

The default for vma->vm_ops for all mmap_prepare-initialised mappings is
vma_dummy_vm_ops, so map->vm_ops will be set to this and setting
vma->vm_ops to this will render the VMA mistakenly non-anon.

In general, we should never be setting user-defined fields for an
anonymous VMA, so explicitly check for this to avoid doing so for the one
case where a mapping can be both mmap_prepare and anonymous.

In the case of legacy ->mmap hooks some drivers may set vma->vm_ops NULL
believing this is the equivalent of setting no VMA operations.  Therefore
update mmap_file() to correct this by setting dummy VMA operations if this
occurs.

An example of this is drm_gem_shmem_mmap() which deliberately clears
vma->vm_ops before handing the VMA to dma-buf.  Cases such as this will be
updated when they are converted to mmap_prepare.

Also, in order to avoid a single commit bisection hazard, add a temporary
workaround to set the VMA anonymous only after vma->vm_file is assigned in
__mmap_new_file_vma().

This is because vma_set_range() calls vma_set_pgoff() and
assert_sane_pgoff() in turn, prior to the vma->vm_file being assigned.  If
we set the VMA anonymous early then this assert will fail.

This is removed in the subsequent commit.

Link: https://lore.kernel.org/20260908-map-private-dev-zero-v2-3-acc7b5625305@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/char-mem.c |    6 +-----
 mm/internal.h |   17 ++++++++++-------
 mm/vma.c      |   31 ++++++++++++++++++++++++-------
 3 files changed, 35 insertions(+), 19 deletions(-)

--- a/mm/char-mem.c~mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous
+++ a/mm/char-mem.c
@@ -508,11 +508,7 @@ static int mmap_zero_prepare(struct vm_a
 	if (vma_desc_test(desc, VMA_SHARED_BIT))
 		return shmem_zero_setup_desc(desc);
 
-	/*
-	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
-	 * of /dev/zero anonymous, despite it not being.
-	 */
-	vma_desc_set_anonymous(desc);
+	/* MAP_PRIVATE semantics are taken care of for us by core mm. */
 	return 0;
 }
 
--- a/mm/internal.h~mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous
+++ a/mm/internal.h
@@ -226,15 +226,18 @@ static inline int mmap_file(struct file
 {
 	int err = vfs_mmap(file, vma);
 
-	if (likely(!err))
-		return 0;
-
 	/*
-	 * OK, we tried to call the file hook for mmap(), but an error
-	 * arose. The mapping is in an inconsistent state and we must not invoke
-	 * any further hooks on it.
+	 * Either we tried to call the file hook for mmap() and an error arose
+	 * or a driver set vma->vm_ops = NULL intending there to be no VMA
+	 * operations.
+	 *
+	 * In the former case the VMA is in an inconsistent state and we mustn't
+	 * invoke any further hooks on it, in the latter case the hook actually
+	 * wanted no further hooks to be invoked, so fix both by setting dummy
+	 * VMA ops.
 	 */
-	vma->vm_ops = &vma_dummy_vm_ops;
+	if (unlikely(err || !vma->vm_ops))
+		vma->vm_ops = &vma_dummy_vm_ops;
 
 	return err;
 }
--- a/mm/vma.c~mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous
+++ a/mm/vma.c
@@ -2644,6 +2644,19 @@ static int __mmap_new_file_vma(struct mm
 	return 0;
 }
 
+static bool map_is_private(const struct mmap_state *map)
+{
+	return !vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
+}
+
+static bool map_is_anon(const struct mmap_state *map)
+{
+	if (!map_is_private(map))
+		return false;
+
+	return !map->file || file_is_dev_zero(map->file);
+}
+
 /*
  * __mmap_new_vma() - Allocate a new VMA for the region, as merging was not
  * possible.
@@ -2657,8 +2670,7 @@ static int __mmap_new_file_vma(struct mm
 static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	struct mmap_action *action)
 {
-	const bool is_anon = !map->file &&
-		!vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
+	const bool is_anon = map_is_anon(map);
 	struct vma_iterator *vmi = map->vmi;
 	int error = 0;
 	struct vm_area_struct *vma;
@@ -2674,7 +2686,7 @@ static int __mmap_new_vma(struct mmap_st
 
 	vma_iter_config(vmi, map->addr, map->end);
 
-	if (is_anon)
+	if (is_anon && !map->file)
 		vma_set_anonymous(vma);
 
 	vma_set_range(vma, map->addr, map->end, map->pgoff, map->anon_pgoff);
@@ -2692,6 +2704,10 @@ static int __mmap_new_vma(struct mmap_st
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
 
+	/* Temporary MAP_PRIVATE-/dev/zero workaround. */
+	if (is_anon && map->file)
+		vma_set_anonymous(vma);
+
 	if (error)
 		goto free_iter_vma;
 
@@ -2800,6 +2816,10 @@ static int call_mmap_prepare(struct mmap
 	if (err)
 		return err;
 
+	/* Hooks cannot mark themselves anonymous. */
+	if (!desc->vm_ops)
+		return -EINVAL;
+
 	err = call_action_prepare(map, desc);
 	if (err)
 		return err;
@@ -2822,10 +2842,7 @@ static int call_mmap_prepare(struct mmap
 static void set_vma_user_defined_fields(struct vm_area_struct *vma,
 		struct mmap_state *map)
 {
-	if (map->vm_ops)
-		vma->vm_ops = map->vm_ops;
-	else	/* Only /dev/zero should do this. */
-		vma_set_anonymous(vma);
+	vma->vm_ops = map->vm_ops;
 	vma->vm_private_data = map->vm_private_data;
 }
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-mremap-fix-locked_vm-leak-from-mremap_dontunmap-self-merge.patch
mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap.patch
mm-vmpressure-remove-window-size-todo.patch
tools-testing-selftests-mm-add-missing-gitignore-entries.patch
mm-move-drivers-char-memc-to-mm-char-memc.patch
mm-implement-file_is_dev_zero-to-uniquely-identify-dev-zero.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-madvise-swap-in-cowd-map_private-file-mappings-on-madv_willneed.patch
mm-khugepaged-deposit-a-newly-allocated-page-table-on-collapse.patch
mm-enable-mmu_gather_rcu_table_free-for-most-2-level-architectures.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-riscv.patch
mm-enable-mmu_gather_rcu_table_free-for-mmu-arm.patch
mm-enable-mmu_gather_rcu_table_free-for-arc-microblaze-xtensa.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc64.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-coldfire.patch
mm-enable-mmu_gather_rcu_table_free-for-sh-x2.patch
mm-enable-mmu_gather_rcu_table_free-for-m68k-motorola.patch
mm-enable-mmu_gather_rcu_table_free-for-sparc32.patch
mm-userland-pgtable-freeing-is-rcu-safe-now-remove-leftover-bits.patch
mm-change-the-contract-for-free_pgtables-update-docs.patch
mm-vma-fix-mmap_prepare-file-handling-remove-file_doesnt_need_get.patch
mm-vma-introduce-and-use-vma_can_merge.patch
mm-consistently-validate-vma-state-after-mmap-hooks.patch
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
mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch

