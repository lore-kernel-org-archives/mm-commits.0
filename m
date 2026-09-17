Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2074E0B7A
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679424; cv=none; b=Lh3TaHkCl1vz0UNserv8bhitfRLPSF0Ykq/qwWXW80Uz/PfmJSlMDcd0StuVFbMnV9XJFXm7wSagMA+FooMoO1pmY1sll3QdGPfvwFHvgrU1fEoTAZlNcrS1F5/W41OC8vudxiWCyXxV5h9i5L7Uv1TDlS9wGHm+vc00/vGuRH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679424; c=relaxed/simple;
	bh=6z3qGVPSHq1G4ybHjLYvCQ5eYQSxw1yfiUt29z4v4xY=;
	h=Date:To:From:Subject:Message-Id; b=e854D8ibdMwLEAHEwjZnzMyyoET2GXoiY3Gc04Or2tsV3+XXyVtVD4Uobt0wgyJDlvpz8u73HI/MaJnf/TraxpoM25NzsTkJsy6ByBqz7BP8FOCZHOhrH3UV3sGpXKvw0n5BO9iWj5M0j23DL9OZV8U2UPNCJfpYN296U491GQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0hDTTFda; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0hDTTFda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8AD1F00893;
	Thu, 17 Sep 2026 21:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679421;
	bh=W/vedmz0KyhaBhTHx4lPouFfn/eTClUx7XH7mL/K8LY=;
	h=Date:To:From:Subject;
	b=0hDTTFda4ccY2Ol6EaxMXyasJD6jgXx9OEgMvyqc22CrbYC+f8Q1JOnNmLpxH2HVS
	 hCyIkqjFO5pFrCfXTLhpsXCniPYEUs4/8yMbdN6UQ1hvf0/O5hlzfeFHwln43DaH/J
	 r24hl8ouFvak0kny6JNBcQk1dYEI5u3flc/yReSQ=
Date: Thu, 17 Sep 2026 14:10:20 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-remove-vma_io_bit-check-in-vma_is_kernel_owned.patch removed from -mm tree
Message-Id: <20260917211021.3B8AD1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove VMA_IO_BIT check in vma[_flags]_is_kernel_owned()
has been removed from the -mm tree.  Its filename was
     mm-remove-vma_io_bit-check-in-vma_is_kernel_owned.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: remove VMA_IO_BIT check in vma[_flags]_is_kernel_owned()
Date: Mon, 14 Sep 2026 15:57:46 +0100

We have now made it such that every driver which sets VMA_IO_BIT marks it
as kernel-owned.

However, vma_flags_is_kernel_owned() currently checks for VMA_IO_BIT. 
This was a product of drivers previously marking a range as kernel-owned
by setting VMA_IO_BIT alone.

Fix this by removing the VMA_IO_BIT check in vma_flags_is_kernel_owned(),
and update mmap_validate_vma_flags() to use vma_flags_is_kernel_owned()
rather than open-coding the VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT check.

This change means that vma[_flags]_can_merge() doesn't check VMA_IO_BIT
any longer (which is now redundant) as it calls
vma_flags_is_kernel_owned().

Now that the predicate means precisely VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT,
also use it at the other sites which open-code that pair, so the intent is
stated rather than the flags, with no functional change:

zap_special_vma_range() only zaps kernel-owned mappings, as drivers use it
to tear down ranges they established themselves.

The mprotect() arch PFN modification check applies to kernel-owned
mappings, which may map PFNs without struct pages.

NUMA balancing skips VM_MIXEDMAP mappings having already excluded VM_IO
and VM_PFNMAP mappings via vma_migratable(), so it skips exactly the
kernel-owned mappings - say so.

Finally, update the VMA userland merge 'special' flag tests to no longer
assert that VMA_IO_BIT prevents merge as VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT
now suffices.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-26-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h              |    3 +--
 kernel/sched/fair.c             |    2 +-
 mm/memory.c                     |    6 +++---
 mm/mprotect.c                   |    3 +--
 mm/vma.c                        |    2 +-
 tools/testing/vma/include/dup.h |    3 +--
 tools/testing/vma/tests/merge.c |   10 ++--------
 7 files changed, 10 insertions(+), 19 deletions(-)

