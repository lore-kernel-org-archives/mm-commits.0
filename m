From: akpm@linux-foundation.org
Subject: - sgi-xp-enable-xpnet-to-handle-more-than-64-partitions.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:16:50 -0700
Message-ID: <200807301916.m6UJGoUL011157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753508AbYG3TYK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:24:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, mm-commits@vger.kernel.org


The patch titled
     sgi-xp: enable XPNET to handle more than 64 partitions
has been removed from the -mm tree.  Its filename was
     sgi-xp-enable-xpnet-to-handle-more-than-64-partitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: enable XPNET to handle more than 64 partitions
From: Dean Nelson <dcn@sgi.com>

Enable XPNET to support more than 64 partitions.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-xp/xpnet.c |  213 +++++++++++++++-------------------
 1 file changed, 94 insertions(+), 119 deletions(-)

diff -puN drivers/misc/sgi-xp/xpnet.c~sgi-xp-enable-xpnet-to-handle-more-than-64-partitions drivers/misc/sgi-xp/xpnet.c
--- a/drivers/misc/sgi-xp/xpnet.c~sgi-xp-enable-xpnet-to-handle-more-than-64-partitions
+++ a/drivers/misc/sgi-xp/xpnet.c
@@ -21,7 +21,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
@@ -32,8 +31,6 @@
 #include <linux/mii.h>
 #include <linux/smp.h>
 #include <linux/string.h>
-#include <asm/sn/io.h>
-#include <asm/sn/sn_sal.h>
 #include <asm/atomic.h>
 #include "xp.h"
 
