From: akpm@linux-foundation.org
Subject: + fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch added to -mm tree
Date: Tue, 27 Feb 2007 13:09:51 -0800
Message-ID: <200702272109.l1RL9t6k028671@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52270 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbXB0VJ7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:09:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbdev: add Ultrasharp UXGA to broken monitor database
has been added to the -mm tree.  Its filename is
     fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: add Ultrasharp UXGA to broken monitor database
From: "Antonino A. Daplas" <adaplas@gmail.com>

This particular monitor does not have a limits block and has only one set of
monitor timings.  Fix by adding a limits block to the EDID and extend the
horizontal sync frequency range to 30 kHz and 75 Khz.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmon.c |  168 ++++++++++++++++++++++++++--------------
 1 file changed, 112 insertions(+), 56 deletions(-)

diff -puN drivers/video/fbmon.c~fbdev-add-ultrasharp-uxga-to-broken-monitor-database drivers/video/fbmon.c
--- a/drivers/video/fbmon.c~fbdev-add-ultrasharp-uxga-to-broken-monitor-database
+++ a/drivers/video/fbmon.c
@@ -48,8 +48,9 @@
 #define DPRINTK(fmt, args...)
 #endif
 
-#define FBMON_FIX_HEADER 1
-#define FBMON_FIX_INPUT  2
+#define FBMON_FIX_HEADER  1
+#define FBMON_FIX_INPUT   2
+#define FBMON_FIX_TIMINGS 3
 
 #ifdef CONFIG_FB_MODE_HELPERS
 struct broken_edid {
@@ -71,6 +72,12 @@ static const struct broken_edid brokendb
 		.model        = 0x5a44,
 		.fix          = FBMON_FIX_INPUT,
 	},
