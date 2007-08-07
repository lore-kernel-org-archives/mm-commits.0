From: akpm@linux-foundation.org
Subject: - net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch removed from -mm tree
Date: Tue, 07 Aug 2007 15:46:12 -0700
Message-ID: <200708072246.l77MkCLZ008757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58484 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760761AbXHGWr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:47:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, ak@suse.de, apw@shadowen.org, clameter@sgi.com, davem@davemloft.net, greg@kroah.com, yinghai.lu@sun.com, mm-commits@vger.kernel.org


The patch titled
     net: use numa_node in net_devcice->dev instead of parent
has been removed from the -mm tree.  Its filename was
     net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch

This patch was dropped because finish-i386-and-x86-64-sysdata-conversion.patch might have destroyed it

------------------------------------------------------
Subject: net: use numa_node in net_devcice->dev instead of parent
From: "Yinghai Lu" <yhlu.kernel@gmail.com>

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Greg KH <greg@kroah.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/skbuff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/core/skbuff.c~net-use-numa_node-in-net_devcice-dev-instead-of-parent net/core/skbuff.c
--- a/net/core/skbuff.c~net-use-numa_node-in-net_devcice-dev-instead-of-parent
+++ a/net/core/skbuff.c
@@ -252,7 +252,7 @@ nodata:
 struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
 		unsigned int length, gfp_t gfp_mask)
 {
-	int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
+	int node = dev_to_node(&dev->dev);
 	struct sk_buff *skb;
 
 	skb = __alloc_skb(length + NET_SKB_PAD, gfp_mask, 0, node);
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

finish-i386-and-x86-64-sysdata-conversion.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86_64-store-core-id-bits-in-cpuinfo_x8.patch
x86_64-use-core-id-bits-for-apicid_to_node-initialization.patch
x86_64-remove-never-used-apic_mapped.patch
x86_64-get-boot_cpu_id-as-early-for-k8_scan_nodes.patch
