From: akpm@linux-foundation.org
Subject: - fbdev-add-ultrasharp-uxga-to-broken-monitor-database-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:06:38 -0800
Message-ID: <200703060206.l2626dIw008900@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46869 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965709AbXCFCGo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:06:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: fix Sharp UXGA checking
has been removed from the -mm tree.  Its filename was
     fbdev-add-ultrasharp-uxga-to-broken-monitor-database-fix.patch

This patch was dropped because it was folded into fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch

------------------------------------------------------
Subject: fbdev: fix Sharp UXGA checking
From: "Antonino A. Daplas" <adaplas@gmail.com>

If the Ultrasharp UXGA is detected, the check function returns a nonzero
value.  It should return the type of fix instead.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/fbmon.c~fbdev-add-ultrasharp-uxga-to-broken-monitor-database-fix drivers/video/fbmon.c
--- a/drivers/video/fbmon.c~fbdev-add-ultrasharp-uxga-to-broken-monitor-database-fix
+++ a/drivers/video/fbmon.c
@@ -183,10 +183,11 @@ static int check_edid(unsigned char *edi
 		break;
 	case FBMON_FIX_TIMINGS:
 		b = edid + DETAILED_TIMING_DESCRIPTIONS_START;
+		ret = fix;
 
 		for (i = 0; i < 4; i++) {
 			if (edid_is_limits_block(b)) {
-				ret = fix;
+				ret = 0;
 				break;
 			}
 
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
nvidiafb-backlight-fix-implicit-declaration-in-nv_backlight.patch
atyfb-fix-kconfig-error-part-2.patch
fbdev-fix-kconfig-error-if-fb_ddc=n.patch
fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
fbdev-add-ultrasharp-uxga-to-broken-monitor-database-fix.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-hecuba-framebuffer-driver.patch
fbdev-hecuba-framebuffer-driver-fix.patch
