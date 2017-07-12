From: akpm@linux-foundation.org
Subject: [patch 93/96] video: fbdev: intelfb: move inline before
 return type
Date: Wed, 12 Jul 2017 14:37:43 -0700
Message-ID: <20170712213743.v1CSmetC1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55326 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVho (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:37:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, b.zolnierkie@samsung.com, joe@perches.com, mbroemme@libmpq.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: video: fbdev: intelfb: move inline before return type

Make the code like the rest of the kernel.

But there is an oddity here because the inline should probably be removed.

It's an extern function in intelfb.h and it is used in intelfbdrv.c and
intelfbhw.c.

The inline is kept here as I suppose it's possible for some compiler to
make the uses inline in intelfbdrv and and also create an external
function for intelfbhw.

Link: http://lkml.kernel.org/r/8ba151a1fdc84e42cbf4aafc798513c0158edee1.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Maik Broemme <mbroemme@libmpq.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/intelfb/intelfbdrv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/fbdev/intelfb/intelfbdrv.c~video-fbdev-intelfb-move-inline-before-return-type drivers/video/fbdev/intelfb/intelfbdrv.c
--- a/drivers/video/fbdev/intelfb/intelfbdrv.c~video-fbdev-intelfb-move-inline-before-return-type
+++ a/drivers/video/fbdev/intelfb/intelfbdrv.c
@@ -907,7 +907,7 @@ static void intelfb_pci_unregister(struc
  *                       helper functions                      *
  ***************************************************************/
 
-int __inline__ intelfb_var_to_depth(const struct fb_var_screeninfo *var)
+__inline__ int intelfb_var_to_depth(const struct fb_var_screeninfo *var)
 {
 	DBG_MSG("intelfb_var_to_depth: bpp: %d, green.length is %d\n",
 		var->bits_per_pixel, var->green.length);
_
