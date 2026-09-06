Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0511DED5C
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 02:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788660078; cv=none; b=S8QNNtXOxK8MDePgK0LN248qeAERxQRZ3xN4csHm35ze9Yom7DX7Mzc5X+rpsY6zbwg19d4yy6/hA6Jnu4nVRuB3DiMfxOA5qlc6XWvSwYcYVrqBVOw1R5CGdoBLWMqisQp2IkW86eEBC03WLH0umdzy8cU64IZpBIfovf9M27Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788660078; c=relaxed/simple;
	bh=Hf+izdv0Smbo6P8Ag1RzTqw7ZV9rLgQa0G6p2duBrHI=;
	h=Date:To:From:Subject:Message-Id; b=mfsWcrqH9HYUGMowxDmXb1zsbngOK6CBlfbPhD+sZognhPB1Kxfqwrgk4xe9n/0NjuVaBlp2H6S5QEEkiDAF3Eqh/zJuJDyEp9bHa2EJ+0+Kc1KtkjdsDIudLdyJmasIeHkzSSyMbpRMffGa0NJcD/Vy64YsjatDzCcGSK6tv/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dH6rLpSG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dH6rLpSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8191F00A3A;
	Sun,  6 Sep 2026 02:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788660076;
	bh=WuPkj9ZNtNZEPn6SsumHNyMg4afOlij4UXra5DdiR5w=;
	h=Date:To:From:Subject;
	b=dH6rLpSGSDb302sRwIBiNiooifO8/hAb9yj+rSuzEFtwRCQHdo/aVuMmVBYROVtjf
	 4S77KiNRT01gaedS3ps0fDltex3YaE4jsO1fN1159F5ASbTL/YuqcleTesWUt6pl1T
	 0njlnkVG5zx5KWgQ32PvXECRQ5yaAVT3W+QqYX0Q=
Date: Sat, 05 Sep 2026 19:01:16 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch added to mm-unstable branch
Message-Id: <20260906020116.CA8191F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: constify vm parameter of get_vm_area_page_order()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/vmalloc: constify vm parameter of get_vm_area_page_order()
Date: Thu, 03 Sep 2026 12:28:29 +0300

get_vm_area_page_order() and vm_area_page_order() do not need to modify
struct vm_struct passed to them.

Constify the parameter.

Link: https://lore.kernel.org/20260903-execmem-set-vm-perms-v0-2-v3-3-949b64a9f755@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
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
@@ -3137,7 +3137,7 @@ EXPORT_SYMBOL(vm_map_ram);
 
 static struct vm_struct *vmlist __initdata;
 
-static inline unsigned int vm_area_page_order(struct vm_struct *vm)
+static inline unsigned int vm_area_page_order(const struct vm_struct *vm)
 {
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
 	return vm->page_order;
@@ -3146,7 +3146,7 @@ static inline unsigned int vm_area_page_
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

set_memory-add-number-of-pages-parameter-to-set_direct_map-apis.patch
mm-vmalloc-set-areas-page_order-after-allocation-succeeds.patch
mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch
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

