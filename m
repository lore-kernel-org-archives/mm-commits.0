From: akpm@linux-foundation.org
Subject: + i810fb-fix-console-switch-regression.patch added to -mm tree
Date: Mon, 17 Mar 2008 20:47:25 -0700
Message-ID: <200803180347.m2I3lPFT012684@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806AbYCRDsV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 23:48:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefan.bauer@cs.tu-chemnitz.de, adaplas@pol.net, geert@linux-m68k.org, hmh@hmh.eng.br


The patch titled
     i810fb: fix console switch regression
has been added to the -mm tree.  Its filename is
     i810fb-fix-console-switch-regression.patch

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
Subject: i810fb: fix console switch regression
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>

Since 4c7ffe0b9f7f40bd818fe3af51342f64c483908e ("fbdev: prevent drivers that
have hardware cursors from calling software cursor code") every call of
i810fb_cursor fails with -ENXIO because of a incorrect "!".

This hasn't struck until eaa0ff15c30dc9799eb4d12660edb73aeb6d32c5 ("fix ! 
versus & precedence in various places") surrounded the expression with braces,
so that the intended behavior was inverted.  That caused 'pixel waste' - the
same line of multi-colored pixels repeated over the whole screen - during
console switch.

This switches back to the original pre-4c7ffe0 behavior.

Signed-off-by: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/i810/i810_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/i810/i810_main.c~i810fb-fix-console-switch-regression drivers/video/i810/i810_main.c
--- a/drivers/video/i810/i810_main.c~i810fb-fix-console-switch-regression
+++ a/drivers/video/i810/i810_main.c
@@ -1476,7 +1476,7 @@ static int i810fb_cursor(struct fb_info 
 	struct i810fb_par *par = info->par;
 	u8 __iomem *mmio = par->mmio_start_virtual;
 
-	if (!(par->dev_flags & LOCKUP))
+	if (par->dev_flags & LOCKUP)
 		return -ENXIO;
 
 	if (cursor->image.width > 64 || cursor->image.height > 64)
_

Patches currently in -mm which might be from stefan.bauer@cs.tu-chemnitz.de are

i810fb-fix-console-switch-regression.patch

