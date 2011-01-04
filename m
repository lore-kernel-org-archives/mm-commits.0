From: akpm@linux-foundation.org
Subject: + mbp_nvidia_bl-check-that-the-backlight-control-functions.patch added to -mm tree
Date: Tue, 04 Jan 2011 14:37:22 -0800
Message-ID: <201101042237.p04MbMSs028179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238Ab1ADWi3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 17:38:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg@redhat.com, mourad@aquazul.com, rpurdie@linux.intel.com


The patch titled
     mbp_nvidia_bl: check that the backlight control functions
has been added to the -mm tree.  Its filename is
     mbp_nvidia_bl-check-that-the-backlight-control-functions.patch

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
Subject: mbp_nvidia_bl: check that the backlight control functions
From: Matthew Garrett <mjg@redhat.com>

The SMI-based backlight control functionality may fail to work if the
system is running under EFI rather than BIOS.  Check that the hardware
responds as expected, and exit if it doesn't.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Cc: Mourad De Clerck <mourad@aquazul.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/mbp_nvidia_bl.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/video/backlight/mbp_nvidia_bl.c~mbp_nvidia_bl-check-that-the-backlight-control-functions drivers/video/backlight/mbp_nvidia_bl.c
--- a/drivers/video/backlight/mbp_nvidia_bl.c~mbp_nvidia_bl-check-that-the-backlight-control-functions
+++ a/drivers/video/backlight/mbp_nvidia_bl.c
@@ -143,6 +143,7 @@ static int __devinit mb_bl_add(struct ac
 {
 	struct backlight_properties props;
 	struct pci_dev *host;
+	int intensity;
 
 	host = pci_get_bus_and_slot(0, 0);
 
@@ -163,6 +164,18 @@ static int __devinit mb_bl_add(struct ac
 		return -ENODEV;
 	}
 
+	/* Check that the hardware responds - this may not work under EFI */
+
+	intensity = hw_data->backlight_ops.get_brightness(NULL);
+
+	if (!intensity) {
+		hw_data->set_brightness(1);
+		if (!hw_data->backlight_ops.get_brightness(NULL))
+			return -ENODEV;
+
+		hw_data->set_brightness(0);
+	}
+
 	if (!request_region(hw_data->iostart, hw_data->iolen,
 			    "Macbook backlight"))
 		return -ENXIO;
_

Patches currently in -mm which might be from mjg@redhat.com are

linux-next.patch
acerhdf-add-support-for-aspire-1410-bios-v13314.patch
mbp_nvidia_bl-remove-dmi-dependency.patch
mbp_nvidia_bl-check-that-the-backlight-control-functions.patch
mbp_nvidia_bl-rename-to-apple_bl.patch
drivers-video-backlight-mbp_nvidia_blc-add-support-for-macbookpro71.patch

