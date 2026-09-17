Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C42D4E36FF
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679438; cv=none; b=aotqAIsWIgHavDxmzFCgp6x1ZCYoo8SjzQiCzNaxIxbJ0eMEUTBXoTtCEhH2n4SdTR0B+9b+syIoIZUeSCcYaCpIu1CAPUu12E8Mc/GkMfrSiDgR3TEA8/bD0AjZTi0lcO/miQIfyaRMZZ5FXn2WOqeSoJjp+Z0vOSsLF9kg7tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679438; c=relaxed/simple;
	bh=RiDmvRVejES1OXArCNoNmD1dK6nLFqsECxxwdZyE0os=;
	h=Date:To:From:Subject:Message-Id; b=j642hoGLtVU2vTSDeyiNQTahyb6WVGETm1F6Kdcunql01qSe19m+EgGtmgInIoBN+rlkA+B323MmsD0qUlKx+q6OedKheitt5eQaxK1q9ExrY9BnepoHnnfP0FiXgGWovxuMgT/6QohpjzjVseh/YuP+4f5JCp0c2KV2jRIaSCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c+yDlzXx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c+yDlzXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C701F00898;
	Thu, 17 Sep 2026 21:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679436;
	bh=RyOVeGA1MKWHvy6XjNzE45vH4EaqS3JM4R1P1icyF6k=;
	h=Date:To:From:Subject;
	b=c+yDlzXxIw9/Cu9mD1sWk9fMiYbNRYLPpFdthmpFeB3/CW5NUrYidP1OmehBE3GDU
	 keprs7fmcdT8KxUjzotIE/uElT+dRUZxGeEWVGAjOa0XjkZSzyo4equNI/IsK+c4fN
	 C+45ByXKSBz2Dg8MjfzRI52Z0QGcFvL5vuz8uvGY=
Date: Thu, 17 Sep 2026 14:10:36 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-remove-vma_is_special_huge.patch removed from -mm tree
Message-Id: <20260917211036.64C701F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: remove vma_is_special_huge()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-remove-vma_is_special_huge.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/huge_memory: remove vma_is_special_huge()
Date: Mon, 14 Sep 2026 15:57:59 +0100

vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
VMA_MIXEDMAP_BIT is set (i.e.  whether the VMA is a kernel-owned mapping),
but with a DAX carve-out.

DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no
longer required.

Therefore test for vma_is_kernel_owned() instead and also drop the
VMA_IO_BIT check, as it is now redundant since it is enforced that only
kernel-owned mappings can set this flag.

This also eliminates another overloaded use of 'special' within mm.

No functional change intended.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-39-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-remove-vma_is_special_huge
+++ a/mm/huge_memory.c
@@ -110,14 +110,6 @@ static inline bool file_thp_enabled(cons
 	return S_ISREG(inode->i_mode);
 }
 
-/* If returns true, we are unable to access the VMA's folios. */
-static bool vma_is_special_huge(const struct vm_area_struct *vma)
-{
-	if (vma_is_dax(vma))
-		return false;
-	return vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT);
-}
-
 static bool vma_file_bypass_thp_tuneables(const struct vm_area_struct *vma,
 		enum tva_type type)
 {
@@ -192,7 +184,7 @@ unsigned long __thp_vma_allowable_orders
 	/* Check the intersection of requested and supported orders. */
 	if (vma_is_anonymous(vma))
 		supported_orders = THP_ORDERS_ALL_ANON;
-	else if (vma_is_dax(vma) || vma_is_special_huge(vma))
+	else if (vma_is_dax(vma) || vma_is_kernel_owned(vma))
 		supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
@@ -3066,7 +3058,7 @@ int zap_huge_pud(struct mmu_gather *tlb,
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
-	if (vma_is_special_huge(vma)) {
+	if (vma_is_kernel_owned(vma)) {
 		spin_unlock(ptl);
 		/* No zero page support yet */
 	} else {
@@ -3222,7 +3214,7 @@ static void __split_huge_pmd_locked(stru
 		 */
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(mm, pmd);
-		if (vma_is_special_huge(vma))
+		if (vma_is_kernel_owned(vma))
 			return;
 		if (unlikely(pmd_is_migration_entry(old_pmd))) {
 			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
@@ -4790,9 +4782,7 @@ static inline bool vma_not_suitable_for_
 {
 	if (vma_is_dax(vma))
 		return true;
-	if (vma_is_special_huge(vma))
-		return true;
-	if (vma_test(vma, VMA_IO_BIT))
+	if (vma_is_kernel_owned(vma))
 		return true;
 	if (vma_is_hugetlb(vma))
 		return true;
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
mm-vma-introduce-and-use-vma_can_gup.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch

