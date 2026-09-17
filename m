Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C08D49EC6E
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679417; cv=none; b=ZE9LL7XEQ40pZwbqqM7T8Kk1HlfZ9WLKgFFv227SPgLYX9LY3AWuPIBkmKz6ZrAGOvU8OyZUX+O8N5OSsUdUGXm2vECkUeo9jcnsEbS4qTdbBoH0VaNEsteEhZDP7/LobR0g8RbWBptIgqTGa9HuvM6U8nqYSz61GaPT4guYOIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679417; c=relaxed/simple;
	bh=CSSQFlhvvhj9X0tId2odBeJWVUtXuN7qBGdwrQtUqX4=;
	h=Date:To:From:Subject:Message-Id; b=ZAGuM3R/ajr1V64su+93SG6b1gDgZ1EL75VbBKZDTyg+FvLlarV4kP99Kbjq4h05FbshY7L7RN4qZ43kYPKHr1G52eWa3RXeWic/J8qH5pypUigcCZZQtFQAuOxm5OuJi1Exchd8hpnp1rWMWHhKo1/UzjJh0oanI9Dz4+/UncE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0slX2hjj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0slX2hjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F2C1F000FF;
	Thu, 17 Sep 2026 21:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679415;
	bh=7F27JO7Hv5omhOqkUoda7wqFsi5ZFTQETlLMuyUYQBA=;
	h=Date:To:From:Subject;
	b=0slX2hjj/ykdBgaT2Si2VPFQrZgRh3hq84T5WfD2T0MJYQCSTMFeq4OHPx2g2zWzi
	 mZkpg+JfKDpxY07Dra4Dm4qgVsp76cFCNEOWClcjb27LOIDVBFDFTCMX1CMlfT7zQP
	 Pcvn/+ovoI3eV+vpJ2Samj0PVBWqjfzik+OzDDxg=
Date: Thu, 17 Sep 2026 14:10:14 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch removed from -mm tree
Message-Id: <20260917211015.52F2C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
has been removed from the -mm tree.  Its filename was
     mm-gup-error-out-early-on-vma_mayread_bit-vmas.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/gup: error out early on !VMA_MAYREAD_BIT VMAs
Date: Mon, 14 Sep 2026 15:57:41 +0100

When populating a VMA range via the aptly named populate_vma_page_range()
an unreadable VMA will always eventually fail with -EFAULT.

That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is
not.

All user mappings always have VMA_MAYREAD_BIT set, so this check only
impacts kernel mappings.

It is implemented specifically to disallow population of uprobes XOL
mappings which are exec-only.

A nasty interaction with these mappings may occur if they are mlocked, so
actively disallow this early.

This allows a subsequent commit to remove the VM_IO check in
__mm_populate() which otherwise requires non-MMIO mappings to be wrongly
flagged simply as a workaround.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-21-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/gup.c~mm-gup-error-out-early-on-vma_mayread_bit-vmas
+++ a/mm/gup.c
@@ -1836,6 +1836,10 @@ long populate_vma_page_range(struct vm_a
 	if (!vma_is_accessible(vma))
 		return -EFAULT;
 
+	/* Unreadable VMAs also cannot be faulted in. */
+	if (!vma_test(vma, VMA_MAYREAD_BIT))
+		return -EFAULT;
+
 	gup_flags = FOLL_TOUCH;
 	/*
 	 * We want to touch writable mappings with a write fault in order
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

