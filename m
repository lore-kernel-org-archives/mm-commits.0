From: akpm@linux-foundation.org
Subject: - fbcon-kill-compile-warning.patch removed from -mm tree
Date: Mon, 13 Aug 2007 22:02:35 -0700
Message-ID: <200708140502.l7E52ZJn031985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760475AbXHNFDO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 01:03:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbcon: Kill compile warning
has been removed from the -mm tree.  Its filename was
     fbcon-kill-compile-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbcon: Kill compile warning
From: "Antonino A. Daplas" <adaplas@gmail.com>

Fix compile warning ('map_override unused') if fbcon is compiled as a module
and CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=n.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/video/console/fbcon.c~fbcon-kill-compile-warning drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-kill-compile-warning
+++ a/drivers/video/console/fbcon.c
@@ -127,8 +127,20 @@ static int last_fb_vc = MAX_NR_CONSOLES 
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
+static inline void fbcon_map_override(void)
+{
+}
+#endif /* CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY */
+
 /* font data */
 static char fontname[40];
 
@@ -506,7 +518,7 @@ static int __init fb_console_setup(char 
 						(options[j++]-'0') % FB_MAX;
 				}
 
-				map_override = 1;
+				fbcon_map_override();
 			}
 
 			return 1;
_

Patches currently in -mm which might be from adaplas@gmail.com are

git-avr32.patch
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
tdfxfb-mtrr-support-fix.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
