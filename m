From: akpm@linux-foundation.org
Subject: - vt-do-not-clear-utf-when-resetting-console.patch removed from -mm tree
Date: Mon, 02 Apr 2007 18:46:26 -0700
Message-ID: <200704030146.l331kQb5014903@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56957 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966141AbXDCBqd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 21:46:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, hpa@zytor.com, jengelh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     vt: do not clear UTF when resetting console
has been removed from the -mm tree.  Its filename was
     vt-do-not-clear-utf-when-resetting-console.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: vt: do not clear UTF when resetting console
From: "Antonino A. Daplas" <adaplas@gmail.com>

Resetting the console, either by ANSI escape sequences or by the reset
utility, will drop the console back to legacy (non-UTF-8) mode.  Fix this
by leaving the field vc_data.vc_utf untouched in reset_terminal().  In
addition, a global variable (default_utf8) which defines system-wide UTF-8
setting is created.  This variable can be adjusted via sysfs.

This is based from patches by Jan Engelhardt and Paul LeoNerd Evans.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/char/vt.c~vt-do-not-clear-utf-when-resetting-console drivers/char/vt.c
--- a/drivers/char/vt.c~vt-do-not-clear-utf-when-resetting-console
+++ a/drivers/char/vt.c
@@ -157,6 +157,8 @@ static void blank_screen_t(unsigned long
 static void set_palette(struct vc_data *vc);
 
 static int printable;		/* Is console ready for printing? */
+static int default_utf8;
+module_param(default_utf8, int, S_IRUGO | S_IWUSR);
 
 /*
  * ignore_poke: don't unblank the screen when things are typed.  This is
@@ -1517,7 +1519,6 @@ static void reset_terminal(struct vc_dat
 	vc->vc_charset		= 0;
 	vc->vc_need_wrap	= 0;
 	vc->vc_report_mouse	= 0;
-	vc->vc_utf		= 0;
 	vc->vc_utf_count	= 0;
 
 	vc->vc_disp_ctrl	= 0;
@@ -2615,6 +2616,7 @@ static void vc_init(struct vc_data *vc, 
 	vc->vc_rows = rows;
 	vc->vc_size_row = cols << 1;
 	vc->vc_screenbuf_size = vc->vc_rows * vc->vc_size_row;
+	vc->vc_utf = default_utf8;
 
 	set_origin(vc);
 	vc->vc_pos = vc->vc_origin;
_

Patches currently in -mm which might be from adaplas@gmail.com are

fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-mm-deferred-io-support-fix-2.patch
fbdev-hecuba-framebuffer-driver.patch
fbdev-hecuba-framebuffer-driver-fix.patch
nvidiafb-fix-reversed-ddc-port.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
vt-do-not-clear-utf-when-resetting-console.patch
