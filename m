Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AD43B637F
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068053; cv=none; b=rvzdnTxKOmnJ43sL6/PBX/yQ0XmHOKpJxmmG5vEVoeMN1QTkyIwYQk1pQMoDj+ddGze0phquci1ltgzZdOEHip5XX0b7MceKJjLCQbf+N5iqhSKh4nNAOSx9VjOdW/DCEB8ZfVGx0lRIL9SnaqvugzDessiLpg4aoNy3CCbv2Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068053; c=relaxed/simple;
	bh=1vpR/OoBSSdttLjO2fZsidv/sNWhLz3+rzQc51UxQL4=;
	h=Date:To:From:Subject:Message-Id; b=q7LfTH55/2C7LDIiIdKKEQKPmN4eWqJ1tm6J8Zh4MyM/QTlDmN6ljolbcfyLBNEhfyWJ9dhdJA39T2luyEANCz/vTrIm7MxFOlq5c5uo4JVF2lcaEOEpyttdh78llZsy2eNfQ7idg1KrVS6ROFIhwUdmhM6/EV8z+1EEnCXctI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JUNjNRuF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JUNjNRuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA401F00A3A;
	Fri,  7 Aug 2026 02:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068048;
	bh=OxKm1Ze1GxWw6bbZY9n5hGvCqDiIMpt8nHyIBBl/Vjc=;
	h=Date:To:From:Subject;
	b=JUNjNRuFsw9JJEblZNXNdlwQyeVLYHhiChv89yeCR+y6HcXf6sGQhGQ4G5jUbySlj
	 zGljwjmXC9UNt27sZRQZV17CT7vTlSCGNacCeHSPheqnJssfq5Se0Jzhw/UqtxEdCi
	 xm/bN5oAuFd1fPUB21u8OfW59AKQHwrbnJ6WDtjQ=
Date: Thu, 06 Aug 2026 19:00:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,lance.yang@linux.dev,jannh@google.com,jani.nikula@intel.com,jack@suse.cz,dev.jain@arm.com,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,airlied@gmail.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-prefer-mm-def_vma_flags-in-mm-logic.patch removed from -mm tree
Message-Id: <20260807020048.4AA401F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: prefer mm->def_vma_flags in mm logic
has been removed from the -mm tree.  Its filename was
     mm-prefer-mm-def_vma_flags-in-mm-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm: prefer mm->def_vma_flags in mm logic
Date: Sat, 11 Jul 2026 19:45:02 +0100

Currently mm->def_flags (of type vm_flags_t) is union'd with
mm->def_vma_flags (of type vma_flags_t).

As part of the effort to convert vm_flags_t usage to vma_flags_t (in order
to no longer be arbitrarily limited to a system word size for VMA flags),
prefer mm->def_vma_flags to mm->def_flags throughout the mm logic.

We update dump_mm() to use the %*pb format which means we make no
assumption about the number of VMA flag bits on output when outputting
default VMA flags.

No functional change intended.

Link: https://lore.kernel.org/20260711-b4-vma-flags-mm-v2-5-0fa2357d5431@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    5 +++--
 mm/mlock.c |   13 +++++++------
 mm/mmap.c  |   11 ++++++-----
 mm/vma.c   |    2 +-
 4 files changed, 17 insertions(+), 14 deletions(-)

--- a/mm/debug.c~mm-prefer-mm-def_vma_flags-in-mm-logic
+++ a/mm/debug.c
@@ -197,7 +197,7 @@ void dump_mm(const struct mm_struct *mm)
 		"numa_next_scan %lu numa_scan_offset %lu numa_scan_seq %d\n"
 #endif
 		"tlb_flush_pending %d\n"
-		"def_flags: %#lx(%pGv)\n",
+		"def_flags: %*pb(%pGv)\n",
 
 		mm, mm->task_size,
 		mm->mmap_base, mm->mmap_legacy_base,
@@ -226,7 +226,8 @@ void dump_mm(const struct mm_struct *mm)
 		mm->numa_next_scan, mm->numa_scan_offset, mm->numa_scan_seq,
 #endif
 		atomic_read(&mm->tlb_flush_pending),
-		mm->def_flags, &mm->def_flags
+		NUM_VMA_FLAG_BITS, mm->def_vma_flags.__vma_flags,
+		&mm->def_vma_flags
 	);
 }
 EXPORT_SYMBOL(dump_mm);
