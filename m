From: akpm@linux-foundation.org
Subject: - fix-null-pointer-dereference-in-appledisplay-driver.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:42:43 -0800
Message-ID: <200702122242.l1CMghue013445@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44957 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030262AbXBLWoU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:44:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux-kernel@hansmi.ch, benh@kernel.crashing.org, greg@kroah.com, lenb@kernel.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     null pointer dereference in appledisplay driver
has been removed from the -mm tree.  Its filename was
     fix-null-pointer-dereference-in-appledisplay-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: null pointer dereference in appledisplay driver
From: Michael Hanselmann <linux-kernel@hansmi.ch>

Commit 40b20c257a13c5a526ac540bc5e43d0fdf29792a by Len Brown introduced
a null pointer dereference in the appledisplay driver. This patch fixes
it.

Signed-off-by: Michael Hanselmann <linux-kernel@hansmi.ch>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/misc/appledisplay.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/misc/appledisplay.c~fix-null-pointer-dereference-in-appledisplay-driver drivers/usb/misc/appledisplay.c
--- a/drivers/usb/misc/appledisplay.c~fix-null-pointer-dereference-in-appledisplay-driver
+++ a/drivers/usb/misc/appledisplay.c
@@ -281,8 +281,8 @@ static int appledisplay_probe(struct usb
 	/* Register backlight device */
 	snprintf(bl_name, sizeof(bl_name), "appledisplay%d",
 		atomic_inc_return(&count_displays) - 1);
-	pdata->bd = backlight_device_register(bl_name, NULL, NULL,
-						&appledisplay_bl_data);
+	pdata->bd = backlight_device_register(bl_name, NULL,
+		pdata, &appledisplay_bl_data);
 	if (IS_ERR(pdata->bd)) {
 		err("appledisplay: Backlight registration failed");
 		goto error;
_

Patches currently in -mm which might be from linux-kernel@hansmi.ch are

origin.patch
git-acpi.patch
git-backlight.patch
