From: akpm@linux-foundation.org
Subject: [merged] acerhdf-add-new-bios-versions.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:32:05 -0800
Message-ID: <200912292132.nBTLW5sM008600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752792AbZL2Vcx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:32:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@piie.net, andi@lisas.de, lenb@kernel.org, petkovbb@gmail.com, mm-commits@vger.kernel.org


The patch titled
     acerhdf: add new BIOS versions
has been removed from the -mm tree.  Its filename was
     acerhdf-add-new-bios-versions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acerhdf: add new BIOS versions
From: Peter Feuerer <peter@piie.net>

Add new BIOS versions for following netbooks: Aspire 1810xx, Packard Bell
DOTMU.

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acerhdf.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN drivers/platform/x86/acerhdf.c~acerhdf-add-new-bios-versions drivers/platform/x86/acerhdf.c
--- a/drivers/platform/x86/acerhdf.c~acerhdf-add-new-bios-versions
+++ a/drivers/platform/x86/acerhdf.c
@@ -52,7 +52,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.20"
+#define DRV_VER "0.5.21"
 
 /*
  * According to the Atom N270 datasheet,
@@ -156,7 +156,13 @@ static const struct bios_settings_t bios
 	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x20, 0x00} },
 	/* Acer 1410 */
 	{"Acer", "Aspire 1410", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	/* special BIOS / other */
+	{"Acer", "Aspire 1410", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	/* Acer 1810xx */
+	{"Acer", "Aspire 1810TZ", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1810T", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1810T", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	/* Gateway */
 	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x21, 0x00} },
 	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x20, 0x00} },
 	{"Gateway         ", "LT31            ", "v1.3103 ", 0x55, 0x58,
@@ -165,10 +171,13 @@ static const struct bios_settings_t bios
 		{0x10, 0x0f, 0x00} },
 	{"Gateway         ", "LT31            ", "v1.3302 ", 0x55, 0x58,
 		{0x10, 0x0f, 0x00} },
+	/* Packard Bell */
 	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x21, 0x00} },
 	{"Packard Bell", "DOA150", "v0.3105", 0x55, 0x58, {0x20, 0x20, 0x00} },
 	{"Packard Bell", "AOA110", "v0.3105", 0x55, 0x58, {0x21, 0x21, 0x00} },
 	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x20, 0x00} },
+	{"Packard Bell", "DOTMU", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Packard Bell", "DOTMU", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
 	/* pewpew-terminator */
 	{"", "", "", 0, 0, {0, 0, 0} }
 };
@@ -641,9 +650,13 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Peter Feuerer");
 MODULE_DESCRIPTION("Aspire One temperature and fan driver");
 MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAspire 1410*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAspire 1810*:");
 MODULE_ALIAS("dmi:*:*Gateway*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Gateway*:pnLT31*:");
 MODULE_ALIAS("dmi:*:*Packard Bell*:pnAOA*:");
 MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOA*:");
+MODULE_ALIAS("dmi:*:*Packard Bell*:pnDOTMU*:");
 
 module_init(acerhdf_init);
 module_exit(acerhdf_exit);
_

Patches currently in -mm which might be from peter@piie.net are


