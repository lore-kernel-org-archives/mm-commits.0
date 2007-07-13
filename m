From: akpm@linux-foundation.org
Subject: + use-mutex-instead-of-semaphore-in-the-ftdi-elan-driver.patch added to -mm tree
Date: Fri, 13 Jul 2007 13:39:35 -0700
Message-ID: <200707132039.l6DKdZqo018451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759486AbXGMUkO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 16:40:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, greg@kroah.com


The patch titled
     use mutex instead of semaphore in the FTDI ELAN driver
has been added to the -mm tree.  Its filename is
     use-mutex-instead-of-semaphore-in-the-ftdi-elan-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use mutex instead of semaphore in the FTDI ELAN driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The FTDI ELAN driver uses a semaphore as mutex. Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/ftdi-elan.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/usb/misc/ftdi-elan.c~use-mutex-instead-of-semaphore-in-the-ftdi-elan-driver drivers/usb/misc/ftdi-elan.c
--- a/drivers/usb/misc/ftdi-elan.c~use-mutex-instead-of-semaphore-in-the-ftdi-elan-driver
+++ a/drivers/usb/misc/ftdi-elan.c
@@ -44,6 +44,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kref.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <linux/usb.h>
 #include <linux/workqueue.h>
@@ -64,7 +65,7 @@ static struct workqueue_struct *respond_
 * ftdi_module_lock exists to protect access to global variables
 *
 */
-static struct semaphore ftdi_module_lock;
+static struct mutex ftdi_module_lock;
 static int ftdi_instances = 0;
 static struct list_head ftdi_static_list;
 /*
@@ -199,10 +200,10 @@ static void ftdi_elan_delete(struct kref
         dev_warn(&ftdi->udev->dev, "FREEING ftdi=%p\n", ftdi);
         usb_put_dev(ftdi->udev);
         ftdi->disconnected += 1;
-        down(&ftdi_module_lock);
+        mutex_lock(&ftdi_module_lock);
         list_del_init(&ftdi->ftdi_list);
         ftdi_instances -= 1;
-        up(&ftdi_module_lock);
+        mutex_unlock(&ftdi_module_lock);
         kfree(ftdi->bulk_in_buffer);
         ftdi->bulk_in_buffer = NULL;
 }
@@ -2780,10 +2781,10 @@ static int ftdi_elan_probe(struct usb_in
                 return -ENOMEM;
         }
         memset(ftdi, 0x00, sizeof(struct usb_ftdi));
-        down(&ftdi_module_lock);
+        mutex_lock(&ftdi_module_lock);
         list_add_tail(&ftdi->ftdi_list, &ftdi_static_list);
         ftdi->sequence_num = ++ftdi_instances;
-        up(&ftdi_module_lock);
+        mutex_unlock(&ftdi_module_lock);
         ftdi_elan_init_kref(ftdi);
         init_MUTEX(&ftdi->sw_lock);
         ftdi->udev = usb_get_dev(interface_to_usbdev(interface));
@@ -2909,7 +2910,7 @@ static int __init ftdi_elan_init(void)
         int result;
         printk(KERN_INFO "driver %s built at %s on %s\n", ftdi_elan_driver.name,
 	       __TIME__, __DATE__);
-        init_MUTEX(&ftdi_module_lock);
+        mutex_init(&ftdi_module_lock);
         INIT_LIST_HEAD(&ftdi_static_list);
         status_queue = create_singlethread_workqueue("ftdi-status-control");
 	if (!status_queue)
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
