From: akpm@linux-foundation.org
Subject: + vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch added to -mm tree
Date: Mon, 02 Apr 2007 18:46:07 -0700
Message-ID: <200704030146.l331k7TO014893@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56966 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966146AbXDCBqf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 21:46:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com, hpa@zytor.com, jengelh@linux01.gwdg.de, leonerd@leonerd.org.uk


The patch titled
     vt: expose system-wide UTF-8 default setting via sysfs
has been added to the -mm tree.  Its filename is
     vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vt: expose system-wide UTF-8 default setting via sysfs
From: "Antonino A. Daplas" <adaplas@gmail.com>

Create a variable, default_utf8, that defines the system-wide default UTF-8
setting.  This variable can be altered via sysfs. If the variable is properly
set, this should mimimize breakage of UTF-8 encoded consoles when doing a
reset or echo -e '\033c' and of newly opened/allocated consoles.

This is based from patches by Jan Engelhardt and Paul LeoNerd Evans.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Paul LeoNerd Evans <leonerd@leonerd.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/char/vt.c~vt-expose-system-wide-utf-8-default-setting-via-sysfs drivers/char/vt.c
--- a/drivers/char/vt.c~vt-expose-system-wide-utf-8-default-setting-via-sysfs
+++ a/drivers/char/vt.c
@@ -157,6 +157,8 @@ static void blank_screen_t(unsigned long
 static void set_palette(struct vc_data *vc);
 
 static int printable;		/* Is console ready for printing? */
+static int default_utf8;
+module_param(default_utf8, int, S_IRUGO | S_IWUSR);
 
 /*
  * ignore_poke: don't unblank the screen when things are typed.  This is
@@ -1517,7 +1519,7 @@ static void reset_terminal(struct vc_dat
 	vc->vc_charset		= 0;
 	vc->vc_need_wrap	= 0;
 	vc->vc_report_mouse	= 0;
-	vc->vc_utf		= 0;
+	vc->vc_utf              = default_utf8;
 	vc->vc_utf_count	= 0;
 
 	vc->vc_disp_ctrl	= 0;
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
vt-do-not-clear-utf-when-resetting-console.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
