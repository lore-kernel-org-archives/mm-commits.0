From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-the-elan-u132-adapter-driver.patch added to -mm tree
Date: Fri, 13 Jul 2007 13:39:31 -0700
Message-ID: <200707132039.l6DKdVQx018445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55191 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757759AbXGMUkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 16:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, greg@kroah.com


The patch titled
     use mutex instead of semaphore in the ELAN U132 adapter driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-the-elan-u132-adapter-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use mutex instead of semaphore in the ELAN U132 adapter driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The ELAN U132 adapter driver uses the semaphore u132_module_lock
as mutex. Use the mutex API instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/u132-hcd.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/usb/host/u132-hcd.c~use-mutex-instead-of-semaphore-in-the-elan-u132-adapter-driver drivers/usb/host/u132-hcd.c
--- a/drivers/usb/host/u132-hcd.c~use-mutex-instead-of-semaphore-in-the-elan-u132-adapter-driver
+++ a/drivers/usb/host/u132-hcd.c
@@ -52,6 +52,7 @@
 #include <linux/workqueue.h>
 #include <linux/platform_device.h>
 #include <linux/pci_ids.h>
+#include <linux/mutex.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/system.h>
@@ -83,7 +84,7 @@ static DECLARE_WAIT_QUEUE_HEAD(u132_hcd_
 * u132_module_lock exists to protect access to global variables
 *
 */
-static struct semaphore u132_module_lock;
+static struct mutex u132_module_lock;
 static int u132_exiting = 0;
 static int u132_instances = 0;
 static struct list_head u132_static_list;
@@ -258,10 +259,10 @@ static void u132_hcd_delete(struct kref 
         struct platform_device *pdev = u132->platform_dev;
         struct usb_hcd *hcd = u132_to_hcd(u132);
         u132->going += 1;
-        down(&u132_module_lock);
+        mutex_lock(&u132_module_lock);
         list_del_init(&u132->u132_list);
         u132_instances -= 1;
-        up(&u132_module_lock);
+        mutex_unlock(&u132_module_lock);
         dev_warn(&u132->platform_dev->dev, "FREEING the hcd=%p and thus the u13"
                 "2=%p going=%d pdev=%p\n", hcd, u132, u132->going, pdev);
         usb_put_hcd(hcd);
@@ -3111,10 +3112,10 @@ static int __devinit u132_probe(struct p
                 int retval = 0;
                 struct u132 *u132 = hcd_to_u132(hcd);
                 hcd->rsrc_start = 0;
-                down(&u132_module_lock);
+                mutex_lock(&u132_module_lock);
                 list_add_tail(&u132->u132_list, &u132_static_list);
                 u132->sequence_num = ++u132_instances;
-                up(&u132_module_lock);
+                mutex_unlock(&u132_module_lock);
                 u132_u132_init_kref(u132);
                 u132_initialise(u132, pdev);
                 hcd->product_desc = "ELAN U132 Host Controller";
@@ -3216,7 +3217,7 @@ static int __init u132_hcd_init(void)
         INIT_LIST_HEAD(&u132_static_list);
         u132_instances = 0;
         u132_exiting = 0;
-        init_MUTEX(&u132_module_lock);
+        mutex_init(&u132_module_lock);
         if (usb_disabled())
                 return -ENODEV;
         printk(KERN_INFO "driver %s built at %s on %s\n", hcd_name, __TIME__,
@@ -3232,9 +3233,9 @@ static void __exit u132_hcd_exit(void)
 {
         struct u132 *u132;
         struct u132 *temp;
-        down(&u132_module_lock);
+        mutex_lock(&u132_module_lock);
         u132_exiting += 1;
-        up(&u132_module_lock);
+        mutex_unlock(&u132_module_lock);
         list_for_each_entry_safe(u132, temp, &u132_static_list, u132_list) {
                 platform_device_unregister(u132->platform_dev);
         } platform_driver_unregister(&u132_platform_driver);
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
git-dvb.patch
git-mtd.patch
git-net.patch
use-mutex-instead-of-semaphore-in-megaraid-mailbox-driver.patch
git-block.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
drivers-block-ubc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch
use-mutex-instead-of-semaphore-in-the-elan-u132-adapter-driver.patch
use-mutex-instead-of-semaphore-in-the-adutux-driver.patch
use-mutex-instead-of-semaphore-in-the-ftdi-elan-driver.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutexes-instead-of-semaphores-in-i2o-driver.patch
fs-block_devc-use-list_for_each_entry.patch
use-mutex-instead-of-semaphore-in-spi-core-init-code.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
