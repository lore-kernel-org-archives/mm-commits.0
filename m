From: akpm@linux-foundation.org
Subject: + uvesafb-the-driver-core-dont-access-vga-registers-directly-when-running-on-non-x86.patch added to -mm tree
Date: Wed, 12 Sep 2007 15:47:00 -0700
Message-ID: <200709122247.l8CMl0FC023051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51738 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754084AbXILWr0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Sep 2007 18:47:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spock@gentoo.org, adaplas@pol.net, hpa@zytor.com, lethal@linux-sh.org, pmarques@grupopie.com


The patch titled
     uvesafb: Don't access VGA registers directly when running on non-x86
has been added to the -mm tree.  Its filename is
     uvesafb-the-driver-core-dont-access-vga-registers-directly-when-running-on-non-x86.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uvesafb: Don't access VGA registers directly when running on non-x86
From: Michal Januszewski <spock@gentoo.org>

The VGA registers are only available at their legacy IO locations on x86. 
Don't try to access them when running on other arches.

Note that the code accessing them directly is just an optimization (limits
slow BIOS function calls).  We don't lose any functionality by using BIOS
calls instead of it on non-x86.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Paulo Marques <pmarques@grupopie.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/video/uvesafb.c~uvesafb-the-driver-core-dont-access-vga-registers-directly-when-running-on-non-x86 drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~uvesafb-the-driver-core-dont-access-vga-registers-directly-when-running-on-non-x86
+++ a/drivers/video/uvesafb.c
@@ -19,8 +19,10 @@
 #include <linux/io.h>
 #include <linux/mutex.h>
 #include <video/edid.h>
-#include <video/vga.h>
 #include <video/uvesafb.h>
+#ifdef CONFIG_X86
+#include <video/vga.h>
+#endif
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
 #endif
@@ -935,6 +937,7 @@ static int uvesafb_setpalette(struct uve
 	if (start + count > 256)
 		return -EINVAL;
 
+#ifdef CONFIG_X86
 	/* Use VGA registers if mode is VGA-compatible. */
 	if (i >= 0 && i < par->vbe_modes_cnt &&
 	    par->vbe_modes[i].mode_attr & VBE_MODE_VGACOMPAT) {
@@ -957,8 +960,10 @@ static int uvesafb_setpalette(struct uve
 		  "D" (entries),        /* EDI */
 		  "S" (&par->pmi_pal)); /* ESI */
 	}
-#endif
-	else {
+#endif /* CONFIG_X86_32 */
+	else
+#endif /* CONFIG_X86 */
+	{
 		task = uvesafb_prep();
 		if (!task)
 			return -ENOMEM;
@@ -1102,6 +1107,7 @@ static int uvesafb_blank(int blank, stru
 	struct uvesafb_ktask *task;
 	int err = 1;
 
+#ifdef CONFIG_X86
 	if (par->vbe_ib.capabilities & VBE_CAP_VGACOMPAT) {
 		int loop = 10000;
 		u8 seq = 0, crtc17 = 0;
@@ -1124,7 +1130,9 @@ static int uvesafb_blank(int blank, stru
 		while (loop--);
 		vga_wcrt(NULL, 0x17, crtc17);
 		vga_wseq(NULL, 0x00, 0x03);
-	} else {
+	} else
+#endif /* CONFIG_X86 */
+	{
 		task = uvesafb_prep();
 		if (!task)
 			return -ENOMEM;
_

Patches currently in -mm which might be from spock@gentoo.org are

fbdev-export-fb_destroy_modelist.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
uvesafb-the-driver-core.patch
uvesafb-the-driver-core-uvesafb-set-the-refresh-rate-to-60hz-if-nocrtc-is-used.patch
uvesafb-the-driver-core-uvesafb-always-use-mutexes-when-accessing-uvfb_tasks.patch
uvesafb-the-driver-core-uvesafb-fix-a-typo-in-a-warning.patch
uvesafb-the-driver-core-uvesafb-use-visual_truecolor-as-the-default-visual.patch
uvesafb-the-driver-core-uvesafb-use-the-default-refresh-rate-if-the-monitor-limits-are-not-set.patch
uvesafb-the-driver-core-uvesafb-try-to-set-mode-with-default-timings-if-setting-it-with-our-own-timings-failed.patch
uvesafb-the-driver-core-dont-access-vga-registers-directly-when-running-on-non-x86.patch
uvesafb-documentation.patch
uvesafb-documentation-uvesafb-add-info-about-pmipal-yrap-and-ypan-being-available-only-on-x86.patch
