From: akpm@linux-foundation.org
Subject: [merged]
 mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping.patch removed from -mm tree
Date: Wed, 12 Oct 2016 12:25:56 -0700
Message-ID: <57fe8e44.ffnzfMCE5VRqpVDS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33485 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932347AbcJLTZ5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:25:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, vigneshr@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak: avoid using __va() on addresses that don't have a lowmem mapping
has been removed from the -mm tree.  Its filename was
     mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: kmemleak: avoid using __va() on addresses that don't have a lowmem mapping

Some of the kmemleak_*() callbacks in memblock, bootmem, CMA convert a
physical address to a virtual one using __va().  However, such physical
addresses may sometimes be located in highmem and using __va() is
incorrect, leading to inconsistent object tracking in kmemleak.

The following functions have been added to the kmemleak API and they take
a physical address as the object pointer.  They only perform the
corresponding action if the address has a lowmem mapping:

kmemleak_alloc_phys
kmemleak_free_part_phys
kmemleak_not_leak_phys
kmemleak_ignore_phys

The affected calling places have been updated to use the new kmemleak
API.

Link: http://lkml.kernel.org/r/1471531432-16503-1-git-send-email-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Vignesh R <vigneshr@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/dev-tools/kmemleak.rst |    9 ++++
 include/linux/kmemleak.h             |   18 +++++++++
 mm/bootmem.c                         |    6 +--
 mm/cma.c                             |    2 -
 mm/kmemleak.c                        |   47 +++++++++++++++++++++++++
 mm/memblock.c                        |    8 ++--
 mm/nobootmem.c                       |    2 -
 7 files changed, 83 insertions(+), 9 deletions(-)

diff -puN Documentation/dev-tools/kmemleak.rst~mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping Documentation/dev-tools/kmemleak.rst
--- a/Documentation/dev-tools/kmemleak.rst~mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping
+++ a/Documentation/dev-tools/kmemleak.rst
@@ -162,6 +162,15 @@ See the include/linux/kmemleak.h header
 - ``kmemleak_alloc_recursive`` - as kmemleak_alloc but checks the recursiveness
 - ``kmemleak_free_recursive``	 - as kmemleak_free but checks the recursiveness
 
+The following functions take a physical address as the object pointer
+and only perform the corresponding action if the address has a lowmem
+mapping:
+
+- ``kmemleak_alloc_phys``
+- ``kmemleak_free_part_phys``
+- ``kmemleak_not_leak_phys``
+- ``kmemleak_ignore_phys``
+
 Dealing with false positives/negatives
 --------------------------------------
 
