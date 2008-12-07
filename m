From: akpm@linux-foundation.org
Subject: - misc-add-dell-laptop-driver-update.patch removed from -mm tree
Date: Sat, 06 Dec 2008 22:15:25 -0800
Message-ID: <200812070615.mB76FPBA015279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436AbYLGGPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 01:15:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, Matt_Domsch@dell.com, greg@kroah.com, ivdoorn@gmail.com, lenb@kernel.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     misc-add-dell-laptop-driver update
has been removed from the -mm tree.  Its filename was
     misc-add-dell-laptop-driver-update.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: misc-add-dell-laptop-driver update
From: Matthew Garrett <mjg59@srcf.ucam.org>

Contains Andrew's suggested updates, plus a fix for a leak on the init
error path.

Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Greg KH <greg@kroah.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/dell-laptop.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/misc/dell-laptop.c~misc-add-dell-laptop-driver-update drivers/misc/dell-laptop.c
--- a/drivers/misc/dell-laptop.c~misc-add-dell-laptop-driver-update
+++ a/drivers/misc/dell-laptop.c
@@ -34,7 +34,7 @@ struct calling_interface_buffer {
 	u16 select;
 	volatile u32 input[4];
 	volatile u32 output[4];
-} __attribute__ ((packed));
+} __packed;
 
 struct calling_interface_token {
 	u16 tokenID;
@@ -51,7 +51,7 @@ struct calling_interface_structure {
 	u8 cmdIOCode;
 	u32 supportedCmds;
 	struct calling_interface_token tokens[];
-} __attribute__ ((packed));
+} __packed;
 
 static int da_command_address;
 static int da_command_code;
@@ -63,7 +63,7 @@ static struct rfkill *wifi_rfkill;
 static struct rfkill *bluetooth_rfkill;
 static struct rfkill *wwan_rfkill;
 
-static struct dmi_system_id __initdata dell_device_table[] = {
+static const struct dmi_system_id __initdata dell_device_table[] = {
 	{
 		.ident = "Dell laptop",
 		.matches = {
@@ -358,17 +358,22 @@ static int __init dell_init(void)
 
 	dmi_walk(find_tokens);
 
-	if (!da_tokens)
+	if (!da_tokens)  {
+		printk(KERN_INFO "dell-laptop: Unable to find dmi tokens\n");
 		return -ENODEV;
+	}
 
 	ret = dell_setup_rfkill();
 
 	if (ret) {
 		printk(KERN_WARNING "dell-laptop: Unable to setup rfkill\n");
-		return ret;
+		goto out;
 	}
 
 #ifdef CONFIG_ACPI
+	/* In the event of an ACPI backlight being available, don't
+	 * register the platform controller.
+	 */
 	if (acpi_video_backlight_support())
 		return 0;
 #endif
@@ -388,8 +393,8 @@ static int __init dell_init(void)
 			&dell_ops);
 
 		if (IS_ERR(dell_backlight_device)) {
-			dell_backlight_device = NULL;
 			ret = PTR_ERR(dell_backlight_device);
+			dell_backlight_device = NULL;
 			goto out;
 		}
 
@@ -407,6 +412,7 @@ out:
 		rfkill_unregister(bluetooth_rfkill);
 	if (wwan_rfkill)
 		rfkill_unregister(wwan_rfkill);
+	kfree(da_tokens);
 	return ret;
 }
 
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

linux-next.patch
hp-wmi-handle-rfkill_register-failure.patch
dcdbas-export-functionality-for-use-in-other-drivers.patch
misc-add-dell-laptop-driver-update.patch

