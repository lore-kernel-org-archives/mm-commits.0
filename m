From: akpm@linux-foundation.org
Subject: + fdev-export-symbol-fb_mode_option.patch added to -mm tree
Date: Thu, 29 May 2008 13:04:01 -0700
Message-ID: <200805292004.m4TK42Mv019694@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753273AbYE2UE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 May 2008 16:04:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geoffrey.levand@am.sony.com, Geert.Uytterhoeven@sonycom.com, krzysztof.h1@poczta.fm


The patch titled
     fdev: export symbol fb_mode_option
has been added to the -mm tree.  Its filename is
     fdev-export-symbol-fb_mode_option.patch

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
Subject: fdev: export symbol fb_mode_option
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

linux-next.patch
fdev-export-symbol-fb_mode_option.patch

