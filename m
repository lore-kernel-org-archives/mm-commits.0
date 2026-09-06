Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C184A3126B0
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 01:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788659304; cv=none; b=WmAMG2qtOQtnZg8Yx64OrIl3Lv8fL2Phs7JfEJPMuy3GcrRKo1zkx3Qravyy+YOmv9U64sAjr5p3eAD3bHq0D4k3bLZOadQcASAp5Q43/2J+81aeD3DU6VjCSTya5wz3oUfQ7cL18roghAyKcOZ9BBsBXwV0K93k6V659+yQFHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788659304; c=relaxed/simple;
	bh=LC7UxDV/qIaRrLXMJma8GuTAAtOKKLvsBCDZrDSoRog=;
	h=Date:To:From:Subject:Message-Id; b=F/20krmpsT0ZwcV6qVtLNaX9J8jzst50WQNngjZ0V5ddV5VAEuP1ULR1JAIQHt6ta/nPDow3puAPeRg7QzkNtAJ0quGnietGDcTW1i5hPQprmItIV2wKkMf6jLY+dmduflhadfDZ4vqVNALS/VNMYeW/++1hsw3cfCurSq3f124=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LG+kQ5hY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LG+kQ5hY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545F81F00A3A;
	Sun,  6 Sep 2026 01:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788659302;
	bh=0Td/N05xoLqr+FazewuPRMKjyMrfb0Jan0iHHs8mgho=;
	h=Date:To:From:Subject;
	b=LG+kQ5hYRHn7npGzocRDmbUh1/FFXAShWkgJzdua1MhTMqGH85i55iVR8Gz6viftI
	 0JEemqdE4mOArYtgQiMr4aWC6vbEcvJuwCokJSXNXkiYtKbgCWT6V8aVuis+fHVTRw
	 fICd1mZZyZJcJLQkPLB7vy7oQZWjY07FH8v9eB4k=
Date: Sat, 05 Sep 2026 18:48:21 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch removed from -mm tree
Message-Id: <20260906014822.545F81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: constify vm parameter of get_vm_area_page_order()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/vmalloc: constify vm parameter of get_vm_area_page_order()
Date: Sun, 23 Aug 2026 14:46:14 +0300

get_vm_area_page_order() and vm_area_page_order() do not need to modify
struct vm_struct passed to them.

Constify the parameter.

Link: https://lore.kernel.org/20260823-execmem-set-vm-perms-v0-2-v2-3-b013a37d84b3@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
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
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 mm/vmalloc.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order
+++ a/mm/vmalloc.c
@@ -3129,7 +3129,7 @@ EXPORT_SYMBOL(vm_map_ram);
 
 static struct vm_struct *vmlist __initdata;
 
-static inline unsigned int vm_area_page_order(struct vm_struct *vm)
+static inline unsigned int vm_area_page_order(const struct vm_struct *vm)
 {
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
 	return vm->page_order;
@@ -3138,7 +3138,7 @@ static inline unsigned int vm_area_page_
 #endif
 }
 
-unsigned int get_vm_area_page_order(struct vm_struct *vm)
+unsigned int get_vm_area_page_order(const struct vm_struct *vm)
 {
 	return vm_area_page_order(vm);
 }
--- a/mm/vmalloc.h~mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order
+++ a/mm/vmalloc.h
@@ -12,7 +12,7 @@ void __init vmalloc_init(void);
 int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages,
 		unsigned int page_shift, gfp_t gfp_mask);
-unsigned int get_vm_area_page_order(struct vm_struct *vm);
+unsigned int get_vm_area_page_order(const struct vm_struct *vm);
 #else
 static inline void vmalloc_init(void) {}
 
_

Patches currently in -mm which might be from rppt@kernel.org are

mm-vmalloc-make-set_area_direct_map-huge_vmap-friendly.patch
mm-execmem-use-vm_flush_reset_perms-for-rox-cache-allocations.patch
revert-arch-introduce-set_direct_map_valid_noflush.patch
docs-core-api-memory-allocation-add-kalloc_obj-and-clarify-kmalloc.patch
maintainers-add-memory-related-docs-in-core-mm-to-mm-misc-section.patch
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

