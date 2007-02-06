From: akpm@linux-foundation.org
Subject: + usb-fix-concurrent-buffer-access-in-the-hub-driver.patch added to -mm tree
Date: Tue, 06 Feb 2007 15:52:43 -0800
Message-ID: <200702062352.l16NqhP7000841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55881 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965604AbXBFXyC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 18:54:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, greg@kroah.com, stable@kernel.org


The patch titled
     USB: fix concurrent buffer access in the hub driver
has been added to the -mm tree.  Its filename is
     usb-fix-concurrent-buffer-access-in-the-hub-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: USB: fix concurrent buffer access in the hub driver
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as849) fixes a bug in the hub driver.  A single pre-allocated
buffer is used for all port status reads, but nothing guarantees exclusive
use of the buffer.  A mutex is added to provide this guarantee.

It fixes the "usb somehow broken (CONFIG_USB_SUSPEND)" bug reported by
Prakash Punnoor.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hub.c |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN drivers/usb/core/hub.c~usb-fix-concurrent-buffer-access-in-the-hub-driver drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~usb-fix-concurrent-buffer-access-in-the-hub-driver
+++ a/drivers/usb/core/hub.c
@@ -44,6 +44,7 @@ struct usb_hub {
 		struct usb_hub_status	hub;
 		struct usb_port_status	port;
 	}			*status;	/* buffer for status reports */
+	struct mutex		status_mutex;	/* for the status buffer */
 
 	int			error;		/* last reported error */
 	int			nerrors;	/* track consecutive errors */
@@ -535,6 +536,7 @@ static int hub_hub_status(struct usb_hub
 {
 	int ret;
 
+	mutex_lock(&hub->status_mutex);
 	ret = get_hub_status(hub->hdev, &hub->status->hub);
 	if (ret < 0)
 		dev_err (hub->intfdev,
@@ -544,6 +546,7 @@ static int hub_hub_status(struct usb_hub
 		*change = le16_to_cpu(hub->status->hub.wHubChange); 
 		ret = 0;
 	}
+	mutex_unlock(&hub->status_mutex);
 	return ret;
 }
 
@@ -617,6 +620,7 @@ static int hub_configure(struct usb_hub 
 		ret = -ENOMEM;
 		goto fail;
 	}
+	mutex_init(&hub->status_mutex);
 
 	hub->descriptor = kmalloc(sizeof(*hub->descriptor), GFP_KERNEL);
 	if (!hub->descriptor) {
@@ -1397,6 +1401,7 @@ static int hub_port_status(struct usb_hu
 {
 	int ret;
 
+	mutex_lock(&hub->status_mutex);
 	ret = get_port_status(hub->hdev, port1, &hub->status->port);
 	if (ret < 4) {
 		dev_err (hub->intfdev,
@@ -1408,6 +1413,7 @@ static int hub_port_status(struct usb_hu
 		*change = le16_to_cpu(hub->status->port.wPortChange); 
 		ret = 0;
 	}
+	mutex_unlock(&hub->status_mutex);
 	return ret;
 }
 
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

scsi-handle-bad-inquiry-responses.patch
fix-gregkh-usb-usbcore-remove-unused-bandwith-related-code.patch
usb-p990i-is-an-unusual-device.patch
usb-fix-concurrent-buffer-access-in-the-hub-driver.patch
arch-i386-kernel-ptracec-trivial-whitespace-cleanup.patch
