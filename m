From: akpm@linux-foundation.org
Subject: - vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch removed from -mm tree
Date: Tue, 08 May 2007 20:00:11 -0700
Message-ID: <200705090300.l4930Bi2010534@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032828AbXEIDAY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:00:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, hpa@zytor.com, jengelh@linux01.gwdg.de, leonerd@leonerd.org.uk, mm-commits@vger.kernel.org


The patch titled
     vt: expose system-wide UTF-8 default setting via sysfs
has been removed from the -mm tree.  Its filename was
     vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
