From: akpm@linux-foundation.org
Subject: - sm501-reverse-fpen-vbiasen-flags-behaviour.patch removed from -mm tree
Date: Tue, 27 May 2008 00:27:54 -0700
Message-ID: <200805270727.m4R7RstZ014802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756145AbYE0H3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:29:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-fbdev@fluff.org, arnaud.patard@rtp-net.org, ben-linux@fluff.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     SM501: reverse FPEN/VBIASEN flags behaviour
has been removed from the -mm tree.  Its filename was
     sm501-reverse-fpen-vbiasen-flags-behaviour.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: SM501: reverse FPEN/VBIASEN flags behaviour
From: Ben Dooks <ben-fbdev@fluff.org>

To keep backwards compatibility, reverse the meanings of these flags so
that when they are not set, the driver uses the original behvaiour.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sm501fb.c |    8 ++++----
 include/linux/sm501.h   |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/video/sm501fb.c~sm501-reverse-fpen-vbiasen-flags-behaviour drivers/video/sm501fb.c
--- a/drivers/video/sm501fb.c~sm501-reverse-fpen-vbiasen-flags-behaviour
+++ a/drivers/video/sm501fb.c
@@ -663,14 +663,14 @@ static void sm501fb_panel_power(struct s
 		sm501fb_sync_regs(fbi);
 		mdelay(10);
 
-		if (pd->flags & SM501FB_FLAG_PANEL_USE_VBIASEN) {
+		if (!(pd->flags & SM501FB_FLAG_PANEL_NO_VBIASEN)) {
 			control |= SM501_DC_PANEL_CONTROL_BIAS;	/* VBIASEN */
 			writel(control, ctrl_reg);
 			sm501fb_sync_regs(fbi);
 			mdelay(10);
 		}
 
-		if (pd->flags & SM501FB_FLAG_PANEL_USE_FPEN) {
+		if (!(pd->flags & SM501FB_FLAG_PANEL_NO_FPEN)) {
 			control |= SM501_DC_PANEL_CONTROL_FPEN;
 			writel(control, ctrl_reg);
 			sm501fb_sync_regs(fbi);
@@ -678,14 +678,14 @@ static void sm501fb_panel_power(struct s
 		}
 	} else if (!to && (control & SM501_DC_PANEL_CONTROL_VDD) != 0) {
 		/* disable panel power */
-		if (pd->flags & SM501FB_FLAG_PANEL_USE_FPEN) {
+		if (!(pd->flags & SM501FB_FLAG_PANEL_NO_FPEN)) {
 			control &= ~SM501_DC_PANEL_CONTROL_FPEN;
 			writel(control, ctrl_reg);
 			sm501fb_sync_regs(fbi);
 			mdelay(10);
 		}
 
-		if (pd->flags & SM501FB_FLAG_PANEL_USE_VBIASEN) {
+		if (!(pd->flags & SM501FB_FLAG_PANEL_NO_VBIASEN)) {
 			control &= ~SM501_DC_PANEL_CONTROL_BIAS;
 			writel(control, ctrl_reg);
 			sm501fb_sync_regs(fbi);
diff -puN include/linux/sm501.h~sm501-reverse-fpen-vbiasen-flags-behaviour include/linux/sm501.h
--- a/include/linux/sm501.h~sm501-reverse-fpen-vbiasen-flags-behaviour
+++ a/include/linux/sm501.h
@@ -71,8 +71,8 @@ extern unsigned long sm501_gpio_get(stru
 #define SM501FB_FLAG_DISABLE_AT_EXIT	(1<<1)
 #define SM501FB_FLAG_USE_HWCURSOR	(1<<2)
 #define SM501FB_FLAG_USE_HWACCEL	(1<<3)
-#define SM501FB_FLAG_PANEL_USE_FPEN	(1<<4)
-#define SM501FB_FLAG_PANEL_USE_VBIASEN	(1<<5)
+#define SM501FB_FLAG_PANEL_NO_FPEN	(1<<4)
+#define SM501FB_FLAG_PANEL_NO_VBIASEN	(1<<5)
 
 struct sm501_platdata_fbsub {
 	struct fb_videomode	*def_mode;
_

Patches currently in -mm which might be from ben-fbdev@fluff.org are


