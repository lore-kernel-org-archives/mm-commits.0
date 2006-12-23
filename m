From: akpm@osdl.org
Subject: - add-support-for-asus-a6va-m6v-w5f-v6v-laptops-in-asus-acpi.patch removed from -mm tree
Date: Fri, 22 Dec 2006 20:13:45 -0800
Message-ID: <200612230413.kBN4Dk0C007127@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38550 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbWLWENx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Dec 2006 23:13:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: papadako@gmail.com, thoenig@suse.de, mm-commits@vger.kernel.org


The patch titled
     Add support for ASUS A6VA, M6V, W5F, V6V laptops in asus-acpi
has been removed from the -mm tree.  Its filename was
     add-support-for-asus-a6va-m6v-w5f-v6v-laptops-in-asus-acpi.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: Add support for ASUS A6VA, M6V, W5F, V6V laptops in asus-acpi
From: "Panagiotis Papadakos" <papadako@gmail.com>

This patch is based on
http://www.mail-archive.com/linux-acpi@vger.kernel.org/msg02277.html
and adds support for ASUS A6VA, M6V, W5F and V6V laptops in asus-acpi.
Also some trailing spaces cleanups.

Cc: Timo Hoenig <thoenig@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/asus_acpi.c |   93 ++++++++++++++++++++++++++++++++-----
 1 files changed, 82 insertions(+), 11 deletions(-)

