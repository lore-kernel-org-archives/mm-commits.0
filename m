From: akpm@linux-foundation.org
Subject: + acerhdf-remove-chk_off-as-it-was-only-needed-for-t31-netbooks.patch added to -mm tree
Date: Mon, 21 Jun 2010 14:56:06 -0700
Message-ID: <201006212156.o5LLu6eC007206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932513Ab0FUV44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jun 2010 17:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: peter@piie.net, andi@lisas.de, lenb@kernel.org, mjg@redhat.com, petkovbb@gmail.com


The patch titled
     acerhdf: remove "chk_off" as it was only needed for T31 netbooks
has been added to the -mm tree.  Its filename is
     acerhdf-remove-chk_off-as-it-was-only-needed-for-t31-netbooks.patch

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
Subject: acerhdf: remove "chk_off" as it was only needed for T31 netbooks
From: Peter Feuerer <peter@piie.net>

Remove "chk_off" as it was only needed for T31 netbooks.  But those
netbooks can also be handled just with "cmd_off" register (0x9e) for
reading the state back.

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acerhdf.c |   92 +++++++++++++++----------------
 1 file changed, 45 insertions(+), 47 deletions(-)

diff -puN drivers/platform/x86/acerhdf.c~acerhdf-remove-chk_off-as-it-was-only-needed-for-t31-netbooks drivers/platform/x86/acerhdf.c
--- a/drivers/platform/x86/acerhdf.c~acerhdf-remove-chk_off-as-it-was-only-needed-for-t31-netbooks
+++ a/drivers/platform/x86/acerhdf.c
@@ -112,14 +112,12 @@ module_param_string(force_product, force
 MODULE_PARM_DESC(force_product, "Force BIOS product and omit BIOS check");
 
 /*
- * cmd_off: to switch the fan completely off
- * chk_off: to check if the fan is off
+ * cmd_off: to switch the fan completely off and check if the fan is off
  *	cmd_auto: to set the BIOS in control of the fan. The BIOS regulates then
  *		the fan speed depending on the temperature
  */
 struct fancmd {
 	u8 cmd_off;
-	u8 chk_off;
 	u8 cmd_auto;
 };
 
@@ -136,55 +134,55 @@ struct bios_settings_t {
 /* Register addresses and values for different BIOS versions */
 static const struct bios_settings_t bios_tbl[] = {
 	/* AOA110 */
-	{"Acer", "AOA110", "v0.3109", 0x55, 0x58, {0x1f, 0x1f, 0x00} },
-	{"Acer", "AOA110", "v0.3114", 0x55, 0x58, {0x1f, 0x1f, 0x00} },
-	{"Acer", "AOA110", "v0.3301", 0x55, 0x58, {0xaf, 0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3304", 0x55, 0x58, {0xaf, 0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3305", 0x55, 0x58, {0xaf, 0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3307", 0x55, 0x58, {0xaf, 0xaf, 0x00} },
-	{"Acer", "AOA110", "v0.3308", 0x55, 0x58, {0x21, 0x21, 0x00} },
-	{"Acer", "AOA110", "v0.3309", 0x55, 0x58, {0x21, 0x21, 0x00} },
-	{"Acer", "AOA110", "v0.3310", 0x55, 0x58, {0x21, 0x21, 0x00} },
+	{"Acer", "AOA110", "v0.3109", 0x55, 0x58, {0x1f, 0x00} },
+	{"Acer", "AOA110", "v0.3114", 0x55, 0x58, {0x1f, 0x00} },
+	{"Acer", "AOA110", "v0.3301", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3304", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3305", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3307", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3308", 0x55, 0x58, {0x21, 0x00} },
+	{"Acer", "AOA110", "v0.3309", 0x55, 0x58, {0x21, 0x00} },
+	{"Acer", "AOA110", "v0.3310", 0x55, 0x58, {0x21, 0x00} },
 	/* AOA150 */
-	{"Acer", "AOA150", "v0.3114", 0x55, 0x58, {0x1f, 0x1f, 0x00} },
-	{"Acer", "AOA150", "v0.3301", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3304", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3305", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3307", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3308", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3114", 0x55, 0x58, {0x1f, 0x00} },
+	{"Acer", "AOA150", "v0.3301", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3304", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3305", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3307", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3308", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
 	/* Acer 1410 */
-	{"Acer", "Aspire 1410", "v0.3115", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1410", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1410", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1410", "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
 	/* Acer 1810xx */
-	{"Acer", "Aspire 1810TZ", "v0.3115", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810T", "v0.3115", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v0.3119", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810T", "v0.3119", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810T", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v1.3204", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810T", "v1.3204", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810TZ", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Acer", "Aspire 1810T", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v0.3115", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v0.3119", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v0.3119", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v1.3204", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v1.3204", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810TZ", "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
+	{"Acer", "Aspire 1810T",  "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
 	/* Gateway */
-	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x21, 0x00} },
-	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Gateway", "LT31", "v1.3103", 0x55, 0x58, {0x10, 0x0f, 0x00} },
-	{"Gateway", "LT31", "v1.3201", 0x55, 0x58, {0x10, 0x0f, 0x00} },
-	{"Gateway", "LT31", "v1.3302", 0x55, 0x58, {0x10, 0x0f, 0x00} },
+	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x00} },
+	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x00} },
+	{"Gateway", "LT31",   "v1.3103", 0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "LT31",   "v1.3201", 0x55, 0x58, {0x9e, 0x00} },
+	{"Gateway", "LT31",   "v1.3302", 0x55, 0x58, {0x9e, 0x00} },
 	/* Packard Bell */
-	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x21, 0x00} },
-	{"Packard Bell", "DOA150", "v0.3105", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Packard Bell", "AOA110", "v0.3105", 0x55, 0x58, {0x21, 0x21, 0x00} },
-	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Packard Bell", "DOTMU", "v1.3303", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Packard Bell", "DOTMU", "v0.3120", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
-	{"Packard Bell", "DOTMA", "v1.3201", 0x55, 0x58, {0x9e, 0x9e, 0x00} },
+	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "DOA150", "v0.3105", 0x55, 0x58, {0x20, 0x00} },
+	{"Packard Bell", "AOA110", "v0.3105", 0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "AOA150", "v0.3105", 0x55, 0x58, {0x20, 0x00} },
+	{"Packard Bell", "DOTMU",  "v1.3303", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMU",  "v0.3120", 0x55, 0x58, {0x9e, 0x00} },
+	{"Packard Bell", "DOTMA",  "v1.3201", 0x55, 0x58, {0x9e, 0x00} },
 	/* pewpew-terminator */
-	{"", "", "", 0, 0, {0, 0, 0} }
+	{"", "", "", 0, 0, {0, 0} }
 };
 
 static const struct bios_settings_t *bios_cfg __read_mostly;
@@ -208,7 +206,7 @@ static int acerhdf_get_fanstate(int *sta
 	if (ec_read(bios_cfg->fanreg, &fan))
 		return -EINVAL;
 
-	if (fan != bios_cfg->cmd.chk_off)
+	if (fan != bios_cfg->cmd.cmd_off)
 		*state = ACERHDF_FAN_AUTO;
 	else
 		*state = ACERHDF_FAN_OFF;
_

Patches currently in -mm which might be from peter@piie.net are

acerhdf-add-new-bios-versions.patch
acerhdf-remove-chk_off-as-it-was-only-needed-for-t31-netbooks.patch
acerhdf-driver-didnt-verify-the-pointers-in-which-it-got-product-information.patch
acerhdf-add-ao531-and-many-bios-versions-for-1410-1810xx-and-packard-bell-netbooks.patch

