Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A4A4E36C5
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679422; cv=none; b=MqmkL+3MZDjGksKaNaTXIoWshfGtzBgwR7o04UH6U4Lcmx0Y6D/9LpMFJeRPBYo3EAk3t0ReLpzlqQgVWnJVij5w42SDK8hjrR0E8csbGkSjcR8otsiV9KiAF6yfmMjQdDTsCyMzb7BS+FOpiXhIguRxzfhuDvhVuhaHvwP23KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679422; c=relaxed/simple;
	bh=RFGRT609GBQRkGSV75sPHR6mE7XbjcsdK/vHarwfqyQ=;
	h=Date:To:From:Subject:Message-Id; b=EqMVVmuzGHcDdMM6kMZfpMMRD8RD2uCxtFoKkgpB3OW7zdcNQ8+St4C4biecIQjTt8AMxUsNkYrB4t6H+3wn2yI6i3YROg89/6UIJNnAylyvEYi+RC3IA+hefUZf5QE4X9GnJWirDZDDMl6L47CVLBvmha34UfHorhhN2qSP+Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iJ/kaV4X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iJ/kaV4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E58D1F000FF;
	Thu, 17 Sep 2026 21:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679420;
	bh=8pPGEeeYiEwqwxR+eKwSYdLDvFiZscDWWf/hsntUt5k=;
	h=Date:To:From:Subject;
	b=iJ/kaV4XGRfspIEvO1YJulu5D4ziks7xrIBQOGLugCXtQCzvQE30d91mRVD50diB3
	 CD3OBaunBDQ77RGMh/sxX4LbCocTUN3QUxDkVBhpijKi2KQNI0QFbvUTC1iEf+LRKH
	 lz/ksEvqthXvL1C7SCmwmjRNNbC8PXXlRlBuo2Ek=
Date: Thu, 17 Sep 2026 14:10:19 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vma-enforce-that-only-kernel-owned-mappings-may-set-vma_io_bit.patch removed from -mm tree
Message-Id: <20260917211020.0E58D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: enforce that only kernel-owned mappings may set VMA_IO_BIT
has been removed from the -mm tree.  Its filename was
     mm-vma-enforce-that-only-kernel-owned-mappings-may-set-vma_io_bit.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: enforce that only kernel-owned mappings may set VMA_IO_BIT
Date: Mon, 14 Sep 2026 15:57:45 +0100

It makes no sense for a mapping whose contents the kernel does not own to
specify that the range is MMIO.

Prior to this patch, all in-tree drivers which did so have been updated
such that they are marked as kernel-owned.  The check WARNs and fails the
mmap for any out-of-tree driver that still sets VMA_IO_BIT without a
kernel mapping.

No functional change intended for in-tree code.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-25-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/vma.c~mm-vma-enforce-that-only-kernel-owned-mappings-may-set-vma_io_bit
+++ a/mm/vma.c
@@ -2787,6 +2787,12 @@ static int mmap_validate_vma_flags(const
 		return -EINVAL;
 #endif
 
+	if (!vma_flags_test_any(flags, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)) {
+		/* Only kernel-owned mappings may set VMA_IO_BIT. */
+		if (WARN_ON_ONCE(vma_flags_test(flags, VMA_IO_BIT)))
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
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

