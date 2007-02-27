From: akpm@linux-foundation.org
Subject: + usbatm-create-sysfs-link-device-from-atm-class-device.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:50:40 -0800
Message-ID: <200702272050.l1RKoiSR028100@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51328 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbXB0UvI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:51:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: simon@arlott.org, duncan.sands@math.u-psud.fr, greg@kroah.com, simon@fire.lp0.eu


The patch titled
     usbatm: create sysfs link "device" from atm class device to usb interface
has been added to the -mm tree.  Its filename is
     usbatm-create-sysfs-link-device-from-atm-class-device.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usbatm: create sysfs link "device" from atm class device to usb interface
From: Simon Arlott <simon@arlott.org>

There is currently no path from the ATM device in /sys to the USB device's
interface that the driver is using; this patch creates a "device" symlink.  It
is then possible to get to the cxacru ADSL statistics
(http://lkml.org/lkml/2007/2/23/328):

/sys/class/atm/cxacru0/device $ ls *_rate *_margin *_attenuation
downstream_attenuation  downstream_snr_margin  upstream_rate
downstream_rate         upstream_attenuation   upstream_snr_margin

If this link is not appropriate I'd have to create device files in
/sys/class/atm/cxacru0 instead - which seems less appropriate since the ADSL
statistics are for the USB device not ATM (which is running over the ADSL).

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/usbatm.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/usb/atm/usbatm.c~usbatm-create-sysfs-link-device-from-atm-class-device drivers/usb/atm/usbatm.c
--- a/drivers/usb/atm/usbatm.c~usbatm-create-sysfs-link-device-from-atm-class-device
+++ a/drivers/usb/atm/usbatm.c
@@ -966,6 +966,12 @@ static int usbatm_atm_init(struct usbatm
 	/* temp init ATM device, set to 128kbit */
 	atm_dev->link_rate = 128 * 1000 / 424;
 
+	ret = sysfs_create_link(&atm_dev->class_dev.kobj, &instance->usb_intf->dev.kobj, "device");
+	if (ret) {
+		atm_err(instance, "%s: sysfs_create_link failed: %d\n", __func__, ret);
+		goto fail_sysfs;
+	}
+
 	if (instance->driver->atm_start && ((ret = instance->driver->atm_start(instance, atm_dev)) < 0)) {
 		atm_err(instance, "%s: atm_start failed: %d!\n", __func__, ret);
 		goto fail;
@@ -984,6 +990,8 @@ static int usbatm_atm_init(struct usbatm
 	return 0;
 
  fail:
+	sysfs_remove_link(&atm_dev->class_dev.kobj, "device");
+ fail_sysfs:
 	instance->atm_dev = NULL;
 	atm_dev_deregister(atm_dev); /* usbatm_atm_dev_close will eventually be called */
 	return ret;
@@ -1316,8 +1324,10 @@ void usbatm_usb_disconnect(struct usb_in
 	kfree(instance->cell_buf);
 
 	/* ATM finalize */
-	if (instance->atm_dev)
+	if (instance->atm_dev) {
+		sysfs_remove_link(&instance->atm_dev->class_dev.kobj, "device");
 		atm_dev_deregister(instance->atm_dev);
+	}
 
 	usbatm_put_instance(instance);	/* taken in usbatm_usb_probe */
 }
_

Patches currently in -mm which might be from simon@arlott.org are

usbatm-create-sysfs-link-device-from-atm-class-device.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
cxacru-export-detailed-device-info-through-sysfs-updated.patch
maintainers-add-myself-for-cxacru-in-drivers-usb-atm.patch
