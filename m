From: akpm@linux-foundation.org
Subject: + dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch added to -mm tree
Date: Tue, 07 Aug 2007 19:29:31 -0700
Message-ID: <200708080229.l782TVLO016689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44511 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757612AbXHHCaT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 22:30:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, apw@shadowen.org, clameter@sgi.com, jeff@garzik.org, yinghai.lu@Sun.COM


The patch titled
     dma: use dev_to_node to get node for device in dma_alloc_pages
has been added to the -mm tree.  Its filename is
     dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

x86_64-remove-sync_arb_ids.patch
x86_64-clear-io_apic-before-enabing-apic-error-vector.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
