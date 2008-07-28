From: akpm@linux-foundation.org
Subject: + sh7760fb-write-colormap-value-to-hardware.patch added to -mm tree
Date: Mon, 28 Jul 2008 13:42:07 -0700
Message-ID: <200807282042.m6SKg7XN026249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39377 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759609AbYG1UoI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 16:44:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mano@roarinelk.homelinux.net, iwamatsu.nobuhiro@renesas.com, lethal@linux-sh.org, munakata.hisao@renesas.com


The patch titled
     sh7760fb: write colormap value to hardware
has been added to the -mm tree.  Its filename is
     sh7760fb-write-colormap-value-to-hardware.patch

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
Subject: sh7760fb: write colormap value to hardware
From: Manuel Lauss <mano@roarinelk.homelinux.net>

The computed color value is never actually written to hardware
colormap register.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Cc: Munakata Hisao <munakata.hisao@renesas.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sh7760fb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/sh7760fb.c~sh7760fb-write-colormap-value-to-hardware drivers/video/sh7760fb.c
--- a/drivers/video/sh7760fb.c~sh7760fb-write-colormap-value-to-hardware
+++ a/drivers/video/sh7760fb.c
@@ -152,6 +152,7 @@ static int sh7760fb_setcmap(struct fb_cm
 		col |= ((*g) & 0xff) << 8;
 		col |= ((*b) & 0xff);
 		col &= SH7760FB_PALETTE_MASK;
+		iowrite32(col, par->base + LDPR(s));
 
 		if (s < 16)
 			((u32 *) (info->pseudo_palette))[s] = s;
_

Patches currently in -mm which might be from mano@roarinelk.homelinux.net are

origin.patch
sh7760fb-write-colormap-value-to-hardware.patch
linux-next.patch

