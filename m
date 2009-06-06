From: akpm@linux-foundation.org
Subject: + fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers.patch added to -mm tree
Date: Fri, 05 Jun 2009 18:50:12 -0700
Message-ID: <200906060150.n561oCGK001294@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945AbZFFBus (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jun 2009 21:50:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: airlied@redhat.com, geert@linux-m68k.org, krzysztof.h1@poczta.fm, pjones@redhat.com


The patch titled
     fbdev: add support for handoff from firmware to hw framebuffers
has been added to the -mm tree.  Its filename is
     fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers.patch

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
Subject: fbdev: add support for handoff from firmware to hw framebuffers
From: Dave Airlie <airlied@redhat.com>

With KMS we have ran into an issue where we really want the KMS fb driver
to be the one running the console, so panics etc can be shown by switching
out of X etc.

However with vesafb/efifb built-in, we end up with those on fb0 and the
KMS fb driver on fb1, driving the same piece of hw, so this adds an fb
info flag to denote a firmware fbdev, and adds a new aperture base/size
range which can be compared when the hw drivers are installed to see if
there is a conflict with a firmware driver, and if there is the firmware
driver is unregistered and the hw driver takes over.

It uses new aperture_base/size members instead of comparing on the fix
smem_start/length, as smem_start/length might for example only cover the
first 1MB of the PCI aperture, and we could allocate the kms fb from 8MB
into the aperture, thus they would never overlap.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Acked-by: Peter Jones <pjones@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/intel_fb.c |    8 ++++++++
 drivers/video/efifb.c           |    5 ++++-
 drivers/video/fbmem.c           |   29 +++++++++++++++++++++++++++++
 drivers/video/vesafb.c          |   15 ++++++++++++++-
 include/linux/fb.h              |   12 +++++++++++-
 5 files changed, 66 insertions(+), 3 deletions(-)

diff -puN drivers/gpu/drm/i915/intel_fb.c~fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers drivers/gpu/drm/i915/intel_fb.c
--- a/drivers/gpu/drm/i915/intel_fb.c~fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers
+++ a/drivers/gpu/drm/i915/intel_fb.c
@@ -504,6 +504,14 @@ static int intelfb_create(struct drm_dev
 	info->fbops = &intelfb_ops;
 
 	info->fix.line_length = fb->pitch;
+
+	/* setup aperture base/size for vesafb takeover */
+	info->aperture_base = dev->mode_config.fb_base;
+	if (IS_I9XX(dev))
+		info->aperture_size = pci_resource_len(dev->pdev, 2);
+	else
+		info->aperture_size = pci_resource_len(dev->pdev, 0);
+
 	info->fix.smem_start = dev->mode_config.fb_base + obj_priv->gtt_offset;
 	info->fix.smem_len = size;
 
diff -puN drivers/video/efifb.c~fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers drivers/video/efifb.c
--- a/drivers/video/efifb.c~fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers
+++ a/drivers/video/efifb.c
@@ -280,6 +280,9 @@ static int __init efifb_probe(struct pla
 	info->pseudo_palette = info->par;
 	info->par = NULL;
 
+	info->aperture_base = efifb_fix.smem_start;
+	info->aperture_size = size_total;
+
 	info->screen_base = ioremap(efifb_fix.smem_start, efifb_fix.smem_len);
 	if (!info->screen_base) {
 		printk(KERN_ERR "efifb: abort, cannot ioremap video memory "
@@ -337,7 +340,7 @@ static int __init efifb_probe(struct pla
 	info->fbops = &efifb_ops;
 	info->var = efifb_defined;
 	info->fix = efifb_fix;
-	info->flags = FBINFO_FLAG_DEFAULT;
+	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE;
 
 	if ((err = fb_alloc_cmap(&info->cmap, 256, 0)) < 0) {
 		printk(KERN_ERR "efifb: cannot allocate colormap\n");
diff -puN drivers/video/fbmem.c~fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers
+++ a/drivers/video/fbmem.c
@@ -1462,6 +1462,16 @@ static int fb_check_foreignness(struct f
 	return 0;
 }
 
+static bool fb_do_apertures_overlap(struct fb_info *gen, struct fb_info *hw)
+{
+	/* is the generic aperture base the same as the HW one */
+	if (gen->aperture_base == hw->aperture_base)
+		return true;
+	/* is the generic aperture base inside the hw base->hw base+size */
+	if (gen->aperture_base > hw->aperture_base && gen->aperture_base <= hw->aperture_base + hw->aperture_size)
+		return true;
+	return false;
+}
 /**
  *	register_framebuffer - registers a frame buffer device
  *	@fb_info: frame buffer info structure
@@ -1485,6 +1495,21 @@ register_framebuffer(struct fb_info *fb_
 	if (fb_check_foreignness(fb_info))
 		return -ENOSYS;
 
+	/* check all firmware fbs and kick off if the base addr overlaps */
+	for (i = 0 ; i < FB_MAX; i++) {
+		if (!registered_fb[i])
+			continue;
+
+		if (registered_fb[i]->flags & FBINFO_MISC_FIRMWARE) {
+			if (fb_do_apertures_overlap(registered_fb[i], fb_info)) {
+				printk("fb: conflicting fb hw usage %s vs %s - removing generic driver\n",
+				       fb_info->fix.id, registered_fb[i]->fix.id);
+				unregister_framebuffer(registered_fb[i]);
+				break;
+			}
+		}
+	}
+
 	num_registered_fb++;
 	for (i = 0 ; i < FB_MAX; i++)
 		if (!registered_fb[i])
@@ -1586,6 +1611,10 @@ unregister_framebuffer(struct fb_info *f
 	device_destroy(fb_class, MKDEV(FB_MAJOR, i));
 	event.info = fb_info;
 	fb_notifier_call_chain(FB_EVENT_FB_UNREGISTERED, &event);
+
+	/* this may free fb info */
+	if (fb_info->fbops->fb_destroy)
+		fb_info->fbops->fb_destroy(fb_info);
 done:
 	return ret;
 }
diff -puN drivers/video/vesafb.c~fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers drivers/video/vesafb.c
--- a/drivers/video/vesafb.c~fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers
+++ a/drivers/video/vesafb.c
@@ -174,8 +174,17 @@ static int vesafb_setcolreg(unsigned reg
 	return err;
 }
 
+static void vesafb_destroy(struct fb_info *info)
+{
+	if (info->screen_base)
+		iounmap(info->screen_base);
+	release_mem_region(info->aperture_base, info->aperture_size);
+	framebuffer_release(info);
+}
+
 static struct fb_ops vesafb_ops = {
 	.owner		= THIS_MODULE,
+	.fb_destroy     = vesafb_destroy,
 	.fb_setcolreg	= vesafb_setcolreg,
 	.fb_pan_display	= vesafb_pan_display,
 	.fb_fillrect	= cfb_fillrect,
@@ -286,6 +295,10 @@ static int __init vesafb_probe(struct pl
 	info->pseudo_palette = info->par;
 	info->par = NULL;
 
+	/* set vesafb aperture size for generic probing */
+	info->aperture_base = screen_info.lfb_base;
+	info->aperture_size = size_total;
+
 	info->screen_base = ioremap(vesafb_fix.smem_start, vesafb_fix.smem_len);
 	if (!info->screen_base) {
 		printk(KERN_ERR
@@ -437,7 +450,7 @@ static int __init vesafb_probe(struct pl
 	info->fbops = &vesafb_ops;
 	info->var = vesafb_defined;
 	info->fix = vesafb_fix;
-	info->flags = FBINFO_FLAG_DEFAULT |
+	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE |
 		(ypan ? FBINFO_HWACCEL_YPAN : 0);
 
 	if (!ypan)
diff -puN include/linux/fb.h~fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers include/linux/fb.h
--- a/include/linux/fb.h~fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers
+++ a/include/linux/fb.h
@@ -677,6 +677,9 @@ struct fb_ops {
 	/* get capability given var */
 	void (*fb_get_caps)(struct fb_info *info, struct fb_blit_caps *caps,
 			    struct fb_var_screeninfo *var);
+
+	/* teardown any resources to do with this framebuffer */
+	void (*fb_destroy)(struct fb_info *info);
 };
 
 #ifdef CONFIG_FB_TILEBLITTING
@@ -786,6 +789,8 @@ struct fb_tile_ops {
 #define FBINFO_MISC_USEREVENT          0x10000 /* event request
 						  from userspace */
 #define FBINFO_MISC_TILEBLITTING       0x20000 /* use tile blitting */
+#define FBINFO_MISC_FIRMWARE           0x40000 /* a replaceable firmware
+						  inited framebuffer */
 
 /* A driver may set this flag to indicate that it does want a set_par to be
  * called every time when fbcon_switch is executed. The advantage is that with
@@ -854,7 +859,12 @@ struct fb_info {
 	u32 state;			/* Hardware state i.e suspend */
 	void *fbcon_par;                /* fbcon use-only private area */
 	/* From here on everything is device dependent */
-	void *par;	
+	void *par;
+	/* we need the PCI or similiar aperture base/size not
+	   smem_start/size as smem_start may just be an object
+	   allocated inside the aperture so may not actually overlap */
+	resource_size_t aperture_base;
+	resource_size_t aperture_size;
 };
 
 #ifdef MODULE
_

Patches currently in -mm which might be from airlied@redhat.com are

origin.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers.patch

