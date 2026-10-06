Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E183D6CB0;
	Tue,  6 Oct 2026 23:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330291; cv=none; b=aKFsMFGX+wgJWCXxVSetcIT0Raaq51BY184/3uKqTdAFjjuPLyaEYy/EfR150DTFogddwUBS4yKDYBbM6HC8PCeKMZvswRyLoUyjP0Bp0agb/4Dj7v1Q0w4KaKacnojO/zbI595pQ7Aol8wDk58q7gEHExSHTVs4NDqE0CvhwVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330291; c=relaxed/simple;
	bh=uGmTm53AvCPGqKxwXfY4VR1IV2mqRKprO94nWyMhazI=;
	h=Date:To:From:Subject:Message-Id; b=qFwrQZkQ7LJi1GFppxFcr5v1f0eWXfLKpJmiAx/Lzg1Oqe55Vvoen0tevw8dNiciZQaj26bpBjXxq3mDQJHN670V+GgT/Pma9izpeaf7Ajj8iUY/m3tXTtDFXJ04GrtSkgvZtzs/14wWrxpLV1jLHZP6y6HDMF+IvqoV8vO0u1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YVTIr4++; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YVTIr4++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2E11F0089C;
	Tue,  6 Oct 2026 23:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791330289;
	bh=20Pmg9+kLtppSxFDBy4tVmHHIfU38eYh1XpBhoi9/4w=;
	h=Date:To:From:Subject;
	b=YVTIr4++2zU01eU+NHo69TQpxwIMLjrxSj+WU87+pCQb5GEVL2gyKUB2oNlvTfNxr
	 a77nIWfbz3QRl0MZm3puNgPmKswlLA4PiFlIsYZ9dL5P3ZJbZyLAr4d9n7Pku8Ak4c
	 sPAHJBjuCs/11Rlo2DIX/urM0nAV3/CdKLTIbF58=
Date: Tue, 06 Oct 2026 16:44:48 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,pfalcato@suse.de,minchan@kernel.org,liam@infradead.org,kas@kernel.org,jannh@google.com,bgeffon@google.com,azpijr@gmail.com,asrinivasan@oss.tenstorrent.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap.patch removed from -mm tree
Message-Id: <20261006234448.EB2E11F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP
Date: Wed, 30 Sep 2026 19:47:10 +0100

The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
operations that keep the original VMA in place.

Historically this has led to a lot of bugs where non-obvious interactions
occur between existing mremap() operations and the original VMA.

Fix another of these - partial copies.

The long-standing mremap() partial VMA logic has the baked-in assumption
that the originating VMA is unmapped and thus moved.

However MREMAP_DONTUNMAP defeats this by performing a partial copy
instead since it keeps the source VMA around.

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
mremap()'d distinct from the rest of it, a.k.a. split it.

Therefore resolve this issue by splitting it ahead of the rest of the
mremap() operation if the VMA is mlock()'d.

This is valid, as the source VMA will lose its VMA_LOCKED_BIT flag, so if a
partial remap it will become distinct from the rest of the VMA.

In order to make this change re-expose split_vma() in vma.h for
CONFIG_MMU (nommu doesn't compile mremap.c and uses a static helper
instead).

Finally, update the sys_map_count check to account for this case.

Note that the early check does not use needs_pre_split() - this is because
the VMA has not been looked up by this point, so be conservative and assume
that the VMA is mlock()'d in this case for the purposes of the
sys_map_count check.

Link: https://lore.kernel.org/20260930-fix-dontunmap-partial-self-merge-v2-2-f388985a0f0a@kernel.org
Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
---

 mm/mremap.c |   62 +++++++++++++++++++++++++++++++++++++-------------
 mm/vma.c    |    4 +--
 mm/vma.h    |    5 ++++
 3 files changed, 53 insertions(+), 18 deletions(-)

