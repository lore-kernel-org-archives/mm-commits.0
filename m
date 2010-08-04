From: akpm@linux-foundation.org
Subject: + pps-move-idr-stuff-to-ppsc.patch added to -mm tree
Date: Wed, 04 Aug 2010 16:38:27 -0700
Message-ID: <201008042338.o74NcRi0017005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752620Ab0HEACM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Aug 2010 20:02:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@enneenne.com, johnstul@us.ibm.com, joonwpark81@gmail.com, tj@kernel.org, yoush@cs.msu.su


The patch titled
     pps: move idr stuff to pps.c
has been added to the -mm tree.  Its filename is
     pps-move-idr-stuff-to-ppsc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: move idr stuff to pps.c
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Since now idr is only used to manage char device id's and not used in
kernel API anymore it should be moved to pps.c.  This also makes it
possible to release id only at actual device freeing so nobody can
register a pps device with the same id while our device is not freed yet.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/kapi.c |   53 -------------------------------------------
 drivers/pps/pps.c  |   49 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 49 insertions(+), 53 deletions(-)

diff -puN drivers/pps/kapi.c~pps-move-idr-stuff-to-ppsc drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-move-idr-stuff-to-ppsc
+++ a/drivers/pps/kapi.c
@@ -26,19 +26,11 @@
 #include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/spinlock.h>
-#include <linux/idr.h>
 #include <linux/fs.h>
 #include <linux/pps_kernel.h>
 #include <linux/slab.h>
 
 /*
- * Local variables
- */
-
-static DEFINE_SPINLOCK(pps_idr_lock);
-static DEFINE_IDR(pps_idr);
-
-/*
  * Local functions
  */
 
@@ -75,7 +67,6 @@ struct pps_device *pps_register_source(s
 		int default_params)
 {
 	struct pps_device *pps;
-	int id;
 	int err;
 
 	/* Sanity checks */
@@ -116,54 +107,18 @@ struct pps_device *pps_register_source(s
 	init_waitqueue_head(&pps->queue);
 	spin_lock_init(&pps->lock);
 
-	/* Get new ID for the new PPS source */
-	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0) {
-		err = -ENOMEM;
-		goto kfree_pps;
-	}
-
-	spin_lock_irq(&pps_idr_lock);
-
-	/* Now really allocate the PPS source.
-	 * After idr_get_new() calling the new source will be freely available
-	 * into the kernel.
-	 */
-	err = idr_get_new(&pps_idr, pps, &id);
-	if (err < 0) {
-		spin_unlock_irq(&pps_idr_lock);
-		goto kfree_pps;
-	}
-
-	id = id & MAX_ID_MASK;
-	if (id >= PPS_MAX_SOURCES) {
-		spin_unlock_irq(&pps_idr_lock);
-
-		pr_err("pps: %s: too many PPS sources in the system\n",
-					info->name);
-		err = -EBUSY;
-		goto free_idr;
-	}
-	pps->id = id;
-
-	spin_unlock_irq(&pps_idr_lock);
-
 	/* Create the char device */
 	err = pps_register_cdev(pps);
 	if (err < 0) {
 		pr_err("pps: %s: unable to create char device\n",
 					info->name);
-		goto free_idr;
+		goto kfree_pps;
 	}
 
 	dev_info(pps->dev, "new PPS source %s\n", info->name);
 
 	return pps;
 
-free_idr:
-	spin_lock_irq(&pps_idr_lock);
-	idr_remove(&pps_idr, id);
-	spin_unlock_irq(&pps_idr_lock);
-
 kfree_pps:
 	kfree(pps);
 
@@ -183,13 +138,7 @@ EXPORT_SYMBOL(pps_register_source);
 
 void pps_unregister_source(struct pps_device *pps)
 {
-	unsigned int id = pps->id;
-
 	pps_unregister_cdev(pps);
-
-	spin_lock_irq(&pps_idr_lock);
-	idr_remove(&pps_idr, pps->id);
-	spin_unlock_irq(&pps_idr_lock);
 }
 EXPORT_SYMBOL(pps_unregister_source);
 
diff -puN drivers/pps/pps.c~pps-move-idr-stuff-to-ppsc drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-move-idr-stuff-to-ppsc
+++ a/drivers/pps/pps.c
@@ -29,6 +29,7 @@
 #include <linux/cdev.h>
 #include <linux/poll.h>
 #include <linux/pps_kernel.h>
+#include <linux/slab.h>
 
 /*
  * Local variables
@@ -37,6 +38,9 @@
 static dev_t pps_devt;
 static struct class *pps_class;
 
+static DEFINE_SPINLOCK(pps_idr_lock);
+static DEFINE_IDR(pps_idr);
+
 /*
  * Char device methods
  */
@@ -228,11 +232,47 @@ static const struct file_operations pps_
 	.release	= pps_cdev_release,
 };
 
+static void pps_device_destruct(struct device *dev)
+{
+	struct pps_device *pps = dev_get_drvdata(dev);
+
+	/* release id here to protect others from using it while it's
+	 * still in use */
+	spin_lock_irq(&pps_idr_lock);
+	idr_remove(&pps_idr, pps->id);
+	spin_unlock_irq(&pps_idr_lock);
+
+	kfree(dev);
+}
+
 int pps_register_cdev(struct pps_device *pps)
 {
 	int err;
 	dev_t devt;
 
+	/* Get new ID for the new PPS source */
+	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0)
+		return -ENOMEM;
+
+	/* Now really allocate the PPS source.
+	 * After idr_get_new() calling the new source will be freely available
+	 * into the kernel.
+	 */
+	spin_lock_irq(&pps_idr_lock);
+	err = idr_get_new(&pps_idr, pps, &pps->id);
+	spin_unlock_irq(&pps_idr_lock);
+
+	if (err < 0)
+		return err;
+
+	pps->id &= MAX_ID_MASK;
+	if (pps->id >= PPS_MAX_SOURCES) {
+		pr_err("pps: %s: too many PPS sources in the system\n",
+					pps->info.name);
+		err = -EBUSY;
+		goto free_idr;
+	}
+
 	devt = MKDEV(MAJOR(pps_devt), pps->id);
 
 	cdev_init(&pps->cdev, &pps_cdev_fops);
@@ -242,13 +282,15 @@ int pps_register_cdev(struct pps_device 
 	if (err) {
 		pr_err("pps: %s: failed to add char device %d:%d\n",
 				pps->info.name, MAJOR(pps_devt), pps->id);
-		return err;
+		goto free_idr;
 	}
 	pps->dev = device_create(pps_class, pps->info.dev, devt, pps,
 							"pps%d", pps->id);
 	if (IS_ERR(pps->dev))
 		goto del_cdev;
 
+	pps->dev->release = pps_device_destruct;
+
 	pr_debug("source %s got cdev (%d:%d)\n", pps->info.name,
 			MAJOR(pps_devt), pps->id);
 
@@ -257,6 +299,11 @@ int pps_register_cdev(struct pps_device 
 del_cdev:
 	cdev_del(&pps->cdev);
 
+free_idr:
+	spin_lock_irq(&pps_idr_lock);
+	idr_remove(&pps_idr, pps->id);
+	spin_unlock_irq(&pps_idr_lock);
+
 	return err;
 }
 
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-add-async-pps-event-handler.patch
pps-dont-disable-interrupts-when-using-spin-locks.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

