From: akpm@linux-foundation.org
Subject: - dma-make-dma-pool-to-use-kmalloc_node.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:58:47 -0700
Message-ID: <200707162058.l6GKwliZ002367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49830 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763719AbXGPVbX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:31:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, clameter@sgi.com, greg@kroah.com, rientjes@google.com, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     dma: make dma pool to use kmalloc_node
has been removed from the -mm tree.  Its filename was
     dma-make-dma-pool-to-use-kmalloc_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dma: make dma pool to use kmalloc_node
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Using dev_to_node(&dev->dev) to get node, and kmalloc_node to dma buffer on
corresponding node dma pool

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/dmapool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/dmapool.c~dma-make-dma-pool-to-use-kmalloc_node drivers/base/dmapool.c
--- a/drivers/base/dmapool.c~dma-make-dma-pool-to-use-kmalloc_node
+++ a/drivers/base/dmapool.c
@@ -127,7 +127,7 @@ dma_pool_create (const char *name, struc
 	} else if (allocation < size)
 		return NULL;
 
-	if (!(retval = kmalloc (sizeof *retval, GFP_KERNEL)))
+	if (!(retval = kmalloc_node (sizeof *retval, GFP_KERNEL, dev_to_node(dev))))
 		return retval;
 
 	strlcpy (retval->name, name, sizeof retval->name);
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
x86-64-disable-the-gart-in-shutdown.patch
x86_84-move-iommu-declaration-from-proto-to-iommuh.patch
x86_64-change-_map_single-to-static-in-pci_gartc-etc.patch
x86_64-geode-hw-random-number-generator-depend-on-x86_3.patch
x86_64-get-mp_bus_to_node-as-early.patch