--- a/include/linux/mm.h~mm-remove-vma_io_bit-check-in-vma_is_kernel_owned
+++ a/include/linux/mm.h
@@ -1630,8 +1630,7 @@ static inline bool vma_is_shared_maywrit
  */
 static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
 {
-	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
-				  VMA_IO_BIT);
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
 /**
--- a/kernel/sched/fair.c~mm-remove-vma_io_bit-check-in-vma_is_kernel_owned
+++ a/kernel/sched/fair.c
@@ -4212,7 +4212,7 @@ retry_pids:
 
 	for (; vma; vma = vma_next(&vmi)) {
 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
-			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
+			is_vm_hugetlb_page(vma) || vma_is_kernel_owned(vma)) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
 			continue;
 		}
--- a/mm/memory.c~mm-remove-vma_io_bit-check-in-vma_is_kernel_owned
+++ a/mm/memory.c
@@ -2343,19 +2343,19 @@ void zap_vma_range(struct vm_area_struct
 }
 
 /**
- * zap_special_vma_range - zap all page table entries in a special vma range
+ * zap_special_vma_range - zap all page table entries in a kernel-owned VMA
  * @vma: the vma covering the range to zap
  * @address: starting address of the range to zap
  * @size: number of bytes to zap
  *
  * This function does nothing when the provided address range is not fully
- * contained in @vma, or when the @vma is not VM_PFNMAP or VM_MIXEDMAP.
+ * contained in @vma, or when @vma is not kernel-owned.
  */
 void zap_special_vma_range(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size)
 {
 	if (!range_in_vma(vma, address, address + size) ||
-	   !(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP)))
+	   !vma_is_kernel_owned(vma))
 		return;
 
 	zap_vma_range(vma, address, size);
--- a/mm/mprotect.c~mm-remove-vma_io_bit-check-in-vma_is_kernel_owned
+++ a/mm/mprotect.c
@@ -783,8 +783,7 @@ mprotect_fixup(struct vma_iterator *vmi,
 	 * uncommon case, so doesn't need to be very optimized.
 	 */
 	if (arch_has_pfn_modify_check() &&
-	    vma_flags_test_any(&old_vma_flags, VMA_PFNMAP_BIT,
-			       VMA_MIXEDMAP_BIT) &&
+	    vma_flags_is_kernel_owned(&old_vma_flags) &&
 	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
 		pgprot_t new_pgprot = vm_get_page_prot(newflags);
 
--- a/mm/vma.c~mm-remove-vma_io_bit-check-in-vma_is_kernel_owned
+++ a/mm/vma.c
@@ -2787,7 +2787,7 @@ static int mmap_validate_vma_flags(const
 		return -EINVAL;
 #endif
 
-	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
+	if (!vma_flags_is_kernel_owned(flags)) {
 		/* Only kernel-owned mappings may set VMA_IO_BIT. */
 		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
 			return -EINVAL;
--- a/tools/testing/vma/include/dup.h~mm-remove-vma_io_bit-check-in-vma_is_kernel_owned
+++ a/tools/testing/vma/include/dup.h
@@ -1667,8 +1667,7 @@ static inline bool file_is_dev_zero(cons
 
 static inline bool vma_flags_is_kernel_owned(const vma_flags_t *flags)
 {
-	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT,
-				  VMA_IO_BIT);
+	return vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
 }
 
 static inline bool vma_is_kernel_owned(const struct vm_area_struct *vma)
--- a/tools/testing/vma/tests/merge.c~mm-remove-vma_io_bit-check-in-vma_is_kernel_owned
+++ a/tools/testing/vma/tests/merge.c
@@ -496,17 +496,11 @@ static bool test_vma_merge_special_flags
 		.mm = &mm,
 		.vmi = &vmi,
 	};
-	vma_flag_t special_flags[] = { VMA_IO_BIT, VMA_DONTEXPAND_BIT,
+	vma_flag_t special_flags[] = { VMA_DONTEXPAND_BIT,
 		VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT };
-	vma_flags_t all_special_flags = EMPTY_VMA_FLAGS;
 	int i;
 	struct vm_area_struct *vma_left, *vma;
 
-	/* Make sure there aren't new VM_SPECIAL flags. */
-	for (i = 0; i < ARRAY_SIZE(special_flags); i++)
-		vma_flags_set(&all_special_flags, special_flags[i]);
-	ASSERT_FLAGS_SAME_MASK(&all_special_flags, VMA_SPECIAL_FLAGS);
-
 	/*
 	 * 01234
 	 * AAA
@@ -520,7 +514,7 @@ static bool test_vma_merge_special_flags
 	 * 01234
 	 * AAA*
 	 *
-	 * This should merge if not for the VM_SPECIAL flag.
+	 * This should merge if not for the 'special' flag.
 	 */
 	vmg_set_range(&vmg, 0x3000, 0x4000, 3, vma_flags);
 	for (i = 0; i < ARRAY_SIZE(special_flags); i++) {
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