+	/* Sharp UXGA? */
+	{
+		.manufacturer = "SHP",
+		.model        = 0x138e,
+		.fix          = FBMON_FIX_TIMINGS,
+	},
 };
 
 static const unsigned char edid_v1_header[] = { 0x00, 0xff, 0xff, 0xff,
@@ -87,6 +94,55 @@ static void copy_string(unsigned char *c
   while (i-- && (*--s == 0x20)) *s = 0;
 }
 
+static int edid_is_serial_block(unsigned char *block)
+{
+	if ((block[0] == 0x00) && (block[1] == 0x00) &&
+	    (block[2] == 0x00) && (block[3] == 0xff) &&
+	    (block[4] == 0x00))
+		return 1;
+	else
+		return 0;
+}
+
+static int edid_is_ascii_block(unsigned char *block)
+{
+	if ((block[0] == 0x00) && (block[1] == 0x00) &&
+	    (block[2] == 0x00) && (block[3] == 0xfe) &&
+	    (block[4] == 0x00))
+		return 1;
+	else
+		return 0;
+}
+
+static int edid_is_limits_block(unsigned char *block)
+{
+	if ((block[0] == 0x00) && (block[1] == 0x00) &&
+	    (block[2] == 0x00) && (block[3] == 0xfd) &&
+	    (block[4] == 0x00))
+		return 1;
+	else
+		return 0;
+}
+
+static int edid_is_monitor_block(unsigned char *block)
+{
+	if ((block[0] == 0x00) && (block[1] == 0x00) &&
+	    (block[2] == 0x00) && (block[3] == 0xfc) &&
+	    (block[4] == 0x00))
+		return 1;
+	else
+		return 0;
+}
+
+static int edid_is_timing_block(unsigned char *block)
+{
+	if ((block[0] != 0x00) || (block[1] != 0x00) ||
+	    (block[2] != 0x00) || (block[4] != 0x00))
+		return 1;
+	else
+		return 0;
+}
+
 static int check_edid(unsigned char *edid)
 {
 	unsigned char *block = edid + ID_MANUFACTURER_NAME, manufacturer[4];
@@ -104,9 +160,6 @@ static int check_edid(unsigned char *edi
 	for (i = 0; i < ARRAY_SIZE(brokendb); i++) {
 		if (!strncmp(manufacturer, brokendb[i].manufacturer, 4) &&
 			brokendb[i].model == model) {
-			printk("fbmon: The EDID Block of "
-			       "Manufacturer: %s Model: 0x%x is known to "
-			       "be broken,\n",  manufacturer, model);
  			fix = brokendb[i].fix;
  			break;
 		}
@@ -115,8 +168,10 @@ static int check_edid(unsigned char *edi
 	switch (fix) {
 	case FBMON_FIX_HEADER:
 		for (i = 0; i < 8; i++) {
-			if (edid[i] != edid_v1_header[i])
+			if (edid[i] != edid_v1_header[i]) {
 				ret = fix;
+				break;
+			}
 		}
 		break;
 	case FBMON_FIX_INPUT:
@@ -126,14 +181,33 @@ static int check_edid(unsigned char *edi
 		if (b[4] & 0x01 && b[0] & 0x80)
 			ret = fix;
 		break;
+	case FBMON_FIX_TIMINGS:
+		b = edid + DETAILED_TIMING_DESCRIPTIONS_START;
+
+		for (i = 0; i < 4; i++) {
+			if (edid_is_limits_block(b)) {
+				ret = fix;
+				break;
+			}
+
+			b += DETAILED_TIMING_DESCRIPTION_SIZE;
+		}
+
+		break;
 	}
 
+	if (ret)
+		printk("fbmon: The EDID Block of "
+		       "Manufacturer: %s Model: 0x%x is known to "
+		       "be broken,\n",  manufacturer, model);
+
 	return ret;
 }
 
 static void fix_edid(unsigned char *edid, int fix)
 {
-	unsigned char *b;
+	int i;
+	unsigned char *b, csum = 0;
 
 	switch (fix) {
 	case FBMON_FIX_HEADER:
@@ -145,6 +219,37 @@ static void fix_edid(unsigned char *edid
 		b = edid + EDID_STRUCT_DISPLAY;
 		b[0] &= ~0x80;
 		edid[127] += 0x80;
+		break;
+	case FBMON_FIX_TIMINGS:
+		printk("fbmon: trying to fix monitor timings\n");
+		b = edid + DETAILED_TIMING_DESCRIPTIONS_START;
+		for (i = 0; i < 4; i++) {
+			if (!(edid_is_serial_block(b) ||
+			      edid_is_ascii_block(b) ||
+			      edid_is_monitor_block(b) ||
+			      edid_is_timing_block(b))) {
+				b[0] = 0x00;
+				b[1] = 0x00;
+				b[2] = 0x00;
+				b[3] = 0xfd;
+				b[4] = 0x00;
+				b[5] = 60;   /* vfmin */
+				b[6] = 60;   /* vfmax */
+				b[7] = 30;   /* hfmin */
+				b[8] = 75;   /* hfmax */
+				b[9] = 17;   /* pixclock - 170 MHz*/
+				b[10] = 0;   /* GTF */
+				break;
+			}
+
+			b += DETAILED_TIMING_DESCRIPTION_SIZE;
+		}
+
+		for (i = 0; i < EDID_LENGTH - 1; i++)
+			csum += edid[i];
+
+		edid[127] = 256 - csum;
+		break;
 	}
 }
 
@@ -273,46 +378,6 @@ static void get_chroma(unsigned char *bl
 	DPRINTK("WhiteY:   0.%03d\n", specs->chroma.whitey);
 }
 
-static int edid_is_serial_block(unsigned char *block)
-{
-	if ((block[0] == 0x00) && (block[1] == 0x00) && 
-	    (block[2] == 0x00) && (block[3] == 0xff) &&
-	    (block[4] == 0x00))
-		return 1;
-	else
-		return 0;
-}
-
-static int edid_is_ascii_block(unsigned char *block)
-{
-	if ((block[0] == 0x00) && (block[1] == 0x00) && 
-	    (block[2] == 0x00) && (block[3] == 0xfe) &&
-	    (block[4] == 0x00))
-		return 1;
-	else
-		return 0;
-}
-
-static int edid_is_limits_block(unsigned char *block)
-{
-	if ((block[0] == 0x00) && (block[1] == 0x00) && 
-	    (block[2] == 0x00) && (block[3] == 0xfd) &&
-	    (block[4] == 0x00))
-		return 1;
-	else
-		return 0;
-}
-
-static int edid_is_monitor_block(unsigned char *block)
-{
-	if ((block[0] == 0x00) && (block[1] == 0x00) && 
-	    (block[2] == 0x00) && (block[3] == 0xfc) &&
-	    (block[4] == 0x00))
-		return 1;
-	else
-		return 0;
-}
-
 static void calc_mode_timings(int xres, int yres, int refresh,
 			      struct fb_videomode *mode)
 {
@@ -795,15 +860,6 @@ static void get_monspecs(unsigned char *
 	}
 }
 
-static int edid_is_timing_block(unsigned char *block)
-{
-	if ((block[0] != 0x00) || (block[1] != 0x00) ||
-	    (block[2] != 0x00) || (block[4] != 0x00))
-		return 1;
-	else
-		return 0;
-}
-
 int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
 {
 	int i;
_

Patches currently in -mm which might be from adaplas@gmail.com are

patch-maintainers-update-email-address.patch
atyfb-fix-kconfig-error.patch
fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-hecuba-framebuffer-driver.patch
