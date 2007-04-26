From: akpm@linux-foundation.org
Subject: - usb-cxacru-adsl-state-management-udpate.patch removed from -mm tree
Date: Thu, 26 Apr 2007 00:36:49 -0700
Message-ID: <200704260736.l3Q7ankS024342@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933174AbXDZHhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 03:37:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@fire.lp0.eu, duncan.sands@math.u-psud.fr, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     usb-cxacru-adsl-state-management update
has been removed from the -mm tree.  Its filename was
     usb-cxacru-adsl-state-management-udpate.patch

This patch was dropped because it was folded into usb-cxacru-adsl-state-management.patch

------------------------------------------------------
Subject: usb-cxacru-adsl-state-management update
From: Simon Arlott <simon@fire.lp0.eu>

Revision 2+3: Add adsl_state_serialize mutex and use it around ADSL start/stop
commands followed by deciding on the poll state.  Fix mishandling of -EIO
return value.  Allow newlines etc.  at the end of adsl_state commands.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/cxacru.c |   41 +++++++++++++++++++++++++++----------
 1 files changed, 31 insertions(+), 10 deletions(-)

diff -puN drivers/usb/atm/cxacru.c~usb-cxacru-adsl-state-management-udpate drivers/usb/atm/cxacru.c
--- a/drivers/usb/atm/cxacru.c~usb-cxacru-adsl-state-management-udpate
+++ a/drivers/usb/atm/cxacru.c
@@ -166,6 +166,7 @@ struct cxacru_data {
 	const struct cxacru_modem_type *modem_type;
 
 	int line_status;
+	struct mutex adsl_state_serialize;
 	int adsl_status;
 	struct delayed_work poll_work;
 	u32 card_info[CXINF_MAX];
@@ -320,13 +321,23 @@ static ssize_t cxacru_sysfs_store_adsl_s
 	struct usb_interface *intf = to_usb_interface(dev);
 	struct usbatm_data *usbatm_instance = usb_get_intfdata(intf);
 	struct cxacru_data *instance = usbatm_instance->driver_data;
-	int ret = 0;
+	int ret;
 	int poll = -1;
+	char str_cmd[8];
+	int len = strlen(buf);
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EACCES;
 
-	if (!strcmp(buf, "stop") || !strcmp(buf, "restart")) {
+	ret = sscanf(buf, "%7s", str_cmd);
+	if (ret != 1)
+		return -EINVAL;
+	ret = 0;
+
+	if (mutex_lock_interruptible(&instance->adsl_state_serialize))
+		return -ERESTARTSYS;
+
+	if (!strcmp(str_cmd, "stop") || !strcmp(str_cmd, "restart")) {
 		ret = cxacru_cm(instance, CM_REQUEST_CHIP_ADSL_LINE_STOP, NULL, 0, NULL, 0);
 		if (ret < 0) {
 			atm_err(usbatm_instance, "change adsl state:"
@@ -334,7 +345,7 @@ static ssize_t cxacru_sysfs_store_adsl_s
 
 			ret = -EIO;
 		} else {
-			ret = strlen(buf);
+			ret = len;
 			poll = CXPOLL_STOPPED;
 		}
 	}
@@ -343,10 +354,10 @@ static ssize_t cxacru_sysfs_store_adsl_s
 	 * and the device appears to only react to
 	 * START/STOP every second too. Wait 1.5s to
 	 * be sure that restart will have an effect. */
-	if (!strcmp(buf, "restart"))
+	if (!strcmp(str_cmd, "restart"))
 		msleep(1500);
 
-	if (!strcmp(buf, "start") || !strcmp(buf, "restart")) {
+	if (!strcmp(str_cmd, "start") || !strcmp(str_cmd, "restart")) {
 		ret = cxacru_cm(instance, CM_REQUEST_CHIP_ADSL_LINE_START, NULL, 0, NULL, 0);
 		if (ret < 0) {
 			atm_err(usbatm_instance, "change adsl state:"
@@ -354,18 +365,20 @@ static ssize_t cxacru_sysfs_store_adsl_s
 
 			ret = -EIO;
 		} else {
-			ret = strlen(buf);
+			ret = len;
 			poll = CXPOLL_POLLING;
 		}
 	}
 
-	if (!strcmp(buf, "poll")) {
-		ret = strlen(buf);
+	if (!strcmp(str_cmd, "poll")) {
+		ret = len;
 		poll = CXPOLL_POLLING;
 	}
 
-	if (!ret)
-		return -EINVAL;
+	if (ret == 0) {
+		ret = -EINVAL;
+		poll = -1;
+	}
 
 	if (poll == CXPOLL_POLLING) {
 		mutex_lock(&instance->poll_state_serialize);
@@ -392,6 +405,8 @@ static ssize_t cxacru_sysfs_store_adsl_s
 		mutex_unlock(&instance->poll_state_serialize);
 	}
 
+	mutex_unlock(&instance->adsl_state_serialize);
+
 	if (poll == CXPOLL_POLLING)
 		cxacru_poll_status(&instance->poll_work.work);
 
@@ -635,9 +650,11 @@ static int cxacru_atm_start(struct usbat
 	}
 
 	/* start ADSL */
+	mutex_lock(&instance->adsl_state_serialize);
 	ret = cxacru_cm(instance, CM_REQUEST_CHIP_ADSL_LINE_START, NULL, 0, NULL, 0);
 	if (ret < 0) {
 		atm_err(usbatm_instance, "cxacru_atm_start: CHIP_ADSL_LINE_START returned %d\n", ret);
+		mutex_unlock(&instance->adsl_state_serialize);
 		return ret;
 	}
 
@@ -658,6 +675,7 @@ static int cxacru_atm_start(struct usbat
 		start_polling = 0;
 	}
 	mutex_unlock(&instance->poll_state_serialize);
+	mutex_unlock(&instance->adsl_state_serialize);
 
 	if (start_polling)
 		cxacru_poll_status(&instance->poll_work.work);
@@ -1014,11 +1032,14 @@ static int cxacru_bind(struct usbatm_dat
 	instance->usbatm = usbatm_instance;
 	instance->modem_type = (struct cxacru_modem_type *) id->driver_info;
 	memset(instance->card_info, 0, sizeof(instance->card_info));
+
 	mutex_init(&instance->poll_state_serialize);
 	instance->poll_state = CXPOLL_STOPPED;
 	instance->line_status = -1;
 	instance->adsl_status = -1;
 
+	mutex_init(&instance->adsl_state_serialize);
+
 	instance->rcv_buf = (u8 *) __get_free_page(GFP_KERNEL);
 	if (!instance->rcv_buf) {
 		dbg("cxacru_bind: no memory for rcv_buf");
_

Patches currently in -mm which might be from simon@fire.lp0.eu are

ohci1394-fix-mistake-in-printk-message.patch
usbatm-detect-usb-device-shutdown-and-ignore-failed-urbs.patch
usb-cxacru-adsl-state-management.patch
usb-cxacru-adsl-state-management-udpate.patch
cxacru-add-documentation-file.patch
cxacru-add-documentation-file-fix.patch
