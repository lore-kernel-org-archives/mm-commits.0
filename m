From: akpm@linux-foundation.org
Subject: - cxacru-create-sysfs-attributes-in-atm_start-instead-of-bind.patch removed from -mm tree
Date: Mon, 21 May 2007 16:17:13 -0700
Message-ID: <200705212317.l4LNHCuB022451@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50193 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756955AbXEUXUP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 19:20:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@fire.lp0.eu, duncan.sands@math.u-psud.fr, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     cxacru: create sysfs attributes in atm_start instead of bind
has been removed from the -mm tree.  Its filename was
     cxacru-create-sysfs-attributes-in-atm_start-instead-of-bind.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cxacru: create sysfs attributes in atm_start instead of bind
From: Simon Arlott <simon@fire.lp0.eu>

Since usbatm doesn't set the usb_interface driver data until after calling
bind and heavy_init, it would be NULL when the sysfs attributes are read. 
Reading the MAC address from atm_dev before atm_dev exists would have been
be possible too.

Calling create_device_file in atm_start will avoid this problem, and the
data is useless until the first status poll runs.  However, it must be
ready before a status poll does a printk on line status change otherwise
userspace could react before the files exist.

For completeness I've moved remove_device_file to atm_stop so it's not
called in unbind when it's not needed.  There's no point starting ADSL if
atm_start could still fail either.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/cxacru.c |   45 ++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff -puN drivers/usb/atm/cxacru.c~cxacru-create-sysfs-attributes-in-atm_start-instead-of-bind drivers/usb/atm/cxacru.c
--- a/drivers/usb/atm/cxacru.c~cxacru-create-sysfs-attributes-in-atm_start-instead-of-bind
+++ a/drivers/usb/atm/cxacru.c
@@ -618,10 +618,22 @@ static int cxacru_card_status(struct cxa
 	return 0;
 }
 
+static void cxacru_remove_device_files(struct usbatm_data *usbatm_instance,
+		struct atm_dev *atm_dev)
+{
+	struct usb_interface *intf = usbatm_instance->usb_intf;
+
+	#define CXACRU_DEVICE_REMOVE_FILE(_name) \
+		device_remove_file(&intf->dev, &dev_attr_##_name);
+	CXACRU_ALL_FILES(REMOVE);
+	#undef CXACRU_DEVICE_REMOVE_FILE
+}
+
 static int cxacru_atm_start(struct usbatm_data *usbatm_instance,
 		struct atm_dev *atm_dev)
 {
 	struct cxacru_data *instance = usbatm_instance->driver_data;
+	struct usb_interface *intf = usbatm_instance->usb_intf;
 	/*
 	struct atm_dev *atm_dev = usbatm_instance->atm_dev;
 	*/
@@ -638,6 +650,13 @@ static int cxacru_atm_start(struct usbat
 		return ret;
 	}
 
+	#define CXACRU_DEVICE_CREATE_FILE(_name) \
+		ret = device_create_file(&intf->dev, &dev_attr_##_name); \
+		if (unlikely(ret)) \
+			goto fail_sysfs;
+	CXACRU_ALL_FILES(CREATE);
+	#undef CXACRU_DEVICE_CREATE_FILE
+
 	/* start ADSL */
 	mutex_lock(&instance->adsl_state_serialize);
 	ret = cxacru_cm(instance, CM_REQUEST_CHIP_ADSL_LINE_START, NULL, 0, NULL, 0);
@@ -669,6 +688,11 @@ static int cxacru_atm_start(struct usbat
 	if (start_polling)
 		cxacru_poll_status(&instance->poll_work.work);
 	return 0;
+
+fail_sysfs:
+	usb_err(usbatm_instance, "cxacru_atm_start: device_create_file failed (%d)\n", ret);
+	cxacru_remove_device_files(usbatm_instance, atm_dev);
+	return ret;
 }
 
 static void cxacru_poll_status(struct work_struct *work)
@@ -1054,13 +1078,6 @@ static int cxacru_bind(struct usbatm_dat
 		goto fail;
 	}
 
-	#define CXACRU_DEVICE_CREATE_FILE(_name) \
-		ret = device_create_file(&intf->dev, &dev_attr_##_name); \
-		if (unlikely(ret)) \
-			goto fail_sysfs;
-	CXACRU_ALL_FILES(CREATE);
-	#undef CXACRU_DEVICE_CREATE_FILE
-
 	usb_fill_int_urb(instance->rcv_urb,
 			usb_dev, usb_rcvintpipe(usb_dev, CXACRU_EP_CMD),
 			instance->rcv_buf, PAGE_SIZE,
@@ -1081,14 +1098,6 @@ static int cxacru_bind(struct usbatm_dat
 
 	return 0;
 
- fail_sysfs:
-	dbg("cxacru_bind: device_create_file failed (%d)\n", ret);
-
-	#define CXACRU_DEVICE_REMOVE_FILE(_name) \
-		device_remove_file(&intf->dev, &dev_attr_##_name);
-	CXACRU_ALL_FILES(REMOVE);
-	#undef CXACRU_DEVICE_REVOVE_FILE
-
  fail:
 	free_page((unsigned long) instance->snd_buf);
 	free_page((unsigned long) instance->rcv_buf);
@@ -1135,11 +1144,6 @@ static void cxacru_unbind(struct usbatm_
 	free_page((unsigned long) instance->snd_buf);
 	free_page((unsigned long) instance->rcv_buf);
 
-	#define CXACRU_DEVICE_REMOVE_FILE(_name) \
-		device_remove_file(&intf->dev, &dev_attr_##_name);
-	CXACRU_ALL_FILES(REMOVE);
-	#undef CXACRU_DEVICE_REVOVE_FILE
-
 	kfree(instance);
 
 	usbatm_instance->driver_data = NULL;
@@ -1220,6 +1224,7 @@ static struct usbatm_driver cxacru_drive
 	.heavy_init	= cxacru_heavy_init,
 	.unbind		= cxacru_unbind,
 	.atm_start	= cxacru_atm_start,
+	.atm_stop	= cxacru_remove_device_files,
 	.bulk_in	= CXACRU_EP_DATA,
 	.bulk_out	= CXACRU_EP_DATA,
 	.rx_padding	= 3,
_

Patches currently in -mm which might be from simon@fire.lp0.eu are

origin.patch
git-dvb.patch
git-sh.patch
git-xtensa.patch
