From: akpm@linux-foundation.org
Subject: [merged] bootmem-fix-wrong-call-parameter-for-free_bootmem.patch removed from -mm tree
Date: Wed, 12 Dec 2012 12:01:25 -0800
Message-ID: <20121212200125.B948F100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:39474 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab2LLUJg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 15:09:36 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so116820qcq.3
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 12:09:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, benh@kernel.crashing.org, egtvedt@samfundet.no, fujita.tomonori@lab.ntt.co.jp, hannes@cmpxchg.org, hskinnemoen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bootmem: fix wrong call parameter for free_bootmem()
has been removed from the -mm tree.  Its filename was
     bootmem-fix-wrong-call-parameter-for-free_bootmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: bootmem: fix wrong call parameter for free_bootmem()

It is strange that alloc_bootmem() returns a virtual address and
free_bootmem() requires a physical address.  Anyway, free_bootmem()'s
first parameter should be physical address.

There are some call sites for free_bootmem() with virtual address.  So fix
them.

[akpm@linux-foundation.org: improve free_bootmem() and free_bootmem_pate() documentation]
Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/celleb_pci.c |    4 ++--
 drivers/macintosh/smu.c                  |    2 +-
 include/linux/bootmem.h                  |    4 ++--
 lib/cpumask.c                            |    2 +-
 mm/bootmem.c                             |   20 ++++++++++----------
 5 files changed, 16 insertions(+), 16 deletions(-)

diff -puN arch/powerpc/platforms/cell/celleb_pci.c~bootmem-fix-wrong-call-parameter-for-free_bootmem arch/powerpc/platforms/cell/celleb_pci.c
--- a/arch/powerpc/platforms/cell/celleb_pci.c~bootmem-fix-wrong-call-parameter-for-free_bootmem
+++ a/arch/powerpc/platforms/cell/celleb_pci.c
@@ -401,11 +401,11 @@ error:
 	} else {
 		if (config && *config) {
 			size = 256;
-			free_bootmem((unsigned long)(*config), size);
+			free_bootmem(__pa(*config), size);
 		}
 		if (res && *res) {
 			size = sizeof(struct celleb_pci_resource);
-			free_bootmem((unsigned long)(*res), size);
+			free_bootmem(__pa(*res), size);
 		}
 	}
 
diff -puN drivers/macintosh/smu.c~bootmem-fix-wrong-call-parameter-for-free_bootmem drivers/macintosh/smu.c
--- a/drivers/macintosh/smu.c~bootmem-fix-wrong-call-parameter-for-free_bootmem
+++ a/drivers/macintosh/smu.c
@@ -565,7 +565,7 @@ fail_msg_node:
 fail_db_node:
 	of_node_put(smu->db_node);
 fail_bootmem:
-	free_bootmem((unsigned long)smu, sizeof(struct smu_device));
+	free_bootmem(__pa(smu), sizeof(struct smu_device));
 	smu = NULL;
 fail_np:
 	of_node_put(np);
diff -puN include/linux/bootmem.h~bootmem-fix-wrong-call-parameter-for-free_bootmem include/linux/bootmem.h
--- a/include/linux/bootmem.h~bootmem-fix-wrong-call-parameter-for-free_bootmem
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
diff -puN lib/cpumask.c~bootmem-fix-wrong-call-parameter-for-free_bootmem lib/cpumask.c
--- a/lib/cpumask.c~bootmem-fix-wrong-call-parameter-for-free_bootmem
+++ a/lib/cpumask.c
@@ -161,6 +161,6 @@ EXPORT_SYMBOL(free_cpumask_var);
  */
 void __init free_bootmem_cpumask_var(cpumask_var_t mask)
 {
-	free_bootmem((unsigned long)mask, cpumask_size());
+	free_bootmem(__pa(mask), cpumask_size());
 }
 #endif
diff -puN mm/bootmem.c~bootmem-fix-wrong-call-parameter-for-free_bootmem mm/bootmem.c
--- a/mm/bootmem.c~bootmem-fix-wrong-call-parameter-for-free_bootmem
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

Patches currently in -mm which might be from js1304@gmail.com are

origin.patch
bootmem-remove-not-implemented-function-call-bootmem_arch_preferred_node.patch
bootmem-remove-alloc_arch_preferred_bootmem.patch
mm-warn_on_once-if-f_op-mmap-change-vmas-start-address.patch
linux-next.patch

