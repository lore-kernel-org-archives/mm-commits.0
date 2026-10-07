Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F68547041
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334189; cv=none; b=kFQwOnzoMw6jTlqrgEA+5qnhgAqniQP83da2oRezCndUwootI8BUKS09yqxLIesgnopJ942wTyH0ylqC8fTEnMUAg4pD6KbnY50ZHu7p/360eTPHmVHcISSJN4chGJikTi0A9Ae4sFiHOypdHctTJ94AT/AdOLGpcoHNECRIDtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334189; c=relaxed/simple;
	bh=0RfZEBxxdmqYFF8PuxESdw8VgVCHRoQRZbuuhTr2fSE=;
	h=Date:To:From:Subject:Message-Id; b=CtbX8AoLJYl3FXAon0Km+rfsSpZrWeddZXVfZFUzLblSCerSI933BUEeZ08wZylW8ZkXbmX1f+8P7+0+/W5k2g85gQ+nqymdUU0tiZU0x85GtO9mFhfh37SBXwE7xkon8KIQXwxTaQ6Iqd2gsufCuouFE6K/vb4rdH8+eMWzUFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zdprz5wA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zdprz5wA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB891F0089C;
	Wed,  7 Oct 2026 00:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334187;
	bh=4B3KUmddjmZcvUR2daxwpHwLM+t9X6C0Wm/KrzZwEaM=;
	h=Date:To:From:Subject;
	b=zdprz5wAg5tEeBWZJgfmgzTvxjmPsxYRBiV6WX2jdSxxw21TLsv4s6HRP+qG2q3Ov
	 aZ1rKP71KzbDBmyK3RByP7UTgJp7s32+/PSdZErEX/5iwgjA3lIUm8EZZI8xXntdfH
	 0i9rVL7SMheQqrzyuKKXSRBtsQobQ8AqbRYw5qUs=
Date: Tue, 06 Oct 2026 17:49:47 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,urezki@gmail.com,svens@linux.ibm.com,ryan.roberts@arm.com,rafael@kernel.org,peterz@infradead.org,palmer@dabbelt.com,mingo@redhat.com,luto@kernel.org,lenb@kernel.org,kevin.brodsky@arm.com,kernel@xen0n.name,hpa@zytor.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dev.jain@arm.com,david@kernel.org,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,brendan.jackman@linux.dev,bp@alien8.de,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,alex@ghiti.fr,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch removed from -mm tree
Message-Id: <20261007004947.CBB891F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmalloc: constify vm parameter of get_vm_area_page_order()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: mm/vmalloc: constify vm parameter of get_vm_area_page_order()
Date: Thu, 03 Sep 2026 12:28:29 +0300

get_vm_area_page_order() and vm_area_page_order() do not need to modify
struct vm_struct passed to them.

Constify the parameter.

Link: https://lore.kernel.org/20260903-execmem-set-vm-perms-v0-2-v3-3-949b64a9f755@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
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
---

 mm/vmalloc.c |    4 ++--
 mm/vmalloc.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-constify-vm-parameter-of-get_vm_area_page_order
+++ a/mm/vmalloc.c
@@ -3124,7 +3124,7 @@ EXPORT_SYMBOL(vm_map_ram);
 
 static struct vm_struct *vmlist __initdata;
 
-static inline unsigned int vm_area_page_order(struct vm_struct *vm)
+static inline unsigned int vm_area_page_order(const struct vm_struct *vm)
 {
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
 	return vm->page_order;
@@ -3133,7 +3133,7 @@ static inline unsigned int vm_area_page_
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

