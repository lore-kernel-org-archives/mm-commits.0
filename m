From: akpm@linux-foundation.org
Subject: + gigaset-permit-module-unload.patch added to -mm tree
Date: Mon, 03 Dec 2007 14:18:41 -0800
Message-ID: <200712032218.lB3MIf1X020398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53363 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbXLCWTR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 17:19:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, gregkh@suse.de, hjlipp@web.de, kkeil@suse.de


The patch titled
     Gigaset: permit module unload
has been added to the -mm tree.  Its filename is
     gigaset-permit-module-unload.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Gigaset: permit module unload
From: Tilman Schmidt <tilman@imap.cc>

Fix the initialization and reference counting of the Gigaset driver modules
so that they can be unloaded when they are not actually in use.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Cc: Hansjoerg Lipp <hjlipp@web.de>
Cc: Greg KH <gregkh@suse.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/bas-gigaset.c |   80 ++++++++++----------
 drivers/isdn/gigaset/common.c      |  105 +++++++--------------------
 drivers/isdn/gigaset/gigaset.h     |    8 --
 drivers/isdn/gigaset/interface.c   |    4 -
 drivers/isdn/gigaset/usb-gigaset.c |   30 +++----
 5 files changed, 85 insertions(+), 142 deletions(-)

diff -puN drivers/isdn/gigaset/bas-gigaset.c~gigaset-permit-module-unload drivers/isdn/gigaset/bas-gigaset.c
--- a/drivers/isdn/gigaset/bas-gigaset.c~gigaset-permit-module-unload
+++ a/drivers/isdn/gigaset/bas-gigaset.c
@@ -134,7 +134,6 @@ struct bas_cardstate {
 
 
 static struct gigaset_driver *driver = NULL;
-static struct cardstate *cardstate = NULL;
 
 /* usb specific object needed to register this driver with the usb subsystem */
 static struct usb_driver gigaset_usb_driver = {
@@ -2247,11 +2246,11 @@ static int gigaset_probe(struct usb_inte
 		 __func__, le16_to_cpu(udev->descriptor.idVendor),
 		 le16_to_cpu(udev->descriptor.idProduct));
 
-	cs = gigaset_getunassignedcs(driver);
-	if (!cs) {
-		dev_err(&udev->dev, "no free cardstate\n");
+	/* allocate memory for our device state and intialize it */
+	cs = gigaset_initcs(driver, BAS_CHANNELS, 0, 0, cidmode,
+			    GIGASET_MODULENAME);
+	if (!cs)
 		return -ENODEV;
-	}
 	ucs = cs->hw.bas;
 
 	/* save off device structure ptrs for later use */
@@ -2320,7 +2319,7 @@ allocerr:
 error:
 	freeurbs(cs);
 	usb_set_intfdata(interface, NULL);
-	gigaset_unassign(cs);
+	gigaset_freecs(cs);
 	return -ENODEV;
 }
 
@@ -2362,7 +2361,7 @@ static void gigaset_disconnect(struct us
 	ucs->interface = NULL;
 	ucs->udev = NULL;
 	cs->dev = NULL;
-	gigaset_unassign(cs);
+	gigaset_freecs(cs);
 }
 
 /* gigaset_suspend
@@ -2501,12 +2500,6 @@ static int __init bas_gigaset_init(void)
 				       &gigops, THIS_MODULE)) == NULL)
 		goto error;
 
-	/* allocate memory for our device state and intialize it */
-	cardstate = gigaset_initcs(driver, BAS_CHANNELS, 0, 0, cidmode,
-				   GIGASET_MODULENAME);
-	if (!cardstate)
-		goto error;
-
 	/* register this driver with the USB subsystem */
 	result = usb_register(&gigaset_usb_driver);
 	if (result < 0) {
@@ -2518,9 +2511,7 @@ static int __init bas_gigaset_init(void)
 	info(DRIVER_DESC);
 	return 0;
 
-error:	if (cardstate)
-		gigaset_freecs(cardstate);
-	cardstate = NULL;
+error:
 	if (driver)
 		gigaset_freedriver(driver);
 	driver = NULL;
@@ -2532,43 +2523,50 @@ error:	if (cardstate)
  */
 static void __exit bas_gigaset_exit(void)
 {
-	struct bas_cardstate *ucs = cardstate->hw.bas;
+	struct bas_cardstate *ucs;
+	int i;
 
 	gigaset_blockdriver(driver); /* => probe will fail
 				      * => no gigaset_start any more
 				      */
 
-	gigaset_shutdown(cardstate);
-	/* from now on, no isdn callback should be possible */
-
-	/* close all still open channels */
-	if (ucs->basstate & BS_B1OPEN) {
-		gig_dbg(DEBUG_INIT, "closing B1 channel");
-		usb_control_msg(ucs->udev, usb_sndctrlpipe(ucs->udev, 0),
-				HD_CLOSE_B1CHANNEL, OUT_VENDOR_REQ, 0, 0,
-				NULL, 0, BAS_TIMEOUT);
-	}
-	if (ucs->basstate & BS_B2OPEN) {
-		gig_dbg(DEBUG_INIT, "closing B2 channel");
-		usb_control_msg(ucs->udev, usb_sndctrlpipe(ucs->udev, 0),
-				HD_CLOSE_B2CHANNEL, OUT_VENDOR_REQ, 0, 0,
-				NULL, 0, BAS_TIMEOUT);
-	}
-	if (ucs->basstate & BS_ATOPEN) {
-		gig_dbg(DEBUG_INIT, "closing AT channel");
-		usb_control_msg(ucs->udev, usb_sndctrlpipe(ucs->udev, 0),
-				HD_CLOSE_ATCHANNEL, OUT_VENDOR_REQ, 0, 0,
-				NULL, 0, BAS_TIMEOUT);
+	/* stop all connected devices */
+	for (i = 0; i < driver->minors; i++) {
+		if (gigaset_shutdown(driver->cs + i) < 0)
+			continue;		/* no device */
+		/* from now on, no isdn callback should be possible */
+
+		/* close all still open channels */
+		ucs = driver->cs[i].hw.bas;
+		if (ucs->basstate & BS_B1OPEN) {
+			gig_dbg(DEBUG_INIT, "closing B1 channel");
+			usb_control_msg(ucs->udev,
+					usb_sndctrlpipe(ucs->udev, 0),
+					HD_CLOSE_B1CHANNEL, OUT_VENDOR_REQ,
+					0, 0, NULL, 0, BAS_TIMEOUT);
+		}
+		if (ucs->basstate & BS_B2OPEN) {
+			gig_dbg(DEBUG_INIT, "closing B2 channel");
+			usb_control_msg(ucs->udev,
+					usb_sndctrlpipe(ucs->udev, 0),
+					HD_CLOSE_B2CHANNEL, OUT_VENDOR_REQ,
+					0, 0, NULL, 0, BAS_TIMEOUT);
+		}
+		if (ucs->basstate & BS_ATOPEN) {
+			gig_dbg(DEBUG_INIT, "closing AT channel");
+			usb_control_msg(ucs->udev,
+					usb_sndctrlpipe(ucs->udev, 0),
+					HD_CLOSE_ATCHANNEL, OUT_VENDOR_REQ,
+					0, 0, NULL, 0, BAS_TIMEOUT);
+		}
+		ucs->basstate = 0;
 	}
-	ucs->basstate = 0;
 
 	/* deregister this driver with the USB subsystem */
 	usb_deregister(&gigaset_usb_driver);
 	/* this will call the disconnect-callback */
 	/* from now on, no disconnect/probe callback should be running */
 
-	gigaset_freecs(cardstate);
-	cardstate = NULL;
 	gigaset_freedriver(driver);
 	driver = NULL;
 }
diff -puN drivers/isdn/gigaset/common.c~gigaset-permit-module-unload drivers/isdn/gigaset/common.c
--- a/drivers/isdn/gigaset/common.c~gigaset-permit-module-unload
+++ a/drivers/isdn/gigaset/common.c
@@ -31,7 +31,6 @@ MODULE_PARM_DESC(debug, "debug level");
 /* driver state flags */
 #define VALID_MINOR	0x01
 #define VALID_ID	0x02
-#define ASSIGNED	0x04
 
 void gigaset_dbg_buffer(enum debuglevel level, const unsigned char *msg,
 			size_t len, const unsigned char *buf)
@@ -178,7 +177,7 @@ int gigaset_get_channel(struct bc_state 
 	unsigned long flags;
 
 	spin_lock_irqsave(&bcs->cs->lock, flags);
-	if (bcs->use_count) {
+	if (bcs->use_count || !try_module_get(bcs->cs->driver->owner)) {
 		gig_dbg(DEBUG_ANY, "could not allocate channel %d",
 			bcs->channel);
 		spin_unlock_irqrestore(&bcs->cs->lock, flags);
@@ -203,6 +202,7 @@ void gigaset_free_channel(struct bc_stat
 	}
 	--bcs->use_count;
 	bcs->busy = 0;
+	module_put(bcs->cs->driver->owner);
 	gig_dbg(DEBUG_ANY, "freed channel %d", bcs->channel);
 	spin_unlock_irqrestore(&bcs->cs->lock, flags);
 }
@@ -356,31 +356,28 @@ static struct cardstate *alloc_cs(struct
 {
 	unsigned long flags;
 	unsigned i;
+	struct cardstate *cs;
 	struct cardstate *ret = NULL;
 
 	spin_lock_irqsave(&drv->lock, flags);
+	if (drv->blocked)
+		goto exit;
 	for (i = 0; i < drv->minors; ++i) {
-		if (!(drv->flags[i] & VALID_MINOR)) {
-			if (try_module_get(drv->owner)) {
-				drv->flags[i] = VALID_MINOR;
-				ret = drv->cs + i;
-			}
+		cs = drv->cs + i;
+		if (!(cs->flags & VALID_MINOR)) {
+			cs->flags = VALID_MINOR;
+			ret = cs;
 			break;
 		}
 	}
+exit:
 	spin_unlock_irqrestore(&drv->lock, flags);
 	return ret;
 }
 
 static void free_cs(struct cardstate *cs)
 {
-	unsigned long flags;
-	struct gigaset_driver *drv = cs->driver;
-	spin_lock_irqsave(&drv->lock, flags);
-	if (drv->flags[cs->minor_index] & VALID_MINOR)
-		module_put(drv->owner);
-	drv->flags[cs->minor_index] = 0;
-	spin_unlock_irqrestore(&drv->lock, flags);
+	cs->flags = 0;
 }
 
 static void make_valid(struct cardstate *cs, unsigned mask)
@@ -388,7 +385,7 @@ static void make_valid(struct cardstate 
 	unsigned long flags;
 	struct gigaset_driver *drv = cs->driver;
 	spin_lock_irqsave(&drv->lock, flags);
-	drv->flags[cs->minor_index] |= mask;
+	cs->flags |= mask;
 	spin_unlock_irqrestore(&drv->lock, flags);
 }
 
@@ -397,7 +394,7 @@ static void make_invalid(struct cardstat
 	unsigned long flags;
 	struct gigaset_driver *drv = cs->driver;
 	spin_lock_irqsave(&drv->lock, flags);
-	drv->flags[cs->minor_index] &= ~mask;
+	cs->flags &= ~mask;
 	spin_unlock_irqrestore(&drv->lock, flags);
 }
 
@@ -893,10 +890,17 @@ error:
 }
 EXPORT_SYMBOL_GPL(gigaset_start);
 
-void gigaset_shutdown(struct cardstate *cs)
+/* gigaset_shutdown
+ * check if a device is associated to the cardstate structure and stop it
+ * return value: 0 if ok, -1 if no device was associated
+ */
+int gigaset_shutdown(struct cardstate *cs)
 {
 	mutex_lock(&cs->mutex);
 
+	if (!(cs->flags & VALID_MINOR))
+		return -1;
+
 	cs->waiting = 1;
 
 	if (!gigaset_add_event(cs, &cs->at_state, EV_SHUTDOWN, NULL, 0, NULL)) {
@@ -913,6 +917,7 @@ void gigaset_shutdown(struct cardstate *
 
 exit:
 	mutex_unlock(&cs->mutex);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(gigaset_shutdown);
 
@@ -954,13 +959,11 @@ struct cardstate *gigaset_get_cs_by_id(i
 	list_for_each_entry(drv, &drivers, list) {
 		spin_lock(&drv->lock);
 		for (i = 0; i < drv->minors; ++i) {
-			if (drv->flags[i] & VALID_ID) {
-				cs = drv->cs + i;
-				if (cs->myid == id)
-					ret = cs;
-			}
-			if (ret)
+			cs = drv->cs + i;
+			if ((cs->flags & VALID_ID) && cs->myid == id) {
+				ret = cs;
 				break;
+			}
 		}
 		spin_unlock(&drv->lock);
 		if (ret)
@@ -983,10 +986,9 @@ void gigaset_debugdrivers(void)
 		spin_lock(&drv->lock);
 		for (i = 0; i < drv->minors; ++i) {
 			gig_dbg(DEBUG_DRIVER, "  index %u", i);
-			gig_dbg(DEBUG_DRIVER, "    flags 0x%02x",
-				drv->flags[i]);
 			cs = drv->cs + i;
 			gig_dbg(DEBUG_DRIVER, "    cardstate %p", cs);
+			gig_dbg(DEBUG_DRIVER, "    flags 0x%02x", cs->flags);
 			gig_dbg(DEBUG_DRIVER, "    minor_index %u",
 				cs->minor_index);
 			gig_dbg(DEBUG_DRIVER, "    driver %p", cs->driver);
@@ -1010,7 +1012,7 @@ static struct cardstate *gigaset_get_cs_
 			continue;
 		index = minor - drv->minor;
 		spin_lock(&drv->lock);
-		if (drv->flags[index] & VALID_MINOR)
+		if (drv->cs[index].flags & VALID_MINOR)
 			ret = drv->cs + index;
 		spin_unlock(&drv->lock);
 		if (ret)
@@ -1038,7 +1040,6 @@ void gigaset_freedriver(struct gigaset_d
 	gigaset_if_freedriver(drv);
 
 	kfree(drv->cs);
-	kfree(drv->flags);
 	kfree(drv);
 }
 EXPORT_SYMBOL_GPL(gigaset_freedriver);
@@ -1080,12 +1081,8 @@ struct gigaset_driver *gigaset_initdrive
 	if (!drv->cs)
 		goto error;
 
-	drv->flags = kmalloc(minors * sizeof *drv->flags, GFP_KERNEL);
-	if (!drv->flags)
-		goto error;
-
 	for (i = 0; i < minors; ++i) {
-		drv->flags[i] = 0;
+		drv->cs[i].flags = 0;
 		drv->cs[i].driver = drv;
 		drv->cs[i].ops = drv->ops;
 		drv->cs[i].minor_index = i;
@@ -1106,53 +1103,9 @@ error:
 }
 EXPORT_SYMBOL_GPL(gigaset_initdriver);
 
-/* For drivers without fixed assignment device<->cardstate (usb) */
-struct cardstate *gigaset_getunassignedcs(struct gigaset_driver *drv)
-{
-	unsigned long flags;
-	struct cardstate *cs = NULL;
-	unsigned i;
-
-	spin_lock_irqsave(&drv->lock, flags);
-	if (drv->blocked)
-		goto exit;
-	for (i = 0; i < drv->minors; ++i) {
-		if ((drv->flags[i] & VALID_MINOR) &&
-		    !(drv->flags[i] & ASSIGNED)) {
-			drv->flags[i] |= ASSIGNED;
-			cs = drv->cs + i;
-			break;
-		}
-	}
-exit:
-	spin_unlock_irqrestore(&drv->lock, flags);
-	return cs;
-}
-EXPORT_SYMBOL_GPL(gigaset_getunassignedcs);
-
-void gigaset_unassign(struct cardstate *cs)
-{
-	unsigned long flags;
-	unsigned *minor_flags;
-	struct gigaset_driver *drv;
-
-	if (!cs)
-		return;
-	drv = cs->driver;
-	spin_lock_irqsave(&drv->lock, flags);
-	minor_flags = drv->flags + cs->minor_index;
-	if (*minor_flags & VALID_MINOR)
-		*minor_flags &= ~ASSIGNED;
-	spin_unlock_irqrestore(&drv->lock, flags);
-}
-EXPORT_SYMBOL_GPL(gigaset_unassign);
-
 void gigaset_blockdriver(struct gigaset_driver *drv)
 {
-	unsigned long flags;
-	spin_lock_irqsave(&drv->lock, flags);
 	drv->blocked = 1;
-	spin_unlock_irqrestore(&drv->lock, flags);
 }
 EXPORT_SYMBOL_GPL(gigaset_blockdriver);
 
diff -puN drivers/isdn/gigaset/gigaset.h~gigaset-permit-module-unload drivers/isdn/gigaset/gigaset.h
--- a/drivers/isdn/gigaset/gigaset.h~gigaset-permit-module-unload
+++ a/drivers/isdn/gigaset/gigaset.h
@@ -435,6 +435,7 @@ struct cardstate {
 	unsigned minor_index;
 	struct device *dev;
 	struct device *tty_dev;
+	unsigned flags;
 
 	const struct gigaset_ops *ops;
 
@@ -539,7 +540,6 @@ struct gigaset_driver {
 	unsigned minor;
 	unsigned minors;
 	struct cardstate *cs;
-	unsigned *flags;
 	int blocked;
 
 	const struct gigaset_ops *ops;
@@ -767,10 +767,6 @@ void gigaset_freedriver(struct gigaset_d
 void gigaset_debugdrivers(void);
 struct cardstate *gigaset_get_cs_by_tty(struct tty_struct *tty);
 struct cardstate *gigaset_get_cs_by_id(int id);
-
-/* For drivers without fixed assignment device<->cardstate (usb) */
-struct cardstate *gigaset_getunassignedcs(struct gigaset_driver *drv);
-void gigaset_unassign(struct cardstate *cs);
 void gigaset_blockdriver(struct gigaset_driver *drv);
 
 /* Allocate and initialize card state. Calls hardware dependent
@@ -789,7 +785,7 @@ int gigaset_start(struct cardstate *cs);
 void gigaset_stop(struct cardstate *cs);
 
 /* Tell common.c that the driver is being unloaded. */
-void gigaset_shutdown(struct cardstate *cs);
+int gigaset_shutdown(struct cardstate *cs);
 
 /* Tell common.c that an skb has been sent. */
 void gigaset_skb_sent(struct bc_state *bcs, struct sk_buff *skb);
diff -puN drivers/isdn/gigaset/interface.c~gigaset-permit-module-unload drivers/isdn/gigaset/interface.c
--- a/drivers/isdn/gigaset/interface.c~gigaset-permit-module-unload
+++ a/drivers/isdn/gigaset/interface.c
@@ -161,7 +161,7 @@ static int if_open(struct tty_struct *tt
 	tty->driver_data = NULL;
 
 	cs = gigaset_get_cs_by_tty(tty);
-	if (!cs)
+	if (!cs || !try_module_get(cs->driver->owner))
 		return -ENODEV;
 
 	if (mutex_lock_interruptible(&cs->mutex))
@@ -207,6 +207,8 @@ static void if_close(struct tty_struct *
 	}
 
 	mutex_unlock(&cs->mutex);
+
+	module_put(cs->driver->owner);
 }
 
 static int if_ioctl(struct tty_struct *tty, struct file *file,
diff -puN drivers/isdn/gigaset/usb-gigaset.c~gigaset-permit-module-unload drivers/isdn/gigaset/usb-gigaset.c
--- a/drivers/isdn/gigaset/usb-gigaset.c~gigaset-permit-module-unload
+++ a/drivers/isdn/gigaset/usb-gigaset.c
@@ -115,7 +115,6 @@ static int gigaset_resume(struct usb_int
 static int gigaset_pre_reset(struct usb_interface *intf);
 
 static struct gigaset_driver *driver = NULL;
-static struct cardstate *cardstate = NULL;
 
 /* usb specific object needed to register this driver with the usb subsystem */
 static struct usb_driver gigaset_usb_driver = {
@@ -727,11 +726,10 @@ static int gigaset_probe(struct usb_inte
 
 	dev_info(&udev->dev, "%s: Device matched ... !\n", __func__);
 
-	cs = gigaset_getunassignedcs(driver);
-	if (!cs) {
-		dev_warn(&udev->dev, "no free cardstate\n");
+	/* allocate memory for our device state and intialize it */
+	cs = gigaset_initcs(driver, 1, 1, 0, cidmode, GIGASET_MODULENAME);
+	if (!cs)
 		return -ENODEV;
-	}
 	ucs = cs->hw.usb;
 
 	/* save off device structure ptrs for later use */
@@ -818,7 +816,7 @@ error:
 	usb_put_dev(ucs->udev);
 	ucs->udev = NULL;
 	ucs->interface = NULL;
-	gigaset_unassign(cs);
+	gigaset_freecs(cs);
 	return retval;
 }
 
@@ -852,7 +850,7 @@ static void gigaset_disconnect(struct us
 	ucs->interface = NULL;
 	ucs->udev = NULL;
 	cs->dev = NULL;
-	gigaset_unassign(cs);
+	gigaset_freecs(cs);
 }
 
 /* gigaset_suspend
@@ -934,11 +932,6 @@ static int __init usb_gigaset_init(void)
 				       &ops, THIS_MODULE)) == NULL)
 		goto error;
 
-	/* allocate memory for our device state and intialize it */
-	cardstate = gigaset_initcs(driver, 1, 1, 0, cidmode, GIGASET_MODULENAME);
-	if (!cardstate)
-		goto error;
-
 	/* register this driver with the USB subsystem */
 	result = usb_register(&gigaset_usb_driver);
 	if (result < 0) {
@@ -951,9 +944,7 @@ static int __init usb_gigaset_init(void)
 	info(DRIVER_DESC);
 	return 0;
 
-error:	if (cardstate)
-		gigaset_freecs(cardstate);
-	cardstate = NULL;
+error:
 	if (driver)
 		gigaset_freedriver(driver);
 	driver = NULL;
@@ -967,11 +958,16 @@ error:	if (cardstate)
  */
 static void __exit usb_gigaset_exit(void)
 {
+	int i;
+
 	gigaset_blockdriver(driver); /* => probe will fail
 				      * => no gigaset_start any more
 				      */
 
-	gigaset_shutdown(cardstate);
+	/* stop all connected devices */
+	for (i = 0; i < driver->minors; i++)
+		gigaset_shutdown(driver->cs + i);
+
 	/* from now on, no isdn callback should be possible */
 
 	/* deregister this driver with the USB subsystem */
@@ -979,8 +975,6 @@ static void __exit usb_gigaset_exit(void
 	/* this will call the disconnect-callback */
 	/* from now on, no disconnect/probe callback should be running */
 
-	gigaset_freecs(cardstate);
-	cardstate = NULL;
 	gigaset_freedriver(driver);
 	driver = NULL;
 }
_

Patches currently in -mm which might be from tilman@imap.cc are

origin.patch
gigaset-clean-up-urb-status-usage.patch
gigaset-code-cleanups.patch
bas_gigaset-suspend-support-v2.patch
usb_gigaset-suspend-support-v3.patch
gigaset-atomic-cleanup.patch
gigaset-permit-module-unload.patch
