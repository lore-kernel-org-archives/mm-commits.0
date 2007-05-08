From: akpm@linux-foundation.org
Subject: - uml-eliminate-temporary-buffer-in-eth_configure.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:31 -0700
Message-ID: <200705080006.l4806Vqg009197@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967386AbXEHAGw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: Eliminate temporary buffer in eth_configure
has been removed from the -mm tree.  Its filename was
     uml-eliminate-temporary-buffer-in-eth_configure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: Eliminate temporary buffer in eth_configure
From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Avoid using the temporary buffer introduced by previous patch to hold the
device name.

Btw, avoid leaking device on an error path.  Other error paths may need
cleanup.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_kern.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN arch/um/drivers/net_kern.c~uml-eliminate-temporary-buffer-in-eth_configure arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-eliminate-temporary-buffer-in-eth_configure
+++ a/arch/um/drivers/net_kern.c
@@ -348,17 +348,24 @@ static void eth_configure(int n, void *i
 	struct net_device *dev;
 	struct uml_net_private *lp;
 	int save, err, size;
-	char name[sizeof(dev->name)];
 
 	size = transport->private_size + sizeof(struct uml_net_private) +
 		sizeof(((struct uml_net_private *) 0)->user);
 
 	device = kzalloc(sizeof(*device), GFP_KERNEL);
 	if (device == NULL) {
-		printk(KERN_ERR "eth_configure failed to allocate uml_net\n");
+		printk(KERN_ERR "eth_configure failed to allocate struct "
+		       "uml_net\n");
 		return;
 	}
 
+	dev = alloc_etherdev(size);
+	if (dev == NULL) {
+		printk(KERN_ERR "eth_configure: failed to allocate struct "
+		       "net_device for eth%d\n", n);
+		goto out_free_device;
+	}
+
 	INIT_LIST_HEAD(&device->list);
 	device->index = n;
 
@@ -366,9 +373,9 @@ static void eth_configure(int n, void *i
 	 * netdevice, that is OK, register_netdev{,ice}() will notice this
 	 * and fail.
 	 */
-	snprintf(name, sizeof(name), "eth%d", n);
+	snprintf(dev->name, sizeof(dev->name), "eth%d", n);
 
-	setup_etheraddr(mac, device->mac, name);
+	setup_etheraddr(mac, device->mac, dev->name);
 
 	printk(KERN_INFO "Netdevice %d ", n);
 	printk("(%02x:%02x:%02x:%02x:%02x:%02x) ",
@@ -376,11 +383,6 @@ static void eth_configure(int n, void *i
 	       device->mac[2], device->mac[3],
 	       device->mac[4], device->mac[5]);
 	printk(": ");
-	dev = alloc_etherdev(size);
-	if (dev == NULL) {
-		printk(KERN_ERR "eth_configure: failed to allocate device\n");
-		goto out_free_device;
-	}
 
 	lp = dev->priv;
 	/* This points to the transport private data. It's still clear, but we
@@ -399,7 +401,6 @@ static void eth_configure(int n, void *i
 		goto out_free_netdev;
 	SET_NETDEV_DEV(dev,&device->pdev.dev);
 
-	strcpy(dev->name, name);
 	device->dev = dev;
 
 	/*
@@ -466,13 +467,13 @@ static void eth_configure(int n, void *i
 	return;
 
 out_undo_user_init:
-	if (transport->user->init != NULL)
+	if (transport->user->remove != NULL)
 		(*transport->user->remove)(&lp->user);
 out_unregister:
 	platform_device_unregister(&device->pdev);
 out_free_netdev:
 	free_netdev(dev);
-out_free_device: ;
+out_free_device:
 	kfree(device);
 }
 
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