--- a/mm/mremap.c~mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap
+++ a/mm/mremap.c
@@ -1037,6 +1037,7 @@ static void vrm_stat_account(struct vma_
 }
 
 static bool __check_map_count_against_split(struct mm_struct *mm,
+					    bool pre_split,
 					    bool before_unmaps)
 {
 	const int sys_map_count = get_sysctl_max_map_count();
@@ -1088,26 +1089,42 @@ static bool __check_map_count_against_sp
 	 * Therefore we must check to ensure we have headroom of 2 additional
 	 * VMAs.
 	 */
-	return map_count + 2 <= sys_map_count;
+	map_count += 2;
+
+	/* If pre-split, the -1 observed above doesn't apply. */
+	if (pre_split)
+		map_count++;
+
+	return map_count <= sys_map_count;
+}
+
+static bool needs_pre_split(struct vma_remap_struct *vrm)
+{
+	/*
+	 * An MREMAP_DONTUNMAP of a mlock()'d VMA needs to unlock the
+	 * source VMA, so split in this case.
+	 */
+	return (vrm->flags & MREMAP_DONTUNMAP) &&
+		vma_test(vrm->vma, VMA_LOCKED_BIT);
 }
 
 /* Do we violate the map count limit if we split VMAs when moving the VMA? */
-static bool check_map_count_against_split(void)
+static bool check_map_count_against_split(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
-					       /*before_unmaps=*/false);
+		needs_pre_split(vrm), /*before_unmaps=*/false);
 }
 
 /* Do we violate the map count limit if we split VMAs prior to early unmaps? */
-static bool check_map_count_against_split_early(void)
+static bool check_map_count_against_split_early(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
-					       /*before_unmaps=*/true);
+		vrm->flags & MREMAP_DONTUNMAP, /*before_unmaps=*/true);
 }
 
 /*
- * Perform checks before attempting to write a VMA prior to it being
- * moved.
+ * Perform checks and preparation before attempting to write a VMA prior to it
+ * being moved.
  */
 static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 {
@@ -1116,19 +1133,17 @@ static unsigned long prep_move_vma(struc
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
@@ -1146,6 +1161,21 @@ static unsigned long prep_move_vma(struc
 	if (err)
 		return err;
 
+	/*
+	 * To account mlock()'d pages correctly in the MREMAP_DONTUNMAP
+	 * case perform any split ahead of time for an mlock()'d VMA.
+	 */
+	if (needs_pre_split(vrm)) {
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
 
@@ -2006,7 +2036,7 @@ static unsigned long do_mremap(struct vm
 		return -EINTR;
 	vrm->mmap_locked = true;
 
-	if (!check_map_count_against_split_early()) {
+	if (!check_map_count_against_split_early(vrm)) {
 		mmap_write_unlock(mm);
 		return -ENOMEM;
 	}
--- a/mm/vma.c~mm-mremap-fix-locked_vm-leak-by-splitting-vma-for-mremap_dontunmap
+++ a/mm/vma.c
@@ -634,8 +634,8 @@ out_free_vma:
  * Split a vma into two pieces at address 'addr', a new vma is allocated
  * either for the first part or the tail.
  */
-static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
-		     unsigned long addr, int new_below)
+int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
+	      unsigned long addr, int new_below)
 {
 	if (vma->vm_mm->map_count >= get_sysctl_max_map_count())
 		return -ENOMEM;
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
mm-vma-add-vma_is_mm_managed-predicates.patch
mm-vma-only-allow-mmap-to-clear-vma_maywrite_bit-if-not-mm-managed.patch
mm-vma-add-and-use-vma__is_fixed_mapping.patch
scsi-sg-convert-mmap-hook-to-mmap_prepare-and-rework.patch
fbdev-defio-assert-fbinfo_virtfb-drop-vm_io-add-vm_mixedmap.patch
hsi-cmt_speech-convert-mmap-hook-to-mmap_prepare-refactor.patch
mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch
uprobes-remove-vm_io-set-vm_mixedmap-for-mapped-kernel-pages.patch
mm-mlock-clear-vma_locked_mask-over-mmap-callback.patch
mm-mlock-eliminate-weird-vma_io_bit-abuse-and-simplify.patch
mm-vma-enforce-that-mm-managed-mappings-may-not-set-vma_io_bit.patch
mm-remove-vma_io_bit-check-in-vma_is_mm_managed.patch
mm-remove-hugetlb_inlineh.patch
mm-rename-is_vm_hugetlb_page-to-vma_is_hugetlb.patch
mm-drop-some-redundant-checks-around-hugetlb-vmas.patch
mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch
mm-vma-introduce-vma_is_mm_backed.patch
mm-uffd-use-predicates-for-userfaultfd-checks.patch
mm-madvise-use-predicates-for-madvise-madv_dofork.patch
mm-eliminate-vma_special_flags-usage-when-hugetlb-explicitly-tested.patch
mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch
mm-vma-dont-remove-vma-from-rmap-if-pgoff-unchanged.patch

