From: akpm@linux-foundation.org
Subject: + fbdev-add-removed-option-mode-to-keep-compatibility.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:34:56 -0800
Message-ID: <200802230735.m1N7ZjrJ018375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55421 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbYBWHyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     fbdev: add removed option "mode" to keep compatibility
has been added to the -mm tree.  Its filename is
     fbdev-add-removed-option-mode-to-keep-compatibility.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

pm2fb-correct-error-values-returned-from-probe-function.patch
pm2fb-change-option-mode-to-mode_option.patch
tridentfb-change-option-mode-to-mode_option.patch
pm3fb-change-option-mode-to-mode_option.patch
update-modedbtxt-documentation-about-mode_option-parameter-change.patch
vt8623fb-change-option-mode-to-mode_option.patch
arkfb-add-option-mode_option.patch
s3fb-add-option-mode_option.patch
fbdev-add-removed-option-mode-to-keep-compatibility.patch
