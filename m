From: akpm@linux-foundation.org
Subject: - use-mutexes-instead-of-semaphores-in-i2o-driver.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:53:24 -0700
Message-ID: <200707162053.l6GKrOMX001623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54102 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759554AbXGPVVC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:21:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Use mutexes instead of semaphores in I2O driver
has been removed from the -mm tree.  Its filename was
     use-mutexes-instead-of-semaphores-in-i2o-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Use mutexes instead of semaphores in I2O driver
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

The I2O driver uses two semaphores as mutexes.  Use the mutex API instead of
the (binary) semaphores.

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/device.c   |   16 ++++++++--------
 drivers/message/i2o/exec-osm.c |    4 ++--
 drivers/message/i2o/iop.c      |    2 +-
 include/linux/i2o.h            |    5 +++--
 4 files changed, 14 insertions(+), 13 deletions(-)

diff -puN drivers/message/i2o/device.c~use-mutexes-instead-of-semaphores-in-i2o-driver drivers/message/i2o/device.c
--- a/drivers/message/i2o/device.c~use-mutexes-instead-of-semaphores-in-i2o-driver
+++ a/drivers/message/i2o/device.c
@@ -62,7 +62,7 @@ int i2o_device_claim(struct i2o_device *
 {
 	int rc = 0;
 
-	down(&dev->lock);
+	mutex_lock(&dev->lock);
 
 	rc = i2o_device_issue_claim(dev, I2O_CMD_UTIL_CLAIM, I2O_CLAIM_PRIMARY);
 	if (!rc)
@@ -72,7 +72,7 @@ int i2o_device_claim(struct i2o_device *
 		pr_debug("i2o: claim of device %d failed %d\n",
 			 dev->lct_data.tid, rc);
 
-	up(&dev->lock);
+	mutex_unlock(&dev->lock);
 
 	return rc;
 }
@@ -96,7 +96,7 @@ int i2o_device_claim_release(struct i2o_
 	int tries;
 	int rc = 0;
 
-	down(&dev->lock);
+	mutex_lock(&dev->lock);
 
 	/*
 	 *      If the controller takes a nonblocking approach to
@@ -118,7 +118,7 @@ int i2o_device_claim_release(struct i2o_
 		pr_debug("i2o: claim release of device %d failed %d\n",
 			 dev->lct_data.tid, rc);
 
-	up(&dev->lock);
+	mutex_unlock(&dev->lock);
 
 	return rc;
 }
@@ -198,7 +198,7 @@ static struct i2o_device *i2o_device_all
 		return ERR_PTR(-ENOMEM);
 
 	INIT_LIST_HEAD(&dev->list);
-	init_MUTEX(&dev->lock);
+	mutex_init(&dev->lock);
 
 	dev->device.bus = &i2o_bus_type;
 	dev->device.release = &i2o_device_release;
@@ -326,7 +326,7 @@ int i2o_device_parse_lct(struct i2o_cont
 	u16 table_size;
 	u32 buf;
 
-	down(&c->lct_lock);
+	mutex_lock(&c->lct_lock);
 
 	kfree(c->lct);
 
@@ -335,7 +335,7 @@ int i2o_device_parse_lct(struct i2o_cont
 
 	lct = c->lct = kmalloc(table_size * 4, GFP_KERNEL);
 	if (!lct) {
-		up(&c->lct_lock);
+		mutex_unlock(&c->lct_lock);
 		return -ENOMEM;
 	}
 
@@ -408,7 +408,7 @@ int i2o_device_parse_lct(struct i2o_cont
 			i2o_device_remove(dev);
 	}
 
-	up(&c->lct_lock);
+	mutex_unlock(&c->lct_lock);
 
 	return 0;
 }
diff -puN drivers/message/i2o/exec-osm.c~use-mutexes-instead-of-semaphores-in-i2o-driver drivers/message/i2o/exec-osm.c
--- a/drivers/message/i2o/exec-osm.c~use-mutexes-instead-of-semaphores-in-i2o-driver
+++ a/drivers/message/i2o/exec-osm.c
@@ -537,7 +537,7 @@ static int i2o_exec_lct_notify(struct i2
 	struct device *dev;
 	struct i2o_message *msg;
 
-	down(&c->lct_lock);
+	mutex_lock(&c->lct_lock);
 
 	dev = &c->pdev->dev;
 
@@ -561,7 +561,7 @@ static int i2o_exec_lct_notify(struct i2
 
 	i2o_msg_post(c, msg);
 
-	up(&c->lct_lock);
+	mutex_unlock(&c->lct_lock);
 
 	return 0;
 };
diff -puN drivers/message/i2o/iop.c~use-mutexes-instead-of-semaphores-in-i2o-driver drivers/message/i2o/iop.c
--- a/drivers/message/i2o/iop.c~use-mutexes-instead-of-semaphores-in-i2o-driver
+++ a/drivers/message/i2o/iop.c
@@ -1067,7 +1067,7 @@ struct i2o_controller *i2o_iop_alloc(voi
 
 	INIT_LIST_HEAD(&c->devices);
 	spin_lock_init(&c->lock);
-	init_MUTEX(&c->lct_lock);
+	mutex_init(&c->lct_lock);
 
 	device_initialize(&c->device);
 
diff -puN include/linux/i2o.h~use-mutexes-instead-of-semaphores-in-i2o-driver include/linux/i2o.h
--- a/include/linux/i2o.h~use-mutexes-instead-of-semaphores-in-i2o-driver
+++ a/include/linux/i2o.h
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>	/* work_struct */
 #include <linux/mempool.h>
+#include <linux/mutex.h>
 
 #include <asm/io.h>
 #include <asm/semaphore.h>	/* Needed for MUTEX init macros */
@@ -425,7 +426,7 @@ struct i2o_device {
 
 	struct device device;
 
-	struct semaphore lock;	/* device lock */
+	struct mutex lock;	/* device lock */
 };
 
 /*
@@ -544,7 +545,7 @@ struct i2o_controller {
 	struct i2o_dma hrt;	/* HW Resource Table */
 	i2o_lct *lct;		/* Logical Config Table */
 	struct i2o_dma dlct;	/* Temp LCT */
-	struct semaphore lct_lock;	/* Lock for LCT updates */
+	struct mutex lct_lock;	/* Lock for LCT updates */
 	struct i2o_dma status_block;	/* IOP status block */
 
 	struct i2o_io base;	/* controller messaging unit */
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
kcopyd-use-mutex-instead-of-semaphore.patch
git-dvb.patch
git-mtd.patch
videopix-frame-grabber-fix-unreleased-lock-in-vfc_debug.patch
use-mutex-instead-of-semaphore-in-the-usb-gadget-serial-driver.patch
use-mutex-instead-of-semaphore-in-the-elan-u132-adapter-driver.patch
use-mutex-instead-of-semaphore-in-the-adutux-driver.patch
use-mutex-instead-of-semaphore-in-the-ftdi-elan-driver.patch
use-list_for_each_entry-for-iteration-in-prism-54-driver.patch
use-mutex-instead-of-semaphore-in-spi-core-init-code.patch
use-mutex-instead-of-semaphore-in-capi-20-driver.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
