From: akpm@linux-foundation.org
Subject: [folded-merged] bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:54:10 -0800
Message-ID: <20121211235410.EE53520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:40122 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab2LKXyO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:54:14 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so2172wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:54:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, egtvedt@samfundet.no, fujita.tomonori@lab.ntt.co.jp, hannes@cmpxchg.org, hskinnemoen@gmail.com, js1304@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bootmem-fix-wrong-call-parameter-for-free_bootmem-fix
has been removed from the -mm tree.  Its filename was
     bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch

This patch was dropped because it was folded into bootmem-fix-wrong-call-parameter-for-free_bootmem.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bootmem-fix-wrong-call-parameter-for-free_bootmem-fix

improve free_bootmem() and free_bootmem_pate() documentation

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    4 ++--
 mm/bootmem.c            |   20 ++++++++++----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN include/linux/bootmem.h~bootmem-fix-wrong-call-parameter-for-free_bootmem-fix include/linux/bootmem.h
--- a/include/linux/bootmem.h~bootmem-fix-wrong-call-parameter-for-free_bootmem-fix
+++ a/include/linux/bootmem.h
@@ -51,8 +51,8 @@ extern unsigned long free_all_bootmem(vo
 extern void free_bootmem_node(pg_data_t *pgdat,
 			      unsigned long addr,
 			      unsigned long size);
-extern void free_bootmem(unsigned long addr, unsigned long size);
-extern void free_bootmem_late(unsigned long addr, unsigned long size);
+extern void free_bootmem(unsigned long physaddr, unsigned long size);
+extern void free_bootmem_late(unsigned long physaddr, unsigned long size);
 
 /*
  * Flags for reserve_bootmem (also if CONFIG_HAVE_ARCH_BOOTMEM_NODE,
diff -puN mm/bootmem.c~bootmem-fix-wrong-call-parameter-for-free_bootmem-fix mm/bootmem.c
--- a/mm/bootmem.c~bootmem-fix-wrong-call-parameter-for-free_bootmem-fix
+++ a/mm/bootmem.c
@@ -147,21 +147,21 @@ unsigned long __init init_bootmem(unsign
 
 /*
  * free_bootmem_late - free bootmem pages directly to page allocator
- * @addr: starting address of the range
+ * @addr: starting physical address of the range
  * @size: size of the range in bytes
  *
  * This is only useful when the bootmem allocator has already been torn
  * down, but we are still initializing the system.  Pages are given directly
  * to the page allocator, no bootmem metadata is updated because it is gone.
  */
-void __init free_bootmem_late(unsigned long addr, unsigned long size)
+void __init free_bootmem_late(unsigned long physaddr, unsigned long size)
 {
 	unsigned long cursor, end;
 
-	kmemleak_free_part(__va(addr), size);
+	kmemleak_free_part(__va(physaddr), size);
 
-	cursor = PFN_UP(addr);
-	end = PFN_DOWN(addr + size);
+	cursor = PFN_UP(physaddr);
+	end = PFN_DOWN(physaddr + size);
 
 	for (; cursor < end; cursor++) {
 		__free_pages_bootmem(pfn_to_page(cursor), 0);
@@ -377,21 +377,21 @@ void __init free_bootmem_node(pg_data_t 
 
 /**
  * free_bootmem - mark a page range as usable
- * @addr: starting address of the range
+ * @addr: starting physical address of the range
  * @size: size of the range in bytes
  *
  * Partial pages will be considered reserved and left as they are.
  *
  * The range must be contiguous but may span node boundaries.
  */
-void __init free_bootmem(unsigned long addr, unsigned long size)
+void __init free_bootmem(unsigned long physaddr, unsigned long size)
 {
 	unsigned long start, end;
 
-	kmemleak_free_part(__va(addr), size);
+	kmemleak_free_part(__va(physaddr), size);
 
-	start = PFN_UP(addr);
-	end = PFN_DOWN(addr + size);
+	start = PFN_UP(physaddr);
+	end = PFN_DOWN(physaddr + size);
 
 	mark_bootmem(start, end, 0, 0);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-introduce-mm_find_pmd.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch
mm-check-rb_subtree_gap-correctness.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-vm_unmapped_area-lookup-function.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch

