From: akpm@linux-foundation.org
Subject: [merged] drivers-platform-x86-acerhdfc-check-bios-information-whether-it-begins-with-string-of-table.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:32:08 -0800
Message-ID: <200912292132.nBTLW8o2008610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbZL2VdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:33:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peter@piie.net, andi@lisas.de, hpa@zytor.com, lenb@kernel.org, mingo@elte.hu, petkovbb@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     drivers/platform/x86/acerhdf.c: check BIOS information whether it begins with string of table
has been removed from the -mm tree.  Its filename was
     drivers-platform-x86-acerhdfc-check-bios-information-whether-it-begins-with-string-of-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/platform/x86/acerhdf.c: check BIOS information whether it begins with string of table
From: Peter Feuerer <peter@piie.net>

BIOS information is now checked whether it begins with the strings stored
in the BIOS table.  Previous method did a strcmp, what lead to problems if
BIOS information has appended whitespaces.

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Borislav Petkov <petkovbb@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Len Brown <lenb@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/acerhdf.c |   46 ++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff -puN drivers/platform/x86/acerhdf.c~drivers-platform-x86-acerhdfc-check-bios-information-whether-it-begins-with-string-of-table drivers/platform/x86/acerhdf.c
--- a/drivers/platform/x86/acerhdf.c~drivers-platform-x86-acerhdfc-check-bios-information-whether-it-begins-with-string-of-table
+++ a/drivers/platform/x86/acerhdf.c
@@ -52,7 +52,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.21"
+#define DRV_VER "0.5.22"
 
 /*
  * According to the Atom N270 datasheet,
@@ -165,12 +165,9 @@ static const struct bios_settings_t bios
 	/* Gateway */
 	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x21, 0x00} },
 	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x20, 0x00} },
-	{"Gateway         ", "LT31            ", "v1.3103 ", 0x55, 0x58,
-		{0x10, 0x0f, 0x00} },
-	{"Gateway         ", "LT31            ", "v1.3201 ", 0x55, 0x58,
-		{0x10, 0x0f, 0x00} },
-	{"Gateway         ", "LT31            ", "v1.3302 ", 0x55, 0x58,
-		{0x10, 0x0f, 0x00} },
+	{"Gateway", "LT31", "v1.3103", 0x55, 0x58, {0x10, 0x0f, 0x00} },
+	{"Gateway", "LT31", "v1.3201", 0x55, 0x58, {0x10, 0x0f, 0x00} },
+	{"Gateway", "LT31", "v1.3302", 0x55, 0x58, {0x10, 0x0f, 0x00} },
 	/* Packard Bell */
 	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x21, 0x00} },
 	{"Packard Bell", "DOA150", "v0.3105", 0x55, 0x58, {0x20, 0x20, 0x00} },
@@ -495,13 +492,26 @@ static struct platform_driver acerhdf_dr
 	.remove = acerhdf_remove,
 };
 
+/* checks if str begins with start */
+static int str_starts_with(const char *str, const char *start)
+{
+	unsigned long str_len = 0, start_len = 0;
+
+	str_len = strlen(str);
+	start_len = strlen(start);
+
+	if (str_len >= start_len &&
+			!strncmp(str, start, start_len))
+		return 1;
+
+	return 0;
+}
 
 /* check hardware */
 static int acerhdf_check_hardware(void)
 {
 	char const *vendor, *version, *product;
-	int i;
-	unsigned long prod_len = 0;
+	const struct bios_settings_t *bt = NULL;
 
 	/* get BIOS data */
 	vendor  = dmi_get_system_info(DMI_SYS_VENDOR);
@@ -523,20 +533,20 @@ static int acerhdf_check_hardware(void)
 		kernelmode = 0;
 	}
 
-	prod_len = strlen(product);
-
 	if (verbose)
 		pr_info("BIOS info: %s %s, product: %s\n",
 			vendor, version, product);
 
 	/* search BIOS version and vendor in BIOS settings table */
-	for (i = 0; bios_tbl[i].version[0]; i++) {
-		if (strlen(bios_tbl[i].product) >= prod_len &&
-		    !strncmp(bios_tbl[i].product, product,
-			   strlen(bios_tbl[i].product)) &&
-		    !strcmp(bios_tbl[i].vendor, vendor) &&
-		    !strcmp(bios_tbl[i].version, version)) {
-			bios_cfg = &bios_tbl[i];
+	for (bt = bios_tbl; bt->vendor[0]; bt++) {
+		/*
+		 * check if actual hardware BIOS vendor, product and version
+		 * IDs start with the strings of BIOS table entry
+		 */
+		if (str_starts_with(vendor, bt->vendor) &&
+				str_starts_with(product, bt->product) &&
+				str_starts_with(version, bt->version)) {
+			bios_cfg = bt;
 			break;
 		}
 	}
_

Patches currently in -mm which might be from peter@piie.net are


