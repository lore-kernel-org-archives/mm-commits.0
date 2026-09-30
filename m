Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD5B350A05
	for <mm-commits@vger.kernel.org>; Wed, 30 Sep 2026 22:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790806522; cv=none; b=R0FvymXMzDUoCQDAi9fP5HH/WqtPnxOY6BGbCkryHFWDO+jcMiu1PxaBzlebAVJ6BJNQP2OZS1e5/SUxBKzfNSBrwyvXDI/G8Lm1kiWpNWpqGLDP2NPe3xGD60CrymJzDRlKS8t8XGsWziXHePx6cm6hRrrfUGSs3HqXn7F6JR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790806522; c=relaxed/simple;
	bh=EsfxUfDR4AZDPTumob63QafJyH+NFdPRUwdib1ok4WI=;
	h=Date:To:From:Subject:Message-Id; b=BUJYyrP9b0xXFiGFCceSmrxc6V3QiRnbtK38YeI1cWnyfcmFX2AVPouRg2kEX8JjBBgkgsfb1iEr7WYJqvPPnT0SgLdDXrowWloO9KGZOhtDpQI01mtxBVyFORxu1Dn6AIpThjdyVkpkem5nWuxb7v/nWSKLtmdfVenTEYcLPS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r5iXFtD6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r5iXFtD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008D71F00898;
	Wed, 30 Sep 2026 22:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790806520;
	bh=TRn5g7m0mbleDVWBh1O7JCIPWdeghF+mcMyz4naHF9Q=;
	h=Date:To:From:Subject;
	b=r5iXFtD66cPL9NNpmgWc6prErKuL3yvMCQWa9eC0zXcIQLUgFT2ZnQBJ9BOx3vqkl
	 IEflbZyLKSP4Z+FlijcNla2eun3Xd+ci0HQiKPRCIbx4uT6pBubQefsv0+s7f3rWJd
	 P+Fz8W7MEm827vQervXVZ9Ph/e1uQXd2edl2SBzQ=
Date: Wed, 30 Sep 2026 15:15:19 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap.patch removed from -mm tree
Message-Id: <20260930221520.008D71F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP
Date: Sun, 20 Sep 2026 15:13:11 +0100

The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
operations that keep the original VMA in place.

Historically this has led to a lot of bugs where non-obvious interactions
occur between existing mremap() operations and the original VMA.

Fix another of these - partial copies.

The long-standing mremap() partial VMA logic has the baked-in assumption
that the originating VMA is unmapped and thus moved.

However MREMAP_DONTUNMAP defeats this by performing a partial copy instead
since it keeps the source VMA around.

An mremap(..., MREMAP_DONTUNMAP) operation disallows resizing of the VMA,
but the operation can be performed partially:

                           |-----------------|
                           |                 |
                           |                 v
                        <------>          <------>
                        .new_sz.           new_sz
                     |--.------.--|       |------|
                     |  .source.  |       | dest |
                     |--.------.--|       |------|
                     <------------>
                         old_sz

The page tables in the specified range are moved, but the original VMA is
kept intact.

This interacts poorly with mlock()'d VMAs, as the VMA_LOCKED_BIT flag is
cleared for the entire source VMA and set for the entire destination VMA.

This results in an mm->locked_vm leak as the change is therefore not
accounted correctly.

The clear solution here is to make the portion of the source VMA which is
mremap()'d distinct from the rest of it, a.k.a.  split it.

Therefore resolve this issue by splitting it ahead of the rest of the
mremap() operation.

In order to make this change re-expose split_vma() in vma.h for CONFIG_MMU
(nommu doesn't compile mremap.c and uses a static helper instead).

A quick search of how MREMAP_DONTUNMAP is used in the wild suggests that
the partial case is either unused or rarely used, so this should not
result in unreasonable VMA proliferation.

Since this makes every mremap() MREMAP_DONTUNMAP operation operate across
an entire, distinct, VMA, also eliminate now-redundant code checking for
this in dontunmap_complete().

Finally, update the sys_map_count check to account for this case.

Link: https://lore.kernel.org/20260920-fix-dontunmap-partial-self-merge-v1-2-6ffb556f8f8b@kernel.org
Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/mremap.c |   81 ++++++++++++++++++++++++++++++--------------------
 mm/vma.c    |    2 -
 mm/vma.h    |    5 +++
 3 files changed, 56 insertions(+), 32 deletions(-)

--- a/mm/mremap.c~mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap
+++ a/mm/mremap.c
@@ -1037,6 +1037,7 @@ static void vrm_stat_account(struct vma_
 }
 
 static bool __check_map_count_against_split(struct mm_struct *mm,
+					    bool is_dontunmap,
 					    bool before_unmaps)
 {
 	const int sys_map_count = get_sysctl_max_map_count();
@@ -1088,26 +1089,38 @@ static bool __check_map_count_against_sp
 	 * Therefore we must check to ensure we have headroom of 2 additional
 	 * VMAs.
 	 */
-	return map_count + 2 <= sys_map_count;
+	map_count += 2;
+
+	/*
+	 * If MREMAP_DONTUNMAP is set and a partial operation is performed,
+	 * the VMA is split ahead of time and the -1 observed above doesn't
+	 * apply.
+	 */
+	if (is_dontunmap)
+		map_count++;
+
+	return map_count <= sys_map_count;
 }
 
 /* Do we violate the map count limit if we split VMAs when moving the VMA? */
-static bool check_map_count_against_split(void)
+static bool check_map_count_against_split(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
+					       vrm->flags & MREMAP_DONTUNMAP,
 					       /*before_unmaps=*/false);
 }
 
 /* Do we violate the map count limit if we split VMAs prior to early unmaps? */
