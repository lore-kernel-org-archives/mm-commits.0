From: akpm@linux-foundation.org
Subject: - sh7760fb-write-colormap-value-to-hardware.patch removed from -mm tree
Date: Tue, 29 Jul 2008 13:30:14 -0700
Message-ID: <200807292030.m6TKUEgQ019806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50669 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753621AbYG2Uab (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 16:30:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mano@roarinelk.homelinux.net, iwamatsu.nobuhiro@renesas.com, lethal@linux-sh.org, munakata.hisao@renesas.com, mm-commits@vger.kernel.org


The patch titled
     sh7760fb: write colormap value to hardware
has been removed from the -mm tree.  Its filename was
     sh7760fb-write-colormap-value-to-hardware.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-alsa-tiwai.patch