--- a/mm/mlock.c~mm-prefer-mm-def_vma_flags-in-mm-logic
+++ a/mm/mlock.c
@@ -699,26 +699,27 @@ SYSCALL_DEFINE2(munlock, unsigned long,
 
 /*
  * Take the MCL_* flags passed into mlockall (or 0 if called from munlockall)
- * and translate into the appropriate modifications to mm->def_flags and/or the
- * flags for all current VMAs.
+ * and translate into the appropriate modifications to mm->def_vma_flags and/or
+ * the flags for all current VMAs.
  *
  * There are a couple of subtleties with this.  If mlockall() is called multiple
  * times with different flags, the values do not necessarily stack.  If mlockall
  * is called once including the MCL_FUTURE flag and then a second time without
- * it, VM_LOCKED and VM_LOCKONFAULT will be cleared from mm->def_flags.
+ * it, VM_LOCKED and VM_LOCKONFAULT will be cleared from mm->def_vma_flags.
  */
 static int apply_mlockall_flags(int flags)
 {
 	VMA_ITERATOR(vmi, current->mm, 0);
+	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev = NULL;
 	vm_flags_t to_add = 0;
 
-	current->mm->def_flags &= ~VM_LOCKED_MASK;
+	vma_flags_clear_mask(&mm->def_vma_flags, VMA_LOCKED_MASK);
 	if (flags & MCL_FUTURE) {
-		current->mm->def_flags |= VM_LOCKED;
+		vma_flags_set(&mm->def_vma_flags, VMA_LOCKED_BIT);
 
 		if (flags & MCL_ONFAULT)
-			current->mm->def_flags |= VM_LOCKONFAULT;
+			vma_flags_set(&mm->def_vma_flags, VMA_LOCKONFAULT_BIT);
 
 		if (!(flags & MCL_CURRENT))
 			goto out;
--- a/mm/mmap.c~mm-prefer-mm-def_vma_flags-in-mm-logic
+++ a/mm/mmap.c
@@ -102,15 +102,16 @@ void vma_set_page_prot(struct vm_area_st
  */
 static int check_brk_limits(unsigned long addr, unsigned long len)
 {
+	const struct mm_struct *mm = current->mm;
+	const bool is_def_locked =
+		vma_flags_test(&mm->def_vma_flags, VMA_LOCKED_BIT);
 	unsigned long mapped_addr;
 
 	mapped_addr = get_unmapped_area(NULL, addr, len, 0, MAP_FIXED);
 	if (IS_ERR_VALUE(mapped_addr))
 		return mapped_addr;
 
-	return mlock_future_ok(current->mm,
-			      current->mm->def_flags & VM_LOCKED, len)
-		? 0 : -EAGAIN;
+	return mlock_future_ok(mm, is_def_locked, len) ? 0 : -EAGAIN;
 }
 
 SYSCALL_DEFINE1(brk, unsigned long, brk)
@@ -197,7 +198,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 		goto out;
 
 	mm->brk = brk;
-	if (mm->def_flags & VM_LOCKED)
+	if (vma_flags_test(&mm->def_vma_flags, VMA_LOCKED_BIT))
 		populate = true;
 
 success:
@@ -1247,7 +1248,7 @@ int vm_brk_flags(unsigned long addr, uns
 
 	vma = vma_prev(&vmi);
 	ret = do_brk_flags(&vmi, vma, addr, len, vma_flags);
-	populate = ((mm->def_flags & VM_LOCKED) != 0);
+	populate = vma_flags_test(&mm->def_vma_flags, VMA_LOCKED_BIT);
 	mmap_write_unlock(mm);
 	userfaultfd_unmap_complete(mm, &uf);
 	if (populate && !ret)
--- a/mm/vma.c~mm-prefer-mm-def_vma_flags-in-mm-logic
+++ a/mm/vma.c
@@ -3426,7 +3426,7 @@ struct vm_area_struct *__install_special
 	if (unlikely(vma == NULL))
 		return ERR_PTR(-ENOMEM);
 
-	vm_flags |= mm->def_flags | VM_DONTEXPAND;
+	vm_flags |= vma_flags_to_legacy(mm->def_vma_flags) | VM_DONTEXPAND;
 	if (pgtable_supports_soft_dirty())
 		vm_flags |= VM_SOFTDIRTY;
 	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
_

Patches currently in -mm which might be from ljs@kernel.org are

x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-introduce-linear_anon_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-anon-index-if-appropriate.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-vma-fix-self-merge-check-in-copy_vma.patch
tools-testing-vma-add-tests-for-copy_vma-self-merge.patch
mm-propagate-vma-anonymous-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch
mm-clean-up-vma_address_end.patch
mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch
mm-migrate-calculate-large-folio-page-index-using-pfn.patch
mm-rmap-use-anon-pgoff-to-track-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

