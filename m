From: akpm@osdl.org
Subject: + asus_acpi-add-support-for-asus-z81sp.patch added to -mm tree
Date: Thu, 14 Dec 2006 16:43:31 -0800
Message-ID: <200612150043.kBF0hVNC001764@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:46444 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932186AbWLOAnd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 19:43:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: calvinmc@gmail.com


The patch titled
     asus_acpi: Add support for Asus Z81SP
has been added to the -mm tree.  Its filename is
     asus_acpi-add-support-for-asus-z81sp.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: asus_acpi: Add support for Asus Z81SP
From: Matthew C Campbell <calvinmc@gmail.com>

Adds support in asus_acpi for the Asus Z81SP laptop.  This preserves all
old functionality when improperly detected as well as enabling Bluetooth
support.

Signed-off-by: Matthew C Campbell <calvinmc@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/asus_acpi.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/asus_acpi.c~asus_acpi-add-support-for-asus-z81sp drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c~asus_acpi-add-support-for-asus-z81sp
+++ a/drivers/acpi/asus_acpi.c
@@ -145,6 +145,7 @@ struct asus_hotk {
 		W5F,            //W5F
 		V6V,            //V6V
 		xxN,		//M2400N, M3700N, M5200N, M6800N, S1300N, S5200N
+		A4S,            //Z81sp
 		//(Centrino)
 		END_MODEL
 	} model;		//Models currently supported
@@ -450,7 +451,16 @@ static struct model_data model_conf[END_
 	 .brightness_set = "SPLV",
 	 .brightness_get = "GPLV",
 	 .display_set = "SDSP",
-	 .display_get = "\\ADVG"}
+	.display_get = "\\ADVG"},
+
+	{
+		.name              = "A4S",
+		.brightness_set    = "SPLV",
+		.brightness_get    = "GPLV",
+		.mt_bt_switch      = "BLED",
+		.mt_wled           = "WLED"
+	}
+
 };
 
 /* procdir we use */
@@ -1189,6 +1199,8 @@ static int asus_model_match(char *model)
 		return W5F;
 	else if (strncmp(model, "V6V", 3) == 0)
 		return V6V;
+	else if (strncmp(model, "A4S", 3) == 0)
+		return A4S;
 	else
 		return END_MODEL;
 }
_

Patches currently in -mm which might be from calvinmc@gmail.com are

asus_acpi-add-support-for-asus-z81sp.patch

