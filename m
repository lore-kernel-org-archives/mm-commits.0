From: akpm@linux-foundation.org
Subject: - dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch removed from -mm tree
Date: Tue, 07 Aug 2007 15:46:25 -0700
Message-ID: <200708072246.l77MkPaP008763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44035 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935197AbXHGWrl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:47:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, ak@suse.de, apw@shadowen.org, clameter@sgi.com, greg@kroah.com, yinghai.lu@sun.com, mm-commits@vger.kernel.org


The patch titled
     dma: use dev_to_node to get node for device in dma_alloc_pages
has been removed from the -mm tree.  Its filename was
     dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch

This patch was dropped because finish-i386-and-x86-64-sysdata-conversion.patch might have destroyed it

------------------------------------------------------
Subject: dma: use dev_to_node to get node for device in dma_alloc_pages
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-dma.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN arch/x86_64/kernel/pci-dma.c~dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages arch/x86_64/kernel/pci-dma.c
--- a/arch/x86_64/kernel/pci-dma.c~dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages
+++ a/arch/x86_64/kernel/pci-dma.c
@@ -51,11 +51,9 @@ dma_alloc_pages(struct device *dev, gfp_
 {
 	struct page *page;
 	int node;
-#ifdef CONFIG_PCI
-	if (dev->bus == &pci_bus_type)
-		node = pcibus_to_node(to_pci_dev(dev)->bus);
-	else
-#endif
+
+	node = dev_to_node(dev);
+	if (node == -1)
 		node = numa_node_id();
 
 	if (node < first_node(node_online_map))
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

finish-i386-and-x86-64-sysdata-conversion.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86_64-store-core-id-bits-in-cpuinfo_x8.patch
x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch
x86_64-remove-never-used-apic_mapped.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
