From: akpm@linux-foundation.org
Subject: - fdev-export-symbol-fb_mode_option.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:48:55 -0700
Message-ID: <200806081948.m58JmtQs017543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754469AbYFHTtH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:49:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geoffrey.levand@am.sony.com, Geert.Uytterhoeven@sonycom.com, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbdev: export symbol fb_mode_option
has been removed from the -mm tree.  Its filename was
     fdev-export-symbol-fb_mode_option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: export symbol fb_mode_option
From: Geoff Levand <geoffrey.levand@am.sony.com>

Frame buffer and mode setting drivers can be built as modules,
so fb_mode_option needs to be exported to support these.

Prevents this error:

  ERROR: "fb_mode_option" [drivers/ps3/ps3av_mod.ko] undefined!

Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/modedb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/modedb.c~fdev-export-symbol-fb_mode_option drivers/video/modedb.c
--- a/drivers/video/modedb.c~fdev-export-symbol-fb_mode_option
+++ a/drivers/video/modedb.c
@@ -28,6 +28,7 @@
 #endif
 
 const char *fb_mode_option;
+EXPORT_SYMBOL_GPL(fb_mode_option);
 
     /*
      *  Standard video mode definitions (taken from XFree86)
_

Patches currently in -mm which might be from geoffrey.levand@am.sony.com are

origin.patch
linux-next.patch

