From: akpm@linux-foundation.org
Subject: + revert-fbdev-atafb-add-palette-register-check.patch added to -mm tree
Date: Thu, 17 Dec 2009 14:00:06 -0800
Message-ID: <200912172200.nBHM06WP021068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763075AbZLQWAz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Dec 2009 17:00:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, krzysztof.h1@wp.pl


The patch titled
     Revert "fbdev: atafb - add palette register check"
has been added to the -mm tree.  Its filename is
     revert-fbdev-atafb-add-palette-register-check.patch

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
Subject: Revert "fbdev: atafb - add palette register check"
From: Geert Uytterhoeven <geert@linux-m68k.org>

This reverts commit 8546e3ce6e37c359979b69862442f94e0ef0e03b, as it's a
partial duplicate of commit 2f390380ca69e1617cdddb12d8da94f0a9f4319d ("fbdev:
add palette register check to several drivers").
The former went in first through the m68k tree, the latter through Andrew
Morton.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/atafb.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/video/atafb.c~revert-fbdev-atafb-add-palette-register-check drivers/video/atafb.c
--- a/drivers/video/atafb.c~revert-fbdev-atafb-add-palette-register-check
+++ a/drivers/video/atafb.c
@@ -2242,9 +2242,6 @@ static int ext_setcolreg(unsigned int re
 	if (!external_vgaiobase)
 		return 1;
 
-	if (regno > 255)
-		return 1;