diff -puN include/linux/kmemleak.h~mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping include/linux/kmemleak.h
--- a/include/linux/kmemleak.h~mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping
+++ a/include/linux/kmemleak.h
@@ -38,6 +38,11 @@ extern void kmemleak_not_leak(const void
 extern void kmemleak_ignore(const void *ptr) __ref;
 extern void kmemleak_scan_area(const void *ptr, size_t size, gfp_t gfp) __ref;
 extern void kmemleak_no_scan(const void *ptr) __ref;
+extern void kmemleak_alloc_phys(phys_addr_t phys, size_t size, int min_count,
+				gfp_t gfp) __ref;
+extern void kmemleak_free_part_phys(phys_addr_t phys, size_t size) __ref;
+extern void kmemleak_not_leak_phys(phys_addr_t phys) __ref;
+extern void kmemleak_ignore_phys(phys_addr_t phys) __ref;
 
 static inline void kmemleak_alloc_recursive(const void *ptr, size_t size,
 					    int min_count, unsigned long flags,
@@ -106,6 +111,19 @@ static inline void kmemleak_erase(void *
 static inline void kmemleak_no_scan(const void *ptr)
 {
 }
+static inline void kmemleak_alloc_phys(phys_addr_t phys, size_t size,
+				       int min_count, gfp_t gfp)
+{
+}
+static inline void kmemleak_free_part_phys(phys_addr_t phys, size_t size)
+{
+}
+static inline void kmemleak_not_leak_phys(phys_addr_t phys)
+{
+}
+static inline void kmemleak_ignore_phys(phys_addr_t phys)
+{
+}
 
 #endif	/* CONFIG_DEBUG_KMEMLEAK */
 
diff -puN mm/bootmem.c~mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping mm/bootmem.c
--- a/mm/bootmem.c~mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping
+++ a/mm/bootmem.c
@@ -155,7 +155,7 @@ void __init free_bootmem_late(unsigned l
 {
 	unsigned long cursor, end;
 
-	kmemleak_free_part(__va(physaddr), size);
+	kmemleak_free_part_phys(physaddr, size);
 
 	cursor = PFN_UP(physaddr);
 	end = PFN_DOWN(physaddr + size);
@@ -399,7 +399,7 @@ void __init free_bootmem_node(pg_data_t
 {
 	unsigned long start, end;
 
-	kmemleak_free_part(__va(physaddr), size);
+	kmemleak_free_part_phys(physaddr, size);
 
 	start = PFN_UP(physaddr);
 	end = PFN_DOWN(physaddr + size);
@@ -420,7 +420,7 @@ void __init free_bootmem(unsigned long p
 {
 	unsigned long start, end;
 
-	kmemleak_free_part(__va(physaddr), size);
+	kmemleak_free_part_phys(physaddr, size);
 
 	start = PFN_UP(physaddr);
 	end = PFN_DOWN(physaddr + size);
diff -puN mm/cma.c~mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping mm/cma.c
--- a/mm/cma.c~mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping
+++ a/mm/cma.c
@@ -336,7 +336,7 @@ int __init cma_declare_contiguous(phys_a
 		 * kmemleak scans/reads tracked objects for pointers to other
 		 * objects but this address isn't mapped and accessible
 		 */
-		kmemleak_ignore(phys_to_virt(addr));
+		kmemleak_ignore_phys(addr);
 		base = addr;
 	}
 
diff -puN mm/kmemleak.c~mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping
+++ a/mm/kmemleak.c
@@ -90,6 +90,8 @@
 #include <linux/cache.h>
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
+#include <linux/bootmem.h>
+#include <linux/pfn.h>
 #include <linux/mmzone.h>
 #include <linux/slab.h>
 #include <linux/thread_info.h>
@@ -1121,6 +1123,51 @@ void __ref kmemleak_no_scan(const void *
 }
 EXPORT_SYMBOL(kmemleak_no_scan);
 
+/**
+ * kmemleak_alloc_phys - similar to kmemleak_alloc but taking a physical
+ *			 address argument
+ */
+void __ref kmemleak_alloc_phys(phys_addr_t phys, size_t size, int min_count,
+			       gfp_t gfp)
+{
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+		kmemleak_alloc(__va(phys), size, min_count, gfp);
+}
+EXPORT_SYMBOL(kmemleak_alloc_phys);
+
+/**
+ * kmemleak_free_part_phys - similar to kmemleak_free_part but taking a
+ *			     physical address argument
+ */
+void __ref kmemleak_free_part_phys(phys_addr_t phys, size_t size)
+{
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+		kmemleak_free_part(__va(phys), size);
+}
+EXPORT_SYMBOL(kmemleak_free_part_phys);
+
+/**
+ * kmemleak_not_leak_phys - similar to kmemleak_not_leak but taking a physical
+ *			    address argument
+ */
+void __ref kmemleak_not_leak_phys(phys_addr_t phys)
+{
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+		kmemleak_not_leak(__va(phys));
+}
+EXPORT_SYMBOL(kmemleak_not_leak_phys);
+
+/**
+ * kmemleak_ignore_phys - similar to kmemleak_ignore but taking a physical
+ *			  address argument
+ */
+void __ref kmemleak_ignore_phys(phys_addr_t phys)
+{
+	if (!IS_ENABLED(CONFIG_HIGHMEM) || PHYS_PFN(phys) < max_low_pfn)
+		kmemleak_ignore(__va(phys));
+}
+EXPORT_SYMBOL(kmemleak_ignore_phys);
+
 /*
  * Update an object's checksum and return true if it was modified.
  */
diff -puN mm/memblock.c~mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping mm/memblock.c
--- a/mm/memblock.c~mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping
+++ a/mm/memblock.c
@@ -723,7 +723,7 @@ int __init_memblock memblock_free(phys_a
 		     (unsigned long long)base + size - 1,
 		     (void *)_RET_IP_);
 
-	kmemleak_free_part(__va(base), size);
+	kmemleak_free_part_phys(base, size);
 	return memblock_remove_range(&memblock.reserved, base, size);
 }
 
@@ -1152,7 +1152,7 @@ static phys_addr_t __init memblock_alloc
 		 * The min_count is set to 0 so that memblock allocations are
 		 * never reported as leaks.
 		 */
-		kmemleak_alloc(__va(found), size, 0, 0);
+		kmemleak_alloc_phys(found, size, 0, 0);
 		return found;
 	}
 	return 0;
@@ -1399,7 +1399,7 @@ void __init __memblock_free_early(phys_a
 	memblock_dbg("%s: [%#016llx-%#016llx] %pF\n",
 		     __func__, (u64)base, (u64)base + size - 1,
 		     (void *)_RET_IP_);
-	kmemleak_free_part(__va(base), size);
+	kmemleak_free_part_phys(base, size);
 	memblock_remove_range(&memblock.reserved, base, size);
 }
 
@@ -1419,7 +1419,7 @@ void __init __memblock_free_late(phys_ad
 	memblock_dbg("%s: [%#016llx-%#016llx] %pF\n",
 		     __func__, (u64)base, (u64)base + size - 1,
 		     (void *)_RET_IP_);
-	kmemleak_free_part(__va(base), size);
+	kmemleak_free_part_phys(base, size);
 	cursor = PFN_UP(base);
 	end = PFN_DOWN(base + size);
 
diff -puN mm/nobootmem.c~mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping mm/nobootmem.c
--- a/mm/nobootmem.c~mm-kmemleak-avoid-using-__va-on-addresses-that-dont-have-a-lowmem-mapping
+++ a/mm/nobootmem.c
@@ -84,7 +84,7 @@ void __init free_bootmem_late(unsigned l
 {
 	unsigned long cursor, end;
 
-	kmemleak_free_part(__va(addr), size);
+	kmemleak_free_part_phys(addr, size);
 
 	cursor = PFN_UP(addr);
 	end = PFN_DOWN(addr + size);
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


