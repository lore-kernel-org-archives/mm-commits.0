From: akpm@linux-foundation.org
Subject: - fbdev-add-removed-option-mode-to-keep-compatibility.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:11 -0700
Message-ID: <200804282158.m3SLwBCh018471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965316AbYD1V6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     fbdev: add removed option "mode" to keep compatibility
has been removed from the -mm tree.  Its filename was
     fbdev-add-removed-option-mode-to-keep-compatibility.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: add removed option "mode" to keep compatibility
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add removed option "mode" to keep compatibility with existing setups.  The
option is back for pm2fb, tridentfb and vt8623fb drivers.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm2fb.c     |    2 ++
 drivers/video/tridentfb.c |    2 ++
 drivers/video/vt8623fb.c  |    2 ++
 3 files changed, 6 insertions(+)

diff -puN drivers/video/pm2fb.c~fbdev-add-removed-option-mode-to-keep-compatibility drivers/video/pm2fb.c
--- a/drivers/video/pm2fb.c~fbdev-add-removed-option-mode-to-keep-compatibility
+++ a/drivers/video/pm2fb.c
@@ -1837,6 +1837,8 @@ module_exit(pm2fb_exit);
 
 module_param(mode_option, charp, 0);
 MODULE_PARM_DESC(mode_option, "Initial video mode e.g. '648x480-8@60'");
+module_param_named(mode, mode_option, charp, 0);
+MODULE_PARM_DESC(mode, "Initial video mode e.g. '648x480-8@60' (deprecated)");
 module_param(lowhsync, bool, 0);
 MODULE_PARM_DESC(lowhsync, "Force horizontal sync low regardless of mode");
 module_param(lowvsync, bool, 0);
diff -puN drivers/video/tridentfb.c~fbdev-add-removed-option-mode-to-keep-compatibility drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~fbdev-add-removed-option-mode-to-keep-compatibility
+++ a/drivers/video/tridentfb.c
@@ -75,6 +75,8 @@ static int nativex;
 
 module_param(mode_option, charp, 0);
 MODULE_PARM_DESC(mode_option, "Initial video mode e.g. '648x480-8@60'");
+module_param_named(mode, mode_option, charp, 0);
+MODULE_PARM_DESC(mode, "Initial video mode e.g. '648x480-8@60' (deprecated)");
 module_param(bpp, int, 0);
 module_param(center, int, 0);
 module_param(stretch, int, 0);
diff -puN drivers/video/vt8623fb.c~fbdev-add-removed-option-mode-to-keep-compatibility drivers/video/vt8623fb.c
--- a/drivers/video/vt8623fb.c~fbdev-add-removed-option-mode-to-keep-compatibility
+++ a/drivers/video/vt8623fb.c
@@ -112,6 +112,8 @@ MODULE_DESCRIPTION("fbdev driver for int
 
 module_param(mode_option, charp, 0644);
 MODULE_PARM_DESC(mode_option, "Default video mode ('640x480-8@60', etc)");
+module_param_named(mode, mode_option, charp, 0);
+MODULE_PARM_DESC(mode, "Default video mode e.g. '648x480-8@60' (deprecated)");
 
 #ifdef CONFIG_MTRR
 module_param(mtrr, int, 0444);
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

