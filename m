From: akpm@osdl.org
Subject: + usbatm-allow-sub-drivers-to-handle-calls-to-atm_proc_read.patch added to -mm tree
Date: Wed, 31 Jan 2007 15:43:14 -0800
Message-ID: <200701312343.l0VNhEQJ030253@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59157 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161097AbXAaXoJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 18:44:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: simon@arlott.org, greg@kroah.com, simon@fire.lp0.eu


The patch titled
     usbatm: allow sub-drivers to handle calls to atm_proc_read
has been added to the -mm tree.  Its filename is
     usbatm-allow-sub-drivers-to-handle-calls-to-atm_proc_read.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usbatm: allow sub-drivers to handle calls to atm_proc_read
From: Simon Arlott <simon@arlott.org>

usbatm only outputs basic information via the per-device /proc/net/atm/ file,
this patch allows the device specific USB ATM drivers to replace the
atm_proc_read function with their own.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/atm/usbatm.c |    3 +++
 drivers/usb/atm/usbatm.h |    3 +++
 2 files changed, 6 insertions(+)

diff -puN drivers/usb/atm/usbatm.c~usbatm-allow-sub-drivers-to-handle-calls-to-atm_proc_read drivers/usb/atm/usbatm.c
--- a/drivers/usb/atm/usbatm.c~usbatm-allow-sub-drivers-to-handle-calls-to-atm_proc_read
+++ a/drivers/usb/atm/usbatm.c
@@ -761,6 +761,9 @@ static int usbatm_atm_proc_read(struct a
 		return -ENODEV;
 	}
 
+	if (instance->driver->proc_read != NULL)
+		return instance->driver->proc_read(instance, atm_dev, pos, page);
+
 	if (!left--)
 		return sprintf(page, "%s\n", instance->description);
 
diff -puN drivers/usb/atm/usbatm.h~usbatm-allow-sub-drivers-to-handle-calls-to-atm_proc_read drivers/usb/atm/usbatm.h
--- a/drivers/usb/atm/usbatm.h~usbatm-allow-sub-drivers-to-handle-calls-to-atm_proc_read
+++ a/drivers/usb/atm/usbatm.h
@@ -121,6 +121,9 @@ struct usbatm_driver {
 	/* cleanup ATM device ... can sleep, but can't fail */
 	void (*atm_stop) (struct usbatm_data *, struct atm_dev *);
 
+	/* called when the proc file is read */
+	int (*proc_read) (struct usbatm_data *, struct atm_dev *, loff_t * pos, char *page);
+
         int bulk_in;	/* bulk rx endpoint */
         int isoc_in;	/* isochronous rx endpoint */
         int bulk_out;	/* bulk tx endpoint */
_

Patches currently in -mm which might be from simon@arlott.org are

usbatm-allow-sub-drivers-to-handle-calls-to-atm_proc_read.patch
cxacru-poll-for-device-status-more-frequently.patch
cxacru-store-all-device-status-information-and-report-it-when-atm_proc_read-is-called.patch
