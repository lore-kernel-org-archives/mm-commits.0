From: akpm@linux-foundation.org
Subject: + x86_64-calgary-change-_map_single-etc-to-static.patch added to -mm tree
Date: Wed, 11 Jul 2007 17:42:58 -0700
Message-ID: <200707120042.l6C0gwul030796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51197 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934348AbXGLAnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 20:43:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai.lu@sun.com, ak@suse.de, muli@il.ibm.com


The patch titled
     x86_64: Calgary - change _map_single, etc to static
has been added to the -mm tree.  Its filename is
     x86_64-calgary-change-_map_single-etc-to-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: Calgary - change _map_single, etc to static
From: Yinghai Lu <yinghai.lu@sun.com>

there function are called via dma_ops->.., so change them to static

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86_64-calgary-change-_map_single-etc-to-static arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86_64-calgary-change-_map_single-etc-to-static
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -417,7 +417,7 @@ static int calgary_nontranslate_map_sg(s
 	return nelems;
 }
 
-int calgary_map_sg(struct device *dev, struct scatterlist *sg,
+static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	int nelems, int direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
@@ -462,7 +462,7 @@ error:
 	return 0;
 }
 
-dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
+static dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
 	size_t size, int direction)
 {
 	dma_addr_t dma_handle = bad_dma_address;
@@ -481,7 +481,7 @@ dma_addr_t calgary_map_single(struct dev
 	return dma_handle;
 }
 
-void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
+static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
 	size_t size, int direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
@@ -494,7 +494,7 @@ void calgary_unmap_single(struct device 
 	iommu_free(tbl, dma_handle, npages);
 }
 
-void* calgary_alloc_coherent(struct device *dev, size_t size,
+static void* calgary_alloc_coherent(struct device *dev, size_t size,
 	dma_addr_t *dma_handle, gfp_t flag)
 {
 	void *ret = NULL;
_

Patches currently in -mm which might be from yinghai.lu@sun.com are

serial-assert-dtr-for-serial-console-devices.patch
usb-make-the-usb_device-numa_node-to-get-assigned-from.patch
x86_64-calgary-change-_map_single-etc-to-static.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch
x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
x86_64-get-mp_bus_to_node-as-early.patch
console-more-buf-for-index-parsing.patch
console-console-handover-to-preferred-console.patch
x86-initial-fixmap-support.patch
serial-convert-early_uart-to-earlycon-for-8250.patch
dma-make-dma-pool-to-use-kmalloc_node.patch
