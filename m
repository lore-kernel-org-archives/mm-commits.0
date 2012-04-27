From: akpm@linux-foundation.org
Subject: [merged] acerhdf-add-support-for-new-hardware.patch removed from -mm tree
Date: Fri, 27 Apr 2012 12:35:18 -0700
Message-ID: <20120427193518.69EBDA02CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:57788 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761328Ab2D0TfU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 15:35:20 -0400
Received: by wejx9 with SMTP id x9so54354wej.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 12:35:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@piie.net, mjg@redhat.com, petkovbb@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: acerhdf: add support for new hardware
has been removed from the -mm tree.  Its filename was
     acerhdf-add-support-for-new-hardware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Peter Feuerer <peter@piie.net>
Subject: acerhdf: add support for new hardware

Add support for new hardware:
Acer Aspire LT-10Q/531/751/1810/1825,
Acer Travelmate 7730,
Packard Bell ENBFT/DOTVR46

Signed-off-by: Peter Feuerer <peter@piie.net>
Acked-by: Borislav Petkov <petkovbb@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acerhdf.c |   62 +++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 20 deletions(-)

diff -puN drivers/platform/x86/acerhdf.c~acerhdf-add-support-for-new-hardware drivers/platform/x86/acerhdf.c
--- a/drivers/platform/x86/acerhdf.c~acerhdf-add-support-for-new-hardware
+++ a/drivers/platform/x86/acerhdf.c
@@ -50,7 +50,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.24"
+#define DRV_VER "0.5.26"
 
 /*
  * According to the Atom N270 datasheet,
@@ -150,6 +150,8 @@ static const struct bios_settings_t bios
 	{"Acer", "AOA150", "v0.3308", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
+	/* LT1005u */
+	{"Acer", "LT-10Q", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
 	/* Acer 1410 */
 	{"Acer", "Aspire 1410", "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1410", "v0.3113", 0x55, 0x58, {0x9e, 0x00} },
@@ -184,29 +186,44 @@ static const struct bios_settings_t bios
 	{"Acer", "Aspire 1810TZ", "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810T",  "v1.3310", 0x55, 0x58, {0x9e, 0x00} },
 	{"Acer", "Aspire 1810TZ", "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v1.3314", 0x55, 0x58, {0x9e, 0x00} },
 	/* Acer 531 */
+	{"Acer", "AO531h", "v0.3104", 0x55, 0x58, {0x20, 0x00} },
 	{"Acer", "AO531h", "v0.3201", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AO531h", "v0.3304", 0x55, 0x58, {0x20, 0x00} },
+	/* Acer 751 */
+	{"Acer", "AO751h", "V0.3212", 0x55, 0x58, {0x21, 0x00} },
+	/* Acer 1825 */
+	{"Acer", "Aspire 1825PTZ", "V1.3118", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1825PTZ", "V1.3127", 0x55, 0x58, {0x9e, 0x00} },
+	/* Acer TravelMate 7730 */
+	{"Acer", "TravelMate 7730G", "v0.3509", 0x55, 0x58, {0xaf, 0x00} },
 	/* Gateway */
-	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x00} },
-	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x00} },
-	{"Gateway", "LT31",   "v1.3103", 0x55, 0x58, {0x9e, 0x00} },
-	{"Gateway", "LT31",   "v1.3201", 0x55, 0x58, {0x9e, 0x00} },
-	{"Gateway", "LT31",   "v1.3302", 0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "AOA110", "v0.3103",  0x55, 0x58, {0x21, 0x00} },
+	{"Gateway", "AOA150", "v0.3103",  0x55, 0x58, {0x20, 0x00} },
+	{"Gateway", "LT31",   "v1.3103",  0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "LT31",   "v1.3201",  0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "LT31",   "v1.3302",  0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "LT31",   "v1.3303t", 0x55, 0x58, {0x9e, 0x00} },
 	/* Packard Bell */
-	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x00} },
-	{"Packard Bell", "DOA150", "v0.3105", 0x55, 0x58, {0x20, 0x00} },
-	{"Packard Bell", "AOA110", "v0.3105", 0x55, 0x58, {0x21, 0x00} },
-	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x00} },
-	{"Packard Bell", "DOTMU",  "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3108", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3113", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3117", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v0.3119", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMU",  "v1.3204", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMA",  "v1.3201", 0x55, 0x58, {0x9e, 0x00} },
-	{"Packard Bell", "DOTMA",  "v1.3302", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOA150",  "v0.3104",  0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "DOA150",  "v0.3105",  0x55, 0x58, {0x20, 0x00} },
+	{"Packard Bell", "AOA110",  "v0.3105",  0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "AOA150",  "v0.3105",  0x55, 0x58, {0x20, 0x00} },
+	{"Packard Bell", "ENBFT",   "V1.3118",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "ENBFT",   "V1.3127",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v1.3303",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3120",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3108",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3113",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3115",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3117",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v0.3119",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",   "v1.3204",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMA",   "v1.3201",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMA",   "v1.3302",  0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMA",   "v1.3303t", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTVR46", "v1.3308",  0x55, 0x58, {0x9e, 0x00} },
 	/* pewpew-terminator */
 	{"", "", "", 0, 0, {0, 0} }
 };
@@ -702,15 +719,20 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Peter Feuerer");
 MODULE_DESCRIPTION("Aspire One temperature and fan driver");
 MODULE_ALIAS("dmi:*:*Acer*:pnAOA*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAO751h*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1410*:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1810*:");
+MODULE_ALIAS("dmi:*:*Acer*:pnAspire*1825PTZ:");
 MODULE_ALIAS("dmi:*:*Acer*:pnAO531*:");
+MODULE_ALIAS("dmi:*:*Acer*:TravelMate*7730G:");
 MODULE_ALIAS("dmi:*:*Gateway*:pnAOA*:");
 MODULE_ALIAS("dmi:*:*Gateway*:pnLT31*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnAOA*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOA*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTMU*:");
+MODULE_ALIAS("dmi:*:*Packard*Bell*:pnENBFT*:");
 MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTMA*:");
+MODULE_ALIAS("dmi:*:*Packard*Bell*:pnDOTVR46*:");
 
 module_init(acerhdf_init);
 module_exit(acerhdf_exit);
_

Patches currently in -mm which might be from peter@piie.net are

origin.patch