@@ -104,7 +101,6 @@ struct xpnet_message {
  * then be released.
  */
 struct xpnet_pending_msg {
-	struct list_head free_list;
 	struct sk_buff *skb;
 	atomic_t use_count;
 };
@@ -120,7 +116,7 @@ struct net_device *xpnet_device;
  * When we are notified of other partitions activating, we add them to
  * our bitmask of partitions to which we broadcast.
  */
-static u64 xpnet_broadcast_partitions;
+static unsigned long *xpnet_broadcast_partitions;
 /* protect above */
 static DEFINE_SPINLOCK(xpnet_broadcast_lock);
 
@@ -140,16 +136,13 @@ static DEFINE_SPINLOCK(xpnet_broadcast_l
 #define XPNET_DEF_MTU (0x8000UL)
 
 /*
- * The partition id is encapsulated in the MAC address.  The following
- * define locates the octet the partid is in.
+ * The partid is encapsulated in the MAC address beginning in the following
+ * octet and it consists of two octets.
  */
-#define XPNET_PARTID_OCTET	1
-#define XPNET_LICENSE_OCTET	2
+#define XPNET_PARTID_OCTET	2
+
+/* Define the XPNET debug device structures to be used with dev_dbg() et al */
 
-/*
- * Define the XPNET debug device structure that is to be used with dev_dbg(),
- * dev_err(), dev_warn(), and dev_info().
- */
 struct device_driver xpnet_dbg_name = {
 	.name = "xpnet"
 };
@@ -231,7 +224,7 @@ xpnet_receive(short partid, int channel,
 					  (void *)msg->buf_pa, msg->size);
 
 		ret = xp_remote_memcpy((void *)((u64)skb->data &
-				                ~(L1_CACHE_BYTES - 1)),
+						~(L1_CACHE_BYTES - 1)),
 				       (void *)msg->buf_pa, msg->size);
 
 		if (ret != xpSuccess) {
@@ -283,8 +276,6 @@ static void
 xpnet_connection_activity(enum xp_retval reason, short partid, int channel,
 			  void *data, void *key)
 {
-	long bp;
-
 	DBUG_ON(partid < 0 || partid >= xp_max_npartitions);
 	DBUG_ON(channel != XPC_NET_CHANNEL);
 
@@ -297,31 +288,28 @@ xpnet_connection_activity(enum xp_retval
 
 	case xpConnected:	/* connection completed to a partition */
 		spin_lock_bh(&xpnet_broadcast_lock);
-		xpnet_broadcast_partitions |= 1UL << (partid - 1);
-		bp = xpnet_broadcast_partitions;
+		__set_bit(partid, xpnet_broadcast_partitions);
 		spin_unlock_bh(&xpnet_broadcast_lock);
 
 		netif_carrier_on(xpnet_device);
 
-		dev_dbg(xpnet, "%s connection created to partition %d; "
-			"xpnet_broadcast_partitions=0x%lx\n",
-			xpnet_device->name, partid, bp);
+		dev_dbg(xpnet, "%s connected to partition %d\n",
+			xpnet_device->name, partid);
 		break;
 
 	default:
 		spin_lock_bh(&xpnet_broadcast_lock);
-		xpnet_broadcast_partitions &= ~(1UL << (partid - 1));
-		bp = xpnet_broadcast_partitions;
+		__clear_bit(partid, xpnet_broadcast_partitions);
 		spin_unlock_bh(&xpnet_broadcast_lock);
 
-		if (bp == 0)
+		if (bitmap_empty((unsigned long *)xpnet_broadcast_partitions,
+				 xp_max_npartitions)) {
 			netif_carrier_off(xpnet_device);
+		}
 
-		dev_dbg(xpnet, "%s disconnected from partition %d; "
-			"xpnet_broadcast_partitions=0x%lx\n",
-			xpnet_device->name, partid, bp);
+		dev_dbg(xpnet, "%s disconnected from partition %d\n",
+			xpnet_device->name, partid);
 		break;
-
 	}
 }
 
@@ -424,36 +412,72 @@ xpnet_send_completed(enum xp_retval reas
 	}
 }
 
+static void
+xpnet_send(struct sk_buff *skb, struct xpnet_pending_msg *queued_msg,
+	   u64 start_addr, u64 end_addr, u16 embedded_bytes, int dest_partid)
+{
+	u8 msg_buffer[XPNET_MSG_SIZE];
+	struct xpnet_message *msg = (struct xpnet_message *)&msg_buffer;
+	enum xp_retval ret;
+
+	msg->embedded_bytes = embedded_bytes;
+	if (unlikely(embedded_bytes != 0)) {
+		msg->version = XPNET_VERSION_EMBED;
+		dev_dbg(xpnet, "calling memcpy(0x%p, 0x%p, 0x%lx)\n",
+			&msg->data, skb->data, (size_t)embedded_bytes);
+		skb_copy_from_linear_data(skb, &msg->data,
+					  (size_t)embedded_bytes);
+	} else {
+		msg->version = XPNET_VERSION;
+	}
+	msg->magic = XPNET_MAGIC;
+	msg->size = end_addr - start_addr;
+	msg->leadin_ignore = (u64)skb->data - start_addr;
+	msg->tailout_ignore = end_addr - (u64)skb_tail_pointer(skb);
+	msg->buf_pa = __pa(start_addr);
+
+	dev_dbg(xpnet, "sending XPC message to %d:%d\n"
+		KERN_DEBUG "msg->buf_pa=0x%lx, msg->size=%u, "
+		"msg->leadin_ignore=%u, msg->tailout_ignore=%u\n",
+		dest_partid, XPC_NET_CHANNEL, msg->buf_pa, msg->size,
+		msg->leadin_ignore, msg->tailout_ignore);
+
+	atomic_inc(&queued_msg->use_count);
+
+	ret = xpc_send_notify(dest_partid, XPC_NET_CHANNEL, XPC_NOWAIT, msg,
+			      XPNET_MSG_SIZE, xpnet_send_completed, queued_msg);
+	if (unlikely(ret != xpSuccess))
+		atomic_dec(&queued_msg->use_count);
+}
+
 /*
  * Network layer has formatted a packet (skb) and is ready to place it
  * "on the wire".  Prepare and send an xpnet_message to all partitions
  * which have connected with us and are targets of this packet.
  *
  * MAC-NOTE:  For the XPNET driver, the MAC address contains the
- * destination partition_id.  If the destination partition id word
- * is 0xff, this packet is to broadcast to all partitions.
+ * destination partid.  If the destination partid octets are 0xffff,
+ * this packet is to be broadcast to all connected partitions.
  */
 static int
 xpnet_dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct xpnet_pending_msg *queued_msg;
-	enum xp_retval ret;
-	u8 msg_buffer[XPNET_MSG_SIZE];
-	struct xpnet_message *msg = (struct xpnet_message *)&msg_buffer[0];
 	u64 start_addr, end_addr;
-	long dp;
-	u8 second_mac_octet;
 	short dest_partid;
-	struct xpnet_dev_private *priv;
-	u16 embedded_bytes;
-
-	priv = (struct xpnet_dev_private *)dev->priv;
+	struct xpnet_dev_private *priv = (struct xpnet_dev_private *)dev->priv;
+	u16 embedded_bytes = 0;
 
 	dev_dbg(xpnet, ">skb->head=0x%p skb->data=0x%p skb->tail=0x%p "
 		"skb->end=0x%p skb->len=%d\n", (void *)skb->head,
 		(void *)skb->data, skb_tail_pointer(skb), skb_end_pointer(skb),
 		skb->len);
 
+	if (skb->data[0] == 0x33) {
+		dev_kfree_skb(skb);
+		return 0;	/* nothing needed to be done */
+	}
+
 	/*
 	 * The xpnet_pending_msg tracks how many outstanding
 	 * xpc_send_notifies are relying on this skb.  When none
@@ -465,7 +489,6 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 			 "packet\n", sizeof(struct xpnet_pending_msg));
 
 		priv->stats.tx_errors++;
-
 		return -ENOMEM;
 	}
 
@@ -474,7 +497,6 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 	end_addr = L1_CACHE_ALIGN((u64)skb_tail_pointer(skb));
 
 	/* calculate how many bytes to embed in the XPC message */
-	embedded_bytes = 0;
 	if (unlikely(skb->len <= XPNET_MSG_DATA_MAX)) {
 		/* skb->data does fit so embed */
 		embedded_bytes = skb->len;
@@ -490,78 +512,28 @@ xpnet_dev_hard_start_xmit(struct sk_buff
 	atomic_set(&queued_msg->use_count, 1);
 	queued_msg->skb = skb;
 
-	second_mac_octet = skb->data[XPNET_PARTID_OCTET];
-	if (second_mac_octet == 0xff) {
+	if (skb->data[0] == 0xff) {
 		/* we are being asked to broadcast to all partitions */
-		dp = xpnet_broadcast_partitions;
-	} else if (second_mac_octet != 0) {
-		dp = xpnet_broadcast_partitions &
-		    (1UL << (second_mac_octet - 1));
-	} else {
-		/* 0 is an invalid partid.  Ignore */
-		dp = 0;
-	}
-	dev_dbg(xpnet, "destination Partitions mask (dp) = 0x%lx\n", dp);
-
-	/*
-	 * If we wanted to allow promiscuous mode to work like an
-	 * unswitched network, this would be a good point to OR in a
-	 * mask of partitions which should be receiving all packets.
-	 */
-
-	/*
-	 * Main send loop.
-	 */
-	for (dest_partid = 0; dp && dest_partid < xp_max_npartitions;
-	     dest_partid++) {
+		for_each_bit(dest_partid, xpnet_broadcast_partitions,
+			     xp_max_npartitions) {
 
-		if (!(dp & (1UL << (dest_partid - 1)))) {
-			/* not destined for this partition */
-			continue;
+			xpnet_send(skb, queued_msg, start_addr, end_addr,
+				   embedded_bytes, dest_partid);
 		}
+	} else {
+		dest_partid = (short)skb->data[XPNET_PARTID_OCTET + 1];
+		dest_partid |= (short)skb->data[XPNET_PARTID_OCTET + 0] << 8;
 
-		/* remove this partition from the destinations mask */
-		dp &= ~(1UL << (dest_partid - 1));
-
-		/* found a partition to send to */
+		if (dest_partid >= 0 &&
+		    dest_partid < xp_max_npartitions &&
+		    test_bit(dest_partid, xpnet_broadcast_partitions) != 0) {
 
-		msg->embedded_bytes = embedded_bytes;
-		if (unlikely(embedded_bytes != 0)) {
-			msg->version = XPNET_VERSION_EMBED;
-			dev_dbg(xpnet, "calling memcpy(0x%p, 0x%p, 0x%lx)\n",
-				&msg->data, skb->data, (size_t)embedded_bytes);
-			skb_copy_from_linear_data(skb, &msg->data,
-						  (size_t)embedded_bytes);
-		} else {
-			msg->version = XPNET_VERSION;
-		}
-		msg->magic = XPNET_MAGIC;
-		msg->size = end_addr - start_addr;
-		msg->leadin_ignore = (u64)skb->data - start_addr;
-		msg->tailout_ignore = end_addr - (u64)skb_tail_pointer(skb);
-		msg->buf_pa = __pa(start_addr);
-
-		dev_dbg(xpnet, "sending XPC message to %d:%d\n"
-			KERN_DEBUG "msg->buf_pa=0x%lx, msg->size=%u, "
-			"msg->leadin_ignore=%u, msg->tailout_ignore=%u\n",
-			dest_partid, XPC_NET_CHANNEL, msg->buf_pa, msg->size,
-			msg->leadin_ignore, msg->tailout_ignore);
-
-		atomic_inc(&queued_msg->use_count);
-
-		ret = xpc_send_notify(dest_partid, XPC_NET_CHANNEL, XPC_NOWAIT,
-				      &msg, sizeof(msg) + embedded_bytes - 1,
-				      xpnet_send_completed, queued_msg);
-		if (unlikely(ret != xpSuccess)) {
-			atomic_dec(&queued_msg->use_count);
-			continue;
+			xpnet_send(skb, queued_msg, start_addr, end_addr,
+				   embedded_bytes, dest_partid);
 		}
 	}
 
 	if (atomic_dec_return(&queued_msg->use_count) == 0) {
-		dev_dbg(xpnet, "no partitions to receive packet destined for "
-			"%d\n", dest_partid);
-
 		dev_kfree_skb(skb);
 		kfree(queued_msg);
 	}
@@ -589,23 +561,28 @@ xpnet_dev_tx_timeout(struct net_device *
 static int __init
 xpnet_init(void)
 {
-	int i;
-	u32 license_num;
-	int result = -ENOMEM;
+	int result;
 
-	if (!ia64_platform_is("sn2"))
+	if (!is_shub() && !is_uv())
 		return -ENODEV;
 
 	dev_info(xpnet, "registering network device %s\n", XPNET_DEVICE_NAME);
 
+	xpnet_broadcast_partitions = kzalloc(BITS_TO_LONGS(xp_max_npartitions) *
+					     sizeof(long), GFP_KERNEL);
+	if (xpnet_broadcast_partitions == NULL)
+		return -ENOMEM;
+
 	/*
 	 * use ether_setup() to init the majority of our device
 	 * structure and then override the necessary pieces.
 	 */
 	xpnet_device = alloc_netdev(sizeof(struct xpnet_dev_private),
 				    XPNET_DEVICE_NAME, ether_setup);
-	if (xpnet_device == NULL)
+	if (xpnet_device == NULL) {
+		kfree(xpnet_broadcast_partitions);
 		return -ENOMEM;
+	}
 
 	netif_carrier_off(xpnet_device);
 
@@ -623,14 +600,10 @@ xpnet_init(void)
 	 * MAC addresses.  We chose the first octet of the MAC to be unlikely
 	 * to collide with any vendor's officially issued MAC.
 	 */
-	xpnet_device->dev_addr[0] = 0xfe;
-	xpnet_device->dev_addr[XPNET_PARTID_OCTET] = sn_partition_id;
-	license_num = sn_partition_serial_number_val();
-	for (i = 3; i >= 0; i--) {
-		xpnet_device->dev_addr[XPNET_LICENSE_OCTET + i] =
-		    license_num & 0xff;
-		license_num = license_num >> 8;
-	}
+	xpnet_device->dev_addr[0] = 0x02;     /* locally administered, no OUI */
+
+	xpnet_device->dev_addr[XPNET_PARTID_OCTET + 1] = sn_partition_id;
+	xpnet_device->dev_addr[XPNET_PARTID_OCTET + 0] = (sn_partition_id >> 8);
 
 	/*
 	 * ether_setup() sets this to a multicast device.  We are
@@ -646,8 +619,10 @@ xpnet_init(void)
 	xpnet_device->features = NETIF_F_NO_CSUM;
 
 	result = register_netdev(xpnet_device);
-	if (result != 0)
+	if (result != 0) {
 		free_netdev(xpnet_device);
+		kfree(xpnet_broadcast_partitions);
+	}
 
 	return result;
 }
@@ -661,8 +636,8 @@ xpnet_exit(void)
 		 xpnet_device[0].name);
 
 	unregister_netdev(xpnet_device);
