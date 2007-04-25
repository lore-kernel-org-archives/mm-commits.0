From: akpm@linux-foundation.org
Subject: - fix-sparse-errors-in-drivers-net-ibmvethc.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:39:30 -0700
Message-ID: <200704252039.l3PKdU9w012312@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993182AbXDYU6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:58:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@ellerman.id.au, santil@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Fix sparse errors in drivers/net/ibmveth.c
has been removed from the -mm tree.  Its filename was
     fix-sparse-errors-in-drivers-net-ibmvethc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix sparse errors in drivers/net/ibmveth.c
From: Michael Ellerman <michael@ellerman.id.au>

drivers/net/ibmveth.c:96:46: error: marked inline, but without a definition
drivers/net/ibmveth.c:96: warning: 'ibmveth_rxq_harvest_buffer' declared inline after being called
drivers/net/ibmveth.c:96: warning: previous declaration of 'ibmveth_rxq_harvest_buffer' was here

Just let the compiler decide, as it happens gcc 4.~ inlines it anyway.

drivers/net/ibmveth.c:957:71: warning: Using plain integer as NULL pointer
drivers/net/ibmveth.c:964:85: warning: Using plain integer as NULL pointer

Split the long lines as well, ugly, but < 80 columns.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Cc:  Santiago Leon <santil@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ibmveth.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/net/ibmveth.c~fix-sparse-errors-in-drivers-net-ibmvethc drivers/net/ibmveth.c
--- a/drivers/net/ibmveth.c~fix-sparse-errors-in-drivers-net-ibmvethc
+++ a/drivers/net/ibmveth.c
@@ -93,7 +93,7 @@ static void ibmveth_proc_unregister_driv
 static void ibmveth_proc_register_adapter(struct ibmveth_adapter *adapter);
 static void ibmveth_proc_unregister_adapter(struct ibmveth_adapter *adapter);
 static irqreturn_t ibmveth_interrupt(int irq, void *dev_instance);
-static inline void ibmveth_rxq_harvest_buffer(struct ibmveth_adapter *adapter);
+static void ibmveth_rxq_harvest_buffer(struct ibmveth_adapter *adapter);
 static struct kobj_type ktype_veth_pool;
 
 #ifdef CONFIG_PROC_FS
@@ -389,7 +389,7 @@ static void ibmveth_rxq_recycle_buffer(s
 	}
 }
 
-static inline void ibmveth_rxq_harvest_buffer(struct ibmveth_adapter *adapter)
+static void ibmveth_rxq_harvest_buffer(struct ibmveth_adapter *adapter)
 {
 	ibmveth_remove_buffer_from_pool(adapter, adapter->rx_queue.queue_addr[adapter->rx_queue.index].correlator);
 
@@ -954,14 +954,16 @@ static int __devinit ibmveth_probe(struc
 	ibmveth_debug_printk_no_adapter("entering ibmveth_probe for UA 0x%x\n",
 					dev->unit_address);
 
-	mac_addr_p = (unsigned char *) vio_get_attribute(dev, VETH_MAC_ADDR, 0);
+	mac_addr_p = (unsigned char *) vio_get_attribute(dev,
+						VETH_MAC_ADDR, NULL);
 	if(!mac_addr_p) {
 		printk(KERN_ERR "(%s:%3.3d) ERROR: Can't find VETH_MAC_ADDR "
 				"attribute\n", __FILE__, __LINE__);
 		return 0;
 	}
 
-	mcastFilterSize_p= (unsigned int *) vio_get_attribute(dev, VETH_MCAST_FILTER_SIZE, 0);
+	mcastFilterSize_p = (unsigned int *) vio_get_attribute(dev,
+						VETH_MCAST_FILTER_SIZE, NULL);
 	if(!mcastFilterSize_p) {
 		printk(KERN_ERR "(%s:%3.3d) ERROR: Can't find "
 				"VETH_MCAST_FILTER_SIZE attribute\n",
_

Patches currently in -mm which might be from michael@ellerman.id.au are

git-powerpc.patch
powerpc-rtas-msi-support.patch
git-netdev-all.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation-fix.patch
