From: akpm@linux-foundation.org
Subject: - fbdev-do-not-let-config_fb_deferred_io-default-to-y.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:01 -0700
Message-ID: <200805132134.m4DLY1WV000873@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759386AbYEMVeL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, jayakumar.lkml@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: do not let CONFIG_FB_DEFERRED_IO default to y
has been removed from the -mm tree.  Its filename was
     fbdev-do-not-let-config_fb_deferred_io-default-to-y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: do not let CONFIG_FB_DEFERRED_IO default to y
From: Geert Uytterhoeven <geert@linux-m68k.org>

CONFIG_FB_DEFERRED_IO can not be turned off, while it's already selected
automatically by the drivers that need it.

Although it's nice to have more compile-coverage, not being able to disable a
rarely used feature is annoying.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/video/Kconfig~fbdev-do-not-let-config_fb_deferred_io-default-to-y drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-do-not-let-config_fb_deferred_io-default-to-y
+++ a/drivers/video/Kconfig
@@ -171,7 +171,6 @@ config FB_SYS_FOPS
 config FB_DEFERRED_IO
 	bool
 	depends on FB
-	default y
 
 config FB_METRONOME
 	tristate
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
zorro-replace-deprecated-__initcall-with-equivalent-device_initcall.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch

