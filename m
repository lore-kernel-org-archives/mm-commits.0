From: akpm@linux-foundation.org
Subject: + fix-null-pointer-dereference-in-appledisplay-driver.patch added to -mm tree
Date: Fri, 09 Feb 2007 20:16:58 -0800
Message-ID: <200702100416.l1A4GwBm003339@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35452 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbXBJESb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 23:18:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux-kernel@hansmi.ch, benh@kernel.crashing.org, greg@kroah.com, lenb@kernel.org, rpurdie@rpsys.net


The patch titled
     null pointer dereference in appledisplay driver
has been added to the -mm tree.  Its filename is
     fix-null-pointer-dereference-in-appledisplay-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -280,8 +280,8 @@ static int appledisplay_probe(struct usb
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

fix-null-pointer-dereference-in-appledisplay-driver.patch
