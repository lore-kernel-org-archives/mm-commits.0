From: akpm@linux-foundation.org
Subject: - fix-alpha-isa-support.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:50:43 -0700
Message-ID: <200707162050.l6GKohf7001330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36232 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758526AbXGPV00 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:26:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     fix alpha ISA support
has been removed from the -mm tree.  Its filename was
     fix-alpha-isa-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix alpha ISA support
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

isa_bus_to_virt() is still needed in a few places (lance.c, at least).  When
we switch the kernel to using -Werror-implicit-function-declaration, the lack
of isa_bus_to_virt() breaks alpha allmodconfig builds.

Add isa_bus_to_virt() and deprecate the ezisting ISA APIs, though it might be
better to define these functions as BUG(), since virt_to_bus/bus_to_virt just
do wrong things on a number of machines.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/io.h |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN include/asm-alpha/io.h~fix-alpha-isa-support include/asm-alpha/io.h
--- a/include/asm-alpha/io.h~fix-alpha-isa-support
+++ a/include/asm-alpha/io.h
@@ -4,6 +4,7 @@
 #ifdef __KERNEL__
 
 #include <linux/kernel.h>
+#include <linux/mm.h>
 #include <asm/compiler.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
@@ -90,6 +91,11 @@ static inline void * phys_to_virt(unsign
 
 #define page_to_phys(page)	page_to_pa(page)
 
+static inline dma_addr_t __deprecated isa_page_to_bus(struct page *page)
+{
+	return page_to_phys(page);
+}
+
 /* This depends on working iommu.  */
 #define BIO_VMERGE_BOUNDARY	(alpha_mv.mv_pci_tbi ? PAGE_SIZE : 0)
 
@@ -102,12 +108,12 @@ static inline void * phys_to_virt(unsign
  *
  * Note that this only works for a limited range of kernel addresses,
  * and very well may not span all memory.  Consider this interface 
- * deprecated in favour of the mapping functions in <asm/pci.h>.
+ * deprecated in favour of the DMA-mapping API.
  */
 extern unsigned long __direct_map_base;
 extern unsigned long __direct_map_size;
 
-static inline unsigned long virt_to_bus(void *address)
+static inline unsigned long __deprecated virt_to_bus(void *address)
 {
 	unsigned long phys = virt_to_phys(address);
 	unsigned long bus = phys + __direct_map_base;
@@ -115,7 +121,7 @@ static inline unsigned long virt_to_bus(
 }
 #define isa_virt_to_bus virt_to_bus
 
-static inline void *bus_to_virt(unsigned long address)
+static inline void * __deprecated bus_to_virt(unsigned long address)
 {
 	void *virt;
 
@@ -126,6 +132,7 @@ static inline void *bus_to_virt(unsigned
 	virt = phys_to_virt(address);
 	return (long)address <= 0 ? NULL : virt;
 }
+#define isa_bus_to_virt bus_to_virt
 
 /*
  * There are different chipsets to interface the Alpha CPUs to the world.
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

origin.patch
print-utsname-on-oops-on-all-architectures.patch
print-utsname-on-oops-on-all-architectures-fix.patch
i386-put-allocated-elf-notes-in-read-only-data-segment.patch
alpha-put-allocated-elf-notes-in-read-only-data-segment.patch
add-sys-kernel-notes.patch
use-build-id-ld-option.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
make-sure-nobodys-leaking-resources.patch
