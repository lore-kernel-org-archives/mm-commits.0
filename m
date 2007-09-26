From: akpm@linux-foundation.org
Subject: + uml-network-driver-mtu-cleanups.patch added to -mm tree
Date: Wed, 26 Sep 2007 15:11:22 -0700
Message-ID: <200709262211.l8QMBMvw006553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762880AbXIZWLa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 18:11:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: network driver MTU cleanups
has been added to the -mm tree.  Its filename is
     uml-network-driver-mtu-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: network driver MTU cleanups
From: Jeff Dike <jdike@addtoit.com>

A bunch of MTU-related cleanups in the network code.

First, there is the addition of the notion of a maximally-sized packet, which
is the MTU plus headers.  This is used to size the skb that will receive a
packet.  This allows ether_adjust_skb to go away, as it was used to resize the
skb after it was allocated.

Since the skb passed into the low-level read routine is no longer resized, and
possibly reallocated, there, they (and the write routines) don't need to get
an sk_buff **.  They just need the sk_buff * now.  The callers of
ether_adjust_skb still need to do the skb_put, so that's now inlined.

The MAX_PACKET definitions in most of the drivers are gone.

The set_mtu methods were all the same and did nothing, so they can be
removed.

The ethertap driver had a typo which doubled the size of the packet rather
than adding two bytes to it.  It also wasn't defining its setup_size, causing
a zero-byte kmalloc and crash when the invalid pointer returned from kmalloc
was dereferenced.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/um/drivers/daemon_kern.c~uml-network-driver-mtu-cleanups arch/um/drivers/daemon_kern.c
--- a/arch/um/drivers/daemon_kern.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/drivers/daemon_kern.c
@@ -39,20 +39,15 @@ static void daemon_init(struct net_devic
 	printk("\n");
 }
 
-static int daemon_read(int fd, struct sk_buff **skb,
-		       struct uml_net_private *lp)
+static int daemon_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
-	*skb = ether_adjust_skb(*skb, ETH_HEADER_OTHER);
-	if (*skb == NULL)
-		return -ENOMEM;
-	return net_recvfrom(fd, skb_mac_header(*skb),
-			    (*skb)->dev->mtu + ETH_HEADER_OTHER);
+	return net_recvfrom(fd, skb_mac_header(skb),
+			    skb->dev->mtu + ETH_HEADER_OTHER);
 }
 
-static int daemon_write(int fd, struct sk_buff **skb,
-			struct uml_net_private *lp)
+static int daemon_write(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
-	return daemon_user_write(fd, (*skb)->data, (*skb)->len,
+	return daemon_user_write(fd, skb->data, skb->len,
 				 (struct daemon_data *) &lp->user);
 }
 
diff -puN arch/um/drivers/daemon_user.c~uml-network-driver-mtu-cleanups arch/um/drivers/daemon_user.c
--- a/arch/um/drivers/daemon_user.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/drivers/daemon_user.c
@@ -19,8 +19,6 @@
 #include "um_malloc.h"
 #include "user.h"
 
-#define MAX_PACKET (ETH_MAX_PACKET + ETH_HEADER_OTHER)
-
 enum request_type { REQ_NEW_CONTROL };
 
 #define SWITCH_MAGIC 0xfeedface
@@ -184,18 +182,13 @@ int daemon_user_write(int fd, void *buf,
 	return net_sendto(fd, buf, len, data_addr, sizeof(*data_addr));
 }
 
-static int daemon_set_mtu(int mtu, void *data)
-{
-	return mtu;
-}
-
 const struct net_user_info daemon_user_info = {
 	.init		= daemon_user_init,
 	.open		= daemon_open,
 	.close	 	= NULL,
 	.remove	 	= daemon_remove,
-	.set_mtu	= daemon_set_mtu,
 	.add_address	= NULL,
 	.delete_address = NULL,
-	.max_packet	= MAX_PACKET - ETH_HEADER_OTHER
+	.mtu		= ETH_MAX_PACKET,
+	.max_packet	= ETH_MAX_PACKET + ETH_HEADER_OTHER,
 };
diff -puN arch/um/drivers/mcast_kern.c~uml-network-driver-mtu-cleanups arch/um/drivers/mcast_kern.c
--- a/arch/um/drivers/mcast_kern.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/drivers/mcast_kern.c
@@ -39,18 +39,15 @@ static void mcast_init(struct net_device
 	       dpri->addr, dpri->port, dpri->ttl);
 }
 
