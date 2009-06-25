From: akpm@linux-foundation.org
Subject: + omapfb-fix-coding-style-remove-dead-line.patch added to -mm tree
Date: Wed, 24 Jun 2009 17:08:19 -0700
Message-ID: <200906250008.n5P08JBd005251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755030AbZFYAJF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 20:09:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arunedarath@mistralsolutions.com, imre.deak@nokia.com, krzysztof.h1@wp.pl, linux@arm.linux.org.uk, tony@atomide.com


The patch titled
     omapfb: fix coding style / remove dead line
has been added to the -mm tree.  Its filename is
     omapfb-fix-coding-style-remove-dead-line.patch

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
Subject: omapfb: fix coding style / remove dead line
From: arun c <arunedarath@mistralsolutions.com>

- use __iomem type attribute where appropriate
- expand (a ? : b) to (a ? a : b)
As suggested by Russel King <linux@arm.linux.org.uk>

- remove a dead line from omapfb_main.c

Signed-off-by: Arun C <arunedarath@mistralsolutions.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-omap/include/mach/omapfb.h |    4 ++--
 drivers/video/omap/omapfb_main.c         |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN arch/arm/plat-omap/include/mach/omapfb.h~omapfb-fix-coding-style-remove-dead-line arch/arm/plat-omap/include/mach/omapfb.h
--- a/arch/arm/plat-omap/include/mach/omapfb.h~omapfb-fix-coding-style-remove-dead-line
+++ a/arch/arm/plat-omap/include/mach/omapfb.h
@@ -276,8 +276,8 @@ typedef int (*omapfb_notifier_callback_t
 					  void *fbi);
 
 struct omapfb_mem_region {
-	dma_addr_t	paddr;
-	void		*vaddr;
+	u32		paddr;
+	void __iomem	*vaddr;
 	unsigned long	size;
 	u8		type;		/* OMAPFB_PLANE_MEM_* */
 	unsigned	alloc:1;	/* allocated by the driver */
diff -puN drivers/video/omap/omapfb_main.c~omapfb-fix-coding-style-remove-dead-line drivers/video/omap/omapfb_main.c
--- a/drivers/video/omap/omapfb_main.c~omapfb-fix-coding-style-remove-dead-line
+++ a/drivers/video/omap/omapfb_main.c
@@ -564,7 +564,6 @@ static int set_fb_var(struct fb_info *fb
 		var->xoffset = var->xres_virtual - var->xres;
 	if (var->yres + var->yoffset > var->yres_virtual)
 		var->yoffset = var->yres_virtual - var->yres;
-	line_size = var->xres * bpp / 8;
 
 	if (plane->color_mode == OMAPFB_COLOR_RGB444) {
 		var->red.offset	  = 8; var->red.length	 = 4;
@@ -1723,8 +1722,8 @@ static int omapfb_do_probe(struct platfo
 
 	pr_info("omapfb: configured for panel %s\n", fbdev->panel->name);
 
-	def_vxres = def_vxres ? : fbdev->panel->x_res;
-	def_vyres = def_vyres ? : fbdev->panel->y_res;
+	def_vxres = def_vxres ? def_vxres : fbdev->panel->x_res;
+	def_vyres = def_vyres ? def_vyres : fbdev->panel->y_res;
 
 	init_state++;
 
_

Patches currently in -mm which might be from arunedarath@mistralsolutions.com are

omapfb-add-support-for-the-omap2evm-lcd.patch
omapfb-add-support-for-the-omap3-evm-lcd.patch
omapfb-dispc-various-typo-fixes.patch
omapfb-fix-coding-style-remove-dead-line.patch