diff -puN drivers/acpi/asus_acpi.c~add-support-for-asus-a6va-m6v-w5f-v6v-laptops-in-asus-acpi drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c~add-support-for-asus-a6va-m6v-w5f-v6v-laptops-in-asus-acpi
+++ a/drivers/acpi/asus_acpi.c
@@ -122,6 +122,7 @@ struct asus_hotk {
 		A1x = 0,	//A1340D, A1300F
 		A2x,		//A2500H
 		A4G,		//A4700G
+		A6VA,           //A6VA
 		D1x,		//D1
 		L2D,		//L2000D
 		L3C,		//L3800C
@@ -134,12 +135,15 @@ struct asus_hotk {
 		M2E,		//M2400E, L4400L
 		M6N,		//M6800N, W3400N
 		M6R,		//M6700R, A3000G
+		M6V,            //M6A, M6V-B022P, M6V-8012P
 		P30,		//Samsung P30
 		S1x,		//S1300A, but also L1400B and M2400A (L84F)
 		S2x,		//S200 (J1 reported), Victor MP-XP7210
 		W1N,		//W1000N
-		W5A,		//W5A
 		W3V,            //W3030V
+		W5A,		//W5A
+		W5F,            //W5F
+		V6V,            //V6V
 		xxN,		//M2400N, M3700N, M5200N, M6800N, S1300N, S5200N
 		//(Centrino)
 		END_MODEL
@@ -194,6 +198,17 @@ static struct model_data model_conf[END_
 	 .display_get = "\\ADVG"},
 
 	{
+	 .name = "A6VA",
+	 .mt_mled = "MLED",
+	 .mt_wled = "WLED",
+	 .mt_lcd_switch = "\\Q11",
+	 .lcd_status = "\\RGPL",
+	 .brightness_set = "SPLV",
+	 .brightness_get = "GPLV",
+	 .display_set = "SDSP",
+	 .display_get = "\\ADVG"},
+
+	{
 	 .name = "D1x",
 	 .mt_mled = "MLED",
 	 .mt_lcd_switch = "\\Q0D",
@@ -326,6 +341,20 @@ static struct model_data model_conf[END_
 	 .display_get = "\\_SB.PCI0.P0P1.VGA.GETD"},
 
 	{
+	 .name = "M6V",
+	 .mt_bt_switch = "BLED",
+	 .mt_wled = "WLED",
+	 .mt_mled = NULL,
+	 .mt_lcd_switch = xxN_PREFIX "_Q10",
+	 .bt_status = "\\_SB.PCI0.SBRG.BLTS",
+	 .lcd_status = "\\RGPL",
+	 .wled_status = "\\WLSF",
+	 .display_get = "\\_SB.PCI0.P0P3.VGA.GETD",
+	 .display_set = "SDSP",
+	 .brightness_set = "SPLV",
+	 .brightness_get = "GPLV"},
+
+	{
 	 .name = "P30",
 	 .mt_wled = "WLED",
 	 .mt_lcd_switch = P30_PREFIX "_Q0E",
@@ -368,6 +397,17 @@ static struct model_data model_conf[END_
 	 .display_get = "\\ADVG"},
 
 	{
+	 .name = "W3V",
+	 .mt_mled = "MLED",
+	 .mt_wled = "WLED",
+	 .mt_lcd_switch = xxN_PREFIX "_Q10",
+	 .lcd_status = "\\BKLT",
+	 .brightness_set = "SPLV",
+	 .brightness_get = "GPLV",
+	 .display_set = "SDSP",
+	 .display_get = "\\INFB"},
+
+	{
 	 .name = "W5A",
 	 .mt_bt_switch = "BLED",
 	 .mt_wled = "WLED",
@@ -378,17 +418,30 @@ static struct model_data model_conf[END_
 	 .display_get = "\\ADVG"},
 
 	{
-	 .name = "W3V",
-	 .mt_mled = "MLED",
+	 .name = "W5F",
+	 .mt_bt_switch = "BLED",
 	 .mt_wled = "WLED",
+	 .mt_tled = "TLED",
 	 .mt_lcd_switch = xxN_PREFIX "_Q10",
-	 .lcd_status = "\\BKLT",
 	 .brightness_set = "SPLV",
 	 .brightness_get = "GPLV",
 	 .display_set = "SDSP",
-	 .display_get = "\\INFB"},
+	 .display_get = "\\ADVG"},
+
+	{
+	 .name = "V6V",
+	 .mt_bt_switch = "BLED",
+	 .mt_wled = "WLED",
+	 .mt_tled = "TLED",
+	 .mt_lcd_switch = xxN_PREFIX "_Q10",
+	 .bt_status = "\\_SB.PCI0.SBRG.BLTS",
+	 .display_get = "\\_SB.PCI0.POP1.VGA.GETD",
+	 .display_set = "SDSP",
+	 .brightness_set = "SPLV",
+	 .brightness_get = "GPLV",
+	 .lcd_status = "\\BKLT"},
 
-       {
+	{
 	 .name = "xxN",
 	 .mt_mled = "MLED",
 /* WLED present, but not controlled by ACPI */
@@ -695,7 +748,7 @@ static int get_lcd_state(void)
 {
 	int lcd = 0;
 
-	if (hotk->model != L3H) {
+	if (hotk->model != A6VA && hotk->model != M6V && hotk->model != L3H) {
 		/* We don't have to check anything if we are here */
 		if (!read_acpi_int(NULL, hotk->methods->lcd_status, &lcd))
 			printk(KERN_WARNING
@@ -715,9 +768,15 @@ static int get_lcd_state(void)
 		/* Note: the following values are partly guessed up, but 
 		   otherwise they seem to work */
 		mt_params[0].type = ACPI_TYPE_INTEGER;
-		mt_params[0].integer.value = 0x02;
 		mt_params[1].type = ACPI_TYPE_INTEGER;
-		mt_params[1].integer.value = 0x02;
+
+		if (hotk->model == A6VA || hotk->model == M6V) {
+			mt_params[0].integer.value = 0x15;
+			mt_params[1].integer.value = 0x01;
+		} else if (hotk->model == L3H) {
+			mt_params[0].integer.value = 0x02;
+			mt_params[1].integer.value = 0x02;
+		}
 
 		output.length = sizeof(out_obj);
 		output.pointer = &out_obj;
@@ -727,9 +786,13 @@ static int get_lcd_state(void)
 					 &input, &output);
 		if (status != AE_OK)
 			return -1;
-		if (out_obj.type == ACPI_TYPE_INTEGER)
+		if (out_obj.type == ACPI_TYPE_INTEGER) {
 			/* That's what the AML code does */
-			lcd = out_obj.integer.value >> 8;
+			if (hotk->model == A6VA || hotk->model == M6V)
+				lcd = out_obj.integer.value;
+			else if (hotk->model == L3H)
+				lcd = out_obj.integer.value >> 8;
+		}
 	}
 
 	return (lcd & 1);
@@ -1095,6 +1158,8 @@ static int asus_model_match(char *model)
 		return M1A;
 	else if (strncmp(model, "M2", 2) == 0 || strncmp(model, "L4E", 3) == 0)
 		return M2E;
+	else if (strncmp(model, "M6A", 3) == 0 || strncmp(model, "M6V", 3) == 0)
+		return M6V;
 	else if (strncmp(model, "L2", 2) == 0)
 		return L2D;
 	else if (strncmp(model, "L8", 2) == 0)
@@ -1105,6 +1170,8 @@ static int asus_model_match(char *model)
 		return A1x;
 	else if (strncmp(model, "A2", 2) == 0)
 		return A2x;
+	else if (strncmp(model, "A6VA", 4) == 0)
+		return A6VA;
 	else if (strncmp(model, "J1", 2) == 0)
 		return S2x;
 	else if (strncmp(model, "L5", 2) == 0)
@@ -1117,6 +1184,10 @@ static int asus_model_match(char *model)
 		return W3V;
 	else if (strncmp(model, "W5A", 3) == 0)
 		return W5A;
+	else if (strncmp(model, "W5F", 3) == 0)
+		return W5F;
+	else if (strncmp(model, "V6V", 3) == 0)
+		return V6V;
 	else
 		return END_MODEL;
 }
_

Patches currently in -mm which might be from papadako@gmail.com are

add-support-for-asus-a6va-m6v-w5f-v6v-laptops-in-asus-acpi.patch

