From: akpm@linux-foundation.org
Subject: + skeletonfb-more-corrections.patch added to -mm tree
Date: Mon, 07 May 2007 15:27:21 -0700
Message-ID: <200705072227.l47MRLXH006991@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966705AbXEGW2B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 18:28:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@gmail.com, jsimmons@infradead.org


The patch titled
     skeletonfb: more corrections
has been added to the -mm tree.  Its filename is
     skeletonfb-more-corrections.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: skeletonfb: more corrections
From: Krzysztof Helt <krzysztof.h1@wp.pl>

More corrections to skeletonfb.c file:
- fixed types of more arguments
- removed returned values in void functions
- removed not existing fb_poll function
- fixed closing comment typo
- corrected misleading constant name ADDR

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Acked-By: James Simmons <jsimmons@infradead.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/skeletonfb.c |   26 +++++---------------------
 1 files changed, 5 insertions(+), 21 deletions(-)

diff -puN drivers/video/skeletonfb.c~skeletonfb-more-corrections drivers/video/skeletonfb.c
--- a/drivers/video/skeletonfb.c~skeletonfb-more-corrections
+++ a/drivers/video/skeletonfb.c
@@ -148,7 +148,7 @@ int xxxfb_setup(char*);
  *
  *	Returns negative errno on error, or zero on success.
  */
-static int xxxfb_open(const struct fb_info *info, int user)
+static int xxxfb_open(struct fb_info *info, int user)
 {
     return 0;
 }
@@ -167,7 +167,7 @@ static int xxxfb_open(const struct fb_in
  *
  *	Returns negative errno on error, or zero on success.
  */
-static int xxxfb_release(const struct fb_info *info, int user)
+static int xxxfb_release(struct fb_info *info, int user)
 {
     return 0;
 }
@@ -629,19 +629,6 @@ void xxxfb_rotate(struct fb_info *info, 
 }
 
 /**
- *	xxxfb_poll - NOT a required function. The purpose of this
- *		     function is to provide a way for some process
- *		     to wait until a specific hardware event occurs
- *		     for the framebuffer device.
- * 				 
- *      @info: frame buffer structure that represents a single frame buffer
- *	@wait: poll table where we store process that await a event.     
- */
-void xxxfb_poll(struct fb_info *info, poll_table *wait)
-{
-}
-
-/**
  *	xxxfb_sync - NOT a required function. Normally the accel engine 
  *		     for a graphics card take a specific amount of time.
  *		     Often we have to wait for the accelerator to finish
@@ -678,7 +665,6 @@ static struct fb_ops xxxfb_ops = {
 	.fb_imageblit	= xxxfb_imageblit,	/* Needed !!! */
 	.fb_cursor	= xxxfb_cursor,		/* Optional !!! */
 	.fb_rotate	= xxxfb_rotate,
-	.fb_poll	= xxxfb_poll,
 	.fb_sync	= xxxfb_sync,
 	.fb_ioctl	= xxxfb_ioctl,
 	.fb_mmap	= xxxfb_mmap,
@@ -692,7 +678,7 @@ static struct fb_ops xxxfb_ops = {
 
 /* static int __init xxfb_probe (struct device *device) -- for platform devs */
 static int __devinit xxxfb_probe(struct pci_dev *dev,
-			      const_struct pci_device_id *ent)
+			      const struct pci_device_id *ent)
 {
     struct fb_info *info;
     struct xxx_par *par;
@@ -858,8 +844,6 @@ static void __devexit xxxfb_remove(struc
 		/* ... */
 		framebuffer_release(info);
 	}
-
-	return 0;
 }
 
 #ifdef CONFIG_PCI
@@ -902,7 +886,7 @@ static int xxxfb_resume(struct pci_dev *
 static struct pci_device_id xxxfb_id_table[] = {
 	{ PCI_VENDOR_ID_XXX, PCI_DEVICE_ID_XXX,
 	  PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY << 16,
-	  ADDR, 0 },
+	  PCI_CLASS_MASK, 0 },
 	{ 0, }
 };
 
@@ -1033,7 +1017,7 @@ int __init xxxfb_setup(char *options)
 {
     /* Parse user speficied options (`video=xxxfb:') */
 }
-#endif /* MODULE *?
+#endif /* MODULE */
 
 /* ------------------------------------------------------------------------- */
 
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
