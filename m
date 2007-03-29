From: akpm@linux-foundation.org
Subject: - dma_ops-as-const.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:38:58 -0700
Message-ID: <200703292338.l2TNcwJA015393@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43158 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934396AbXC2XjF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:39:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, muli@il.ibm.com, mm-commits@vger.kernel.org


The patch titled
     calgary: dma_ops as const
has been removed from the -mm tree.  Its filename was
     dma_ops-as-const.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: calgary: dma_ops as const
From: Stephen Hemminger <shemminger@linux-foundation.org>

The dma_ops structure can be const since it never changes after boot.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |    2 +-
 arch/x86_64/kernel/pci-gart.c    |    2 +-
 arch/x86_64/kernel/pci-nommu.c   |    2 +-
 arch/x86_64/kernel/pci-swiotlb.c |    2 +-
 arch/x86_64/mm/init.c            |    2 +-
 include/asm-x86_64/dma-mapping.h |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~dma_ops-as-const arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~dma_ops-as-const
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -507,7 +507,7 @@ error:
 	return ret;
 }
 
-static struct dma_mapping_ops calgary_dma_ops = {
+static const struct dma_mapping_ops calgary_dma_ops = {
 	.alloc_coherent = calgary_alloc_coherent,
 	.map_single = calgary_map_single,
 	.unmap_single = calgary_unmap_single,
diff -puN arch/x86_64/kernel/pci-gart.c~dma_ops-as-const arch/x86_64/kernel/pci-gart.c
--- a/arch/x86_64/kernel/pci-gart.c~dma_ops-as-const
+++ a/arch/x86_64/kernel/pci-gart.c
@@ -552,7 +552,7 @@ static __init int init_k8_gatt(struct ag
 
 extern int agp_amd64_init(void);
 
-static struct dma_mapping_ops gart_dma_ops = {
+static const struct dma_mapping_ops gart_dma_ops = {
 	.mapping_error = NULL,
 	.map_single = gart_map_single,
 	.map_simple = gart_map_simple,
diff -puN arch/x86_64/kernel/pci-nommu.c~dma_ops-as-const arch/x86_64/kernel/pci-nommu.c
--- a/arch/x86_64/kernel/pci-nommu.c~dma_ops-as-const
+++ a/arch/x86_64/kernel/pci-nommu.c
@@ -79,7 +79,7 @@ void nommu_unmap_sg(struct device *dev, 
 {
 }
 
-struct dma_mapping_ops nommu_dma_ops = {
+const struct dma_mapping_ops nommu_dma_ops = {
 	.map_single = nommu_map_single,
 	.unmap_single = nommu_unmap_single,
 	.map_sg = nommu_map_sg,
diff -puN arch/x86_64/kernel/pci-swiotlb.c~dma_ops-as-const arch/x86_64/kernel/pci-swiotlb.c
--- a/arch/x86_64/kernel/pci-swiotlb.c~dma_ops-as-const
+++ a/arch/x86_64/kernel/pci-swiotlb.c
@@ -12,7 +12,7 @@
 int swiotlb __read_mostly;
 EXPORT_SYMBOL(swiotlb);
 
-struct dma_mapping_ops swiotlb_dma_ops = {
+const struct dma_mapping_ops swiotlb_dma_ops = {
 	.mapping_error = swiotlb_dma_mapping_error,
 	.alloc_coherent = swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
diff -puN arch/x86_64/mm/init.c~dma_ops-as-const arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~dma_ops-as-const
+++ a/arch/x86_64/mm/init.c
@@ -46,7 +46,7 @@
 #define Dprintk(x...)
 #endif
 
-struct dma_mapping_ops* dma_ops;
+const struct dma_mapping_ops* dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static unsigned long dma_reserve __initdata;
diff -puN include/asm-x86_64/dma-mapping.h~dma_ops-as-const include/asm-x86_64/dma-mapping.h
--- a/include/asm-x86_64/dma-mapping.h~dma_ops-as-const
+++ a/include/asm-x86_64/dma-mapping.h
@@ -52,7 +52,7 @@ struct dma_mapping_ops {
 };
 
 extern dma_addr_t bad_dma_address;
-extern struct dma_mapping_ops* dma_ops;
+extern const struct dma_mapping_ops* dma_ops;
 extern int iommu_merge;
 
 static inline int dma_mapping_error(dma_addr_t dma_addr)
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

git-netdev-all.patch
git-net.patch
git-wireless.patch
