From: akpm@linux-foundation.org
Subject: + viafb-use-read-only-mode-parsing.patch added to -mm tree
Date: Wed, 09 Sep 2009 13:40:05 -0700
Message-ID: <200909092040.n89Ke56Q013206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753915AbZIIUkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2009 16:40:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net, laforge@gnumonks.org


The patch titled
     viafb: use read-only mode parsing
has been added to the -mm tree.  Its filename is
     viafb-use-read-only-mode-parsing.patch

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

viafb-remove-duplicated-cx700-register-init.patch
viafb-remove-temporary-start-address-setting.patch
viafb-merge-viafb_update_viafb_par-in-viafb_update_fix.patch
viafb-split-viafb_set_start_addr-up.patch
viafb-fix-ioremap_nocache-error-handling.patch
viafb-clean-up-viamodeh.patch
viafb-remove-duplicated-mode-information.patch
viafb-clean-up-duoview.patch
viafb-clean-up-virtual-memory-handling.patch
viafb-remove-unused-video-device-stuff.patch
viafb-remove-lvds-initialization.patch
viafb-another-small-cleanup-of-viafb_par.patch
viafb-improve-viafb_par.patch
viafb-2d-engine-rewrite.patch
viafb-2d-engine-rewrite-v2.patch
viafb-switch-to-seq_file.patch
viafb-cleanup-viafb_cursor.patch
viafb-improve-pitch-handling.patch
viafb-hardware-acceleration-initialization-cleanup.patch
viafb-make-module-parameters-visible-in-sysfs.patch
viafb-remove-unused-structure-member.patch
viafb-use-read-only-mode-parsing.patch
fb-fix-fb_pan_display-range-check.patch
fb-do-not-ignore-fb_set_par-errors.patch

