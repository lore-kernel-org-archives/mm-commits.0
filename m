Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B1F4DDB28
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679434; cv=none; b=E4mU1ICue3GBhqgbSlrc4lGXkaXm0O820ysjr6qZhvOKlGdLB7AG7IhYY54oc0jTqavf/ERuxaNkacMW41zmVsCabJe7dcf2eCUlKLJ1CiHrVArMsrzVZyKRZ3zksNQfhjjoZZVNhsZ+dcdgiFA+xhM4RIpb1o//aPIP8FGmaIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679434; c=relaxed/simple;
	bh=qLhLOBCjnWPo0G9aZxhi52Kz7/dNa8SnPVkaRgAjq2g=;
	h=Date:To:From:Subject:Message-Id; b=CYHhrs+I7Lk1RQh/T/V8i1I5RjWZ7HJjDYUuoRZXENtGKVrmJcXa/4jh50+GvDoGfWfpILoCm4FtPR/Q1rNcNPB1lMLbahNgXmQ0CR09fN2D4Va3x5MlAMdKEztifP8GSyJ/n54GZbGkkHl4e18RJ5j9+lrcXrs5CV5B6Czx55Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Knp6+BTr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Knp6+BTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AA41F00893;
	Thu, 17 Sep 2026 21:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679433;
	bh=JM2HEZdVHWRQWFz9eInxHFihJuQS0jt3o9Kn3TKzxpQ=;
	h=Date:To:From:Subject;
	b=Knp6+BTre/OTDrJQBw9ZprQDiUSw/F0Aoo0PXqoMoZRqqXxp4xV5lJjFp/Exo7d4n
	 SYdEupdffZFAVTQW2cVtBitiTIscbVGejA/pGp6cS19vvUGL7vMdfysojbQ8Nbk6Ip
	 Rw/7R33MPXeAWlvKX3ptCO0zGvOfe4o1S3FOCyIo=
Date: Thu, 17 Sep 2026 14:10:32 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch removed from -mm tree
Message-Id: <20260917211032.E7AA41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: avoid use of VMA_SPECIAL_FLAGS in migrate_vma_setup()
has been removed from the -mm tree.  Its filename was
     mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: avoid use of VMA_SPECIAL_FLAGS in migrate_vma_setup()
Date: Mon, 14 Sep 2026 15:57:56 +0100

Now we have the expressive vma_is_kernel_owned() and
vma_is_fixed_mapping() predicates, use them to determine whether to
proceed with migration.  This drops the VMA_IO_BIT test, which is safe as
only kernel-owned mappings may set it.

hugetlb mappings remain excluded, as they are fixed mappings.

No functional change intended.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-36-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/migrate_device.c~mm-avoid-use-of-vma_special_flags-in-migrate_vma_setup
+++ a/mm/migrate_device.c
@@ -739,19 +739,21 @@ static void migrate_vma_unmap(struct mig
  */
 int migrate_vma_setup(struct migrate_vma *args)
 {
+	const struct vm_area_struct *vma = args->vma;
 	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
-	if (!args->vma || vma_test_any_mask(args->vma, VMA_SPECIAL_FLAGS) ||
-	    vma_is_dax(args->vma))
+	if (!vma)
+		return -EINVAL;
+	if (vma_is_kernel_owned(vma) || vma_is_fixed_mapping(vma) ||
+	    vma_is_dax(vma))
 		return -EINVAL;
 	if (nr_pages <= 0)
 		return -EINVAL;
-	if (args->start < args->vma->vm_start ||
-	    args->start >= args->vma->vm_end)
+	if (args->start < vma->vm_start || args->start >= vma->vm_end)
 		return -EINVAL;
-	if (args->end <= args->vma->vm_start || args->end > args->vma->vm_end)
+	if (args->end <= vma->vm_start || args->end > vma->vm_end)
 		return -EINVAL;
 	if (!args->src || !args->dst)
 		return -EINVAL;
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
mm-eliminate-vm_special-vma_special_flags.patch
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-introduce-and-use-vma_can_gup.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch

