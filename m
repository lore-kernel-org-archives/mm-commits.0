From: akpm@osdl.org
Subject: - add-struct-dev-pointer-to-dma_is_consistent.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:07:13 -0800
Message-ID: <200612072307.kB7N7D6X030341@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52820 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163960AbWLGXHu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, James.Bottomley@steeleye.com, davem@davemloft.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Add struct dev pointer to dma_is_consistent()
has been removed from the -mm tree.  Its filename was
     add-struct-dev-pointer-to-dma_is_consistent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add struct dev pointer to dma_is_consistent()
From: Ralf Baechle <ralf@linux-mips.org>

dma_is_consistent() is ill-designed in that it does not have a struct
device pointer argument which makes proper support for systems that consist
of a mix of coherent and non-coherent DMA devices hard.  Change
dma_is_consistent to take a struct device pointer as first argument and fix
the sole caller to pass it.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/DMA-API.txt         |    6 +++---
 arch/mips/mm/dma-coherent.c       |    2 +-
 arch/mips/mm/dma-ip27.c           |    2 +-
 arch/mips/mm/dma-ip32.c           |    2 +-
 arch/mips/mm/dma-noncoherent.c    |    2 +-
 drivers/scsi/53c700.c             |    2 +-
 include/asm-alpha/dma-mapping.h   |    2 +-
 include/asm-arm/dma-mapping.h     |    2 +-
 include/asm-avr32/dma-mapping.h   |    2 +-
 include/asm-cris/dma-mapping.h    |    2 +-
 include/asm-frv/dma-mapping.h     |    2 +-
 include/asm-generic/dma-mapping.h |    2 +-
 include/asm-i386/dma-mapping.h    |    2 +-
 include/asm-ia64/dma-mapping.h    |    2 +-
 include/asm-m68k/dma-mapping.h    |    2 +-
 include/asm-mips/dma-mapping.h    |    2 +-
 include/asm-parisc/dma-mapping.h  |    2 +-
 include/asm-powerpc/dma-mapping.h |    4 ++--
 include/asm-sparc64/dma-mapping.h |    2 +-
 include/asm-um/dma-mapping.h      |    2 +-
 include/asm-x86_64/dma-mapping.h  |    2 +-
 include/asm-xtensa/dma-mapping.h  |    2 +-
 22 files changed, 25 insertions(+), 25 deletions(-)

diff -puN Documentation/DMA-API.txt~add-struct-dev-pointer-to-dma_is_consistent Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~add-struct-dev-pointer-to-dma_is_consistent
+++ a/Documentation/DMA-API.txt
@@ -431,10 +431,10 @@ be identical to those passed in (and ret
 dma_alloc_noncoherent()).
 
 int
-dma_is_consistent(dma_addr_t dma_handle)
+dma_is_consistent(struct device *dev, dma_addr_t dma_handle)
 
-returns true if the memory pointed to by the dma_handle is actually
-consistent.
+returns true if the device dev is performing consistent DMA on the memory
+area pointed to by the dma_handle.
 
 int
 dma_get_cache_alignment(void)
diff -puN arch/mips/mm/dma-coherent.c~add-struct-dev-pointer-to-dma_is_consistent arch/mips/mm/dma-coherent.c
--- a/arch/mips/mm/dma-coherent.c~add-struct-dev-pointer-to-dma_is_consistent
+++ a/arch/mips/mm/dma-coherent.c
@@ -190,7 +190,7 @@ int dma_supported(struct device *dev, u6
 
 EXPORT_SYMBOL(dma_supported);
 
-int dma_is_consistent(dma_addr_t dma_addr)
+int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
 {
 	return 1;
 }
diff -puN arch/mips/mm/dma-ip27.c~add-struct-dev-pointer-to-dma_is_consistent arch/mips/mm/dma-ip27.c
--- a/arch/mips/mm/dma-ip27.c~add-struct-dev-pointer-to-dma_is_consistent
+++ a/arch/mips/mm/dma-ip27.c
@@ -197,7 +197,7 @@ int dma_supported(struct device *dev, u6
 
 EXPORT_SYMBOL(dma_supported);
 
-int dma_is_consistent(dma_addr_t dma_addr)
+int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
 {
 	return 1;
 }
diff -puN arch/mips/mm/dma-ip32.c~add-struct-dev-pointer-to-dma_is_consistent arch/mips/mm/dma-ip32.c
--- a/arch/mips/mm/dma-ip32.c~add-struct-dev-pointer-to-dma_is_consistent
+++ a/arch/mips/mm/dma-ip32.c
@@ -363,7 +363,7 @@ int dma_supported(struct device *dev, u6
 
 EXPORT_SYMBOL(dma_supported);
 
-int dma_is_consistent(dma_addr_t dma_addr)
+int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
 {
 	return 1;
 }
diff -puN arch/mips/mm/dma-noncoherent.c~add-struct-dev-pointer-to-dma_is_consistent arch/mips/mm/dma-noncoherent.c
--- a/arch/mips/mm/dma-noncoherent.c~add-struct-dev-pointer-to-dma_is_consistent
+++ a/arch/mips/mm/dma-noncoherent.c
@@ -299,7 +299,7 @@ int dma_supported(struct device *dev, u6
 
 EXPORT_SYMBOL(dma_supported);
 
-int dma_is_consistent(dma_addr_t dma_addr)
+int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
 {
 	return 1;
 }
diff -puN drivers/scsi/53c700.c~add-struct-dev-pointer-to-dma_is_consistent drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c~add-struct-dev-pointer-to-dma_is_consistent
+++ a/drivers/scsi/53c700.c
@@ -313,7 +313,7 @@ NCR_700_detect(struct scsi_host_template
 	hostdata->status = memory + STATUS_OFFSET;
 	/* all of these offsets are L1_CACHE_BYTES separated.  It is fatal
 	 * if this isn't sufficient separation to avoid dma flushing issues */
-	BUG_ON(!dma_is_consistent(pScript) && L1_CACHE_BYTES < dma_get_cache_alignment());
+	BUG_ON(!dma_is_consistent(hostdata->dev, pScript) && L1_CACHE_BYTES < dma_get_cache_alignment());
 	hostdata->slots = (struct NCR_700_command_slot *)(memory + SLOTS_OFFSET);
 	hostdata->dev = dev;
 
diff -puN include/asm-alpha/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-alpha/dma-mapping.h
--- a/include/asm-alpha/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-alpha/dma-mapping.h
@@ -51,7 +51,7 @@ int dma_map_sg(struct device *dev, struc
 
 #define dma_alloc_noncoherent(d, s, h, f)	dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h)	dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(dev)			(1)
+#define dma_is_consistent(d, h)			(1)
 
 int dma_set_mask(struct device *dev, u64 mask);
 
diff -puN include/asm-arm/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-arm/dma-mapping.h
--- a/include/asm-arm/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-arm/dma-mapping.h
@@ -48,7 +48,7 @@ static inline int dma_get_cache_alignmen
 	return 32;
 }
 
-static inline int dma_is_consistent(dma_addr_t handle)
+static inline int dma_is_consistent(struct device *dev, dma_addr_t handle)
 {
 	return !!arch_is_coherent();
 }
diff -puN include/asm-avr32/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-avr32/dma-mapping.h
--- a/include/asm-avr32/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-avr32/dma-mapping.h
@@ -307,7 +307,7 @@ dma_sync_sg_for_device(struct device *de
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 
-static inline int dma_is_consistent(dma_addr_t dma_addr)
+static inline int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
 {
 	return 1;
 }
diff -puN include/asm-cris/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-cris/dma-mapping.h
--- a/include/asm-cris/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-cris/dma-mapping.h
@@ -156,7 +156,7 @@ dma_get_cache_alignment(void)
 	return (1 << INTERNODE_CACHE_SHIFT);
 }
 
-#define dma_is_consistent(d)	(1)
+#define dma_is_consistent(d, h)	(1)
 
 static inline void
 dma_cache_sync(void *vaddr, size_t size,
diff -puN include/asm-frv/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-frv/dma-mapping.h
--- a/include/asm-frv/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-frv/dma-mapping.h
@@ -172,7 +172,7 @@ int dma_get_cache_alignment(void)
 	return 1 << L1_CACHE_SHIFT;
 }
 
-#define dma_is_consistent(d)	(1)
+#define dma_is_consistent(d, h)	(1)
 
 static inline
 void dma_cache_sync(void *vaddr, size_t size,
diff -puN include/asm-generic/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-generic/dma-mapping.h
--- a/include/asm-generic/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-generic/dma-mapping.h
@@ -266,7 +266,7 @@ dma_error(dma_addr_t dma_addr)
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d)	(1)
+#define dma_is_consistent(d, h)	(1)
 
 static inline int
 dma_get_cache_alignment(void)
diff -puN include/asm-i386/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-i386/dma-mapping.h
--- a/include/asm-i386/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-i386/dma-mapping.h
@@ -156,7 +156,7 @@ dma_get_cache_alignment(void)
 	return (1 << INTERNODE_CACHE_SHIFT);
 }
 
-#define dma_is_consistent(d)	(1)
+#define dma_is_consistent(d, h)	(1)
 
 static inline void
 dma_cache_sync(void *vaddr, size_t size,
diff -puN include/asm-ia64/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-ia64/dma-mapping.h
--- a/include/asm-ia64/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-ia64/dma-mapping.h
@@ -59,6 +59,6 @@ dma_cache_sync (void *vaddr, size_t size
 	mb();
 }
 
-#define dma_is_consistent(dma_handle)	(1)	/* all we do is coherent memory... */
+#define dma_is_consistent(d, h)	(1)	/* all we do is coherent memory... */
 
 #endif /* _ASM_IA64_DMA_MAPPING_H */
diff -puN include/asm-m68k/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-m68k/dma-mapping.h
--- a/include/asm-m68k/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-m68k/dma-mapping.h
@@ -21,7 +21,7 @@ static inline int dma_get_cache_alignmen
 	return 1 << L1_CACHE_SHIFT;
 }
 
-static inline int dma_is_consistent(dma_addr_t dma_addr)
+static inline int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
diff -puN include/asm-mips/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-mips/dma-mapping.h
--- a/include/asm-mips/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-mips/dma-mapping.h
@@ -63,7 +63,7 @@ dma_get_cache_alignment(void)
 	return 128;
 }
 
-extern int dma_is_consistent(dma_addr_t dma_addr);
+extern int dma_is_consistent(struct device *dev, dma_addr_t dma_addr);
 
 extern void dma_cache_sync(void *vaddr, size_t size,
 	       enum dma_data_direction direction);
diff -puN include/asm-parisc/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-parisc/dma-mapping.h
--- a/include/asm-parisc/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-parisc/dma-mapping.h
@@ -191,7 +191,7 @@ dma_get_cache_alignment(void)
 }
 
 static inline int
-dma_is_consistent(dma_addr_t dma_addr)
+dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
 {
 	return (hppa_dma_ops->dma_sync_single_for_cpu == NULL);
 }
diff -puN include/asm-powerpc/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-powerpc/dma-mapping.h
--- a/include/asm-powerpc/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-powerpc/dma-mapping.h
@@ -342,9 +342,9 @@ static inline int dma_mapping_error(dma_
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 #ifdef CONFIG_NOT_COHERENT_CACHE
-#define dma_is_consistent(d)	(0)
+#define dma_is_consistent(d, h)	(0)
 #else
-#define dma_is_consistent(d)	(1)
+#define dma_is_consistent(d, h)	(1)
 #endif
 
 static inline int dma_get_cache_alignment(void)
diff -puN include/asm-sparc64/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-sparc64/dma-mapping.h
--- a/include/asm-sparc64/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-sparc64/dma-mapping.h
@@ -181,7 +181,7 @@ dma_sync_single_for_device(struct device
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d)	(1)
+#define dma_is_consistent(d, h)	(1)
 
 static inline int
 dma_get_cache_alignment(void)
diff -puN include/asm-um/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-um/dma-mapping.h
--- a/include/asm-um/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-um/dma-mapping.h
@@ -94,7 +94,7 @@ dma_sync_sg(struct device *dev, struct s
 
 #define dma_alloc_noncoherent(d, s, h, f) dma_alloc_coherent(d, s, h, f)
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
-#define dma_is_consistent(d) (1)
+#define dma_is_consistent(d, h) (1)
 
 static inline int
 dma_get_cache_alignment(void)
diff -puN include/asm-x86_64/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-x86_64/dma-mapping.h
--- a/include/asm-x86_64/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-x86_64/dma-mapping.h
@@ -180,7 +180,7 @@ static inline int dma_get_cache_alignmen
 	return boot_cpu_data.x86_clflush_size;
 }
 
-#define dma_is_consistent(h) 1
+#define dma_is_consistent(d, h) 1
 
 extern int dma_set_mask(struct device *dev, u64 mask);
 
diff -puN include/asm-xtensa/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent include/asm-xtensa/dma-mapping.h
--- a/include/asm-xtensa/dma-mapping.h~add-struct-dev-pointer-to-dma_is_consistent
+++ a/include/asm-xtensa/dma-mapping.h
@@ -170,7 +170,7 @@ dma_get_cache_alignment(void)
 	return L1_CACHE_BYTES;
 }
 
-#define dma_is_consistent(d)	(1)
+#define dma_is_consistent(d, h)	(1)
 
 static inline void
 dma_cache_sync(void *vaddr, size_t size,
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
mips-dbg_io-stray-brackets-fix.patch
mmc-fix-syntax-error.patch
git-mtd.patch
pci-legacy-resource-fix.patch
pci-legacy-resource-fix-tidy.patch
generic-ioremap_page_range-mips-conversion.patch

