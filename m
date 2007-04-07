From: akpm@linux-foundation.org
Subject: + uml-drivers-get-release-methods.patch added to -mm tree
Date: Fri, 06 Apr 2007 18:16:33 -0700
Message-ID: <200704070116.l371GXfW024568@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41430 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933564AbXDGBQh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 21:16:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: drivers get release methods
has been added to the -mm tree.  Its filename is
     uml-drivers-get-release-methods.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
uml-speed-up-exec.patch
uml-no-locking-needed-in-tlsc.patch
uml-tidy-processc.patch
uml-tidy-processc-fix.patch
uml-remove-page_size.patch
uml-kernel_thread-shouldnt-panic.patch
uml-tidy-fault-code.patch
uml-kernel-segfaults-should-dump-proper-registers.patch
uml-comment-early-boot-locking.patch
uml-irq-locking-commentary.patch
uml-delete-host_frame_size.patch
uml-drivers-get-release-methods.patch
uml-dump-registers-on-ptrace-or-wait-failure.patch
uml-speed-up-page-table-walking.patch
sys_futex64-allows-64bit-futexes-workaround-for-uml.patch
utrace-uml-make-uml-compile-with-utrace-enabled.patch
