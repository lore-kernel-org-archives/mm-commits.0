From: akpm@linux-foundation.org
Subject: + fbdev-fb_goldfish-should-depend-on-has_dma.patch added to -mm
 tree
Date: Wed, 22 May 2013 13:50:27 -0700
Message-ID: <519d2f93.7mrpwJTSLCnkyycu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab3EVUu2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 16:50:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, FlorianSchandinat@gmx.de, geert@linux-m68k.org

Subject: + fbdev-fb_goldfish-should-depend-on-has_dma.patch added to -mm tree
To: geert@linux-m68k.org,FlorianSchandinat@gmx.de
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 13:50:27 -0700


The patch titled
     Subject: fbdev: FB_GOLDFISH should depend on HAS_DMA
has been added to the -mm tree.  Its filename is
     fbdev-fb_goldfish-should-depend-on-has_dma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: fbdev: FB_GOLDFISH should depend on HAS_DMA

If NO_DMA=y:

drivers/built-in.o: In function `goldfish_fb_remove':
drivers/video/goldfishfb.c:301: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `goldfish_fb_probe':
drivers/video/goldfishfb.c:247: undefined reference to `dma_alloc_coherent'
drivers/video/goldfishfb.c:280: undefined reference to `dma_free_coherent'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~fbdev-fb_goldfish-should-depend-on-has_dma drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-fb_goldfish-should-depend-on-has_dma
+++ a/drivers/video/Kconfig
@@ -2199,7 +2199,7 @@ config FB_XILINX
 
 config FB_GOLDFISH
 	tristate "Goldfish Framebuffer"
-	depends on FB
+	depends on FB && HAS_DMA
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch
fbdev-fb_goldfish-should-depend-on-has_dma.patch
init-remove-permanent-string-buffer-from-do_one_initcall.patch
drivers-rtc-rtc-msm6242c-remove-empty-function.patch
lib-add-weak-clz-ctz-functions.patch

