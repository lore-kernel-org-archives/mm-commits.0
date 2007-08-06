From: akpm@linux-foundation.org
Subject: - cdc-acm-fix-sysfs-attribute-registration-bug.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:53:57 -0700
Message-ID: <200708060754.l767rvsN016392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55928 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758891AbXHFH5b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:57:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, greg@kroah.com, oneukum@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     cdc-acm: fix sysfs attribute registration bug
has been removed from the -mm tree.  Its filename was
     cdc-acm-fix-sysfs-attribute-registration-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cdc-acm: fix sysfs attribute registration bug
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as950) fixes a bug in the cdc-acm driver.  It doesn't keep
track of which interface (control or data) the sysfs attributes get
registered for, and as a result, during disconnect it will sometimes
attempt to remove the attributes from the wrong interface.  The
left-over attributes can cause a crash later on, particularly if the driver
module has been unloaded.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Oliver Neukum <oneukum@suse.de>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/class/cdc-acm.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff -puN drivers/usb/class/cdc-acm.c~cdc-acm-fix-sysfs-attribute-registration-bug drivers/usb/class/cdc-acm.c
--- a/drivers/usb/class/cdc-acm.c~cdc-acm-fix-sysfs-attribute-registration-bug
+++ a/drivers/usb/class/cdc-acm.c
@@ -921,6 +921,10 @@ skip_normal_probe:
 			return -EINVAL;
 		}
 	}
+
+	/* Accept probe requests only for the control interface */
+	if (intf != control_interface)
+		return -ENODEV;
 	
 	if (usb_interface_claimed(data_interface)) { /* valid in this context */
 		dev_dbg(&intf->dev,"The data interface isn't available");
@@ -1109,10 +1113,12 @@ static void acm_disconnect(struct usb_in
 		return;
 	}
 	if (acm->country_codes){
-		device_remove_file(&intf->dev, &dev_attr_wCountryCodes);
-		device_remove_file(&intf->dev, &dev_attr_iCountryCodeRelDate);
+		device_remove_file(&acm->control->dev,
+				&dev_attr_wCountryCodes);
+		device_remove_file(&acm->control->dev,
+				&dev_attr_iCountryCodeRelDate);
 	}
-	device_remove_file(&intf->dev, &dev_attr_bmCapabilities);
+	device_remove_file(&acm->control->dev, &dev_attr_bmCapabilities);
 	acm->dev = NULL;
 	usb_set_intfdata(acm->control, NULL);
 	usb_set_intfdata(acm->data, NULL);
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

nikon-d50-is-an-unusual-device.patch
