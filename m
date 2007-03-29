From: akpm@linux-foundation.org
Subject: + uml-improve-checking-and-diagnostics-of-ethernet-macs.patch added to -mm tree
Date: Wed, 28 Mar 2007 17:09:19 -0700
Message-ID: <200703290009.l2T09JTj023434@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36321 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965815AbXC2AJV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 20:09:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: improve checking and diagnostics of ethernet MACs
has been added to the -mm tree.  Its filename is
     uml-improve-checking-and-diagnostics-of-ethernet-macs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

uml-fix-static-linking.patch
uml-use-correct-register-file-size-everywhere.patch
uml-fix-i-o-hang-when-multiple-devices-are-in-use.patch
uml-fix-device-unplug-crash.patch
uml-fix-pte-bit-collision.patch
uml-irq-locking-fixes.patch
uml-fix-lvm-crash.patch
uml-fix-compilation-problems.patch
uml-hostfs-variable-renaming.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-improve-checking-and-diagnostics-of-ethernet-macs.patch
uml-eliminate-temporary-buffer-in-eth_configure.patch
uml-replace-one-element-array-with-zero-element-array.patch
fix-utrace-utrace-tracehook-um.patch
git-gccbug.patch
