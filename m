From: akpm@linux-foundation.org
Subject: - dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:07:40 -0700
Message-ID: <200710180707.l9I77enM031718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40147 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759863AbXJRHIa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:08:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, apw@shadowen.org, clameter@sgi.com, jeff@garzik.org, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     dma: use dev_to_node to get node for device in dma_alloc_pages
has been removed from the -mm tree.  Its filename was
     dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dma: use dev_to_node to get node for device in dma_alloc_pages
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-dma.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN arch/x86_64/kernel/pci-dma.c~dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages arch/x86_64/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma_64.c~dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages
+++ a/arch/x86/kernel/pci-dma_64.c
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

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is.patch
kernel-printkc-concerns-about-the-console-handover.patch