-static int mcast_read(int fd, struct sk_buff **skb, struct uml_net_private *lp)
+static int mcast_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
-	*skb = ether_adjust_skb(*skb, ETH_HEADER_OTHER);
-	if (*skb == NULL)
-		return -ENOMEM;
-	return net_recvfrom(fd, skb_mac_header(*skb),
-			    (*skb)->dev->mtu + ETH_HEADER_OTHER);
+	return net_recvfrom(fd, skb_mac_header(skb),
+			    skb->dev->mtu + ETH_HEADER_OTHER);
 }
 
-static int mcast_write(int fd, struct sk_buff **skb, struct uml_net_private *lp)
+static int mcast_write(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
-	return mcast_user_write(fd, (*skb)->data, (*skb)->len,
+	return mcast_user_write(fd, skb->data, skb->len,
 				(struct mcast_data *) &lp->user);
 }
 
diff -puN arch/um/drivers/mcast_user.c~uml-network-driver-mtu-cleanups arch/um/drivers/mcast_user.c
--- a/arch/um/drivers/mcast_user.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/drivers/mcast_user.c
@@ -20,8 +20,6 @@
 #include "um_malloc.h"
 #include "user.h"
 
-#define MAX_PACKET (ETH_MAX_PACKET + ETH_HEADER_OTHER)
-
 static struct sockaddr_in *new_addr(char *addr, unsigned short port)
 {
 	struct sockaddr_in *sin;
@@ -154,18 +152,13 @@ int mcast_user_write(int fd, void *buf, 
 	return net_sendto(fd, buf, len, data_addr, sizeof(*data_addr));
 }
 
-static int mcast_set_mtu(int mtu, void *data)
-{
-	return mtu;
-}
-
 const struct net_user_info mcast_user_info = {
 	.init		= mcast_user_init,
 	.open		= mcast_open,
 	.close	 	= mcast_close,
 	.remove	 	= mcast_remove,
-	.set_mtu	= mcast_set_mtu,
 	.add_address	= NULL,
 	.delete_address = NULL,
-	.max_packet	= MAX_PACKET - ETH_HEADER_OTHER
+	.mtu		= ETH_MAX_PACKET,
+	.max_packet	= ETH_MAX_PACKET + ETH_HEADER_OTHER,
 };
diff -puN arch/um/drivers/net_kern.c~uml-network-driver-mtu-cleanups arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/drivers/net_kern.c
@@ -41,16 +41,16 @@ static int uml_net_rx(struct net_device 
 	struct sk_buff *skb;
 
 	/* If we can't allocate memory, try again next round. */
-	skb = dev_alloc_skb(dev->mtu);
+	skb = dev_alloc_skb(lp->max_packet);
 	if (skb == NULL) {
 		lp->stats.rx_dropped++;
 		return 0;
 	}
 
 	skb->dev = dev;
-	skb_put(skb, dev->mtu);
+	skb_put(skb, lp->max_packet);
 	skb_reset_mac_header(skb);
-	pkt_len = (*lp->read)(lp->fd, &skb, lp);
+	pkt_len = (*lp->read)(lp->fd, skb, lp);
 
 	if (pkt_len > 0) {
 		skb_trim(skb, pkt_len);
@@ -178,7 +178,7 @@ static int uml_net_start_xmit(struct sk_
 
 	spin_lock_irqsave(&lp->lock, flags);
 
-	len = (*lp->write)(lp->fd, &skb, lp);
+	len = (*lp->write)(lp->fd, skb, lp);
 
 	if (len == skb->len) {
 		lp->stats.tx_packets++;
@@ -240,22 +240,9 @@ static int uml_net_set_mac(struct net_de
 
 static int uml_net_change_mtu(struct net_device *dev, int new_mtu)
 {
-	struct uml_net_private *lp = dev->priv;
-	int err = 0;
-
-	spin_lock_irq(&lp->lock);
-
-	new_mtu = (*lp->set_mtu)(new_mtu, &lp->user);
-	if (new_mtu < 0) {
-		err = new_mtu;
-		goto out;
-	}
-
 	dev->mtu = new_mtu;
 
- out:
-	spin_unlock_irq(&lp->lock);
-	return err;
+	return 0;
 }
 
 static void uml_net_get_drvinfo(struct net_device *dev,
@@ -427,6 +414,7 @@ static void eth_configure(int n, void *i
 		  .dev 			= dev,
 		  .fd 			= -1,
 		  .mac 			= { 0xfe, 0xfd, 0x0, 0x0, 0x0, 0x0},
+		  .max_packet		= transport->user->max_packet,
 		  .protocol 		= transport->kern->protocol,
 		  .open 		= transport->user->open,
 		  .close 		= transport->user->close,
@@ -434,8 +422,7 @@ static void eth_configure(int n, void *i
 		  .read 		= transport->kern->read,
 		  .write 		= transport->kern->write,
 		  .add_address 		= transport->user->add_address,
-		  .delete_address  	= transport->user->delete_address,
-		  .set_mtu 		= transport->user->set_mtu });
+		  .delete_address  	= transport->user->delete_address });
 
 	init_timer(&lp->tl);
 	spin_lock_init(&lp->lock);
@@ -447,7 +434,7 @@ static void eth_configure(int n, void *i
 		goto out_unregister;
 
 	set_ether_mac(dev, device->mac);
-	dev->mtu = transport->user->max_packet;
+	dev->mtu = transport->user->mtu;
 	dev->open = uml_net_open;
 	dev->hard_start_xmit = uml_net_start_xmit;
 	dev->stop = uml_net_close;
@@ -807,19 +794,6 @@ static void close_devices(void)
 
 __uml_exitcall(close_devices);
 
-struct sk_buff *ether_adjust_skb(struct sk_buff *skb, int extra)
-{
-	if ((skb != NULL) && (skb_tailroom(skb) < extra)) {
-	  	struct sk_buff *skb2;
-
-		skb2 = skb_copy_expand(skb, 0, extra, GFP_ATOMIC);
-		dev_kfree_skb(skb);
-		skb = skb2;
-	}
-	if (skb != NULL) skb_put(skb, extra);
-	return skb;
-}
-
 void iter_addresses(void *d, void (*cb)(unsigned char *, unsigned char *,
 					void *),
 		    void *arg)
diff -puN arch/um/drivers/pcap_kern.c~uml-network-driver-mtu-cleanups arch/um/drivers/pcap_kern.c
--- a/arch/um/drivers/pcap_kern.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/drivers/pcap_kern.c
@@ -31,19 +31,14 @@ void pcap_init(struct net_device *dev, v
 	printk("pcap backend, host interface %s\n", ppri->host_if);
 }
 
-static int pcap_read(int fd, struct sk_buff **skb,
-		       struct uml_net_private *lp)
+static int pcap_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
-	*skb = ether_adjust_skb(*skb, ETH_HEADER_OTHER);
-	if (*skb == NULL)
-		return -ENOMEM;
-
-	return pcap_user_read(fd, skb_mac_header(*skb),
-			      (*skb)->dev->mtu + ETH_HEADER_OTHER,
+	return pcap_user_read(fd, skb_mac_header(skb),
+			      skb->dev->mtu + ETH_HEADER_OTHER,
 			      (struct pcap_data *) &lp->user);
 }
 
-static int pcap_write(int fd, struct sk_buff **skb, struct uml_net_private *lp)
+static int pcap_write(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
 	return -EPERM;
 }
diff -puN arch/um/drivers/pcap_user.c~uml-network-driver-mtu-cleanups arch/um/drivers/pcap_user.c
--- a/arch/um/drivers/pcap_user.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/drivers/pcap_user.c
@@ -13,8 +13,6 @@
 #include "um_malloc.h"
 #include "user.h"
 
-#define MAX_PACKET (ETH_MAX_PACKET + ETH_HEADER_OTHER)
-
 #define PCAP_FD(p) (*(int *)(p))
 
 static int pcap_user_init(void *data, void *dev)
@@ -23,7 +21,8 @@ static int pcap_user_init(void *data, vo
 	pcap_t *p;
 	char errors[PCAP_ERRBUF_SIZE];
 
-	p = pcap_open_live(pri->host_if, MAX_PACKET, pri->promisc, 0, errors);
+	p = pcap_open_live(pri->host_if, ETH_MAX_PACKET + ETH_HEADER_OTHER,
+			   pri->promisc, 0, errors);
 	if (p == NULL) {
 		printk(UM_KERN_ERR "pcap_user_init : pcap_open_live failed - "
 		       "'%s'\n", errors);
@@ -133,8 +132,8 @@ const struct net_user_info pcap_user_inf
 	.open		= pcap_open,
 	.close	 	= NULL,
 	.remove	 	= pcap_remove,
-	.set_mtu	= NULL,
 	.add_address	= NULL,
 	.delete_address = NULL,
-	.max_packet	= MAX_PACKET - ETH_HEADER_OTHER
+	.mtu		= ETH_MAX_PACKET,
+	.max_packet	= ETH_MAX_PACKET + ETH_HEADER_OTHER,
 };
diff -puN arch/um/drivers/slip_kern.c~uml-network-driver-mtu-cleanups arch/um/drivers/slip_kern.c
--- a/arch/um/drivers/slip_kern.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/drivers/slip_kern.c
@@ -47,17 +47,15 @@ static unsigned short slip_protocol(stru
 	return htons(ETH_P_IP);
 }
 
-static int slip_read(int fd, struct sk_buff **skb,
-		       struct uml_net_private *lp)
+static int slip_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
-	return slip_user_read(fd, skb_mac_header(*skb), (*skb)->dev->mtu,
+	return slip_user_read(fd, skb_mac_header(skb), skb->dev->mtu,
 			      (struct slip_data *) &lp->user);
 }
 
-static int slip_write(int fd, struct sk_buff **skb,
-		      struct uml_net_private *lp)
+static int slip_write(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
-	return slip_user_write(fd, (*skb)->data, (*skb)->len,
+	return slip_user_write(fd, skb->data, skb->len,
 			       (struct slip_data *) &lp->user);
 }
 
diff -puN arch/um/drivers/slip_user.c~uml-network-driver-mtu-cleanups arch/um/drivers/slip_user.c
--- a/arch/um/drivers/slip_user.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/drivers/slip_user.c
@@ -230,11 +230,6 @@ int slip_user_write(int fd, void *buf, i
 	return slip_proto_write(fd, buf, len, &pri->slip);
 }
 
-static int slip_set_mtu(int mtu, void *data)
-{
-	return mtu;
-}
-
 static void slip_add_addr(unsigned char *addr, unsigned char *netmask,
 			  void *data)
 {
@@ -260,8 +255,8 @@ const struct net_user_info slip_user_inf
 	.open		= slip_open,
 	.close	 	= slip_close,
 	.remove	 	= NULL,
-	.set_mtu	= slip_set_mtu,
 	.add_address	= slip_add_addr,
 	.delete_address = slip_del_addr,
-	.max_packet	= BUF_SIZE
+	.mtu		= BUF_SIZE,
+	.max_packet	= BUF_SIZE,
 };
diff -puN arch/um/drivers/slirp_kern.c~uml-network-driver-mtu-cleanups arch/um/drivers/slirp_kern.c
--- a/arch/um/drivers/slirp_kern.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/drivers/slirp_kern.c
@@ -52,18 +52,16 @@ static unsigned short slirp_protocol(str
 	return htons(ETH_P_IP);
 }
 
-static int slirp_read(int fd, struct sk_buff **skb,
-		       struct uml_net_private *lp)
+static int slirp_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
-	return slirp_user_read(fd, skb_mac_header(*skb), (*skb)->dev->mtu,
-			      (struct slirp_data *) &lp->user);
+	return slirp_user_read(fd, skb_mac_header(skb), skb->dev->mtu,
+			       (struct slirp_data *) &lp->user);
 }
 
-static int slirp_write(int fd, struct sk_buff **skb,
-		      struct uml_net_private *lp)
+static int slirp_write(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
-	return slirp_user_write(fd, (*skb)->data, (*skb)->len,
-			       (struct slirp_data *) &lp->user);
+	return slirp_user_write(fd, skb->data, skb->len,
+				(struct slirp_data *) &lp->user);
 }
 
 const struct net_kern_info slirp_kern_info = {
diff -puN arch/um/drivers/slirp_user.c~uml-network-driver-mtu-cleanups arch/um/drivers/slirp_user.c
--- a/arch/um/drivers/slirp_user.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/drivers/slirp_user.c
@@ -124,18 +124,13 @@ int slirp_user_write(int fd, void *buf, 
 	return slip_proto_write(fd, buf, len, &pri->slip);
 }
 
-static int slirp_set_mtu(int mtu, void *data)
-{
-	return mtu;
-}
-
 const struct net_user_info slirp_user_info = {
 	.init		= slirp_user_init,
 	.open		= slirp_open,
 	.close	 	= slirp_close,
 	.remove	 	= NULL,
-	.set_mtu	= slirp_set_mtu,
 	.add_address	= NULL,
 	.delete_address = NULL,
-	.max_packet	= BUF_SIZE
+	.mtu		= BUF_SIZE,
+	.max_packet	= BUF_SIZE,
 };
diff -puN arch/um/drivers/vde_kern.c~uml-network-driver-mtu-cleanups arch/um/drivers/vde_kern.c
--- a/arch/um/drivers/vde_kern.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/drivers/vde_kern.c
@@ -36,30 +36,25 @@ static void vde_init(struct net_device *
 	printk("\n");
 }
 
-static int vde_read(int fd, struct sk_buff **skb, struct uml_net_private *lp)
+static int vde_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
 	struct vde_data *pri = (struct vde_data *) &lp->user;
 
-	if (pri->conn != NULL) {
-		*skb = ether_adjust_skb(*skb, ETH_HEADER_OTHER);
-		if (*skb == NULL)
-			return -ENOMEM;
-
-		return vde_user_read(pri->conn, skb_mac_header(*skb),
-				     (*skb)->dev->mtu + ETH_HEADER_OTHER);
-	}
+	if (pri->conn != NULL)
+		return vde_user_read(pri->conn, skb_mac_header(skb),
+				     skb->dev->mtu + ETH_HEADER_OTHER);
 
 	printk(KERN_ERR "vde_read - we have no VDECONN to read from");
 	return -EBADF;
 }
 
-static int vde_write(int fd, struct sk_buff **skb, struct uml_net_private *lp)
+static int vde_write(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
 	struct vde_data *pri = (struct vde_data *) &lp->user;
 
 	if (pri->conn != NULL)
-		return vde_user_write((void *)pri->conn, (*skb)->data,
-				      (*skb)->len);
+		return vde_user_write((void *)pri->conn, skb->data,
+				      skb->len);
 
 	printk(KERN_ERR "vde_write - we have no VDECONN to write to");
 	return -EBADF;
diff -puN arch/um/drivers/vde_user.c~uml-network-driver-mtu-cleanups arch/um/drivers/vde_user.c
--- a/arch/um/drivers/vde_user.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/drivers/vde_user.c
@@ -12,8 +12,6 @@
 #include "user.h"
 #include "vde.h"
 
-#define MAX_PACKET (ETH_MAX_PACKET + ETH_HEADER_OTHER)
-
 static int vde_user_init(void *data, void *dev)
 {
 	struct vde_data *pri = data;
@@ -65,20 +63,15 @@ static void vde_remove(void *data)
 	printk(UM_KERN_WARNING "vde_remove - we have no VDECONN to remove");
 }
 
-static int vde_set_mtu(int mtu, void *data)
-{
-	return mtu;
-}
-
 const struct net_user_info vde_user_info = {
 	.init		= vde_user_init,
 	.open		= vde_user_open,
 	.close	 	= NULL,
 	.remove	 	= vde_remove,
-	.set_mtu	= vde_set_mtu,
 	.add_address	= NULL,
 	.delete_address = NULL,
-	.max_packet	= MAX_PACKET - ETH_HEADER_OTHER
+	.mtu		= ETH_MAX_PACKET,
+	.max_packet	= ETH_MAX_PACKET + ETH_HEADER_OTHER,
 };
 
 void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
diff -puN arch/um/include/net_kern.h~uml-network-driver-mtu-cleanups arch/um/include/net_kern.h
--- a/arch/um/include/net_kern.h~uml-network-driver-mtu-cleanups
+++ a/arch/um/include/net_kern.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -30,24 +30,24 @@ struct uml_net_private {
 	struct work_struct work;
 	int fd;
 	unsigned char mac[ETH_ALEN];
+	int max_packet;
 	unsigned short (*protocol)(struct sk_buff *);
 	int (*open)(void *);
 	void (*close)(int, void *);
 	void (*remove)(void *);
-	int (*read)(int, struct sk_buff **skb, struct uml_net_private *);
-	int (*write)(int, struct sk_buff **skb, struct uml_net_private *);
+	int (*read)(int, struct sk_buff *skb, struct uml_net_private *);
+	int (*write)(int, struct sk_buff *skb, struct uml_net_private *);
 
 	void (*add_address)(unsigned char *, unsigned char *, void *);
 	void (*delete_address)(unsigned char *, unsigned char *, void *);
-	int (*set_mtu)(int mtu, void *);
 	char user[0];
 };
 
 struct net_kern_info {
 	void (*init)(struct net_device *, void *);
 	unsigned short (*protocol)(struct sk_buff *);
-	int (*read)(int, struct sk_buff **skb, struct uml_net_private *);
-	int (*write)(int, struct sk_buff **skb, struct uml_net_private *);
+	int (*read)(int, struct sk_buff *skb, struct uml_net_private *);
+	int (*write)(int, struct sk_buff *skb, struct uml_net_private *);
 };
 
 struct transport {
@@ -62,7 +62,6 @@ struct transport {
 
 extern struct net_device *ether_init(int);
 extern unsigned short ether_protocol(struct sk_buff *);
-extern struct sk_buff *ether_adjust_skb(struct sk_buff *skb, int extra);
 extern int tap_setup_common(char *str, char *type, char **dev_name,
 			    char **mac_out, char **gate_addr);
 extern void register_transport(struct transport *new);
diff -puN arch/um/include/net_user.h~uml-network-driver-mtu-cleanups arch/um/include/net_user.h
--- a/arch/um/include/net_user.h~uml-network-driver-mtu-cleanups
+++ a/arch/um/include/net_user.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
+ * Copyright (C) 2002 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
 
@@ -18,10 +18,10 @@ struct net_user_info {
 	int (*open)(void *);
 	void (*close)(int, void *);
 	void (*remove)(void *);
-	int (*set_mtu)(int mtu, void *);
 	void (*add_address)(unsigned char *, unsigned char *, void *);
 	void (*delete_address)(unsigned char *, unsigned char *, void *);
 	int max_packet;
+	int mtu;
 };
 
 extern void ether_user_init(void *data, void *dev);
diff -puN arch/um/os-Linux/drivers/ethertap_kern.c~uml-network-driver-mtu-cleanups arch/um/os-Linux/drivers/ethertap_kern.c
--- a/arch/um/os-Linux/drivers/ethertap_kern.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/os-Linux/drivers/ethertap_kern.c
@@ -36,35 +36,24 @@ static void etap_init(struct net_device 
 	printk("\n");
 }
 
-static int etap_read(int fd, struct sk_buff **skb, struct uml_net_private *lp)
+static int etap_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
 	int len;
 
-	*skb = ether_adjust_skb(*skb, ETH_HEADER_ETHERTAP);
-	if (*skb == NULL)
-		return -ENOMEM;
-	len = net_recvfrom(fd, skb_mac_header(*skb),
-			   (*skb)->dev->mtu + 2 * ETH_HEADER_ETHERTAP);
+	len = net_recvfrom(fd, skb_mac_header(skb),
+			   skb->dev->mtu + 2 + ETH_HEADER_ETHERTAP);
 	if (len <= 0)
-		return len;
-	skb_pull(*skb, 2);
+		return(len);
+
+	skb_pull(skb, 2);
 	len -= 2;
 	return len;
 }
 
-static int etap_write(int fd, struct sk_buff **skb, struct uml_net_private *lp)
+static int etap_write(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
-	if (skb_headroom(*skb) < 2) {
-	  	struct sk_buff *skb2;
-
-		skb2 = skb_realloc_headroom(*skb, 2);
-		dev_kfree_skb(*skb);
-		if (skb2 == NULL)
-			return -ENOMEM;
-		*skb = skb2;
-	}
-	skb_push(*skb, 2);
-	return net_send(fd, (*skb)->data, (*skb)->len);
+	skb_push(skb, 2);
+	return net_send(fd, skb->data, skb->len);
 }
 
 const struct net_kern_info ethertap_kern_info = {
@@ -99,6 +88,7 @@ static struct transport ethertap_transpo
 	.user 		= &ethertap_user_info,
 	.kern 		= &ethertap_kern_info,
 	.private_size 	= sizeof(struct ethertap_data),
+	.setup_size 	= sizeof(struct ethertap_init),
 };
 
 static int register_ethertap(void)
diff -puN arch/um/os-Linux/drivers/ethertap_user.c~uml-network-driver-mtu-cleanups arch/um/os-Linux/drivers/ethertap_user.c
--- a/arch/um/os-Linux/drivers/ethertap_user.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/os-Linux/drivers/ethertap_user.c
@@ -222,11 +222,6 @@ static void etap_close(int fd, void *dat
 	pri->control_fd = -1;
 }
 
-static int etap_set_mtu(int mtu, void *data)
-{
-	return mtu;
-}
-
 static void etap_add_addr(unsigned char *addr, unsigned char *netmask,
 			  void *data)
 {
@@ -254,8 +249,8 @@ const struct net_user_info ethertap_user
 	.open		= etap_open,
 	.close	 	= etap_close,
 	.remove	 	= NULL,
-	.set_mtu	= etap_set_mtu,
 	.add_address	= etap_add_addr,
 	.delete_address = etap_del_addr,
-	.max_packet	= MAX_PACKET - ETH_HEADER_ETHERTAP
+	.mtu		= ETH_MAX_PACKET,
+	.max_packet	= ETH_MAX_PACKET + ETH_HEADER_ETHERTAP,
 };
diff -puN arch/um/os-Linux/drivers/tuntap_kern.c~uml-network-driver-mtu-cleanups arch/um/os-Linux/drivers/tuntap_kern.c
--- a/arch/um/os-Linux/drivers/tuntap_kern.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/os-Linux/drivers/tuntap_kern.c
@@ -35,20 +35,15 @@ static void tuntap_init(struct net_devic
 	printk("\n");
 }
 
-static int tuntap_read(int fd, struct sk_buff **skb,
-		       struct uml_net_private *lp)
+static int tuntap_read(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
-	*skb = ether_adjust_skb(*skb, ETH_HEADER_OTHER);
-	if (*skb == NULL)
-		return -ENOMEM;
-	return net_read(fd, skb_mac_header(*skb),
-			(*skb)->dev->mtu + ETH_HEADER_OTHER);
+	return net_read(fd, skb_mac_header(skb),
+			skb->dev->mtu + ETH_HEADER_OTHER);
 }
 
-static int tuntap_write(int fd, struct sk_buff **skb,
-			struct uml_net_private *lp)
+static int tuntap_write(int fd, struct sk_buff *skb, struct uml_net_private *lp)
 {
-	return net_write(fd, (*skb)->data, (*skb)->len);
+	return net_write(fd, skb->data, skb->len);
 }
 
 const struct net_kern_info tuntap_kern_info = {
diff -puN arch/um/os-Linux/drivers/tuntap_user.c~uml-network-driver-mtu-cleanups arch/um/os-Linux/drivers/tuntap_user.c
--- a/arch/um/os-Linux/drivers/tuntap_user.c~uml-network-driver-mtu-cleanups
+++ a/arch/um/os-Linux/drivers/tuntap_user.c
@@ -18,8 +18,6 @@
 #include "tuntap.h"
 #include "user.h"
 
-#define MAX_PACKET ETH_MAX_PACKET
-
 static int tuntap_user_init(void *data, void *dev)
 {
 	struct tuntap_data *pri = data;
@@ -206,18 +204,13 @@ static void tuntap_close(int fd, void *d
 	pri->fd = -1;
 }
 
-static int tuntap_set_mtu(int mtu, void *data)
-{
-	return mtu;
-}
-
 const struct net_user_info tuntap_user_info = {
 	.init		= tuntap_user_init,
 	.open		= tuntap_open,
 	.close	 	= tuntap_close,
 	.remove	 	= NULL,
-	.set_mtu	= tuntap_set_mtu,
 	.add_address	= tuntap_add_addr,
 	.delete_address = tuntap_del_addr,
-	.max_packet	= MAX_PACKET
+	.mtu		= ETH_MAX_PACKET,
+	.max_packet	= ETH_MAX_PACKET + ETH_HEADER_OTHER,
 };
_

Patches currently in -mm which might be from jdike@addtoit.com are

git-kvm.patch
hostfs-convert-to-new-aops.patch
uml-move-userspace-code-to-userspace-file.patch
uml-tidy-recently-moved-code.patch
uml-fix-error-cleanup-ordering.patch
uml-console-subsystem-tidying.patch
uml-fix-console-writing-bugs.patch
uml-console-tidying.patch
uml-stop-using-libc-asm-pageh.patch
uml-fix-an-ipv6-libc-vs-kernel-symbol-clash.patch
uml-fix-nonremovability-of-watchdog.patch
uml-stop-specially-protecting-kernel-stacks.patch
uml-stop-saving-process-fp-state.patch
uml-stop-saving-process-fp-state-fix.patch
uml-physmem-code-tidying.patch
uml-add-vde-networking-support.patch
uml-remove-unnecessary-hostfs_getattr.patch
uml-throw-out-config_mode_tt.patch
uml-remove-sysdep-threadh.patch
uml-style-fixes-pass-1.patch
uml-throw-out-choose_mode.patch
uml-style-fixes-pass-2.patch
uml-remove-code-made-redundant-by-choose_mode-removal.patch
uml-style-fixes-pass-3.patch
uml-remove-__u64-usage-from-physical-memory-subsystem.patch
uml-get-rid-of-do_longjmp.patch
uml-fold-mmu_context_skas-into-mm_context.patch
uml-rename-pt_regs-general-purpose-register-file.patch
uml-rename-pt_regs-general-purpose-register-file-fix.patch
uml-free-ldt-state-on-process-exit.patch
uml-remove-os_-usage-from-userspace-files.patch
uml-replace-clone-with-fork.patch
uml-fix-inlines.patch
uml-userspace-files-should-call-libc-directly.patch
uml-clean-up-tlb-flush-path.patch
uml-remove-unneeded-if-from-hostfs.patch
uml-fix-hostfs-style.patch
uml-dont-use-glibc-asm-userh.patch
uml-floating-point-signal-delivery-fixes.patch
uml-ptrace-floating-point-fixes.patch
uml-coredumping-floating-point-fixes.patch
uml-sysrq-and-mconsole-fixes.patch
uml-style-fixes-in-fp-code.patch
uml-eliminate-floating-point-state-from-register-file.patch
uml-remove-unused-file.patch
uml-more-idiomatic-parameter-parsing.patch
uml-eliminate-hz.patch
uml-fix-timer-switching.patch
uml-simplify-interval-setting.patch
uml-separate-timer-initialization.patch
uml-generic_time-support.patch
uml-generic_clockevents-support.patch
uml-clocksource-support.patch
uml-clocksource-support-fix.patch
uml-tickless-support.patch
uml-tickless-support-fix.patch
uml-eliminate-interrupts-in-the-idle-loop.patch
uml-time-build-fix.patch
uml-eliminate-sigalrm.patch
uml-use-sec_per_sec-constants.patch
uml-network-formatting.patch
uml-network-driver-mtu-cleanups.patch
uml-correctly-handle-skb-allocation-failures.patch
uml-correctly-handle-skb-allocation-failures-fix.patch
bitops-introduce-lock-ops.patch
