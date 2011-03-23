From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:33:27 -0700
Message-ID: <201103232037.p2NKb3Kc028204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756157Ab1CWUzQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, kristoffer.ericson@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/jornada720_*.c: make needlessly global symbols static
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/jornada720_*.c: make needlessly global symbols static
From: Axel Lin <axel.lin@gmail.com>

The following symbols are needlessly defined global:
jornada_bl_init
jornada_bl_exit
jornada_lcd_init
jornada_lcd_exit

Make them static.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/jornada720_bl.c  |    4 ++--
 drivers/video/backlight/jornada720_lcd.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/jornada720_bl.c~drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static drivers/video/backlight/jornada720_bl.c
--- a/drivers/video/backlight/jornada720_bl.c~drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static
+++ a/drivers/video/backlight/jornada720_bl.c
@@ -147,12 +147,12 @@ static struct platform_driver jornada_bl
 	},
 };
 
-int __init jornada_bl_init(void)
+static int __init jornada_bl_init(void)
 {
 	return platform_driver_register(&jornada_bl_driver);
 }
 
-void __exit jornada_bl_exit(void)
+static void __exit jornada_bl_exit(void)
 {
 	platform_driver_unregister(&jornada_bl_driver);
 }
diff -puN drivers/video/backlight/jornada720_lcd.c~drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static drivers/video/backlight/jornada720_lcd.c
--- a/drivers/video/backlight/jornada720_lcd.c~drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static
+++ a/drivers/video/backlight/jornada720_lcd.c
@@ -135,12 +135,12 @@ static struct platform_driver jornada_lc
 	},
 };
 
-int __init jornada_lcd_init(void)
+static int __init jornada_lcd_init(void)
 {
 	return platform_driver_register(&jornada_lcd_driver);
 }
 
-void __exit jornada_lcd_exit(void)
+static void __exit jornada_lcd_exit(void)
 {
 	platform_driver_unregister(&jornada_lcd_driver);
 }
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch

