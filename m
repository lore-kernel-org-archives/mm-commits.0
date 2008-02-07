From: akpm@linux-foundation.org
Subject: - genericizing-iova.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:03 -0800
Message-ID: <200802070020.m170Ki2n006181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49011 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933940AbYBGAVV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:21:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, anil.s.keshavamurthy@intel.com, mm-commits@vger.kernel.org


The patch titled
     Genericizing iova.[ch]
has been removed from the -mm tree.  Its filename was
     genericizing-iova.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Genericizing iova.[ch]
From: David Miller <davem@davemloft.net>

I would like to potentially move the sparc64 IOMMU code over to using
the nice new drivers/pci/iova.[ch] code for free area management..

In order to do that we have to detach the IOMMU page size assumptions
which only really need to exist in the intel-iommu.[ch] code.

This patch attempts to implement that.

[akpm@linux-foundation.org: build fix]
Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/dmar.c        |    1 +
 drivers/pci/intel-iommu.c |    4 ++--
 drivers/pci/intel-iommu.h |   14 ++++++++++++++
 drivers/pci/iova.c        |    8 ++++----
 drivers/pci/iova.h        |   16 ++--------------
 5 files changed, 23 insertions(+), 20 deletions(-)

diff -puN drivers/pci/dmar.c~genericizing-iova drivers/pci/dmar.c
--- a/drivers/pci/dmar.c~genericizing-iova
+++ a/drivers/pci/dmar.c
@@ -26,6 +26,7 @@
 #include <linux/pci.h>
 #include <linux/dmar.h>
 #include "iova.h"
+#include "intel-iommu.h"
 
 #undef PREFIX
 #define PREFIX "DMAR:"
diff -puN drivers/pci/intel-iommu.c~genericizing-iova drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~genericizing-iova
+++ a/drivers/pci/intel-iommu.c
@@ -1088,7 +1088,7 @@ static void dmar_init_reserved_ranges(vo
 	int i;
 	u64 addr, size;
 
-	init_iova_domain(&reserved_iova_list);
+	init_iova_domain(&reserved_iova_list, DMA_32BIT_PFN);
 
 	/* IOAPIC ranges shouldn't be accessed by DMA */
 	iova = reserve_iova(&reserved_iova_list, IOVA_PFN(IOAPIC_RANGE_START),
@@ -1142,7 +1142,7 @@ static int domain_init(struct dmar_domai
 	int adjust_width, agaw;
 	unsigned long sagaw;
 
-	init_iova_domain(&domain->iovad);
+	init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
 	spin_lock_init(&domain->mapping_lock);
 
 	domain_reserve_special_ranges(domain);
diff -puN drivers/pci/intel-iommu.h~genericizing-iova drivers/pci/intel-iommu.h
--- a/drivers/pci/intel-iommu.h~genericizing-iova
+++ a/drivers/pci/intel-iommu.h
@@ -23,10 +23,24 @@
 
 #include <linux/types.h>
 #include <linux/msi.h>
+#include <linux/sysdev.h>
 #include "iova.h"
 #include <linux/io.h>
 
 /*
+ * We need a fixed PAGE_SIZE of 4K irrespective of
+ * arch PAGE_SIZE for IOMMU page tables.
+ */
+#define PAGE_SHIFT_4K		(12)
+#define PAGE_SIZE_4K		(1UL << PAGE_SHIFT_4K)
+#define PAGE_MASK_4K		(((u64)-1) << PAGE_SHIFT_4K)
+#define PAGE_ALIGN_4K(addr)	(((addr) + PAGE_SIZE_4K - 1) & PAGE_MASK_4K)
+
+#define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT_4K)
+#define DMA_32BIT_PFN		IOVA_PFN(DMA_32BIT_MASK)
+#define DMA_64BIT_PFN		IOVA_PFN(DMA_64BIT_MASK)
+
+/*
  * Intel IOMMU register specification per version 1.0 public spec.
  */
 
diff -puN drivers/pci/iova.c~genericizing-iova drivers/pci/iova.c
--- a/drivers/pci/iova.c~genericizing-iova
+++ a/drivers/pci/iova.c
@@ -9,19 +9,19 @@
 #include "iova.h"
 
 void
-init_iova_domain(struct iova_domain *iovad)
+init_iova_domain(struct iova_domain *iovad, unsigned long pfn_32bit)
 {
 	spin_lock_init(&iovad->iova_alloc_lock);
 	spin_lock_init(&iovad->iova_rbtree_lock);
 	iovad->rbroot = RB_ROOT;
 	iovad->cached32_node = NULL;
-
+	iovad->dma_32bit_pfn = pfn_32bit;
 }
 
 static struct rb_node *
 __get_cached_rbnode(struct iova_domain *iovad, unsigned long *limit_pfn)
 {
-	if ((*limit_pfn != DMA_32BIT_PFN) ||
+	if ((*limit_pfn != iovad->dma_32bit_pfn) ||
 		(iovad->cached32_node == NULL))
 		return rb_last(&iovad->rbroot);
 	else {
@@ -37,7 +37,7 @@ static void
 __cached_rbnode_insert_update(struct iova_domain *iovad,
 	unsigned long limit_pfn, struct iova *new)
 {
-	if (limit_pfn != DMA_32BIT_PFN)
+	if (limit_pfn != iovad->dma_32bit_pfn)
 		return;
 	iovad->cached32_node = &new->node;
 }
diff -puN drivers/pci/iova.h~genericizing-iova drivers/pci/iova.h
--- a/drivers/pci/iova.h~genericizing-iova
+++ a/drivers/pci/iova.h
@@ -15,22 +15,9 @@
 #include <linux/rbtree.h>
 #include <linux/dma-mapping.h>
 
-/*
- * We need a fixed PAGE_SIZE of 4K irrespective of
- * arch PAGE_SIZE for IOMMU page tables.
- */
-#define PAGE_SHIFT_4K		(12)
-#define PAGE_SIZE_4K		(1UL << PAGE_SHIFT_4K)
-#define PAGE_MASK_4K		(((u64)-1) << PAGE_SHIFT_4K)
-#define PAGE_ALIGN_4K(addr)	(((addr) + PAGE_SIZE_4K - 1) & PAGE_MASK_4K)
-
 /* IO virtual address start page frame number */
 #define IOVA_START_PFN		(1)
 
-#define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT_4K)
-#define DMA_32BIT_PFN	IOVA_PFN(DMA_32BIT_MASK)
-#define DMA_64BIT_PFN	IOVA_PFN(DMA_64BIT_MASK)
-
 /* iova structure */
 struct iova {
 	struct rb_node	node;
@@ -44,6 +31,7 @@ struct iova_domain {
 	spinlock_t	iova_rbtree_lock; /* Lock to protect update of rbtree */
 	struct rb_root	rbroot;		/* iova domain rbtree root */
 	struct rb_node	*cached32_node; /* Save last alloced node */
+	unsigned long	dma_32bit_pfn;
 };
 
 struct iova *alloc_iova_mem(void);
@@ -56,7 +44,7 @@ struct iova *alloc_iova(struct iova_doma
 struct iova *reserve_iova(struct iova_domain *iovad, unsigned long pfn_lo,
 	unsigned long pfn_hi);
 void copy_reserved_iova(struct iova_domain *from, struct iova_domain *to);
-void init_iova_domain(struct iova_domain *iovad);
+void init_iova_domain(struct iova_domain *iovad, unsigned long pfn_32bit);
 struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn);
 void put_iova_domain(struct iova_domain *iovad);
 
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
git-perfmon.patch
tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch
iget-stop-openpromfs-from-using-iget-and.patch
add-cmpxchg_local-to-sparc-move-__cmpxchg-to-systemh.patch
add-cmpxchg_local-to-sparc64.patch
mark-net_ns-with-depends-on-namespaces.patch
pid-fix-solaris_procids.patch
