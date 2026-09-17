Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41AA3F5BDC
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679428; cv=none; b=KqaIMbXtnlA2rLdTwBQXClLLhvzAwKRz1Y6+yUlrjQiJBibCE2EPi9OHdxHdpNxUjCZMG0EyC+SuPorGkc0lBGE7F9SwUJPjuzV4lNv1jI9G4vS/qYBzIlRsuXpGACZ9XcPhQoBgPNTVlslEbKOgSubU/tBD9C9blDvazyRclD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679428; c=relaxed/simple;
	bh=Pl9SFZUHgwnLIdICnB7G1YnQvWjZzzUfdwcVs1L5JtU=;
	h=Date:To:From:Subject:Message-Id; b=lh2XF0yy4lW/ygEI8t08dOJyMCPUDOdjfr9FhT0s5AJSRIWCCTn9ZgJyBL0am4nixOjO11B9FuA5ykvOR4io2rFESq65TS6lysmkd3WIOVmLdZyozIgX3BSFy0gBEIwxOpf5nuR06Ew1LRcTVXGvyrSIqust2adc0kNVVytQ7bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OzIYHYQw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OzIYHYQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23191F00898;
	Thu, 17 Sep 2026 21:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679426;
	bh=OtfOYzI2KZza1yTrVA78Oi2T2FB7BEw7g62uDjSSx9c=;
	h=Date:To:From:Subject;
	b=OzIYHYQwqIruEjKooXc+hoQjzNQneyK3+2XYlEBSuofDG1CafDYibwmKM0HZdiuOW
	 1+zHJ1wcodaQMTVr3Zd6Xigf7V881bgMrLBne29kPOytNDRIai6bmTjqhEOWvgU+Ts
	 gjhN34gld0bIQhXoypgm2HOLnxlhjy19Kwy8H5s4=
Date: Thu, 17 Sep 2026 14:10:25 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch removed from -mm tree
Message-Id: <20260917211025.F23191F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: update is_valid_guard_vma() to use vma_can_merge()
has been removed from the -mm tree.  Its filename was
     mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/madvise: update is_valid_guard_vma() to use vma_can_merge()
Date: Mon, 14 Sep 2026 15:57:50 +0100

We currently disallow the installation of lightweight guard regions in
VMAs whose flags intersect VMA_SPECIAL_FLAGS or VMA_HUGETLB_BIT, or
VMA_LOCKED_BIT unless allow_locked is set.

hugetlb VMAs set VMA_DONTEXPAND_BIT so this was already redundant,
VMA_SPECIAL_FLAGS already sufficed.

However, now that VMA_IO_BIT is only set if VMA_PFNMAP or VMA_MIXEDMAP_BIT
is set, this check collapses to being the equivalent of !vma_can_merge().

Update is_valid_guard_vma() to reflect this.

No functional change intended.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-30-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/mm/madvise.c~mm-madvise-update-is_valid_guard_vma-to-use-vma_can_merge
+++ a/mm/madvise.c
@@ -1221,19 +1221,25 @@ static long madvise_remove(struct madvis
 	return error;
 }
 
-static bool is_valid_guard_vma(struct vm_area_struct *vma, bool allow_locked)
+static bool is_valid_guard_vma(const struct vm_area_struct *vma,
+			       bool allow_locked)
 {
-	vm_flags_t disallowed = VM_SPECIAL | VM_HUGETLB;
-
 	/*
-	 * A user could lock after setting a guard range but that's fine, as
+	 * A user could lock after setting a guard range but that's fine as
 	 * they'd not be able to fault in. The issue arises when we try to zap
 	 * existing locked VMAs. We don't want to do that.
 	 */
-	if (!allow_locked)
-		disallowed |= VM_LOCKED;
+	if (!allow_locked && vma_test(vma, VMA_LOCKED_BIT))
+		return false;
+	/*
+	 * Guard regions require a VMA whose page tables are managed solely by
+	 * the core, which is also what merging requires, so disallow any flags
+	 * that would prevent a merge.
+	 */
+	if (!vma_can_merge(vma))
+		return false;
 
-	return !(vma->vm_flags & disallowed);
+	return true;
 }
 
 static bool is_guard_pte_marker(pte_t ptent)
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

