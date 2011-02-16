From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static.patch added to -mm tree
Date: Wed, 16 Feb 2011 15:58:37 -0800
Message-ID: <201102162358.p1GNwbwq022377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755610Ab1BPX7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Feb 2011 18:59:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, kristoffer.ericson@gmail.com, rpurdie@rpsys.net


The patch titled
     drivers/video/backlight/jornada720_*.c: make needlessly global symbols static
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

drivers-video-backlight-jornada720_c-make-needlessly-global-symbols-static.patch

