From: akpm@linux-foundation.org
Subject: [merged] backlight-macbookair3132-mbp-nvidia-bl-support.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:31:09 -0800
Message-ID: <201011161934.oAGJYLVf003196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756408Ab0KPTe6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:34:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gimli@dark-green.com, rpurdie@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     backlight: MacBookAir3,1(3,2) mbp-nvidia-bl support
has been removed from the -mm tree.  Its filename was
     backlight-macbookair3132-mbp-nvidia-bl-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: MacBookAir3,1(3,2) mbp-nvidia-bl support
From: Edgar (gimli) Hucek <gimli@dark-green.com>

Add support for the MacBookAir3,1 and MacBookAir3,2 to the mbp-nvidia-bl
driver.

Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
Acked-by: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/mbp_nvidia_bl.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN drivers/video/backlight/mbp_nvidia_bl.c~backlight-macbookair3132-mbp-nvidia-bl-support drivers/video/backlight/mbp_nvidia_bl.c
--- a/drivers/video/backlight/mbp_nvidia_bl.c~backlight-macbookair3132-mbp-nvidia-bl-support
+++ a/drivers/video/backlight/mbp_nvidia_bl.c
@@ -335,6 +335,24 @@ static const struct dmi_system_id __init
 		},
 		.driver_data	= (void *)&nvidia_chipset_data,
 	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBookAir 3,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,1"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBookAir 3,2",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,2"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from gimli@dark-green.com are

linux-next.patch

