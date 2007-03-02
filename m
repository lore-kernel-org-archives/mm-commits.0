From: akpm@linux-foundation.org
Subject: + fix-locking-in-mousedev.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:43:28 -0800
Message-ID: <200703020243.l222hSJu030312@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36189 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422723AbXCBCnx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:43:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zaitcev@redhat.com, dtor@mail.ru


The patch titled
     Fix locking in mousedev
has been added to the -mm tree.  Its filename is
     fix-locking-in-mousedev.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix locking in mousedev
From: Pete Zaitcev <zaitcev@redhat.com>

If a process is closing /dev/input/mice and an mouse disconnects simulta-
neously, the system is likely to oops.  This usually happens when someone
hits <Alt><Ctrl>F1 or logs out from X, and flips a KVM while the system is
reacting.

I reproduced the issue by running this:
  while true; do cat </dev/null >/dev/input/mice; done
This way, it oopses on 2nd or 3rd disconnect reliably. With the patch,
I can disconnect the mouse 20 times.


Discussion

One of the race scenarios is related to the list of handles. The cat
calls mousedev_close -> mixdev_release, does list_for_each to walk for
all handles for a given handler. Iterations are longish while it does
input_close_device -> hidinput_close -> usbhid_close -> usb_kill_urb,
which sleeps briefly. Into this gap goes khubd and does hid_disconnect ->
hidinput_disconnect -> input_unregister_device. This corrupts the list
of handles which cat process is walking.

I was unable to devise a scheme to protect the stock h_list adequately,
so I implemented a private list of mousedev instances, which can be
protected correctly.

Dmitry, please consider getting rid of the list of handles entirely.
The other major user is drivers/char/keyboard.c.

Other than that, the patch is straightforward. It adds a static mutex
to guard common data structures. It has to be static because instances
of mousedev share common structures, such as the mousedev_table[].

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mousedev.c |   44 ++++++++++++++++++++++++++-----------
 1 files changed, 32 insertions(+), 12 deletions(-)

diff -puN drivers/input/mousedev.c~fix-locking-in-mousedev drivers/input/mousedev.c
--- a/drivers/input/mousedev.c~fix-locking-in-mousedev
+++ a/drivers/input/mousedev.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/random.h>
 #include <linux/major.h>
 #include <linux/device.h>
