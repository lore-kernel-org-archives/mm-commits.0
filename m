From: akpm@linux-foundation.org
Subject: + fbcon-kill-compile-warning.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:40:38 -0700
Message-ID: <200708012240.l71MecVL021126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754000AbXHAWlR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:41:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbcon: Kill compile warning
has been added to the -mm tree.  Its filename is
     fbcon-kill-compile-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbcon: Kill compile warning
From: "Antonino A. Daplas" <adaplas@gmail.com>

Fix compile warning ('map_override unused') if fbcon is compiled as a module
and CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=n.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.c~fbcon-kill-compile-warning drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-kill-compile-warning
+++ a/drivers/video/console/fbcon.c
@@ -127,8 +127,18 @@ static int last_fb_vc = MAX_NR_CONSOLES 
 static int fbcon_is_default = 1; 
 static int fbcon_has_exited;
 static int primary_device = -1;
+
+#ifdef CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
 static int map_override;
 
+static inline void fbcon_map_override(void)
+{
+	map_override = 1;
+}
+#else
+#define fbcon_map_override(...) do { } while (0)
+#endif /* CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY */
+
 /* font data */
 static char fontname[40];
 
@@ -506,7 +516,7 @@ static int __init fb_console_setup(char 
 						(options[j++]-'0') % FB_MAX;
 				}
 
-				map_override = 1;
+				fbcon_map_override();
 			}
 
 			return 1;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
stifb-detect-cards-in-double-buffer-mode-more-reliably.patch
fbcon-kill-compile-warning.patch
pvr2fb-fix-oops-when-pseudo_palette-is-written.patch
pvr2fb-consolidated-cleanup-of-pvr2fbc.patch
pvr2fb-update-documentation-fb-pvr2fbtxt.patch
matroxfb-rectify-jitter-g450-g550.patch
fbdev-export-fb_destroy_modelist.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
uvesafb-the-driver-core.patch
uvesafb-documentation.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
sm501fb-update-suspend-and-resume-code.patch
sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch
sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch
mbxfb-improvements-and-new-features.patch
pxafb-add-support-for-other-palette-formats.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
fbdev-fix-incorrect-timings-in-some-modedb-entries.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
