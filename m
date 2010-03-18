From: akpm@linux-foundation.org
Subject: + mbp_nvidia_bl-add-support-for-older-macbookpro-and-macbook-61.patch added to -mm tree
Date: Thu, 18 Mar 2010 15:58:44 -0700
Message-ID: <201003182258.o2IMwiP8020680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857Ab0CRW7Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 18:59:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: schwalbe@inf.tu-dresden.de, evan.mcclain@gatech.edu, mjg@redhat.com, rpurdie@rpsys.net


The patch titled
     mbp_nvidia_bl: add support for older MacBookPro and MacBook 6,1.
has been added to the -mm tree.  Its filename is
     mbp_nvidia_bl-add-support-for-older-macbookpro-and-macbook-61.patch

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
Subject: mbp_nvidia_bl: add support for older MacBookPro and MacBook 6,1.
From: Mario Schwalbe <schwalbe@inf.tu-dresden.de>

Add support for all remaining models not yet present in Linus'/Richard
Purdie's tree nor Evan McClain's patch to finally complete the list.

Signed-off-by: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Evan McClain <evan.mcclain@gatech.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/mbp_nvidia_bl.c |   45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff -puN drivers/video/backlight/mbp_nvidia_bl.c~mbp_nvidia_bl-add-support-for-older-macbookpro-and-macbook-61 drivers/video/backlight/mbp_nvidia_bl.c
--- a/drivers/video/backlight/mbp_nvidia_bl.c~mbp_nvidia_bl-add-support-for-older-macbookpro-and-macbook-61
+++ a/drivers/video/backlight/mbp_nvidia_bl.c
@@ -184,6 +184,42 @@ static const struct dmi_system_id __init
 	},
 	{
 		.callback	= mbp_dmi_match,
+		.ident		= "MacBookPro 1,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro1,1"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBookPro 1,2",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro1,2"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBookPro 2,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro2,1"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
+		.ident		= "MacBookPro 2,2",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro2,2"),
+		},
+		.driver_data	= (void *)&intel_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
 		.ident		= "MacBookPro 3,1",
 		.matches	= {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
@@ -238,6 +274,15 @@ static const struct dmi_system_id __init
 	},
 	{
 		.callback	= mbp_dmi_match,
+		.ident		= "MacBook 6,1",
+		.matches	= {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook6,1"),
+		},
+		.driver_data	= (void *)&nvidia_chipset_data,
+	},
+	{
+		.callback	= mbp_dmi_match,
 		.ident		= "MacBookAir 2,1",
 		.matches	= {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
_

Patches currently in -mm which might be from schwalbe@inf.tu-dresden.de are

mbp_nvidia_bl-add-support-for-older-macbookpro-and-macbook-61.patch

