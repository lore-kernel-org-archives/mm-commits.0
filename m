From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-mbp_nvidia_blc-add-support-for-macbookpro71.patch added to -mm tree
Date: Mon, 03 Jan 2011 13:27:44 -0800
Message-ID: <201101032127.p03LRiIv029453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754142Ab1ACV2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 16:28:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mourad@aquazul.com, rpurdie@rpsys.net


The patch titled
     drivers/video/backlight/mbp_nvidia_bl.c: add support for MacBookPro7,1
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-mbp_nvidia_blc-add-support-for-macbookpro71.patch

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
Subject: drivers/video/backlight/mbp_nvidia_bl.c: add support for MacBookPro7,1
From: Mourad De Clerck <mourad@aquazul.com>

Add support for the MacBookPro7,1 (13" mid 2010) to the mbp_nvidia_bl
driver.

Signed-off-by: Mourad De Clerck <mourad@aquazul.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
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

drivers-video-backlight-mbp_nvidia_blc-add-support-for-macbookpro71.patch

