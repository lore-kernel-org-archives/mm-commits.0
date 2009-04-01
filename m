From: akpm@linux-foundation.org
Subject: [merged] fb-hide-hardware-cursor-in-graphics-mode-mach64.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:44:15 -0700
Message-ID: <200904011844.n31IiFNP010423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760985AbZDATZl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:25:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, geert@linux-m68k.org, risto.suominen@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fb: hide hardware cursor in graphics mode (Mach64)
has been removed from the -mm tree.  Its filename was
     fb-hide-hardware-cursor-in-graphics-mode-mach64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb: hide hardware cursor in graphics mode (Mach64)
From: Krzysztof Helt <krzysztof.h1@wp.pl>

A hardware cursor is left enabled in the fb_set_par() which is called when a
new console is created.  This is inconsistent with software cursor's
behaviour.

Also, this makes a hardware cursor always visible in the Xfbdev (Xorg kdrive)
server.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Risto Suominen <risto.suominen@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/mach64_accel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/video/aty/mach64_accel.c~fb-hide-hardware-cursor-in-graphics-mode-mach64 drivers/video/aty/mach64_accel.c
--- a/drivers/video/aty/mach64_accel.c~fb-hide-hardware-cursor-in-graphics-mode-mach64
+++ a/drivers/video/aty/mach64_accel.c
@@ -39,7 +39,8 @@ void aty_reset_engine(const struct atyfb
 {
 	/* reset engine */
 	aty_st_le32(GEN_TEST_CNTL,
-		aty_ld_le32(GEN_TEST_CNTL, par) & ~GUI_ENGINE_ENABLE, par);
+		aty_ld_le32(GEN_TEST_CNTL, par) &
+		~(GUI_ENGINE_ENABLE | HWCURSOR_ENABLE), par);
 	/* enable engine */
 	aty_st_le32(GEN_TEST_CNTL,
 		aty_ld_le32(GEN_TEST_CNTL, par) | GUI_ENGINE_ENABLE, par);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
linux-next.patch
tdfxfb-move-i2c-functionality-into-the-tdfxfb.patch
tdfxfb-make-use-of-ddc-information-about-connected-monitor.patch

