From: akpm@linux-foundation.org
Subject: + backlight-macbookair3132-mbp-nvidia-bl-support.patch added to -mm tree
Date: Wed, 10 Nov 2010 21:51:38 -0800
Message-ID: <201011110554.oAB5s51v027883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755101Ab0KKFyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Nov 2010 00:54:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gimli@dark-green.com, rpurdie@linux.intel.com


The patch titled
     backlight: MacBookAir3,1(3,2) mbp-nvidia-bl support
has been added to the -mm tree.  Its filename is
     backlight-macbookair3132-mbp-nvidia-bl-support.patch

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
+       {
+               .callback       = mbp_dmi_match,
+               .ident          = "MacBookAir 3,1",
+               .matches        = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,1"),
+               },
+               .driver_data    = (void *)&nvidia_chipset_data,
+       },
+       {
+               .callback       = mbp_dmi_match,
+               .ident          = "MacBookAir 3,2",
+               .matches        = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir3,2"),
+               },
+               .driver_data    = (void *)&nvidia_chipset_data,
+       },
 	{ }
 };
 
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from gimli@dark-green.com are

origin.patch
linux-next.patch
backlight-macbookair3132-mbp-nvidia-bl-support.patch

