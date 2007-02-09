From: akpm@linux-foundation.org
Subject: + video-fb-add-true-ref_count-atomicity.patch added to -mm tree
Date: Thu, 08 Feb 2007 16:26:50 -0800
Message-ID: <200702090026.l190QooV031990@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46878 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422987AbXBIA1J (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 19:27:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, adaplas@pol.net, dok@directfb.org, jsimmons@infradead.org


The patch titled
     Video: fb, add true ref_count atomicity
has been added to the -mm tree.  Its filename is
     video-fb-add-true-ref_count-atomicity.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Video: fb, add true ref_count atomicity
From: Jiri Slaby <jirislaby@gmail.com>

Some of fb drivers uses atomic_t in bad manner, since there are still some
race-prone gaps.  Use mutexes to protect open/close code sections with
ref_count testing and finally use simple uint.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Denis Oliver Kropp <dok@directfb.org>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/i810/i810.h      |    3 ++-
 drivers/video/i810/i810_main.c |   25 +++++++++++++++----------
 drivers/video/neofb.c          |   21 ++++++++++++++-------
 drivers/video/riva/fbdev.c     |   19 ++++++++++++-------
 drivers/video/riva/rivafb.h    |    3 ++-
 drivers/video/vga16fb.c        |   23 +++++++++++++++--------
 include/video/neomagic.h       |    3 ++-
 7 files changed, 62 insertions(+), 35 deletions(-)

diff -puN drivers/video/i810/i810.h~video-fb-add-true-ref_count-atomicity drivers/video/i810/i810.h
--- a/drivers/video/i810/i810.h~video-fb-add-true-ref_count-atomicity
+++ a/drivers/video/i810/i810.h
@@ -264,7 +264,8 @@ struct i810fb_par {
 	struct heap_data         cursor_heap;
 	struct vgastate          state;
 	struct i810fb_i2c_chan   chan[3];
-	atomic_t                 use_count;
+	struct mutex		 open_lock;
+	unsigned int		 use_count;
 	u32 pseudo_palette[17];
 	unsigned long mmio_start_phys;
 	u8 __iomem *mmio_start_virtual;
diff -puN drivers/video/i810/i810_main.c~video-fb-add-true-ref_count-atomicity drivers/video/i810/i810_main.c
--- a/drivers/video/i810/i810_main.c~video-fb-add-true-ref_count-atomicity
+++ a/drivers/video/i810/i810_main.c
@@ -1235,9 +1235,9 @@ static int i810fb_getcolreg(u8 regno, u8
 static int i810fb_open(struct fb_info *info, int user)
 {
 	struct i810fb_par *par = info->par;
-	u32 count = atomic_read(&par->use_count);
-	
-	if (count == 0) {
+
+	mutex_lock(&par->open_lock);
+	if (par->use_count == 0) {
 		memset(&par->state, 0, sizeof(struct vgastate));
 		par->state.flags = VGA_SAVE_CMAP;
 		par->state.vgabase = par->mmio_start_virtual;
@@ -1246,7 +1246,8 @@ static int i810fb_open(struct fb_info *i
 		i810_save_vga_state(par);
 	}
 
-	atomic_inc(&par->use_count);
+	par->use_count++;
+	mutex_unlock(&par->open_lock);
 	
 	return 0;
 }
@@ -1254,18 +1255,20 @@ static int i810fb_open(struct fb_info *i
 static int i810fb_release(struct fb_info *info, int user)
 {
 	struct i810fb_par *par = info->par;
-	u32 count;
-	
-	count = atomic_read(&par->use_count);
-	if (count == 0)
+
+	mutex_lock(&par->open_lock);
+	if (par->use_count == 0) {
+		mutex_unlock(&par->open_lock);
 		return -EINVAL;
+	}
 
-	if (count == 1) {
+	if (par->use_count == 1) {
 		i810_restore_vga_state(par);
 		restore_vga(&par->state);
 	}
 
-	atomic_dec(&par->use_count);
+	par->use_count--;
+	mutex_unlock(&par->open_lock);
 	
 	return 0;
 }
@@ -1752,6 +1755,8 @@ static void __devinit i810_init_monspecs
 static void __devinit i810_init_defaults(struct i810fb_par *par, 
 				      struct fb_info *info)
 {
+	mutex_init(&par->open_lock);
+
 	if (voffset) 
 		v_offset_default = voffset;
 	else if (par->aperture.size > 32 * 1024 * 1024)
diff -puN drivers/video/neofb.c~video-fb-add-true-ref_count-atomicity drivers/video/neofb.c
--- a/drivers/video/neofb.c~video-fb-add-true-ref_count-atomicity
+++ a/drivers/video/neofb.c
@@ -556,14 +556,16 @@ static int
 neofb_open(struct fb_info *info, int user)
 {
 	struct neofb_par *par = info->par;
-	int cnt = atomic_read(&par->ref_count);
 
-	if (!cnt) {
+	mutex_lock(&par->open_lock);
+	if (!par->ref_count) {
 		memset(&par->state, 0, sizeof(struct vgastate));
 		par->state.flags = VGA_SAVE_MODE | VGA_SAVE_FONTS;
 		save_vga(&par->state);
 	}
-	atomic_inc(&par->ref_count);
+	par->ref_count++;
+	mutex_unlock(&par->open_lock);
+
 	return 0;
 }
 
@@ -571,14 +573,18 @@ static int
 neofb_release(struct fb_info *info, int user)
 {
 	struct neofb_par *par = info->par;
-	int cnt = atomic_read(&par->ref_count);
 
-	if (!cnt)
+	mutex_lock(&par->open_lock);
+	if (!par->ref_count) {
+		mutex_unlock(&par->open_lock);
 		return -EINVAL;
-	if (cnt == 1) {
+	}
+	if (par->ref_count == 1) {
 		restore_vga(&par->state);
 	}
-	atomic_dec(&par->ref_count);
+	par->ref_count--;
+	mutex_unlock(&par->open_lock);
+
 	return 0;
 }
 
@@ -2047,6 +2053,7 @@ static struct fb_info *__devinit neo_all
 
 	info->fix.accel = id->driver_data;
 
+	mutex_init(&par->open_lock);
 	par->pci_burst = !nopciburst;
 	par->lcd_stretch = !nostretch;
 	par->libretto = libretto;
diff -puN drivers/video/riva/fbdev.c~video-fb-add-true-ref_count-atomicity drivers/video/riva/fbdev.c
--- a/drivers/video/riva/fbdev.c~video-fb-add-true-ref_count-atomicity
+++ a/drivers/video/riva/fbdev.c
@@ -1100,10 +1100,10 @@ static int riva_get_cmap_len(const struc
 static int rivafb_open(struct fb_info *info, int user)
 {
 	struct riva_par *par = info->par;
-	int cnt = atomic_read(&par->ref_count);
 
 	NVTRACE_ENTER();
-	if (!cnt) {
+	mutex_lock(&par->open_lock);
+	if (!par->ref_count) {
 #ifdef CONFIG_X86
 		memset(&par->state, 0, sizeof(struct vgastate));
 		par->state.flags = VGA_SAVE_MODE  | VGA_SAVE_FONTS;
@@ -1118,7 +1118,8 @@ static int rivafb_open(struct fb_info *i
 	
 		riva_save_state(par, &par->initial_state);
 	}
-	atomic_inc(&par->ref_count);
+	par->ref_count++;
+	mutex_unlock(&par->open_lock);
 	NVTRACE_LEAVE();
 	return 0;
 }
@@ -1126,12 +1127,14 @@ static int rivafb_open(struct fb_info *i
 static int rivafb_release(struct fb_info *info, int user)
 {
 	struct riva_par *par = info->par;
-	int cnt = atomic_read(&par->ref_count);
 
 	NVTRACE_ENTER();
-	if (!cnt)
+	mutex_lock(&par->open_lock);
+	if (!par->ref_count) {
+		mutex_unlock(&par->open_lock);
 		return -EINVAL;
-	if (cnt == 1) {
+	}
+	if (par->ref_count == 1) {
 		par->riva.LockUnlock(&par->riva, 0);
 		par->riva.LoadStateExt(&par->riva, &par->initial_state.ext);
 		riva_load_state(par, &par->initial_state);
@@ -1140,7 +1143,8 @@ static int rivafb_release(struct fb_info
 #endif
 		par->riva.LockUnlock(&par->riva, 1);
 	}
-	atomic_dec(&par->ref_count);
+	par->ref_count--;
+	mutex_unlock(&par->open_lock);
 	NVTRACE_LEAVE();
 	return 0;
 }
@@ -1998,6 +2002,7 @@ static int __devinit rivafb_probe(struct
 		goto err_disable_device;
 	}
 
+	mutex_init(&default_par->open_lock);
 	default_par->riva.Architecture = riva_get_arch(pd);
 
 	default_par->Chipset = (pd->vendor << 16) | pd->device;
diff -puN drivers/video/riva/rivafb.h~video-fb-add-true-ref_count-atomicity drivers/video/riva/rivafb.h
--- a/drivers/video/riva/rivafb.h~video-fb-add-true-ref_count-atomicity
+++ a/drivers/video/riva/rivafb.h
@@ -53,7 +53,8 @@ struct riva_par {
 #ifdef CONFIG_X86
 	struct vgastate state;
 #endif
-	atomic_t ref_count;
+	struct mutex open_lock;
+	unsigned int ref_count;
 	unsigned char *EDID;
 	unsigned int Chipset;
 	int forceCRTC;
diff -puN drivers/video/vga16fb.c~video-fb-add-true-ref_count-atomicity drivers/video/vga16fb.c
--- a/drivers/video/vga16fb.c~video-fb-add-true-ref_count-atomicity
+++ a/drivers/video/vga16fb.c
@@ -70,7 +70,8 @@ struct vga16fb_par {
 		unsigned char	ClockingMode;	  /* Seq-Controller:01h */
 	} vga_state;
 	struct vgastate state;
-	atomic_t ref_count;
+	struct mutex open_lock;
+	unsigned int ref_count;
 	int palette_blanked, vesa_blanked, mode, isVGA;
 	u8 misc, pel_msk, vss, clkdiv;
 	u8 crtc[VGA_CRT_C];
@@ -300,28 +301,33 @@ static void vga16fb_clock_chip(struct vg
 static int vga16fb_open(struct fb_info *info, int user)
 {
 	struct vga16fb_par *par = info->par;
-	int cnt = atomic_read(&par->ref_count);
 
-	if (!cnt) {
+	mutex_lock(&par->open_lock);
+	if (!par->ref_count) {
 		memset(&par->state, 0, sizeof(struct vgastate));
 		par->state.flags = VGA_SAVE_FONTS | VGA_SAVE_MODE |
 			VGA_SAVE_CMAP;
 		save_vga(&par->state);
 	}
-	atomic_inc(&par->ref_count);
+	par->ref_count++;
+	mutex_unlock(&par->open_lock);
+
 	return 0;
 }
 
 static int vga16fb_release(struct fb_info *info, int user)
 {
 	struct vga16fb_par *par = info->par;
-	int cnt = atomic_read(&par->ref_count);
 
-	if (!cnt)
+	mutex_lock(&par->open_lock);
+	if (!par->ref_count) {
+		mutex_unlock(&par->open_lock);
 		return -EINVAL;
-	if (cnt == 1)
+	}
+	if (par->ref_count == 1)
 		restore_vga(&par->state);
-	atomic_dec(&par->ref_count);
+	par->ref_count--;
+	mutex_unlock(&par->open_lock);
 
 	return 0;
 }
@@ -1357,6 +1363,7 @@ static int __init vga16fb_probe(struct p
 	printk(KERN_INFO "vga16fb: mapped to 0x%p\n", info->screen_base);
 	par = info->par;
 
+	mutex_init(&par->open_lock);
 	par->isVGA = ORIG_VIDEO_ISVGA;
 	par->palette_blanked = 0;
 	par->vesa_blanked = 0;
diff -puN include/video/neomagic.h~video-fb-add-true-ref_count-atomicity include/video/neomagic.h
--- a/include/video/neomagic.h~video-fb-add-true-ref_count-atomicity
+++ a/include/video/neomagic.h
@@ -140,7 +140,8 @@ typedef volatile struct {
 
 struct neofb_par {
 	struct vgastate state;
-	atomic_t ref_count;
+	struct mutex open_lock;
+	unsigned int ref_count;
 
 	unsigned char MiscOutReg;	/* Misc */
 	unsigned char CRTC[25];		/* Crtc Controller */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-input.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
doc-isicom-remove-reserved-ioctl-number.patch
char-mxser_new-alter-locking-in-isr.patch
char-mxser_new-header-file-cleanup.patch
char-mxser_new-less-loops-in-isr.patch
char-mxser_new-fix-twice-resource-releasing.patch
char-mxser_new-do-not-put-pdev.patch
char-mxser_new-upgrade-to-1915.patch
char-mxser_new-upgrade-to-1915-fix.patch
char-mxser_new-do-not-null-driver_data.patch
char-mxser_new-lock-count-and-flags.patch
char-mxser_new-fix-sparse-warning.patch
char-moxa-remove-unused-allocated-page.patch
char-moxa-do-not-initialize-global-static.patch
char-moxa-timers-cleanup.patch
char-moxa-remove-hangup-bottomhalf.patch
char-moxa-remove-unused-functions.patch
char-moxa-devids-cleanup.patch
char-moxa-use-pci_device.patch
char-moxa-eliminate-typedefs.patch
char-moxa-macros-cleanup.patch
char-moxa-use-del_timer_sync.patch
char-moxa-remove-moxa_pci_devinfo.patch
char-moxa-variables-cleanup.patch
char-moxa-remove-useless-vairables.patch
char-moxa-pci_probing-prepare.patch
char-moxa-pci-probing.patch
mxser-remove-useless-fields.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
