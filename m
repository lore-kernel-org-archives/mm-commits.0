From: akpm@linux-foundation.org
Subject: [merged] mbp_nvidia_bl-check-that-the-backlight-control-functions.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:33:21 -0700
Message-ID: <201103232036.p2NKavWf028184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933268Ab1CWUs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:48:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg@redhat.com, mourad@aquazul.com, richard.purdie@linuxfoundation.org, mm-commits@vger.kernel.org


The patch titled
     mbp_nvidia_bl: check that the backlight control functions
has been removed from the -mm tree.  Its filename was
     mbp_nvidia_bl-check-that-the-backlight-control-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mbp_nvidia_bl: check that the backlight control functions
From: Matthew Garrett <mjg@redhat.com>

The SMI-based backlight control functionality may fail to work if the
system is running under EFI rather than BIOS.  Check that the hardware
responds as expected, and exit if it doesn't.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Richard Purdie <richard.purdie@linuxfoundation.org>
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

origin.patch
linux-next.patch
acerhdf-add-support-for-aspire-1410-bios-v13314.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
i915-add-native-backlight-control.patch

