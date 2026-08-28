Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADC23C3C1C
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 05:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787895646; cv=none; b=fElmvwOh4vu9MnyoGd8W9VGuGjixELjoloMFKYtn0VE4I6nELpfGfJ75wXACJiewFMyP5jOS111YfwCBxMJtosZJhNx/OruopdQYnvXQtDGC+V43upVyS4eYYNZyIb8sXOE54aRPMVgUZcoEPYQgwaB+FZWjTzIKojt375Ipc7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787895646; c=relaxed/simple;
	bh=BtGFNwXqb+EKAqzOG19z/nhkpxeq8/iCMrcjSplD+74=;
	h=Date:To:From:Subject:Message-Id; b=DfOdPNBaTlR6d2D1UYbUw2vfQCu0O8mRqW4aAx7z3lL3hataT2Dv/jb2BAZqo/wasiRJ64hy/vTd4+aDdV5BmtRwfxZGeTfwUgUyLx43aqvSsd3L+ZSPxEV/oUcEfK2N7PmjZu9fEMEtJ0vR2ub4O5aw1EUihdCjlllZZniEN6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sx+Um5c4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sx+Um5c4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138C51F00A3A;
	Fri, 28 Aug 2026 05:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787895641;
	bh=tby7TpNzp55BWaevl1NtgZ3dCEitg40ZmEUS3X4xEe0=;
	h=Date:To:From:Subject;
	b=sx+Um5c442vLo6QDi/p3hX+GkftbevI6m5kmbr32SruoUWqCla+SsjIlDvae1sYjs
	 +KizzvpTWhgrWnbYL/azpuX2AqHL5x12IDPeOFZHAgvpNwM8OZEPOQ1VRqFi/c8RIg
	 /SCdh2QoppZf8n1s1A8w0IsOf86UKBXSkl+8tx7E=
Date: Thu, 27 Aug 2026 22:40:40 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch added to mm-new branch
Message-Id: <20260828054041.138C51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmalloc: constify vm parameter of get_vm_area_page_order()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch

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

