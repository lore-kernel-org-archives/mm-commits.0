From: akpm@linux-foundation.org
Subject: + acerhdf-add-new-bios-versions.patch added to -mm tree
Date: Tue, 02 Mar 2010 16:03:01 -0800
Message-ID: <201003030003.o23031nL005916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820Ab0CCADg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 19:03:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@piie.net, andi@lisas.de, lenb@kernel.org, petkovbb@gmail.com


The patch titled
     acerhdf: add new BIOS versions
has been added to the -mm tree.  Its filename is
     acerhdf-add-new-bios-versions.patch

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
Subject: acerhdf: add new BIOS versions
From: Peter Feuerer <peter@piie.net>

Add new BIOS versions for Acer 1410 and 1810xx and Packard Bell netbooks.

Fixed registers of Acer AOA150 BIOS version v0.3114: Old registers caused
Fan to spin up at every temperature check.

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acerhdf.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN drivers/platform/x86/acerhdf.c~acerhdf-add-new-bios-versions drivers/platform/x86/acerhdf.c
--- a/drivers/platform/x86/acerhdf.c~acerhdf-add-new-bios-versions
+++ a/drivers/platform/x86/acerhdf.c
@@ -52,7 +52,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.22"
+#define DRV_VER "0.5.23"
 
 /*
  * According to the Atom N270 datasheet,
@@ -146,7 +146,7 @@ static const struct bios_settings_t bios
 	{"Acer", "AOA110", "v0.3309", 0x55, 0x58, {0x21, 0x21, 0x00} },
 	{"Acer", "AOA110", "v0.3310", 0x55, 0x58, {0x21, 0x21, 0x00} },
 	/* AOA150 */
-	{"Acer", "AOA150", "v0.3114", 0x55, 0x58, {0x20, 0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3114", 0x55, 0x58, {0x1f, 0x1f, 0x00} },
 	{"Acer", "AOA150", "v0.3301", 0x55, 0x58, {0x20, 0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3304", 0x55, 0x58, {0x20, 0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3305", 0x55, 0x58, {0x20, 0x20, 0x00} },
@@ -155,13 +155,20 @@ static const struct bios_settings_t bios
 	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x20, 0x00} },
 	/* Acer 1410 */
+	{"Acer", "Aspire 1410", "v0.3115", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
 	/* Acer 1810xx */
+	{"Acer", "Aspire 1810TZ", "v0.3115", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1810T", "v0.3115", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v0.3119", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1810T", "v0.3119", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
 	{"Acer", "Aspire 1810TZ", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
 	{"Acer", "Aspire 1810T", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810T", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v1.3204", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1810T", "v1.3204", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
 	{"Acer", "Aspire 1810TZ", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1810T", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
 	/* Gateway */
 	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x21, 0x00} },
 	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x20, 0x00} },
@@ -175,6 +182,7 @@ static const struct bios_settings_t bios
 	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x20, 0x00} },
 	{"Packard Bell", "DOTMU", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
 	{"Packard Bell", "DOTMU", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Packard Bell", "DOTMA", "v1.3201", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
 	/* pewpew-terminator */
 	{"", "", "", 0, 0, {0, 0, 0} }
 };
@@ -667,6 +675,7 @@ MODULE_ALIAS("dmi:*:*Gateway*:pnLT31*:")
 MODULE_ALIAS("dmi:*:*Packard Bell*:pnAOA*:");
 MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOA*:");
 MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOTMU*:");
+MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOTMA*:");
 
 module_init(acerhdf_init);
 module_exit(acerhdf_exit);
_

Patches currently in -mm which might be from peter@piie.net are

origin.patch
acerhdf-add-new-bios-versions.patch

