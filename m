From: akpm@linux-foundation.org
Subject: - asus_acpi-add-support-for-asus-z81sp.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:23:19 -0800
Message-ID: <200702100523.l1A5NJOJ004522@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36659 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbXBJFXp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:23:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: calvinmc@gmail.com, acpi4asus-user@lists.sourceforge.net, corentincj@iksaif.net, sziwan@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     asus_acpi: Add support for Asus Z81SP
has been removed from the -mm tree.  Its filename was
     asus_acpi-add-support-for-asus-z81sp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: asus_acpi: Add support for Asus Z81SP
From: Matthew C Campbell <calvinmc@gmail.com>

Adds support in asus_acpi for the Asus Z81SP laptop.  This preserves all
old functionality when improperly detected as well as enabling Bluetooth
support.

Signed-off-by: Matthew C Campbell <calvinmc@gmail.com>
Cc: Corentin Chary <corentincj@iksaif.net>
Cc: Karol Kozimor <sziwan@users.sourceforge.net>
Cc: <acpi4asus-user@lists.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/asus_acpi.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/asus_acpi.c~asus_acpi-add-support-for-asus-z81sp drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c~asus_acpi-add-support-for-asus-z81sp
+++ a/drivers/acpi/asus_acpi.c
@@ -141,6 +141,7 @@ struct asus_hotk {
 		W5A,		//W5A
 		W3V,            //W3030V
 		xxN,		//M2400N, M3700N, M5200N, M6800N, S1300N, S5200N
+		A4S,            //Z81sp
 		//(Centrino)
 		END_MODEL
 	} model;		//Models currently supported
@@ -397,7 +398,16 @@ static struct model_data model_conf[END_
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
@@ -1117,6 +1127,8 @@ static int asus_model_match(char *model)
 		return W3V;
 	else if (strncmp(model, "W5A", 3) == 0)
 		return W5A;
+	else if (strncmp(model, "A4S", 3) == 0)
+		return A4S;
 	else
 		return END_MODEL;
 }
_

Patches currently in -mm which might be from calvinmc@gmail.com are

git-acpi.patch
