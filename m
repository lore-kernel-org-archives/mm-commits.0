From: akpm@linux-foundation.org
Subject: [merged] viafb-use-read-only-mode-parsing.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:02:28 -0700
Message-ID: <200909232002.n8NK2Svf017271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707AbZIWUKK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:10:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net, laforge@gnumonks.org, mm-commits@vger.kernel.org


The patch titled
     viafb: use read-only mode parsing
has been removed from the -mm tree.  Its filename was
     viafb-use-read-only-mode-parsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: use read-only mode parsing
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

viafb: use read-only mode parsing

The previous method of mode parsing wrote to the strings resulting in
truncated mode strings in the sysfs.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Harald Welte <laforge@gnumonks.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |   44 ++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-use-read-only-mode-parsing drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-use-read-only-mode-parsing
+++ a/drivers/video/via/viafbdev.c
@@ -1821,11 +1821,29 @@ static void viafb_remove_proc(struct pro
 	remove_proc_entry("viafb", NULL);
 }
 
+static void parse_mode(const char *str, u32 *xres, u32 *yres)
+{
+	char *ptr;
+
+	*xres = simple_strtoul(str, &ptr, 10);
+	if (ptr[0] != 'x')
+		goto out_default;
+
+	*yres = simple_strtoul(&ptr[1], &ptr, 10);
+	if (ptr[0])
+		goto out_default;
+
+	return;
+
+out_default:
+	printk(KERN_WARNING "viafb received invalid mode string: %s\n", str);
+	*xres = 640;
+	*yres = 480;
+}
+
 static int __devinit via_pci_probe(void)
 {
-	unsigned long default_xres, default_yres;
-	char *tmpc, *tmpm;
-	char *tmpc_sec, *tmpm_sec;
+	u32 default_xres, default_yres;
 	int vmode_index;
 	u32 viafb_par_length;
 
@@ -1902,26 +1920,14 @@ static int __devinit via_pci_probe(void)
 			viafb_second_size * 1024 * 1024;
 	}
 
-	tmpm = viafb_mode;
-	tmpc = strsep(&tmpm, "x");
-	strict_strtoul(tmpc, 0, &default_xres);
-	strict_strtoul(tmpm, 0, &default_yres);
-
+	parse_mode(viafb_mode, &default_xres, &default_yres);
 	vmode_index = viafb_get_mode_index(default_xres, default_yres);
 	DEBUG_MSG(KERN_INFO "0->index=%d\n", vmode_index);
 
 	if (viafb_SAMM_ON == 1) {
-		if (strcmp(viafb_mode, viafb_mode1)) {
-			tmpm_sec = viafb_mode1;
-			tmpc_sec = strsep(&tmpm_sec, "x");
-			strict_strtoul(tmpc_sec, 0,
-				(unsigned long *)&viafb_second_xres);
-			strict_strtoul(tmpm_sec, 0,
-				(unsigned long *)&viafb_second_yres);
-		} else {
-			viafb_second_xres = default_xres;
-			viafb_second_yres = default_yres;
-		}
+		parse_mode(viafb_mode1, &viafb_second_xres,
+			&viafb_second_yres);
+
 		if (0 == viafb_second_virtual_xres) {
 			switch (viafb_second_xres) {
 			case 1400:
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

origin.patch

