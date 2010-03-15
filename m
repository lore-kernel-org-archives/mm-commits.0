From: akpm@linux-foundation.org
Subject: [merged] fbdev-remove-obsolete-config_fb_soft_cursor.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:57:03 -0400
Message-ID: <201003150657.o2F6vaXt016385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756997Ab0COG5v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:57:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: siccegge@stud.informatik.uni-erlangen.de, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     fbdev: remove obsolete CONFIG_FB_SOFT_CURSOR
has been removed from the -mm tree.  Its filename was
     fbdev-remove-obsolete-config_fb_soft_cursor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: remove obsolete CONFIG_FB_SOFT_CURSOR
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>

The config Option FB_SOFT_BUFFER was removed in
c465e05a03209651078b95686158648fd7ed84c5 ("fbcon/fbdev: Move softcursor
out of fbdev to fbcon").

While moving to fbcon this single driver has it left as a select in
KConfig / #ifdef in source.  This last occurence is removed here so the
option is really gone

Signed-off-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig        |    1 -
 drivers/video/sis/sis_main.c |    3 ---
 2 files changed, 4 deletions(-)

diff -puN drivers/video/Kconfig~fbdev-remove-obsolete-config_fb_soft_cursor drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-remove-obsolete-config_fb_soft_cursor
+++ a/drivers/video/Kconfig
@@ -1494,7 +1494,6 @@ config FB_VIA
        select FB_CFB_FILLRECT
        select FB_CFB_COPYAREA
        select FB_CFB_IMAGEBLIT
-       select FB_SOFT_CURSOR
        select I2C_ALGOBIT
        select I2C
        help
diff -puN drivers/video/sis/sis_main.c~fbdev-remove-obsolete-config_fb_soft_cursor drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~fbdev-remove-obsolete-config_fb_soft_cursor
+++ a/drivers/video/sis/sis_main.c
@@ -1891,9 +1891,6 @@ static struct fb_ops sisfb_ops = {
 	.fb_fillrect	= fbcon_sis_fillrect,
 	.fb_copyarea	= fbcon_sis_copyarea,
 	.fb_imageblit	= cfb_imageblit,
-#ifdef CONFIG_FB_SOFT_CURSOR
-	.fb_cursor	= soft_cursor,
-#endif
 	.fb_sync	= fbcon_sis_sync,
 #ifdef SIS_NEW_CONFIG_COMPAT
 	.fb_compat_ioctl= sisfb_ioctl,
_

Patches currently in -mm which might be from siccegge@stud.informatik.uni-erlangen.de are

origin.patch
obsolete-config-in-kernel-source-use_internal_timer.patch
obsolete-config-in-kernel-source-hso_autopm.patch

