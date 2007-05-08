From: akpm@linux-foundation.org
Subject: - uml-improve-checking-and-diagnostics-of-ethernet-macs.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:29 -0700
Message-ID: <200705080006.l4806TPS009194@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967383AbXEHAGu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: improve checking and diagnostics of ethernet MACs
has been removed from the -mm tree.  Its filename was
     uml-improve-checking-and-diagnostics-of-ethernet-macs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: improve checking and diagnostics of ethernet MACs
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Improve checking and diagnostics for broadcast and multicast Ethernet MAC
addresses, and distinguish between those cases in output; also make sure the
device is assigned a MAC address valid only locally to avoid collisions.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_kern.c  |   38 +++++++++++++++++++++++++---------
 include/linux/etherdevice.h |   12 ++++++++++
 2 files changed, 41 insertions(+), 9 deletions(-)

diff -puN arch/um/drivers/net_kern.c~uml-improve-checking-and-diagnostics-of-ethernet-macs arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-improve-checking-and-diagnostics-of-ethernet-macs
+++ a/arch/um/drivers/net_kern.c
@@ -283,7 +283,7 @@ void uml_net_user_timer_expire(unsigned 
 #endif
 }
 
-static void setup_etheraddr(char *str, unsigned char *addr)
+static void setup_etheraddr(char *str, unsigned char *addr, char *name)
 {
 	char *end;
 	int i;
@@ -302,15 +302,32 @@ static void setup_etheraddr(char *str, u
 		}
 		str = end + 1;
 	}
-	if(addr[0] & 1){
+	if (is_multicast_ether_addr(addr)) {
 		printk(KERN_ERR
-		       "Attempt to assign a broadcast ethernet address to a "
+		       "Attempt to assign a multicast ethernet address to a "
 		       "device disallowed\n");
 		goto random;
 	}
+	if (!is_valid_ether_addr(addr)) {
+		printk(KERN_ERR
+		       "Attempt to assign an invalid ethernet address to a "
+		       "device disallowed\n");
+		goto random;
+	}
+	if (!is_local_ether_addr(addr)) {
+		printk(KERN_WARNING
+		       "Warning: attempt to assign a globally valid ethernet address to a "
+		       "device\n");
+		printk(KERN_WARNING "You should better enable the 2nd rightmost bit "
+		      "in the first byte of the MAC, i.e. "
+		      "%02x:%02x:%02x:%02x:%02x:%02x\n",
+		      addr[0] | 0x02, addr[1], addr[2], addr[3], addr[4], addr[5]);
+	}
 	return;
 
 random:
+	printk(KERN_INFO
+	       "Choosing a random ethernet address for device %s\n", name);
 	random_ether_addr(addr);
 }
 
@@ -331,6 +348,7 @@ static void eth_configure(int n, void *i
 	struct net_device *dev;
 	struct uml_net_private *lp;
 	int save, err, size;
+	char name[sizeof(dev->name)];
 
 	size = transport->private_size + sizeof(struct uml_net_private) +
 		sizeof(((struct uml_net_private *) 0)->user);
@@ -344,7 +362,13 @@ static void eth_configure(int n, void *i
 	INIT_LIST_HEAD(&device->list);
 	device->index = n;
 
-	setup_etheraddr(mac, device->mac);
+	/* If this name ends up conflicting with an existing registered
+	 * netdevice, that is OK, register_netdev{,ice}() will notice this
+	 * and fail.
+	 */
+	snprintf(name, sizeof(name), "eth%d", n);
+
+	setup_etheraddr(mac, device->mac, name);
 
 	printk(KERN_INFO "Netdevice %d ", n);
 	printk("(%02x:%02x:%02x:%02x:%02x:%02x) ",
@@ -375,11 +399,7 @@ static void eth_configure(int n, void *i
 		goto out_free_netdev;
 	SET_NETDEV_DEV(dev,&device->pdev.dev);
 
-	/* If this name ends up conflicting with an existing registered
-	 * netdevice, that is OK, register_netdev{,ice}() will notice this
-	 * and fail.
-	 */
-	snprintf(dev->name, sizeof(dev->name), "eth%d", n);
+	strcpy(dev->name, name);
 	device->dev = dev;
 
 	/*
diff -puN include/linux/etherdevice.h~uml-improve-checking-and-diagnostics-of-ethernet-macs include/linux/etherdevice.h
--- a/include/linux/etherdevice.h~uml-improve-checking-and-diagnostics-of-ethernet-macs
+++ a/include/linux/etherdevice.h
@@ -71,6 +71,18 @@ static inline int is_multicast_ether_add
 }
 
 /**
+ * is_local_ether_addr - Determine if the Ethernet address is locally-assigned
+ * one (IEEE 802).
+ * @addr: Pointer to a six-byte array containing the Ethernet address
+ *
+ * Return true if the address is a local address.
+ */
+static inline int is_local_ether_addr(const u8 *addr)
+{
+	return (0x02 & addr[0]);
+}
+
+/**
  * is_broadcast_ether_addr - Determine if the Ethernet address is broadcast
  * @addr: Pointer to a six-byte array containing the Ethernet address
  *
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

origin.patch
uml-make-hostfs_setattr-support-operations-on-unlinked-open-files.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
