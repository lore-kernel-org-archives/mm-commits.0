From: akpm@linux-foundation.org
Subject: - uml-drivers-get-release-methods.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:57 -0700
Message-ID: <200705080006.l4806v7R009239@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967407AbXEHAHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:07:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: drivers get release methods
has been removed from the -mm tree.  Its filename was
     uml-drivers-get-release-methods.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: drivers get release methods
From: Jeff Dike <jdike@addtoit.com>

Define release methods for the ubd and net drivers.  They contain as much of
the remove methods as make sense.  All error checking must have already been
done as well as anything else that might be holding a reference on the device
kobject.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/net_kern.c |   19 +++++++++++++++----
 arch/um/drivers/ubd_kern.c |   17 ++++++++++++-----
 2 files changed, 27 insertions(+), 9 deletions(-)

diff -puN arch/um/drivers/net_kern.c~uml-drivers-get-release-methods arch/um/drivers/net_kern.c
--- a/arch/um/drivers/net_kern.c~uml-drivers-get-release-methods
+++ a/arch/um/drivers/net_kern.c
@@ -341,6 +341,19 @@ static struct platform_driver uml_net_dr
 };
 static int driver_registered;
 
+static void net_device_release(struct device *dev)
+{
+	struct uml_net *device = dev->driver_data;
+	struct net_device *netdev = device->dev;
+	struct uml_net_private *lp = netdev->priv;
+
+	if(lp->remove != NULL)
+		(*lp->remove)(&lp->user);
+	list_del(&device->list);
+	kfree(device);
+	free_netdev(netdev);
+}
+
 static void eth_configure(int n, void *init, char *mac,
 			  struct transport *transport)
 {
@@ -396,6 +409,8 @@ static void eth_configure(int n, void *i
 	}
 	device->pdev.id = n;
 	device->pdev.name = DRIVER_NAME;
+	device->pdev.dev.release = net_device_release;
+	device->pdev.dev.driver_data = device;
 	if(platform_device_register(&device->pdev))
 		goto out_free_netdev;
 	SET_NETDEV_DEV(dev,&device->pdev.dev);
@@ -689,13 +704,9 @@ static int net_remove(int n, char **erro
 	lp = dev->priv;
 	if(lp->fd > 0)
 		return -EBUSY;
-	if(lp->remove != NULL) (*lp->remove)(&lp->user);
 	unregister_netdev(dev);
 	platform_device_unregister(&device->pdev);
 
-	list_del(&device->list);
-	kfree(device);
-	free_netdev(dev);
 	return 0;
 }
 
diff -puN arch/um/drivers/ubd_kern.c~uml-drivers-get-release-methods arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-drivers-get-release-methods
+++ a/arch/um/drivers/ubd_kern.c
@@ -622,6 +622,14 @@ static int ubd_open_dev(struct ubd *ubd_
 	return(err);
 }
 
+static void ubd_device_release(struct device *dev)
+{
+	struct ubd *ubd_dev = dev->driver_data;
+
+	blk_cleanup_queue(ubd_dev->queue);
+	*ubd_dev = ((struct ubd) DEFAULT_UBD);
+}
+
 static int ubd_disk_register(int major, u64 size, int unit,
 			     struct gendisk **disk_out)
 {
@@ -644,6 +652,8 @@ static int ubd_disk_register(int major, 
 	if (major == MAJOR_NR) {
 		ubd_devs[unit].pdev.id   = unit;
 		ubd_devs[unit].pdev.name = DRIVER_NAME;
+		ubd_devs[unit].pdev.dev.release = ubd_device_release;
+		ubd_devs[unit].pdev.dev.driver_data = &ubd_devs[unit];
 		platform_device_register(&ubd_devs[unit].pdev);
 		disk->driverfs_dev = &ubd_devs[unit].pdev.dev;
 	}
@@ -787,7 +797,7 @@ static int ubd_id(char **str, int *start
 
 static int ubd_remove(int n, char **error_out)
 {
-	struct gendisk *disk;
+	struct gendisk *disk = ubd_gendisk[n];
 	struct ubd *ubd_dev;
 	int err = -ENODEV;
 
@@ -803,7 +813,6 @@ static int ubd_remove(int n, char **erro
 	if(ubd_dev->count > 0)
 		goto out;
 
- 	disk = ubd_gendisk[n];
  	ubd_gendisk[n] = NULL;
 	if(disk != NULL){
 		del_gendisk(disk);
@@ -816,10 +825,8 @@ static int ubd_remove(int n, char **erro
 		fake_gendisk[n] = NULL;
 	}
 
-	blk_cleanup_queue(ubd_dev->queue);
-	platform_device_unregister(&ubd_dev->pdev);
-	*ubd_dev = ((struct ubd) DEFAULT_UBD);
 	err = 0;
+	platform_device_unregister(&ubd_dev->pdev);
 out:
 	mutex_unlock(&ubd_lock);
 	return err;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
