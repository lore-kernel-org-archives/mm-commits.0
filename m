From: akpm@linux-foundation.org
Subject: - net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch removed from -mm tree
Date: Wed, 26 Sep 2007 22:54:04 -0700
Message-ID: <200709270600.l8R6011l022388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51265 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365AbXI0GAw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 02:00:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, ak@suse.de, apw@shadowen.org, clameter@sgi.com, davem@davemloft.net, jeff@garzik.org, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     net: use numa_node in net_device->dev instead of parent
has been removed from the -mm tree.  Its filename was
     net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: net: use numa_node in net_device->dev instead of parent
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <ak@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/skbuff.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/core/skbuff.c~net-use-numa_node-in-net_devcice-dev-instead-of-parent net/core/skbuff.c
--- a/net/core/skbuff.c~net-use-numa_node-in-net_devcice-dev-instead-of-parent
+++ a/net/core/skbuff.c
@@ -217,7 +217,7 @@ nodata:
 struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
 		unsigned int length, gfp_t gfp_mask)
 {
-	int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
+	int node = dev_to_node(&dev->dev);
 	struct sk_buff *skb;
 
 	skb = __alloc_skb(length + NET_SKB_PAD, gfp_mask, 0, node);
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
serial-keep-the-dtr-setting-for-serial-console.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-make-io-apic-not-connected-pin-print-complete.patch
x86-use-num_online_nodes-to-get-physical-cpus-numbers-for.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
