From: akpm@linux-foundation.org
Subject: [alternative-merged] drivers-video-backlight-mbp_nvidia_blc-add-support-for-macbookpro71.patch removed from -mm tree
Date: Tue, 04 Jan 2011 14:37:35 -0800
Message-ID: <201101042237.p04MbZK7028196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967Ab1ADWir (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 17:38:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mourad@aquazul.com, mjg@redhat.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/mbp_nvidia_bl.c: add support for MacBookPro7,1
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-mbp_nvidia_blc-add-support-for-macbookpro71.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/mbp_nvidia_bl.c: add support for MacBookPro7,1
From: Mourad De Clerck <mourad@aquazul.com>

Add support for the MacBookPro7,1 (13" mid 2010) to the mbp_nvidia_bl
driver.

Signed-off-by: Mourad De Clerck <mourad@aquazul.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/mbp_nvidia_bl.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/video/backlight/mbp_nvidia_bl.c~drivers-video-backlight-mbp_nvidia_blc-add-support-for-macbookpro71 drivers/video/backlight/mbp_nvidia_bl.c
--- a/drivers/video/backlight/mbp_nvidia_bl.c~drivers-video-backlight-mbp_nvidia_blc-add-support-for-macbookpro71
+++ a/drivers/video/backlight/mbp_nvidia_bl.c
@@ -353,6 +353,15 @@ static const struct dmi_system_id __init
 		},
 		.driver_data	= (void *)&nvidia_chipset_data,
 	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBookPro 7,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro7,1"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from mourad@aquazul.com are

mbp_nvidia_bl-remove-dmi-dependency.patch
mbp_nvidia_bl-check-that-the-backlight-control-functions.patch
mbp_nvidia_bl-rename-to-apple_bl.patch

