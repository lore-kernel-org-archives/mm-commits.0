Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AA84E50C2
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679430; cv=none; b=ShLn6/L7TkOoEe+GiOZkZIt/IRpcfjJ1gYig7IFc9KMODBGui8/cgpZvgWiQ/xCzmOjCyDgjIP1kXaiIJky1zzyHZfWiUPxMgB6N25ZDr/mAHVp3fGtZJaZYzXjk0bynEs3pZAGxVvlpITdzCWrqManso3YY18ts042MugoXPlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679430; c=relaxed/simple;
	bh=VagbIfY4e3mUgcHo2uIV4ttpbiwQZdxZj24alR4G+5g=;
	h=Date:To:From:Subject:Message-Id; b=Vdc2hW9UU2nqqZJurALriy/p19/UCxyLkgIgMkg8nTIhVfcBlLPECAy8/3RFI4moZcV4ywaXtNjG2lplllvzkmATciuigOu2yTMkrfFpz8W1RcmI7cNA5lLUWjn7zMgXkxshduiLH56oXaQuZUekTjf8cZBW3Ug5LwMaScUbpKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ayVj6ORC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ayVj6ORC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492CD1F00899;
	Thu, 17 Sep 2026 21:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679428;
	bh=fyb3ofe3XE7PhGwIaNnDp6il3O+mrxp+ByxnXI8Vm+U=;
	h=Date:To:From:Subject;
	b=ayVj6ORCH8BdjMnkOGxcBJn6fr/xN4SB+8XnA2oZcOriTEESf/RrlxRF53vCLWaeN
	 YYmn0WkmwO90dd/7x6YlZOIjkUnKFo/Anhiyrqp8JRT9q8q3F/Jg8u95wNRbbKv5fK
	 dyncVtkJRH07EVEM6x63dgVc9FpynGAgYcu812cU=
Date: Thu, 17 Sep 2026 14:10:27 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-uffd-use-predicates-for-userfaultfd-checks.patch removed from -mm tree
Message-Id: <20260917211028.492CD1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/uffd: use predicates for userfaultfd checks
has been removed from the -mm tree.  Its filename was
     mm-uffd-use-predicates-for-userfaultfd-checks.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/uffd: use predicates for userfaultfd checks
Date: Mon, 14 Sep 2026 15:57:52 +0100

Rather than directly checking VMA flags, use the newly introduced
vma_is_kernel_owned() and vma_is_persistent() helpers in userfaultfd when
assessing VMA suitability for userfaultfd and UFFDIO_MOVE.

Update vma_move_compatible() so it's expressed in terms of VMA
characteristics rather than arbitrary flags.

Additionally, update the use of the deprecated VMA flag API when checking
VMA_SHADOW_STACK_BIT.

A VMA_IO_BIT check is no longer required but that is fine as a hard
invariant has been established that only kernel-owned mappings may set
VMA_IO_BIT so the check is now redundant.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-32-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/mm/userfaultfd.c~mm-uffd-use-predicates-for-userfaultfd-checks
+++ a/mm/userfaultfd.c
@@ -1754,10 +1754,18 @@ static inline bool move_splits_huge_pmd(
 }
 #endif
 
-static inline bool vma_move_compatible(struct vm_area_struct *vma)
+static inline bool vma_move_compatible(const struct vm_area_struct *vma)
 {
-	return !(vma->vm_flags & (VM_PFNMAP | VM_IO |  VM_HUGETLB |
-				  VM_MIXEDMAP | VM_SHADOW_STACK));
+	/* uffd is generally incompatible with kernel-owned mappings. */
+	if (vma_is_kernel_owned(vma))
+		return false;
+	/* The shadow stack should not be written to by userspace. */
+	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
+		return false;
+	/* hugetlb mappings cannot be safely moved. */
+	if (vma_is_hugetlb(vma))
+		return false;
+	return true;
 }
 
 static int validate_move_areas(struct userfaultfd_ctx *ctx,
@@ -2146,10 +2154,11 @@ static bool vma_can_userfault(struct vm_
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
+	/* Non-persistent memory is inherently not controllable by userspace. */
+	if (!vma_is_persistent(vma))
 		return false;
-
-	if (!vma_is_hugetlb(vma) && (vma->vm_flags & VM_SPECIAL))
+	/* The shadow stack should not be written to by userspace. */
+	if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
 		return false;
 
 	vm_flags &= __VM_UFFD_FLAGS;
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

