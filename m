Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804063C456F
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 05:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787895648; cv=none; b=op0QbLkKf6ikPzbsGyPBETmgnS6PLJ8bQHXzAo2TH9x1urOCJKV2kn+GP0xLlHNaJBzBJ/uTwQvMRcBlnFRtlJKGnOgQWCsNMET3XkQhyQH5rfb+fRhOmDT3MmZl5HtkdF/ZLRO7KGQg6nF+8Mcq/fgGJsitKLmX4a2ipK7iPC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787895648; c=relaxed/simple;
	bh=cibjQw1bVA9TKi2A8/zVZX8xPHoFrK1eB8BXJkUit4Q=;
	h=Date:To:From:Subject:Message-Id; b=R85egneUDFlj8kNYQT0b6zzwDOo59ivirCb6TcS4SfbZ0DMpYYwu9sfR+aeBpBiooUuTfxGbrJLn8LyirB32icsCzv9Zs/odbEBG4Xsgi2jlqiBi26J/OqIHfm7w6b3sc7n/mzgaoUuHZk8mzePhQ/MQew+dt5uQSSQXKGQ1BYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mk+AJYh9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mk+AJYh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD591F00A3D;
	Fri, 28 Aug 2026 05:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787895646;
	bh=S5qMAXVLkgylR80cJfRWl7ODKui5AoVS489bgRPgcBs=;
	h=Date:To:From:Subject;
	b=Mk+AJYh9Bz5hN6DSNFsGUeecVXuM6r1yJaRkEJGTcUx0KUeEIoT5vR8jyqNdY1FGq
	 s23IaHjDiHl5uFJJLEdoRRm3S5eYUY36DGlzEYLRUctrfHTLhn/pHKrx8yHph3Iu/p
	 o9AVd4+C7EHMZNNuu4IVVcob+KK2BWoRbGYnza7w=
Date: Thu, 27 Aug 2026 22:40:45 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations.patch added to mm-new branch
Message-Id: <20260828054046.1BD591F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/execmem: use VM_FLUSH_RESET_PERMS for ROX cache allocations
has been added to the -mm mm-new branch.  Its filename is
     mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/execmem: use VM_FLUSH_RESET_PERMS for ROX cache allocations
Date: Sun, 23 Aug 2026 14:46:16 +0300

Initially execmem completely removed direct map alias for the memory
allocated for the ROX cache in PMD_SIZE chunks.  When that memory was
freed, its direct map was restored also in PMD_SIZE chunks to avoid
fragmentation of the direct map caused by vmalloc::vm_reset_perms().

This required execmem to implement the wrappers for set_direct_map APIs
for proper sequencing of removal and restoration of the direct map
aliases.

Since then x86's CPA gained support for collapsing the direct map page
tables for ROX pages and execmem switched from removing ROX caches from
the direct map to making them ROX there, so execmem only needs to update
direct map alias permissions when freeing the ROX cache memory.

vmalloc already handles those updates for areas with VM_FLUSH_RESET_PERMS
set and vmalloc::vm_reset_perms() does not force split of the direct map
for PMD_SIZE chunks.

Make all execmem vmalloc allocations use VM_FLUSH_RESET_PERMS and remove
custom wrappers for set_direct_map APIs.

Link: https://lore.kernel.org/20260823-execmem-set-vm-perms-v0-2-v2-5-b013a37d84b3@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/execmem.c |   42 +++++++-----------------------------------
 1 file changed, 7 insertions(+), 35 deletions(-)

--- a/mm/execmem.c~mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations
+++ a/mm/execmem.c
@@ -36,6 +36,7 @@ static void *execmem_vmalloc(struct exec
 	unsigned long end = range->end;
 	void *p;
 
+	vm_flags |= VM_FLUSH_RESET_PERMS;
 	if (kasan)
 		vm_flags |= VM_DEFER_KMEMLEAK;
 
@@ -113,28 +114,6 @@ static inline unsigned long mas_range_le
 	return mas->last - mas->index + 1;
 }
 
-static int execmem_set_direct_map_valid(struct vm_struct *vm, bool valid)
-{
-	unsigned int nr = (1 << get_vm_area_page_order(vm));
-	unsigned int updated = 0;
-	int err = 0;
-
-	for (int i = 0; i < vm->nr_pages; i += nr) {
-		err = set_direct_map_valid_noflush(vm->pages[i], nr, valid);
-		if (err)
-			goto err_restore;
-		updated += nr;
-	}
-
-	return 0;
-
-err_restore:
-	for (int i = 0; i < updated; i += nr)
-		set_direct_map_valid_noflush(vm->pages[i], nr, !valid);
-
-	return err;
-}
-
 static int execmem_force_rw(void *ptr, size_t size)
 {
 	unsigned int nr = PAGE_ALIGN(size) >> PAGE_SHIFT;
@@ -169,9 +148,6 @@ static void execmem_cache_clean(struct w
 
 		if (IS_ALIGNED(size, PMD_SIZE) &&
 		    IS_ALIGNED(mas.index, PMD_SIZE)) {
-			struct vm_struct *vm = find_vm_area(area);
-
-			execmem_set_direct_map_valid(vm, true);
 			mas_store_gfp(&mas, NULL, GFP_KERNEL);
 			vfree(area);
 		}
@@ -312,18 +288,15 @@ static void *execmem_cache_populate_allo
 	 */
 	mutex_lock(mutex);
 	err = execmem_cache_add_locked(p, alloc_size, GFP_KERNEL);
-	if (err)
-		goto err_reset_direct_map;
-
-	p = execmem_cache_alloc_locked(range, size);
-
+	if (!err)
+		p = execmem_cache_alloc_locked(range, size);
 	mutex_unlock(mutex);
 
+	if (err)
+		goto err_free_mem;
+
 	return p;
 
-err_reset_direct_map:
-	mutex_unlock(mutex);
-	execmem_set_direct_map_valid(vm, true);
 err_free_mem:
 	vfree(p);
 	return NULL;
@@ -466,7 +439,6 @@ void *execmem_alloc(enum execmem_type ty
 {
 	struct execmem_range *range = &execmem_info->ranges[type];
 	bool use_cache = range->flags & EXECMEM_ROX_CACHE;
-	unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
 	pgprot_t pgprot = range->pgprot;
 	void *p = NULL;
 
@@ -475,7 +447,7 @@ void *execmem_alloc(enum execmem_type ty
 	if (use_cache)
 		p = execmem_cache_alloc(range, size);
 	else
-		p = execmem_vmalloc(range, size, pgprot, vm_flags);
+		p = execmem_vmalloc(range, size, pgprot, 0);
 
 	return kasan_reset_tag(p);
 }
_

Patches currently in -mm which might be from rppt@kernel.org are

set_memory-add-number-of-pages-parameter-to-set_direct_map-apis.patch
mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch
mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch
mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch
mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations.patch
revert-arch-introduce-set_direct_map_valid_noflush.patch
sh-remove-config_numa-and-realted-configuration-options.patch
sh-mm-remove-numac.patch
sh-mm-drop-allocate_pgdat.patch
sh-remove-setup_bootmem_node-and-plat_mem_setup.patch
sh-drop-dead-code-guarded-by-ifdef-config_numa.patch
sh-drop-include-asm-mmzoneh.patch
init-kconfig-drop-arch_want_numa_variable_locality.patch
sh-init-remove-call-the-memblock_set_node.patch
sh-remove-sparsemem-related-entries-from-kconfig.patch
sh-drop-include-asm-sparsememh.patch

