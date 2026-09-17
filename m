Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDCD49EC6E
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679433; cv=none; b=pRhbUBOe0Nq2cj2r8+HQUQTduUn97oRFiIocI8Q36/w865Y2grNsWCP0zHnAOOas3STwiwObhZPOy6qPRBKrB2jRpaOyeNUYAjjEIx70OrSKvQ+F9h9gNzJONyDL78i+lMzxPb7B9I1yLCWPK3F4YFCG3zMJ9VLZ5Ec10gMdt2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679433; c=relaxed/simple;
	bh=i/e0qQfBxDsVoPGRHgv3bNBtC4HBI4KbczcWEYTpIlc=;
	h=Date:To:From:Subject:Message-Id; b=BvqfBMSCMobnDqqhuvV0/Ujc1mcuyofJ7bhtTC2/AUbABDAo350SASHu+Zfrk7PfPcqlrJB21J2lMsqCt+MCG+rEQ484TcVllJAW7SJwhz9XaQAdOSsK6OMInCZk9Eazt7fMEosk2BV8ZVUw3wPzAe9fyOUDxHvQ3H/OyPRY6ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s21HlBH/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s21HlBH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36871F000FF;
	Thu, 17 Sep 2026 21:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679431;
	bh=vnYxcha1UN5ixWJnT6ee7SWxYQVOMc/Co248uwteG/o=;
	h=Date:To:From:Subject;
	b=s21HlBH/OdnXqmNmB6FShY7xGbTwUDOFC5Vt0Ro9id53+950jN+Qv4CvnRZAlbnqP
	 KAeaJfQ3aICabxXMQkw30tNe4k1e9zsMpgio/Nhq/wVKCifwaLTHzXO4kaJY9Xt3wG
	 wDNxHfcMsl0RwbbiPCDpmYF+2M+lsbBUAAE78CJM=
Date: Thu, 17 Sep 2026 14:10:31 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch removed from -mm tree
Message-Id: <20260917211031.C36871F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: eliminate VMA_SPECIAL_FLAGS check in lru_gen_look_around()
has been removed from the -mm tree.  Its filename was
     mm-eliminate-vma_special_flags-check-in-lru_gen_look_around.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: eliminate VMA_SPECIAL_FLAGS check in lru_gen_look_around()
Date: Mon, 14 Sep 2026 15:57:55 +0100

A kernel-owned or fixed mapping is one which sets VMA_PFNMAP_BIT,
VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop
as only kernel-owned mappings may set it.

Using these predicates rather than VMA_SPECIAL_FLAGS makes the check
self-documenting and helps eliminate the confusion around 'special' flags.

No functional change intended.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-35-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-eliminate-vma_special_flags-check-in-lru_gen_look_around
+++ a/mm/vmscan.c
@@ -4422,8 +4422,8 @@ bool lru_gen_look_around(struct page_vma
 	if (spin_is_contended(pvmw->ptl))
 		return true;
 
-	/* exclude special VMAs containing anon pages from COW */
-	if (vma->vm_flags & VM_SPECIAL)
+	/* exclude kernel-owned and fixed VMAs containing anon pages from COW */
+	if (vma_is_kernel_owned(vma) || vma_is_fixed_mapping(vma))
 		return true;
 
 	/* avoid taking the LRU lock under the PTL when possible */
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
mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-introduce-and-use-vma_can_gup.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch

