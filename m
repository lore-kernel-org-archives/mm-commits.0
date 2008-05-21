From: akpm@linux-foundation.org
Subject: + sm501-reverse-fpen-vbiasen-flags-behaviour.patch added to -mm tree
Date: Wed, 21 May 2008 15:13:59 -0700
Message-ID: <200805212214.m4LMDxQB003444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756943AbYEUWOp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 May 2008 18:14:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-fbdev@fluff.org, arnaud.patard@rtp-net.org, ben-linux@fluff.org, krzysztof.h1@wp.pl


The patch titled
     SM501: reverse FPEN/VBIASEN flags behaviour
has been added to the -mm tree.  Its filename is
     sm501-reverse-fpen-vbiasen-flags-behaviour.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

sm501-reverse-fpen-vbiasen-flags-behaviour.patch
s3c2410-ensure-that-fb_blank_powerdown-shuts-down-the-controller.patch
s3c2410-add-error-print-if-we-cannot-add-attribute.patch
s3c2410-clean-out-changelog-header-and-tidy.patch
s3c2410-fix-driver-module_alias.patch

