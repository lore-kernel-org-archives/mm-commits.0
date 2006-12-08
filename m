From: akpm@osdl.org
Subject: - e1000-account-for-net_ip_align-when-calculating-bufsiz.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:04:39 -0800
Message-ID: <200612081104.kB8B4d4I018574@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48818 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425377AbWLHLFz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:05:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: auke-jan.h.kok@intel.com, jeff@garzik.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     e1000: account for NET_IP_ALIGN when calculating bufsiz
has been removed from the -mm tree.  Its filename was
     e1000-account-for-net_ip_align-when-calculating-bufsiz.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: e1000: account for NET_IP_ALIGN when calculating bufsiz
From: Auke Kok <auke-jan.h.kok@intel.com>

Account for NET_IP_ALIGN when requesting buffer sizes from netdev_alloc_skb
to reduce slab allocation by half.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/net/e1000/e1000_main.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN drivers/net/e1000/e1000_main.c~e1000-account-for-net_ip_align-when-calculating-bufsiz drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000-account-for-net_ip_align-when-calculating-bufsiz
+++ a/drivers/net/e1000/e1000_main.c
@@ -1101,7 +1101,7 @@ e1000_sw_init(struct e1000_adapter *adap
 
 	pci_read_config_word(pdev, PCI_COMMAND, &hw->pci_cmd_word);
 
-	adapter->rx_buffer_len = MAXIMUM_ETHERNET_VLAN_SIZE;
+	adapter->rx_buffer_len = MAXIMUM_ETHERNET_VLAN_SIZE + NET_IP_ALIGN;
 	adapter->rx_ps_bsize0 = E1000_RXBUFFER_128;
 	hw->max_frame_size = netdev->mtu +
 			     ENET_HEADER_SIZE + ETHERNET_FCS_SIZE;
@@ -3163,26 +3163,27 @@ e1000_change_mtu(struct net_device *netd
 	 * larger slab size
 	 * i.e. RXBUFFER_2048 --> size-4096 slab */
 
-	if (max_frame <= E1000_RXBUFFER_256)
+	if (max_frame + NET_IP_ALIGN <= E1000_RXBUFFER_256)
 		adapter->rx_buffer_len = E1000_RXBUFFER_256;
-	else if (max_frame <= E1000_RXBUFFER_512)
+	else if (max_frame + NET_IP_ALIGN <= E1000_RXBUFFER_512)
 		adapter->rx_buffer_len = E1000_RXBUFFER_512;
-	else if (max_frame <= E1000_RXBUFFER_1024)
+	else if (max_frame + NET_IP_ALIGN <= E1000_RXBUFFER_1024)
 		adapter->rx_buffer_len = E1000_RXBUFFER_1024;
-	else if (max_frame <= E1000_RXBUFFER_2048)
+	else if (max_frame + NET_IP_ALIGN <= E1000_RXBUFFER_2048)
 		adapter->rx_buffer_len = E1000_RXBUFFER_2048;
-	else if (max_frame <= E1000_RXBUFFER_4096)
+	else if (max_frame + NET_IP_ALIGN <= E1000_RXBUFFER_4096)
 		adapter->rx_buffer_len = E1000_RXBUFFER_4096;
-	else if (max_frame <= E1000_RXBUFFER_8192)
+	else if (max_frame + NET_IP_ALIGN <= E1000_RXBUFFER_8192)
 		adapter->rx_buffer_len = E1000_RXBUFFER_8192;
-	else if (max_frame <= E1000_RXBUFFER_16384)
+	else
 		adapter->rx_buffer_len = E1000_RXBUFFER_16384;
 
 	/* adjust allocation if LPE protects us, and we aren't using SBP */
 	if (!adapter->hw.tbi_compatibility_on &&
 	    ((max_frame == MAXIMUM_ETHERNET_FRAME_SIZE) ||
 	     (max_frame == MAXIMUM_ETHERNET_VLAN_SIZE)))
-		adapter->rx_buffer_len = MAXIMUM_ETHERNET_VLAN_SIZE;
+		adapter->rx_buffer_len = MAXIMUM_ETHERNET_VLAN_SIZE +
+					NET_IP_ALIGN;
 
 	netdev->mtu = new_mtu;
 
@@ -4002,7 +4003,8 @@ e1000_alloc_rx_buffers(struct e1000_adap
 	struct e1000_buffer *buffer_info;
 	struct sk_buff *skb;
 	unsigned int i;
-	unsigned int bufsz = adapter->rx_buffer_len + NET_IP_ALIGN;
+	/* we have already accounted for NET_IP_ALIGN */
+	unsigned int bufsz = adapter->rx_buffer_len;
 
 	i = rx_ring->next_to_use;
 	buffer_info = &rx_ring->buffer_info[i];
_

Patches currently in -mm which might be from auke-jan.h.kok@intel.com are

origin.patch
implement-flush_work.patch
e1000-use-flush_keventd_work.patch
e1000_7033_dump_ring.patch
e1000-printk-warning-fixes.patch