-static bool check_map_count_against_split_early(void)
+static bool check_map_count_against_split_early(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
+					       vrm->flags & MREMAP_DONTUNMAP,
 					       /*before_unmaps=*/true);
 }
 
 /*
- * Perform checks before attempting to write a VMA prior to it being
- * moved.
+ * Perform checks and preparation before attempting to write a VMA prior to it
+ * being moved.
  */
 static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 {
@@ -1116,19 +1129,17 @@ static unsigned long prep_move_vma(struc
 	unsigned long old_addr = vrm->addr;
 	unsigned long old_len = vrm->old_len;
 	vm_flags_t dummy = vma->vm_flags;
+	const bool split_before = vma->vm_start != old_addr;
+	const bool split_after = vma->vm_end != old_addr + old_len;
 
-	/*
-	 * We'd prefer to avoid failure later on in do_munmap: we copy a VMA,
-	 * which may not merge, then (if MREMAP_DONTUNMAP is not set) unmap the
-	 * source, which may split, causing a net increase of 2 mappings.
-	 */
-	if (!check_map_count_against_split())
+	/* Avoid failure later on. */
+	if (!check_map_count_against_split(vrm))
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
-		if (vma->vm_start != old_addr)
+		if (split_before)
 			err = vma->vm_ops->may_split(vma, old_addr);
-		if (!err && vma->vm_end != old_addr + old_len)
+		if (!err && split_after)
 			err = vma->vm_ops->may_split(vma, old_addr + old_len);
 		if (err)
 			return err;
@@ -1146,6 +1157,21 @@ static unsigned long prep_move_vma(struc
 	if (err)
 		return err;
 
+	/*
+	 * To account mlock()'d pages correctly in the MREMAP_DONTUNMAP
+	 * case perform any split ahead of time.
+	 */
+	if (vrm->flags & MREMAP_DONTUNMAP) {
+		VMA_ITERATOR(vmi, vma->vm_mm, old_addr);
+
+		if (split_before)
+			err = split_vma(&vmi, vma, old_addr, 1);
+		if (!err && split_after)
+			err = split_vma(&vmi, vma, old_addr + old_len, 0);
+		vrm->vmi_needs_invalidate = true;
+		return err;
+	}
+
 	return 0;
 }
 
@@ -1330,11 +1356,8 @@ static int copy_vma_and_data(struct vma_
 static void dontunmap_complete(struct vma_remap_struct *vrm,
 			       struct vm_area_struct *new_vma)
 {
-	unsigned long start = vrm->addr;
-	unsigned long end = vrm->addr + vrm->old_len;
 	struct vm_area_struct *vma = vrm->vma;
-	unsigned long old_start = vma->vm_start;
-	unsigned long old_end = vma->vm_end;
+	const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
 
 	/* Self-merge is disallowed. */
 	VM_WARN_ON_ONCE(new_vma == vma);
@@ -1346,19 +1369,15 @@ static void dontunmap_complete(struct vm
 	 * anon_vma links of the old vma is no longer needed after its page
 	 * table has been moved.
 	 */
-	if (start == old_start && end == old_end) {
-		const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
-
-		unlink_anon_vmas(vma);
-		/*
-		 * The VMA is now unfaulted and it is an invariant that
-		 * unfaulted anonymous VMAs have page offset equal to
-		 * vma->vm_start >> PAGE_SHIFT.
-		 */
-		vma_set_anon_pgoff(vma, pgoff_unfaulted);
-		if (vma_is_anonymous(vma) && !vma->vm_file)
-			vma_set_pgoff(vma, pgoff_unfaulted);
-	}
+	unlink_anon_vmas(vma);
+	/*
+	 * The VMA is now unfaulted and it is an invariant that
+	 * unfaulted anonymous VMAs have page offset equal to
+	 * vma->vm_start >> PAGE_SHIFT.
+	 */
+	vma_set_anon_pgoff(vma, pgoff_unfaulted);
+	if (vma_is_anonymous(vma) && !vma->vm_file)
+		vma_set_pgoff(vma, pgoff_unfaulted);
 }
 
 static unsigned long move_vma(struct vma_remap_struct *vrm)
@@ -2006,7 +2025,7 @@ static unsigned long do_mremap(struct vm
 		return -EINTR;
 	vrm->mmap_locked = true;
 
-	if (!check_map_count_against_split_early()) {
+	if (!check_map_count_against_split_early(vrm)) {
 		mmap_write_unlock(mm);
 		return -ENOMEM;
 	}
--- a/mm/vma.c~mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap
+++ a/mm/vma.c
@@ -634,7 +634,7 @@ out_free_vma:
  * Split a vma into two pieces at address 'addr', a new vma is allocated
  * either for the first part or the tail.
  */
-static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
+int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		     unsigned long addr, int new_below)
 {
 	if (vma->vm_mm->map_count >= get_sysctl_max_map_count())
--- a/mm/vma.h~mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap
+++ a/mm/vma.h
@@ -556,6 +556,11 @@ int do_brk_flags(struct vma_iterator *vm
 unsigned long unmapped_area(struct vm_unmapped_area_info *info);
 unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info);
 
+#ifdef CONFIG_MMU
+int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	      unsigned long addr, int new_below);
+#endif
+
 static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
 {
 	/*
_

Patches currently in -mm which might be from ljs@kernel.org are

drivers-char-mem-mmap-readonly-map_shared-dev-zero-correctly.patch
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

