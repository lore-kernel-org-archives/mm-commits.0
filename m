Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D20A29D288
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334194; cv=none; b=nbGQfhTCy/dRJcBNkuYelkARK3ebvBqQHC3I+i0kGOyGaF3bfrwfxOnzrFOQqyYHVQuid4KfFHM2Vhv9nuuFmCAMZp6qWTm6iYy47VSzBquGK4oEB5lrmD0+bX6YElGMgAaPaZMofPbwVf8PU8CSYZUufbU1ADTDuIvMBhTa770=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334194; c=relaxed/simple;
	bh=L279huS1cYJxf/rZEh0vTetzYpn+Icyq6+I5kWo+plw=;
	h=Date:To:From:Subject:Message-Id; b=X6c/2tTWKCFVdi9yFwhAkQc/HW+btIz2WKPvm84SJAbAlyZD1Q2DRrDLr8OJCCqlG0JopLLbJ/X/peUvm1ls7GGgVJmgqlvJaRNyCRkRdi4Zljq+IdPUriYH+/0B5mkE7WrIuUvXdFcIA0Ha6WX1ubBFZnPXSErZ9vJia1qEJ8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OXuQPm8e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OXuQPm8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD481F0089B;
	Wed,  7 Oct 2026 00:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334193;
	bh=hk/pKmdqtaWcPA4BX/VeQovzskA4ERYIPrUSxY/RI2M=;
	h=Date:To:From:Subject;
	b=OXuQPm8euhUqCYutRdwwliVW/njtZoa47l3yQHzJvatTHlWJ312nAtjgv0TUBGO7a
	 llEJOqtZpyIkCJ/ERr9oTgDTvZlhsMV9NfeGw/D+VdPtzEeXJBJR+FAO0sNh2RLCB7
	 WPs/uIXt6uSKhMq3yUvXylHjVEteVWJ3sbACMTpQ=
Date: Tue, 06 Oct 2026 17:49:53 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,urezki@gmail.com,svens@linux.ibm.com,ryan.roberts@arm.com,rafael@kernel.org,peterz@infradead.org,palmer@dabbelt.com,mingo@redhat.com,luto@kernel.org,lenb@kernel.org,kevin.brodsky@arm.com,kernel@xen0n.name,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dev.jain@arm.com,david@kernel.org,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,brendan.jackman@linux.dev,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations.patch removed from -mm tree
Message-Id: <20261007004953.6AD481F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/execmem: use VM_FLUSH_RESET_PERMS for ROX cache allocations
has been removed from the -mm tree.  Its filename was
     mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/execmem: use VM_FLUSH_RESET_PERMS for ROX cache allocations
Date: Thu, 03 Sep 2026 12:28:31 +0300

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

Set the area permissions with set_vm_flush_reset_perms() when populating
the execmem cache just before flipping the area to ROX.

This way freeing an allocated area on an error path won't incur two
updates of the direct map alias of that area and TLB flushing in
vm_reset_perms().

Link: https://lore.kernel.org/20260903-execmem-set-vm-perms-v0-2-v3-5-949b64a9f755@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
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
Cc: Dev Jain <dev.jain@arm.com>
---

 mm/execmem.c |   40 +++++++---------------------------------
 1 file changed, 7 insertions(+), 33 deletions(-)

--- a/mm/execmem.c~mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations
+++ a/mm/execmem.c
@@ -113,28 +113,6 @@ static inline unsigned long mas_range_le
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
@@ -169,9 +147,6 @@ static void execmem_cache_clean(struct w
 
 		if (IS_ALIGNED(size, PMD_SIZE) &&
 		    IS_ALIGNED(mas.index, PMD_SIZE)) {
-			struct vm_struct *vm = find_vm_area(area);
-
-			execmem_set_direct_map_valid(vm, true);
 			mas_store_gfp(&mas, NULL, GFP_KERNEL);
 			vfree(area);
 		}
@@ -301,6 +276,8 @@ static void *execmem_cache_populate_allo
 	/* fill memory with instructions that will trap */
 	execmem_fill_trapping_insns(p, alloc_size);
 
+	set_vm_flush_reset_perms(p);
+
 	err = set_memory_rox((unsigned long)p, vm->nr_pages);
 	if (err)
 		goto err_free_mem;
@@ -312,18 +289,15 @@ static void *execmem_cache_populate_allo
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
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-execmem-free-rox-cache-chunks-only-when-they-span-an-entire-vm-area.patch
mm-execmem-handle-potential-allocation-errors-in-the-maple-tree.patch
mm-execmem-make-sure-rox-cache-always-contains-multiples-of-pmd_size.patch
mm-vmalloc-add-define_free-for-vfree.patch
mm-execmem-use-cleanup-infrastructure-in-rox-cache-functions.patch
docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc.patch
maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section.patch
docs-core-api-memory-allocation-clarify-when-to-use-kzalloc_obj-and-kzalloc.patch
docs-mm-describe-set_memory-and-set_direct_map-apis.patch
docs-mm-describe-set_memory-and-set_direct_map-apis-fix.patch
arch-mm-promote-debug_wx-to-check_wx.patch
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