@@ -64,6 +65,7 @@ struct mousedev {
 	char name[16];
 	wait_queue_head_t wait;
 	struct list_head list;
+	struct list_head h_node;
 	struct input_handle handle;
 
 	struct mousedev_hw_data packet;
@@ -108,10 +110,13 @@ static unsigned char mousedev_imps_seq[]
 static unsigned char mousedev_imex_seq[] = { 0xf3, 200, 0xf3, 200, 0xf3, 80 };
 
 static struct input_handler mousedev_handler;
+static LIST_HEAD(mousedev_h_list);
 
 static struct mousedev *mousedev_table[MOUSEDEV_MINORS];
 static struct mousedev mousedev_mix;
 
+static DEFINE_MUTEX(mousedev_lock);
+
 #define fx(i)  (mousedev->old_x[(mousedev->pkt_count - (i)) & 03])
 #define fy(i)  (mousedev->old_y[(mousedev->pkt_count - (i)) & 03])
 
@@ -366,11 +371,9 @@ static void mousedev_free(struct mousede
 
 static void mixdev_release(void)
 {
-	struct input_handle *handle;
-
-	list_for_each_entry(handle, &mousedev_handler.h_list, h_node) {
-		struct mousedev *mousedev = handle->private;
+	struct mousedev *mousedev;
 
+	list_for_each_entry(mousedev, &mousedev_h_list, h_node) {
 		if (!mousedev->open) {
 			if (mousedev->exist)
 				input_close_device(&mousedev->handle);
@@ -386,6 +389,7 @@ static int mousedev_release(struct inode
 
 	mousedev_fasync(-1, file, 0);
 
+	mutex_lock(&mousedev_lock);
 	list_del(&list->node);
 
 	if (!--list->mousedev->open) {
@@ -398,6 +402,7 @@ static int mousedev_release(struct inode
 				mousedev_free(list->mousedev);
 		}
 	}
+	mutex_unlock(&mousedev_lock);
 
 	kfree(list);
 	return 0;
@@ -406,7 +411,6 @@ static int mousedev_release(struct inode
 static int mousedev_open(struct inode * inode, struct file * file)
 {
 	struct mousedev_list *list;
-	struct input_handle *handle;
 	struct mousedev *mousedev;
 	int i;
 
@@ -417,11 +421,16 @@ static int mousedev_open(struct inode * 
 #endif
 		i = iminor(inode) - MOUSEDEV_MINOR_BASE;
 
-	if (i >= MOUSEDEV_MINORS || !mousedev_table[i])
+	mutex_lock(&mousedev_lock);
+	if (i >= MOUSEDEV_MINORS || !mousedev_table[i]) {
+		mutex_unlock(&mousedev_lock);
 		return -ENODEV;
+	}
 
-	if (!(list = kzalloc(sizeof(struct mousedev_list), GFP_KERNEL)))
+	if (!(list = kzalloc(sizeof(struct mousedev_list), GFP_KERNEL))) {
+		mutex_unlock(&mousedev_lock);
 		return -ENOMEM;
+	}
 
 	spin_lock_init(&list->packet_lock);
 	list->pos_x = xres / 2;
@@ -432,16 +441,16 @@ static int mousedev_open(struct inode * 
 
 	if (!list->mousedev->open++) {
 		if (list->mousedev->minor == MOUSEDEV_MIX) {
-			list_for_each_entry(handle, &mousedev_handler.h_list, h_node) {
-				mousedev = handle->private;
+			list_for_each_entry(mousedev, &mousedev_h_list, h_node) {
 				if (!mousedev->open && mousedev->exist)
-					input_open_device(handle);
+					input_open_device(&mousedev->handle);
 			}
 		} else
 			if (!mousedev_mix.open && list->mousedev->exist)
 				input_open_device(&list->mousedev->handle);
 	}
 
+	mutex_unlock(&mousedev_lock);
 	return 0;
 }
 
@@ -604,7 +613,6 @@ static ssize_t mousedev_read(struct file
 	return count;
 }
 
-/* No kernel lock - fine */
 static unsigned int mousedev_poll(struct file *file, poll_table *wait)
 {
 	struct mousedev_list *list = file->private_data;
@@ -631,14 +639,19 @@ static struct input_handle *mousedev_con
 	struct class_device *cdev;
 	int minor = 0;
 
+	mutex_lock(&mousedev_lock);
+
 	for (minor = 0; minor < MOUSEDEV_MINORS && mousedev_table[minor]; minor++);
 	if (minor == MOUSEDEV_MINORS) {
+		mutex_unlock(&mousedev_lock);
 		printk(KERN_ERR "mousedev: no more free mousedev devices\n");
 		return NULL;
 	}
 
-	if (!(mousedev = kzalloc(sizeof(struct mousedev), GFP_KERNEL)))
+	if (!(mousedev = kzalloc(sizeof(struct mousedev), GFP_KERNEL))) {
+		mutex_unlock(&mousedev_lock);
 		return NULL;
+	}
 
 	INIT_LIST_HEAD(&mousedev->list);
 	init_waitqueue_head(&mousedev->wait);
@@ -664,6 +677,9 @@ static struct input_handle *mousedev_con
 	sysfs_create_link(&input_class.subsys.kset.kobj, &cdev->kobj,
 			  mousedev->name);
 
+	list_add_tail(&mousedev->h_node, &mousedev_h_list);
+
+	mutex_unlock(&mousedev_lock);
 	return &mousedev->handle;
 }
 
@@ -672,6 +688,9 @@ static void mousedev_disconnect(struct i
 	struct mousedev *mousedev = handle->private;
 	struct mousedev_list *list;
 
+	mutex_lock(&mousedev_lock);
+	list_del(&mousedev->h_node);
+
 	sysfs_remove_link(&input_class.subsys.kset.kobj, mousedev->name);
 	class_device_destroy(&input_class,
 			MKDEV(INPUT_MAJOR, MOUSEDEV_MINOR_BASE + mousedev->minor));
@@ -687,6 +706,7 @@ static void mousedev_disconnect(struct i
 			input_close_device(handle);
 		mousedev_free(mousedev);
 	}
+	mutex_unlock(&mousedev_lock);
 }
 
 static const struct input_device_id mousedev_ids[] = {
_

Patches currently in -mm which might be from zaitcev@redhat.com are

throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
fix-locking-in-mousedev.patch
usb-elan-ftdi-check-for-workqueue-creation-v2.patch
