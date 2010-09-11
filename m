From: akpm@linux-foundation.org
Subject: + efifb-check-that-the-base-address-is-plausible-on-pci-systems.patch added to -mm tree
Date: Fri, 10 Sep 2010 17:15:02 -0700
Message-ID: <201009110015.o8B0F2o0011177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755038Ab0IKAPN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 20:15:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pjones@redhat.com


The patch titled
     efifb: check that the base address is plausible on pci systems
has been added to the -mm tree.  Its filename is
     efifb-check-that-the-base-address-is-plausible-on-pci-systems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: efifb: check that the base address is plausible on pci systems
From: Peter Jones <pjones@redhat.com>

Some Apple machines have identical DMI data but different memory
configurations for the video.  Given that, check that the address in our
table is actually within the range of a PCI BAR on a VGA device in the
machine.

This also fixes up the return value from set_system(), which has always
been wrong, but never resulted in bad behavior since there's only ever
been one matching entry in the dmi table.

This also adds me as the efifb maintainer, since I've effectively been
acting as such for quite some time.

Signed-off-by: Peter Jones <pjones@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS           |    6 +++
 drivers/video/efifb.c |   61 ++++++++++++++++++++++++++++++++--------
 2 files changed, 55 insertions(+), 12 deletions(-)

diff -puN MAINTAINERS~efifb-check-that-the-base-address-is-plausible-on-pci-systems MAINTAINERS
--- a/MAINTAINERS~efifb-check-that-the-base-address-is-plausible-on-pci-systems
+++ a/MAINTAINERS
@@ -2204,6 +2204,12 @@ W:	http://acpi4asus.sf.net
 S:	Maintained
 F:	drivers/platform/x86/eeepc-laptop.c
 
+EFIFB FRAMEBUFFER DRIVER
+L:	linux-fbdev@vger.kernel.org
+M:	Peter Jones <pjones@redhat.com>
+S:	Maintained
+F:	drivers/video/efifb.c
+
 EFS FILESYSTEM
 W:	http://aeschi.ch.eu.org/efs/
 S:	Orphan
diff -puN drivers/video/efifb.c~efifb-check-that-the-base-address-is-plausible-on-pci-systems drivers/video/efifb.c
--- a/drivers/video/efifb.c~efifb-check-that-the-base-address-is-plausible-on-pci-systems
+++ a/drivers/video/efifb.c
@@ -13,7 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/screen_info.h>
 #include <linux/dmi.h>
-
+#include <linux/pci.h>
 #include <video/vga.h>
 
 static struct fb_var_screeninfo efifb_defined __devinitdata = {
@@ -116,7 +116,7 @@ static int set_system(const struct dmi_s
 {
 	struct efifb_dmi_info *info = id->driver_data;
 	if (info->base == 0)
-		return -ENODEV;
+		return 0;
 
 	printk(KERN_INFO "efifb: dmi detected %s - framebuffer at %p "
 			 "(%dx%d, stride %d)\n", id->ident,
@@ -124,18 +124,55 @@ static int set_system(const struct dmi_s
 			 info->stride);
 
 	/* Trust the bootloader over the DMI tables */
-	if (screen_info.lfb_base == 0)
+	if (screen_info.lfb_base == 0) {
+#if defined(CONFIG_PCI)
+		struct pci_dev *dev = NULL;
+		int found_bar = 0;
+#endif
 		screen_info.lfb_base = info->base;
-	if (screen_info.lfb_linelength == 0)
-		screen_info.lfb_linelength = info->stride;
-	if (screen_info.lfb_width == 0)
-		screen_info.lfb_width = info->width;
-	if (screen_info.lfb_height == 0)
-		screen_info.lfb_height = info->height;
-	if (screen_info.orig_video_isVGA == 0)
-		screen_info.orig_video_isVGA = VIDEO_TYPE_EFI;
 
-	return 0;
+#if defined(CONFIG_PCI)
+		/* make sure that the address in the table is actually on a
+		 * VGA device's PCI BAR */
+
+		for_each_pci_dev(dev) {
+			int i;
+			if ((dev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
+				continue;
+			for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+				resource_size_t start, end;
+
+				start = pci_resource_start(dev, i);
+				if (start == 0)
+					break;
+				end = pci_resource_end(dev, i);
+				if (screen_info.lfb_base >= start &&
+						screen_info.lfb_base < end) {
+					found_bar = 1;
+				}
+			}
+		}
+		if (!found_bar)
+			screen_info.lfb_base = 0;
+#endif
+	}
+	if (screen_info.lfb_base) {
+		if (screen_info.lfb_linelength == 0)
+			screen_info.lfb_linelength = info->stride;
+		if (screen_info.lfb_width == 0)
+			screen_info.lfb_width = info->width;
+		if (screen_info.lfb_height == 0)
+			screen_info.lfb_height = info->height;
+		if (screen_info.orig_video_isVGA == 0)
+			screen_info.orig_video_isVGA = VIDEO_TYPE_EFI;
+	} else {
+		screen_info.lfb_linelength = 0;
+		screen_info.lfb_width = 0;
+		screen_info.lfb_height = 0;
+		screen_info.orig_video_isVGA = 0;
+		return 0;
+	}
+	return 1;
 }
 
 static int efifb_setcolreg(unsigned regno, unsigned red, unsigned green,
_

Patches currently in -mm which might be from pjones@redhat.com are

efifb-check-that-the-base-address-is-plausible-on-pci-systems.patch
efifb-support-the-efi-framebuffer-on-more-apple-hardware.patch

