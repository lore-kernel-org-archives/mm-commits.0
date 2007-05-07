From: akpm@linux-foundation.org
Subject: + skeletonfb-improvements.patch added to -mm tree
Date: Mon, 07 May 2007 15:27:25 -0700
Message-ID: <200705072227.l47MRPcY006998@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967034AbXEGW1x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 18:27:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com


The patch titled
     skeletonfb: improvements
has been added to the -mm tree.  Its filename is
     skeletonfb-improvements.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: skeletonfb: improvements
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch adds a macro to register PCI ids table and corrects type of
xxxfb_fix variable to avoid modpost warnings.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/skeletonfb.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/skeletonfb.c~skeletonfb-improvements drivers/video/skeletonfb.c
--- a/drivers/video/skeletonfb.c~skeletonfb-improvements
+++ a/drivers/video/skeletonfb.c
@@ -84,7 +84,7 @@ struct xxx_par;
  * if we don't use modedb. If we do use modedb see xxxfb_init how to use it
  * to get a fb_var_screeninfo. Otherwise define a default var as well. 
  */
-static struct fb_fix_screeninfo xxxfb_fix __initdata = {
+static struct fb_fix_screeninfo xxxfb_fix __devinitdata = {
 	.id =		"FB's name", 
 	.type =		FB_TYPE_PACKED_PIXELS,
 	.visual =	FB_VISUAL_PSEUDOCOLOR,
@@ -705,7 +705,7 @@ static int __devinit xxxfb_probe(struct 
     info->screen_base = framebuffer_virtual_memory;
     info->fbops = &xxxfb_ops;
     info->fix = xxxfb_fix; /* this will be the only time xxxfb_fix will be
-			    * used, so mark it as __initdata
+			    * used, so mark it as __devinitdata
 			    */
     info->pseudo_palette = pseudo_palette; /* The pseudopalette is an
 					    * 16-member array
@@ -900,6 +900,8 @@ static struct pci_driver xxxfb_driver = 
 	.resume =       xxxfb_resume,  /* optional but recommended */
 };
 
+MODULE_DEVICE_TABLE(pci, xxxfb_id_table);
+
 int __init xxxfb_init(void)
 {
 	/*
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

skeletonfb-various-corrections.patch
pm2fb-3dlabs-permedia-2v-reference-board-added.patch
pm2fb-permedia-2v-memory-clock-setting.patch
pm2fb-pixclock-setting-restriction.patch
pm2fb-reset-transparency-settings.patch
pm2fb-memclock-setting-corrections.patch
pm2fb-accelerated-fillrect-and-copyarea.patch
skeletonfb-more-corrections.patch
pm2fb-removal-of-pm2fb_par-fields.patch
skeletonfb-improvements.patch
pm2fb-fix-of-jumps-in-pm2fb_probe.patch
