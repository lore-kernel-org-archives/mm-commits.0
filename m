Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B854A4EF4
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 21:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789679436; cv=none; b=K9etCDWO9C4hkmUHuGEfRWAoDS5Un98lN+f6ZT9Fr7F2HpCtBei/PO058jati6fo7K87S6vJvWd1Ly3Sp8cp0knE2fkaI3+IxZl2Db2io8yI4+MwqcHlthMfxVmC7O3+RyxUW/accBmJEb5/1heVvRoPsEx3Lf8WgTBUgOyvJas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789679436; c=relaxed/simple;
	bh=ex0ygbOOId9MmWzRRHOvP+KRnhcQ3UnGO2IZ2i3J2OE=;
	h=Date:To:From:Subject:Message-Id; b=LtJ2foB/XaedLxAxEydhbg3SDeLU2NA3xhCY0m1Aof1vc/Bxh1dKzUGC/SpMB2NxsV68WU3mK0ycp6Vq2jNaSBVFKJMKsfOyAHdVGsnlwV/2s3j+27Lji5PYQQ4OoCt3E/3Voz4zOev81bF306dap4wFbJiKp4f7B76BQNZ4hqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XeynYgoA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XeynYgoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CC01F000FF;
	Thu, 17 Sep 2026 21:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789679434;
	bh=G3JeHNmyEwHdxtuoaPzmobNX45gaMykYncGLGSsjAg8=;
	h=Date:To:From:Subject;
	b=XeynYgoA5E3s0vfkXGWMsDTyJq6tfiWh/g6WzaqoJYSl13rzk7rOEZOMGjCAL0UdR
	 Ym6dePedSoIBcIDQdVWQkHEUCNuMVB7kj1Cx5bR9m9Ti4e5Bkszc2MFrfVBz7kZOUL
	 SlTrZsfQgvKPTmgKJ1jWDEZq3DwlI/Rtjm1Sj7Wg=
Date: Thu, 17 Sep 2026 14:10:33 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-eliminate-vm_special-vma_special_flags.patch removed from -mm tree
Message-Id: <20260917211034.16CC01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
has been removed from the -mm tree.  Its filename was
     mm-eliminate-vm_special-vma_special_flags.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: eliminate VM_SPECIAL, VMA_SPECIAL_FLAGS
Date: Mon, 14 Sep 2026 15:57:57 +0100

Every user of the VM_SPECIAL or VMA_SPECIAL_FLAGS has now been converted
to predicates which explicitly express what is actually being checked for
rather than the nebulous concept of possessing 'special' VMA flags.

In any case 'special' is not so special a term of art in mm - it includes
VDSO/VVAR mappings, special in the sense of vm_normal_folio() and probably
other cases too.

Therefore make things less special by eliminating these now unused flags.

No functional change intended.

Link: https://lore.kernel.org/20260914-b4-mmap-prepare-vma-flag-sanify-v2-37-7d9781ed5361@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h              |    8 --------
 tools/testing/vma/include/dup.h |    8 --------
 2 files changed, 16 deletions(-)

--- a/include/linux/mm.h~mm-eliminate-vm_special-vma_special_flags
+++ a/include/linux/mm.h
@@ -577,14 +577,6 @@ enum {
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
 /*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-#define VM_SPECIAL vma_flags_to_legacy(VMA_SPECIAL_FLAGS)
-
-/*
  * Physically remapped pages are special. Tell the
  * rest of the world about it:
  *   IO tells people not to look at these pages
--- a/tools/testing/vma/include/dup.h~mm-eliminate-vm_special-vma_special_flags
+++ a/tools/testing/vma/include/dup.h
@@ -352,14 +352,6 @@ enum {
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
-/*
- * Special vmas that are non-mergable, non-mlock()able.
- */
-#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
-
-#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
-				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-
 #define VMA_REMAP_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_PFNMAP_BIT,	\
 				     VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)
 
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
fuse-dax-do-not-set-vm_mixedmap.patch
mm-huge_memory-remove-vma_is_special_huge.patch
mm-vma-introduce-and-use-vma_can_gup.patch
mm-vma-const-ify-vma_assert_stabilised-and-associated-functions.patch
mm-implement-and-use-vma_has_anon_rmap-silence-kcsan.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma.patch

