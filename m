From: akpm@linux-foundation.org
Subject: + pps-access-pps-device-by-direct-pointer.patch added to -mm tree
Date: Fri, 17 Dec 2010 16:19:56 -0800
Message-ID: <201012180019.oBI0Juxf004865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948Ab0LRAUF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Dec 2010 19:20:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@linux.it


The patch titled
     pps: access pps device by direct pointer
has been added to the -mm tree.  Its filename is
     pps-access-pps-device-by-direct-pointer.patch

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
Subject: pps: access pps device by direct pointer
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Using device index as a pointer needs some unnecessary work to be done
every time the pointer is needed (in irq handler for example).  Using a
direct pointer is much more easy (and safe as well).

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Acked-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-ktimer.c |   30 +++----
 drivers/pps/clients/pps-ldisc.c  |   41 ++++++---
 drivers/pps/kapi.c               |  124 ++++++-----------------------
 drivers/pps/pps.c                |   22 +----
 include/linux/pps_kernel.h       |   23 ++---
 5 files changed, 82 insertions(+), 158 deletions(-)

diff -puN drivers/pps/clients/pps-ktimer.c~pps-access-pps-device-by-direct-pointer drivers/pps/clients/pps-ktimer.c
--- a/drivers/pps/clients/pps-ktimer.c~pps-access-pps-device-by-direct-pointer
+++ a/drivers/pps/clients/pps-ktimer.c
@@ -31,7 +31,7 @@
  * Global variables
  */
 
-static int source;
+static struct pps_device *pps;
 static struct timer_list ktimer;
 
 /*
@@ -47,7 +47,7 @@ static void pps_ktimer_event(unsigned lo
 
 	pr_info("PPS event at %lu\n", jiffies);
 
-	pps_event(source, &ts, PPS_CAPTUREASSERT, NULL);
+	pps_event(pps, &ts, PPS_CAPTUREASSERT, NULL);
 
 	mod_timer(&ktimer, jiffies + HZ);
 }
@@ -56,12 +56,11 @@ static void pps_ktimer_event(unsigned lo
  * The echo function
  */
 
-static void pps_ktimer_echo(int source, int event, void *data)
+static void pps_ktimer_echo(struct pps_device *pps, int event, void *data)
 {
-	pr_info("echo %s %s for source %d\n",
+	dev_info(pps->dev, "echo %s %s\n",
 		event & PPS_CAPTUREASSERT ? "assert" : "",
-		event & PPS_CAPTURECLEAR ? "clear" : "",
-		source);
+		event & PPS_CAPTURECLEAR ? "clear" : "");
 }
 
 /*
@@ -84,30 +83,27 @@ static struct pps_source_info pps_ktimer
 
 static void __exit pps_ktimer_exit(void)
 {
-	del_timer_sync(&ktimer);
-	pps_unregister_source(source);
+	dev_info(pps->dev, "ktimer PPS source unregistered\n");
 
-	pr_info("ktimer PPS source unregistered\n");
+	del_timer_sync(&ktimer);
+	pps_unregister_source(pps);
 }
 
 static int __init pps_ktimer_init(void)
 {
-	int ret;
-
-	ret = pps_register_source(&pps_ktimer_info,
+	pps = pps_register_source(&pps_ktimer_info,
 				PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
-	if (ret < 0) {
+	if (pps == NULL) {
 		printk(KERN_ERR "cannot register ktimer source\n");
-		return ret;
+		return -ENOMEM;
 	}
-	source = ret;
 
 	setup_timer(&ktimer, pps_ktimer_event, 0);
 	mod_timer(&ktimer, jiffies + HZ);
 
-	pr_info("ktimer PPS source registered at %d\n", source);
+	dev_info(pps->dev, "ktimer PPS source registered\n");
 
-	return  0;
+	return 0;
 }
 
 module_init(pps_ktimer_init);
diff -puN drivers/pps/clients/pps-ldisc.c~pps-access-pps-device-by-direct-pointer drivers/pps/clients/pps-ldisc.c
--- a/drivers/pps/clients/pps-ldisc.c~pps-access-pps-device-by-direct-pointer
+++ a/drivers/pps/clients/pps-ldisc.c
@@ -29,7 +29,7 @@
 static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
 				struct pps_event_time *ts)
 {
-	int id = (long)tty->disc_data;
+	struct pps_device *pps = (struct pps_device *)tty->disc_data;
 	struct pps_event_time __ts;
 
 	/* First of all we get the time stamp... */
