From: akpm@linux-foundation.org
Subject: - use-mutex-instead-of-semaphore-for-misc-char-devices.patch removed from -mm tree
Date: Tue, 08 May 2007 19:52:52 -0700
Message-ID: <200705090252.l492qqj7009623@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032211AbXEICw4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:52:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org


The patch titled
     use mutex instead of semaphore for misc char devices
has been removed from the -mm tree.  Its filename was
     use-mutex-instead-of-semaphore-for-misc-char-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: use mutex instead of semaphore for misc char devices
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The misc character device driver uses a semaphore as mutex.  Use the mutex API
instead of the (binary) semaphore.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/misc.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff -puN drivers/char/misc.c~use-mutex-instead-of-semaphore-for-misc-char-devices drivers/char/misc.c
--- a/drivers/char/misc.c~use-mutex-instead-of-semaphore-for-misc-char-devices
+++ a/drivers/char/misc.c
@@ -41,6 +41,7 @@
 #include <linux/kernel.h>
 #include <linux/major.h>
 #include <linux/slab.h>
+#include <linux/mutex.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/stat.h>
@@ -53,7 +54,7 @@
  * Head entry for the doubly linked miscdevice list
  */
 static LIST_HEAD(misc_list);
-static DECLARE_MUTEX(misc_sem);
+static DEFINE_MUTEX(misc_mtx);
 
 /*
  * Assigned numbers, used for dynamic minors
@@ -69,7 +70,7 @@ static void *misc_seq_start(struct seq_f
 	struct miscdevice *p;
 	loff_t off = 0;
 
-	down(&misc_sem);
+	mutex_lock(&misc_mtx);
 	list_for_each_entry(p, &misc_list, list) {
 		if (*pos == off++) 
 			return p;
@@ -89,7 +90,7 @@ static void *misc_seq_next(struct seq_fi
 
 static void misc_seq_stop(struct seq_file *seq, void *v)
 {
-	up(&misc_sem);
+	mutex_unlock(&misc_mtx);
 }
 
 static int misc_seq_show(struct seq_file *seq, void *v)
@@ -129,7 +130,7 @@ static int misc_open(struct inode * inod
 	int err = -ENODEV;
 	const struct file_operations *old_fops, *new_fops = NULL;
 	
-	down(&misc_sem);
+	mutex_lock(&misc_mtx);
 	
 	list_for_each_entry(c, &misc_list, list) {
 		if (c->minor == minor) {
@@ -139,9 +140,9 @@ static int misc_open(struct inode * inod
 	}
 		
 	if (!new_fops) {
-		up(&misc_sem);
+		mutex_unlock(&misc_mtx);
 		request_module("char-major-%d-%d", MISC_MAJOR, minor);
-		down(&misc_sem);
+		mutex_lock(&misc_mtx);
 
 		list_for_each_entry(c, &misc_list, list) {
 			if (c->minor == minor) {
@@ -165,7 +166,7 @@ static int misc_open(struct inode * inod
 	}
 	fops_put(old_fops);
 fail:
-	up(&misc_sem);
+	mutex_unlock(&misc_mtx);
 	return err;
 }
 
@@ -201,10 +202,10 @@ int misc_register(struct miscdevice * mi
 
 	INIT_LIST_HEAD(&misc->list);
 
-	down(&misc_sem);
+	mutex_lock(&misc_mtx);
 	list_for_each_entry(c, &misc_list, list) {
 		if (c->minor == misc->minor) {
-			up(&misc_sem);
+			mutex_unlock(&misc_mtx);
 			return -EBUSY;
 		}
 	}
@@ -215,7 +216,7 @@ int misc_register(struct miscdevice * mi
 			if ( (misc_minors[i>>3] & (1 << (i&7))) == 0)
 				break;
 		if (i<0) {
-			up(&misc_sem);
+			mutex_unlock(&misc_mtx);
 			return -EBUSY;
 		}
 		misc->minor = i;
@@ -238,7 +239,7 @@ int misc_register(struct miscdevice * mi
 	 */
 	list_add(&misc->list, &misc_list);
  out:
-	up(&misc_sem);
+	mutex_unlock(&misc_mtx);
 	return err;
 }
 
@@ -259,13 +260,13 @@ int misc_deregister(struct miscdevice * 
 	if (list_empty(&misc->list))
 		return -EINVAL;
 
-	down(&misc_sem);
+	mutex_lock(&misc_mtx);
 	list_del(&misc->list);
 	device_destroy(misc_class, MKDEV(MISC_MAJOR, misc->minor));
 	if (i < DYNAMIC_MINORS && i>0) {
 		misc_minors[i>>3] &= ~(1 << (misc->minor & 7));
 	}
-	up(&misc_sem);
+	mutex_unlock(&misc_mtx);
 	return 0;
 }
 
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
power-management-use-mutexes-instead-of-semaphores.patch
sysdev-use-mutex-instead-of-semaphore.patch
git-dvb.patch
scx200-use-mutex-instead-of-semaphore.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
git-scsi-misc.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch
git-watchdog.patch
