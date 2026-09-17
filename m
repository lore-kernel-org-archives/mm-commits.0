Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9554F3DEAFA
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679398; cv=none; b=qeFghA1onoA7eU/rZesOLzS+ahC0GMnT8SpZ3fWJ9tishMwNIY27UDehkgtW/K7M1BkT5SxdJxJSomPntOL/OgyaLJyIAD3h6/+W7GXBqg8p9OWohSyU40yTuN9GjweBdMGYDmRZWSVWt/Ri59F1DK8FwUwBoRi2ayRABig7BmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679398; c=relaxed/simple;
	bh=lmzEEWsOYiNWfHqgMuYZHSE6ZxTwc1xATri4eaqTjMU=;
	h=Date:To:From:Subject:Message-Id; b=AIzfqC7knEyUGDYeZ11lFxuXUgpfOu6xkjyxD1PsUJnEHkXqQg6x6d5v8yL4vRTyCERy4TwIy+hiJUo5ZC9LGn7NpSe4vQO5QGyN7Efl2cykl9YrNhNL44K8ymMnCr/UKxPyOXR+8rjN7C0yxyCr1lVNN51nBRNBeOfU1h69ylw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t+H3Z2LO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t+H3Z2LO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFA51F00899;
	Thu, 17 Sep 2026 21:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679393;
	bh=TmWw32mWyfP08+dmz9yx8UuiDcjAH/uRvgz7fjEJRdU=;
	h=Date:To:From:Subject;
	b=t+H3Z2LOn4I0XyF0UH0o04wu/EFYppvjZBPt8tdxG2sOIfRxJ7ka8nXaJ93GvhFoU
	 yBXjjkNk9y++GjJYvcjhUe3vqRqjZH4hnmBAG3jLKA/UZvP5/OW115IFYGBfdabCWJ
	 KrHB+IiH9t6Q0mkywn+iCBlizqX2HTT8UCUpYazQ=
Date: Thu, 17 Sep 2026 14:09:52 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vma-predicate-setting-mmap_prepare-vma-fields-on-new-vma-alloc.patch removed from -mm tree
Message-Id: <20260917210952.DAFA51F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: predicate setting mmap_prepare VMA fields on new vma alloc
has been removed from the -mm tree.  Its filename was
     mm-vma-predicate-setting-mmap_prepare-vma-fields-on-new-vma-alloc.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: predicate setting mmap_prepare VMA fields on new vma alloc
Date: Mon, 14 Sep 2026 15:57:22 +0100

It only makes sense to manipulate VMA fields if we allocated a new VMA,
rather than merged it.

VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
keeps its own, which is also what the legacy f_op->mmap path does since it
never touches an existing VMA.  Previously set_vma_user_defined_fields()
overwrote the merged VMA's fields with those set for the new mapping.  In
practice these are the same values, with rare exceptions such as shmem
selecting vm_ops based on whether the file has been unlinked, so no
user-visible change is expected.

Make this dependency explicit, and additionally constify have_mmap_prepare
while we're here.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-2-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vma.c~mm-vma-predicate-setting-mmap_prepare-vma-fields-on-new-vma-alloc
+++ a/mm/vma.c
@@ -2892,7 +2892,7 @@ static unsigned long __mmap_region(struc
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = NULL;
-	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
+	const bool have_mmap_prepare = file && file->f_op->mmap_prepare;
 	VMA_ITERATOR(vmi, mm, addr);
 	const pgoff_t anon_pgoff = addr >> PAGE_SHIFT;
 	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, anon_pgoff, vma_flags, file);
@@ -2935,7 +2935,7 @@ static unsigned long __mmap_region(struc
 		allocated_new = true;
 	}
 
-	if (have_mmap_prepare && !map_is_anon(&map))
+	if (have_mmap_prepare && allocated_new && !map_is_anon(&map))
 		set_vma_user_defined_fields(vma, &map);
 
 	__mmap_complete(&map, vma);
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

