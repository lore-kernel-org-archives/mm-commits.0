From: akpm@linux-foundation.org
Subject: + fbdev-do-not-let-config_fb_deferred_io-default-to-y.patch added to -mm tree
Date: Wed, 07 May 2008 15:51:10 -0700
Message-ID: <200805072251.m47MpAxG020928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762650AbYEGWvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 18:51:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, jayakumar.lkml@gmail.com


The patch titled
     fbdev: do not let CONFIG_FB_DEFERRED_IO default to y
has been added to the -mm tree.  Its filename is
     fbdev-do-not-let-config_fb_deferred_io-default-to-y.patch

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
fbdev-do-not-let-config_fb_deferred_io-default-to-y.patch
linux-next.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch

