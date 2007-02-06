From: akpm@linux-foundation.org
Subject: - usbatm-allow-sub-drivers-to-handle-calls-to-atm_proc_read.patch removed from -mm tree
Date: Mon, 05 Feb 2007 16:39:54 -0800
Message-ID: <200702060040.l160ewkF005180@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41886 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965383AbXBFAlf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 19:41:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@arlott.org, greg@kroah.com, simon@fire.lp0.eu, mm-commits@vger.kernel.org


The patch titled
     usbatm: allow sub-drivers to handle calls to atm_proc_read
has been removed from the -mm tree.  Its filename was
     usbatm-allow-sub-drivers-to-handle-calls-to-atm_proc_read.patch

This patch was dropped because an updated version will be merged

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