@@ -39,12 +39,14 @@ static void pps_tty_dcd_change(struct tt
 	if (!ts)	/* No. Do it ourself! */
 		ts = &__ts;
 
+	BUG_ON(pps == NULL);
+
 	/* Now do the PPS event report */
-	pps_event(id, ts, status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR,
-			NULL);
+	pps_event(pps, ts, status ? PPS_CAPTUREASSERT :
+			PPS_CAPTURECLEAR, NULL);
 
-	pr_debug("PPS %s at %lu on source #%d\n",
-			status ? "assert" : "clear", jiffies, id);
+	dev_dbg(pps->dev, "PPS %s at %lu\n",
+			status ? "assert" : "clear", jiffies);
 }
 
 static int (*alias_n_tty_open)(struct tty_struct *tty);
@@ -54,6 +56,7 @@ static int pps_tty_open(struct tty_struc
 	struct pps_source_info info;
 	struct tty_driver *drv = tty->driver;
 	int index = tty->index + drv->name_base;
+	struct pps_device *pps;
 	int ret;
 
 	info.owner = THIS_MODULE;
@@ -64,34 +67,42 @@ static int pps_tty_open(struct tty_struc
 			PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
 			PPS_CANWAIT | PPS_TSFMT_TSPEC;
 
-	ret = pps_register_source(&info, PPS_CAPTUREBOTH | \
+	pps = pps_register_source(&info, PPS_CAPTUREBOTH | \
 				PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
-	if (ret < 0) {
+	if (pps == NULL) {
 		pr_err("cannot register PPS source \"%s\"\n", info.path);
-		return ret;
+		return -ENOMEM;
 	}
-	tty->disc_data = (void *)(long)ret;
+	tty->disc_data = pps;
 
 	/* Should open N_TTY ldisc too */
 	ret = alias_n_tty_open(tty);
-	if (ret < 0)
-		pps_unregister_source((long)tty->disc_data);
+	if (ret < 0) {
+		pr_err("cannot open tty ldisc \"%s\"\n", info.path);
+		goto err_unregister;
+	}
 
-	pr_info("PPS source #%d \"%s\" added\n", ret, info.path);
+	dev_info(pps->dev, "source \"%s\" added\n", info.path);
 
 	return 0;
+
+err_unregister:
+	tty->disc_data = NULL;
+	pps_unregister_source(pps);
+	return ret;
 }
 
 static void (*alias_n_tty_close)(struct tty_struct *tty);
 
 static void pps_tty_close(struct tty_struct *tty)
 {
-	int id = (long)tty->disc_data;
+	struct pps_device *pps = (struct pps_device *)tty->disc_data;
 
-	pps_unregister_source(id);
 	alias_n_tty_close(tty);
 
-	pr_info("PPS source #%d removed\n", id);
+	tty->disc_data = NULL;
+	dev_info(pps->dev, "removed\n");
+	pps_unregister_source(pps);
 }
 
 static struct tty_ldisc_ops pps_ldisc_ops;
diff -puN drivers/pps/kapi.c~pps-access-pps-device-by-direct-pointer drivers/pps/kapi.c
--- a/drivers/pps/kapi.c~pps-access-pps-device-by-direct-pointer
+++ a/drivers/pps/kapi.c
@@ -32,11 +32,11 @@
 #include <linux/slab.h>
 
 /*
- * Global variables
+ * Local variables
  */
 
-DEFINE_SPINLOCK(pps_idr_lock);
-DEFINE_IDR(pps_idr);
+static DEFINE_SPINLOCK(pps_idr_lock);
+static DEFINE_IDR(pps_idr);
 
 /*
  * Local functions
@@ -60,60 +60,6 @@ static void pps_add_offset(struct pps_kt
  * Exported functions
  */
 
-/* pps_get_source - find a PPS source
- * @source: the PPS source ID.
- *
- * This function is used to find an already registered PPS source into the
- * system.
- *
- * The function returns NULL if found nothing, otherwise it returns a pointer
- * to the PPS source data struct (the refcounter is incremented by 1).
- */
-
-struct pps_device *pps_get_source(int source)
-{
-	struct pps_device *pps;
-	unsigned long flags;
-
-	spin_lock_irqsave(&pps_idr_lock, flags);
-
-	pps = idr_find(&pps_idr, source);
-	if (pps != NULL)
-		atomic_inc(&pps->usage);
-
-	spin_unlock_irqrestore(&pps_idr_lock, flags);
-
-	return pps;
-}
-
-/* pps_put_source - free the PPS source data
- * @pps: a pointer to the PPS source.
- *
- * This function is used to free a PPS data struct if its refcount is 0.
- */
-
-void pps_put_source(struct pps_device *pps)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&pps_idr_lock, flags);
-	BUG_ON(atomic_read(&pps->usage) == 0);
-
-	if (!atomic_dec_and_test(&pps->usage)) {
-		pps = NULL;
-		goto exit;
-	}
-
-	/* No more reference to the PPS source. We can safely remove the
-	 * PPS data struct.
-	 */
-	idr_remove(&pps_idr, pps->id);
-
-exit:
-	spin_unlock_irqrestore(&pps_idr_lock, flags);
-	kfree(pps);
-}
-
 /* pps_register_source - add a PPS source in the system
  * @info: the PPS info struct
  * @default_params: the default PPS parameters of the new source
@@ -122,10 +68,11 @@ exit:
  * source is described by info's fields and it will have, as default PPS
  * parameters, the ones specified into default_params.
  *
- * The function returns, in case of success, the PPS source ID.
+ * The function returns, in case of success, the PPS device. Otherwise NULL.
  */
 
-int pps_register_source(struct pps_source_info *info, int default_params)
+struct pps_device *pps_register_source(struct pps_source_info *info,
+		int default_params)
 {
 	struct pps_device *pps;
 	int id;
@@ -168,7 +115,6 @@ int pps_register_source(struct pps_sourc
 
 	init_waitqueue_head(&pps->queue);
 	spin_lock_init(&pps->lock);
-	atomic_set(&pps->usage, 1);
 
 	/* Get new ID for the new PPS source */
 	if (idr_pre_get(&pps_idr, GFP_KERNEL) == 0) {
@@ -211,7 +157,7 @@ int pps_register_source(struct pps_sourc
 
 	pr_info("new PPS source %s at ID %d\n", info->name, id);
 
-	return id;
+	return pps;
 
 free_idr:
 	spin_lock_irq(&pps_idr_lock);
@@ -224,38 +170,33 @@ kfree_pps:
 pps_register_source_exit:
 	printk(KERN_ERR "pps: %s: unable to register source\n", info->name);
 
-	return err;
+	return NULL;
 }
 EXPORT_SYMBOL(pps_register_source);
 
 /* pps_unregister_source - remove a PPS source from the system
- * @source: the PPS source ID
+ * @pps: the PPS source
  *
  * This function is used to remove a previously registered PPS source from
  * the system.
  */
 
-void pps_unregister_source(int source)
+void pps_unregister_source(struct pps_device *pps)
 {
-	struct pps_device *pps;
+	unsigned int id = pps->id;
 
-	spin_lock_irq(&pps_idr_lock);
-	pps = idr_find(&pps_idr, source);
+	pps_unregister_cdev(pps);
 
-	if (!pps) {
-		BUG();
-		spin_unlock_irq(&pps_idr_lock);
-		return;
-	}
+	spin_lock_irq(&pps_idr_lock);
+	idr_remove(&pps_idr, pps->id);
 	spin_unlock_irq(&pps_idr_lock);
 
-	pps_unregister_cdev(pps);
-	pps_put_source(pps);
+	kfree(pps);
 }
 EXPORT_SYMBOL(pps_unregister_source);
 
 /* pps_event - register a PPS event into the system
- * @source: the PPS source ID
+ * @pps: the PPS device
  * @ts: the event timestamp
  * @event: the event type
  * @data: userdef pointer
@@ -263,30 +204,24 @@ EXPORT_SYMBOL(pps_unregister_source);
  * This function is used by each PPS client in order to register a new
  * PPS event into the system (it's usually called inside an IRQ handler).
  *
- * If an echo function is associated with the PPS source it will be called
+ * If an echo function is associated with the PPS device it will be called
  * as:
- *	pps->info.echo(source, event, data);
+ *	pps->info.echo(pps, event, data);
  */
-
-void pps_event(int source, struct pps_event_time *ts, int event, void *data)
+void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
+		void *data)
 {
-	struct pps_device *pps;
 	unsigned long flags;
 	int captured = 0;
 	struct pps_ktime ts_real;
 
 	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
-		printk(KERN_ERR "pps: unknown event (%x) for source %d\n",
-			event, source);
+		dev_err(pps->dev, "unknown event (%x)\n", event);
 		return;
 	}
 
-	pps = pps_get_source(source);
-	if (!pps)
-		return;
-
-	pr_debug("PPS event on source %d at %ld.%09ld\n",
-			pps->id, ts->ts_real.tv_sec, ts->ts_real.tv_nsec);
+	dev_dbg(pps->dev, "PPS event at %ld.%09ld\n",
+			ts->ts_real.tv_sec, ts->ts_real.tv_nsec);
 
 	timespec_to_pps_ktime(&ts_real, ts->ts_real);
 
@@ -294,7 +229,7 @@ void pps_event(int source, struct pps_ev
 
 	/* Must call the echo function? */
 	if ((pps->params.mode & (PPS_ECHOASSERT | PPS_ECHOCLEAR)))
-		pps->info.echo(source, event, data);
+		pps->info.echo(pps, event, data);
 
 	/* Check the event */
 	pps->current_mode = pps->params.mode;
@@ -308,8 +243,8 @@ void pps_event(int source, struct pps_ev
 		/* Save the time stamp */
 		pps->assert_tu = ts_real;
 		pps->assert_sequence++;
-		pr_debug("capture assert seq #%u for source %d\n",
-			pps->assert_sequence, source);
+		dev_dbg(pps->dev, "capture assert seq #%u\n",
+			pps->assert_sequence);
 
 		captured = ~0;
 	}
@@ -323,8 +258,8 @@ void pps_event(int source, struct pps_ev
 		/* Save the time stamp */
 		pps->clear_tu = ts_real;
 		pps->clear_sequence++;
-		pr_debug("capture clear seq #%u for source %d\n",
-			pps->clear_sequence, source);
+		dev_dbg(pps->dev, "capture clear seq #%u\n",
+			pps->clear_sequence);
 
 		captured = ~0;
 	}
@@ -338,8 +273,5 @@ void pps_event(int source, struct pps_ev
 	}
 
 	spin_unlock_irqrestore(&pps->lock, flags);
-
-	/* Now we can release the PPS source for (possible) deregistration */
-	pps_put_source(pps);
 }
 EXPORT_SYMBOL(pps_event);
diff -puN drivers/pps/pps.c~pps-access-pps-device-by-direct-pointer drivers/pps/pps.c
--- a/drivers/pps/pps.c~pps-access-pps-device-by-direct-pointer
+++ a/drivers/pps/pps.c
@@ -204,12 +204,6 @@ static int pps_cdev_open(struct inode *i
 {
 	struct pps_device *pps = container_of(inode->i_cdev,
 						struct pps_device, cdev);
-	int found;
-
-	found = pps_get_source(pps->id) != 0;
-	if (!found)
-		return -ENODEV;
-
 	file->private_data = pps;
 
 	return 0;
@@ -217,11 +211,6 @@ static int pps_cdev_open(struct inode *i
 
 static int pps_cdev_release(struct inode *inode, struct file *file)
 {
-	struct pps_device *pps = file->private_data;
-
-	/* Free the PPS source and wake up (possible) deregistration */
-	pps_put_source(pps);
-
 	return 0;
 }
 
@@ -242,22 +231,23 @@ static const struct file_operations pps_
 int pps_register_cdev(struct pps_device *pps)
 {
 	int err;
+	dev_t devt;
+
+	devt = MKDEV(MAJOR(pps_devt), pps->id);
 
-	pps->devno = MKDEV(MAJOR(pps_devt), pps->id);
 	cdev_init(&pps->cdev, &pps_cdev_fops);
 	pps->cdev.owner = pps->info.owner;
 
-	err = cdev_add(&pps->cdev, pps->devno, 1);
+	err = cdev_add(&pps->cdev, devt, 1);
 	if (err) {
 		printk(KERN_ERR "pps: %s: failed to add char device %d:%d\n",
 				pps->info.name, MAJOR(pps_devt), pps->id);
 		return err;
 	}
-	pps->dev = device_create(pps_class, pps->info.dev, pps->devno, NULL,
+	pps->dev = device_create(pps_class, pps->info.dev, devt, pps,
 							"pps%d", pps->id);
 	if (IS_ERR(pps->dev))
 		goto del_cdev;
-	dev_set_drvdata(pps->dev, pps);
 
 	pr_debug("source %s got cdev (%d:%d)\n", pps->info.name,
 			MAJOR(pps_devt), pps->id);
@@ -272,7 +262,7 @@ del_cdev:
 
 void pps_unregister_cdev(struct pps_device *pps)
 {
-	device_destroy(pps_class, pps->devno);
+	device_destroy(pps_class, pps->dev->devt);
 	cdev_del(&pps->cdev);
 }
 
diff -puN include/linux/pps_kernel.h~pps-access-pps-device-by-direct-pointer include/linux/pps_kernel.h
--- a/include/linux/pps_kernel.h~pps-access-pps-device-by-direct-pointer
+++ a/include/linux/pps_kernel.h
@@ -31,13 +31,16 @@
  * Global defines
  */
 
+struct pps_device;
+
 /* The specific PPS source info */
 struct pps_source_info {
 	char name[PPS_MAX_NAME_LEN];		/* simbolic name */
 	char path[PPS_MAX_NAME_LEN];		/* path of connected device */
 	int mode;				/* PPS's allowed mode */
 
-	void (*echo)(int source, int event, void *data); /* PPS echo function */
+	void (*echo)(struct pps_device *pps,
+			int event, void *data);	/* PPS echo function */
 
 	struct module *owner;
 	struct device *dev;
@@ -65,35 +68,27 @@ struct pps_device {
 	unsigned int id;			/* PPS source unique ID */
 	struct cdev cdev;
 	struct device *dev;
-	int devno;
 	struct fasync_struct *async_queue;	/* fasync method */
 	spinlock_t lock;
-
-	atomic_t usage;				/* usage count */
 };
 
 /*
  * Global variables
  */
 
-extern spinlock_t pps_idr_lock;
-extern struct idr pps_idr;
-
 extern struct device_attribute pps_attrs[];
 
 /*
  * Exported functions
  */
 
-struct pps_device *pps_get_source(int source);
-extern void pps_put_source(struct pps_device *pps);
-extern int pps_register_source(struct pps_source_info *info,
-				int default_params);
-extern void pps_unregister_source(int source);
+extern struct pps_device *pps_register_source(
+		struct pps_source_info *info, int default_params);
+extern void pps_unregister_source(struct pps_device *pps);
 extern int pps_register_cdev(struct pps_device *pps);
 extern void pps_unregister_cdev(struct pps_device *pps);
-extern void pps_event(int source, struct pps_event_time *ts, int event,
-		void *data);
+extern void pps_event(struct pps_device *pps,
+		struct pps_event_time *ts, int event, void *data);
 
 static inline void timespec_to_pps_ktime(struct pps_ktime *kt,
 		struct timespec ts)
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-do-not-disable-interrupts-for-idr-operations.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
pps-timestamp-is-always-passed-to-dcd_change.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

