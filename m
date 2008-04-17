From: akpm@linux-foundation.org
Subject: + miscacpibacklight-compal-laptop-extras-add-support-for-new-laptops.patch added to -mm tree
Date: Thu, 17 Apr 2008 14:33:29 -0700
Message-ID: <200804172133.m3HLXT64028982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754653AbYDQVeZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Apr 2008 17:34:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cezary.jackiewicz@gmail.com, aystarik@gmail.com, hmh@hmh.eng.br, lenb@kernel.org, rpurdie@rpsys.net


The patch titled
     misc,acpi,backlight: Compal Laptop Extras - add support for new laptops
has been added to the -mm tree.  Its filename is
     miscacpibacklight-compal-laptop-extras-add-support-for-new-laptops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: misc,acpi,backlight: Compal Laptop Extras - add support for new laptops
From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>

Compal-laptop: add support for new laptops:

FL91/IFL91
FL92/JFL92
FT00/IFT00

Signed-off-by: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>
Cc: Alexey Starikovskiy <aystarik@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig         |    5 ++++-
 drivers/misc/compal-laptop.c |   29 ++++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 2 deletions(-)

diff -puN drivers/misc/Kconfig~miscacpibacklight-compal-laptop-extras-add-support-for-new-laptops drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~miscacpibacklight-compal-laptop-extras-add-support-for-new-laptops
+++ a/drivers/misc/Kconfig
@@ -193,10 +193,13 @@ config COMPAL_LAPTOP
 	  This is a driver for laptops built by Compal:
 
 	  Compal FL90/IFL90
+	  Compal FL91/IFL91
+	  Compal FL92/JFL92
+	  Compal FT00/IFT00
 
 	  It adds support for Bluetooth, WLAN and LCD brightness control.
 
-	  If you have an Compal FL90/IFL90 laptop, say Y or M here.
+	  If you have an Compal FL9x/IFL9x/FT00 laptop, say Y or M here.
 
 config SONY_LAPTOP
 	tristate "Sony Laptop Extras"
diff -puN drivers/misc/compal-laptop.c~miscacpibacklight-compal-laptop-extras-add-support-for-new-laptops drivers/misc/compal-laptop.c
--- a/drivers/misc/compal-laptop.c~miscacpibacklight-compal-laptop-extras-add-support-for-new-laptops
+++ a/drivers/misc/compal-laptop.c
@@ -24,7 +24,7 @@
  */
 
 /*
- * comapl-laptop.c - Compal FL90/IFL90 laptop support.
+ * comapl-laptop.c - Compal laptop support.
  *
  * This driver exports a few files in /sys/devices/platform/compal-laptop/:
  *
@@ -320,6 +320,30 @@ static struct dmi_system_id __initdata c
 		},
 		.callback = dmi_check_cb
 	},
+	{
+		.ident = "FL91/IFL91",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "IFL91"),
+			DMI_MATCH(DMI_BOARD_VERSION, "IFT00"),
+		},
+		.callback = dmi_check_cb
+	},
+	{
+		.ident = "FL92/JFL92",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "JFL92"),
+			DMI_MATCH(DMI_BOARD_VERSION, "IFT00"),
+		},
+		.callback = dmi_check_cb
+	},
+	{
+		.ident = "FT00/IFT00",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "IFT00"),
+			DMI_MATCH(DMI_BOARD_VERSION, "IFT00"),
+		},
+		.callback = dmi_check_cb
+	},
 	{ }
 };
 
@@ -408,3 +432,6 @@ MODULE_LICENSE("GPL");
 
 MODULE_ALIAS("dmi:*:rnIFL90:rvrIFT00:*");
 MODULE_ALIAS("dmi:*:rnIFL90:rvrREFERENCE:*");
+MODULE_ALIAS("dmi:*:rnIFL91:rvrIFT00:*");
+MODULE_ALIAS("dmi:*:rnJFL92:rvrIFT00:*");
+MODULE_ALIAS("dmi:*:rnIFT00:rvrIFT00:*");
_

Patches currently in -mm which might be from cezary.jackiewicz@gmail.com are

miscacpibacklight-compal-laptop-extras-3rd-try.patch
miscacpibacklight-compal-laptop-extras-add-entry-to-maintainers.patch
miscacpibacklight-compal-laptop-extras-use-bitmask-not-hex.patch
miscacpibacklight-compal-laptop-extras-add-support-for-new-laptops.patch

