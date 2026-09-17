Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689D540928B
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679436; cv=none; b=rExsK3iDZvsA2sHzoBUovs5e0aKHotc7VTZGQTazemzZhCp1rhO5Tq8isDKFsTmzYv+5ZZ9qopFtLH4VV3H/L07yZRpmuYEEHOR/WMWUKTUo/VBsiG+jG2+ilvPnPuP8Xs+g23DScaXZMDACDbbUnka78+0KUmcpTMEXR5E+FRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679436; c=relaxed/simple;
	bh=R8oPoXodfV/psUPAF+THYHo+8EEI7S32pCghAeiu6G0=;
	h=Date:To:From:Subject:Message-Id; b=gKmFMZ+DHMGDLv/wcycQMmqImEVLFGAuvT50uScFP7uEbXR6mq3nwzlz+74yspp9qF5yzl1XGC1ALVb3wOfa3K5faE5OXjx5uiksjeEHohky/z6EsKQFalqSj07iJm7XfB++OS73GQyzqFXUwtKKIBpGRW3Z9v2EXGyI0pl92fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2so6QD3j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2so6QD3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6F11F00893;
	Thu, 17 Sep 2026 21:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679435;
	bh=2QZJwsMV16G/+R3d2PmFEydQVRmURLL0Y6pKLMG0tLQ=;
	h=Date:To:From:Subject;
	b=2so6QD3j39ShPwt7GOXRNQ/7XTvJBmGY0pHm/E6tXq7Hhi1shZpA5wnnSRW4C646E
	 Ld6uJRT/1LJz6dwFBBmz75I4sbdLAIFSmpRKRBAorSauqT7Unbe9tOcVyf9A7Od3tu
	 tJK3DEOyf9r23/N3bmZZ3QBckiqFpiCXVCcazsiI=
Date: Thu, 17 Sep 2026 14:10:34 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fuse-dax-do-not-set-vm_mixedmap.patch removed from -mm tree
Message-Id: <20260917211035.3F6F11F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fuse: dax: do not set VM_MIXEDMAP
has been removed from the -mm tree.  Its filename was
     fuse-dax-do-not-set-vm_mixedmap.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: fuse: dax: do not set VM_MIXEDMAP
Date: Mon, 14 Sep 2026 15:57:58 +0100

Commit e1fb4a086495 ("dax: remove VM_MIXEDMAP for fsdax and device dax")
prevented fsdax and device-dax from setting VM_MIXEDMAP, as DAX no longer
relies on it to direct core mm paths.

The fuse DAX implementation, added later, copied the old pattern and still
sets it.

Fuse DAX maps pages the same way fsdax does, via dax_iomap_fault() and
ultimately vmf_insert_page_mkwrite() and vmf_insert_folio_pmd(), which
insert ordinary refcounted pages and so do not require VM_MIXEDMAP.

Setting it only serves to mark the mapping as kernel-owned, making fuse
DAX the sole DAX implementation whose mappings are unmergeable, cannot be
mlock()'d, eagerly copy page tables on fork and reject MADV_DOFORK and
MADV_DODUMP.

It also requires vma_is_special_huge() in mm/huge_memory.c to carve DAX
out of its kernel-owned check explicitly.

There is no reason for fuse DAX to keep on using this flag so drop it.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-38-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/dax.c~fuse-dax-do-not-set-vm_mixedmap
+++ a/fs/fuse/dax.c
@@ -826,7 +826,7 @@ int fuse_dax_mmap(struct file *file, str
 {
 	file_accessed(file);
 	vma->vm_ops = &fuse_dax_vm_ops;
-	vm_flags_set(vma, VM_MIXEDMAP | VM_HUGEPAGE);
+	vma_set_flags(vma, VMA_HUGEPAGE_BIT);
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
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-introduce-and-use-vma_can_gup.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch

