From: akpm@linux-foundation.org
Subject: + video-mbp_nvidia_bl-add-support-for-macbookair-11.patch added to -mm tree
Date: Mon, 24 Aug 2009 14:21:06 -0700
Message-ID: <200908242121.n7OLL6iv022536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753364AbZHXVV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:21:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rydberg@euromail.se, mjg@redhat.com, rpurdie@rpsys.net, schwalbe@inf.tu-dresden.de


The patch titled
     video: mbp_nvidia_bl: add support for MacBookAir 1,1
has been added to the -mm tree.  Its filename is
     video-mbp_nvidia_bl-add-support-for-macbookair-11.patch

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
Subject: video: mbp_nvidia_bl: add support for MacBookAir 1,1
From: "Henrik Rydberg" <rydberg@euromail.se>

Add LCD backlight support for the Intel GMA965 found in the MacBookAir
1,1.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
Acked-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/mbp_nvidia_bl.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/video/backlight/mbp_nvidia_bl.c~video-mbp_nvidia_bl-add-support-for-macbookair-11 drivers/video/backlight/mbp_nvidia_bl.c
--- a/drivers/video/backlight/mbp_nvidia_bl.c~video-mbp_nvidia_bl-add-support-for-macbookair-11
+++ a/drivers/video/backlight/mbp_nvidia_bl.c
@@ -166,6 +166,15 @@ static const struct dmi_system_id __init
 	},
 	{
 		.callback	= mbp_dmi_match,
+		.ident		= "MacBookAir 1,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookAir1,1"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
 		.ident		= "MacBook 5,1",
 		.matches	= {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
_

Patches currently in -mm which might be from rydberg@euromail.se are

video-mbp_nvidia_bl-add-support-for-macbookair-11.patch
hwmon-applesmc-restore-keyboard-backlight-on-resume.patch

