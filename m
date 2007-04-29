From: akpm@linux-foundation.org
Subject: + fbdev-fbcon-check-if-mode-can-handle-new-screen.patch added to -mm tree
Date: Sun, 29 Apr 2007 02:33:32 -0700
Message-ID: <200704290933.l3T9XW7c012959@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755106AbXD2Jdl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Apr 2007 05:33:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     fbdev: fbcon: check if mode can handle new screen
has been added to the -mm tree.  Its filename is
     fbdev-fbcon-check-if-mode-can-handle-new-screen.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: fbcon: check if mode can handle new screen
From: "Antonino A. Daplas" <adaplas@gmail.com>

Check if the mode can properly display the screen.  This will be needed by
drivers where the capability is not constant with each mode.  The function
fb_set_var() will query fbcon the requirement, then it will query the driver
(via a new hook fb_get_caps()) its capability.  If the driver's capability
cannot handle fbcon's requirement, then fb_set_var() will fail.

For example, if a particular driver supports 2 modes where:

mode1 = can only display 8x16 bitmaps
mode2 = can display any bitmap

then if current mode = mode2 and current font = 12x22

fbset <mode1> /* mode1 cannot handle 12x22 */
fbset will fail

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |   42 ++++++++++++++++++++++++++++++++
 drivers/video/fbmem.c         |   33 +++++++++++++++++++++++++
 include/linux/fb.h            |   12 +++++++++
 3 files changed, 87 insertions(+)

diff -puN drivers/video/console/fbcon.c~fbdev-fbcon-check-if-mode-can-handle-new-screen drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbdev-fbcon-check-if-mode-can-handle-new-screen
+++ a/drivers/video/console/fbcon.c
@@ -3043,6 +3043,43 @@ static void fbcon_new_modelist(struct fb
 	}
 }
 
+static void fbcon_get_requirement(struct fb_info *info,
+				  struct fb_blit_caps *caps)
+{
+	struct vc_data *vc;
+	struct display *p;
+	int charcnt;
+
+	if (caps->flags) {
+		int i;
+
+		for (i = first_fb_vc; i <= last_fb_vc; i++) {
+			vc = vc_cons[i].d;
+			if (vc && vc->vc_mode == KD_TEXT) {
+				p = &fb_display[i];
+				caps->x |= 1 << (vc->vc_font.width - 1);
+				caps->y |= 1 << (vc->vc_font.height - 1);
+				charcnt = (p->userfont) ?
+					FNTCHARCNT(p->fontdata) : 256;
+				if (caps->len < charcnt)
+					caps->len = charcnt;
+			}
+		}
+	} else {
+		vc = vc_cons[fg_console].d;
+
+		if (vc && vc->vc_mode == KD_TEXT) {
+			p = &fb_display[fg_console];
+			caps->x |= 1 << (vc->vc_font.width - 1);
+			caps->y |= 1 << (vc->vc_font.height - 1);
+			charcnt = (p->userfont) ?
+				FNTCHARCNT(p->fontdata) : 256;
+			if (caps->len < charcnt)
+				caps->len = charcnt;
+		}
+	}
+}
+
 static int fbcon_event_notify(struct notifier_block *self, 
 			      unsigned long action, void *data)
 {
@@ -3050,6 +3087,7 @@ static int fbcon_event_notify(struct not
 	struct fb_info *info = event->info;
 	struct fb_videomode *mode;
 	struct fb_con2fbmap *con2fb;
+	struct fb_blit_caps *caps;
 	int ret = 0;
 
 	/*
@@ -3098,6 +3136,10 @@ static int fbcon_event_notify(struct not
 	case FB_EVENT_NEW_MODELIST:
 		fbcon_new_modelist(info);
 		break;
+	case FB_EVENT_GET_REQ:
+		caps = event->data;
+		fbcon_get_requirement(info, caps);
+		break;
 	}
 
 done:
diff -puN drivers/video/fbmem.c~fbdev-fbcon-check-if-mode-can-handle-new-screen drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-fbcon-check-if-mode-can-handle-new-screen
+++ a/drivers/video/fbmem.c
@@ -773,6 +773,29 @@ fb_pan_display(struct fb_info *info, str
         return 0;
 }
 
+static int fb_check_caps(struct fb_info *info, struct fb_var_screeninfo *var,
+			 u32 activate)
+{
+	struct fb_event event;
+	struct fb_blit_caps caps, fbcaps;
+	int err = 0;
+
+	memset(&caps, 0, sizeof(caps));
+	memset(&fbcaps, 0, sizeof(fbcaps));
+	caps.flags = (activate & FB_ACTIVATE_ALL) ? 1 : 0;
+	event.info = info;
+	event.data = &caps;
+	fb_notifier_call_chain(FB_EVENT_GET_REQ, &event);
+	info->fbops->fb_get_caps(info, &fbcaps, var);
+
+	if (((fbcaps.x ^ caps.x) & caps.x) ||
+	    ((fbcaps.y ^ caps.y) & caps.y) ||
+	    (fbcaps.len < caps.len))
+		err = -EINVAL;
+
+	return err;
+}
+
 int
 fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 {
@@ -817,7 +840,15 @@ fb_set_var(struct fb_info *info, struct 
 			struct fb_videomode mode;
 			int err = 0;
 
+			if (info->fbops->fb_get_caps) {
+				err = fb_check_caps(info, var, activate);
+
+				if (err)
+					goto done;
+			}
+
 			info->var = *var;
+
 			if (info->fbops->fb_set_par)
 				info->fbops->fb_set_par(info);
 
@@ -843,6 +874,8 @@ fb_set_var(struct fb_info *info, struct 
 			}
 		}
 	}
+
+ done:
 	return 0;
 }
 
diff -puN include/linux/fb.h~fbdev-fbcon-check-if-mode-can-handle-new-screen include/linux/fb.h
--- a/include/linux/fb.h~fbdev-fbcon-check-if-mode-can-handle-new-screen
+++ a/include/linux/fb.h
@@ -527,12 +527,20 @@ struct fb_cursor_user {
 #define FB_EVENT_MODE_CHANGE_ALL	0x0B
 /*	A software display blank change occured */
 #define FB_EVENT_CONBLANK               0x0C
+/*      Get drawing requirements        */
+#define FB_EVENT_GET_REQ                0x0D
 
 struct fb_event {
 	struct fb_info *info;
 	void *data;
 };
 
+struct fb_blit_caps {
+	u32 x;
+	u32 y;
+	u32 len;
+	u32 flags;
+};
 
 extern int fb_register_client(struct notifier_block *nb);
 extern int fb_unregister_client(struct notifier_block *nb);
@@ -652,6 +660,10 @@ struct fb_ops {
 
 	/* restore saved state */
 	void (*fb_restore_state)(struct fb_info *info);
+
+	/* get capability given var */
+	void (*fb_get_caps)(struct fb_info *info, struct fb_blit_caps *caps,
+			    struct fb_var_screeninfo *var);
 };
 
 #ifdef CONFIG_FB_TILEBLITTING
_

Patches currently in -mm which might be from adaplas@gmail.com are

fbdev-add-ultrasharp-uxga-to-broken-monitor-database.patch
intelfb-fix-ring-space-calculation.patch
nvidiafb-bring-back-generic-ddc-reading.patch
fbdev-ignore-vesa-modes-if-framebuffer-is-disabled.patch
fbdev-fix-obvious-bug-in-show_pan.patch
neofb-fill-transp-msb_right-with-the-correct.patch
atyfb-kill-dead-code.patch
fbdev-mm-deferred-io-support.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-mm-deferred-io-support-fix-2.patch
fbdev-hecuba-framebuffer-driver.patch
fbdev-hecuba-framebuffer-driver-fix.patch
nvidiafb-fix-reversed-ddc-port.patch
vt-expose-system-wide-utf-8-default-setting-via-sysfs.patch
fbdev-dont-show-logo-if-driver-or-fbcon-are-modular.patch
rivafb-nvidiafb-enable-hardware-monitoring.patch
rivafb-handle-i2c-bus-creation-failure.patch
rivafb-nvidiafb-various-cleanups.patch
rivafb-fixed-reversed-ddc-ports.patch
nvidiafb-ensure-that-crtc-registers-are-accessible.patch
nvidiafb-access-crt-registers-safely.patch
skeletonfb-various-corrections.patch
epson1355fbc-fix-error-handling-code.patch
nvidiafb-vga-state-save-and-restore.patch
savagefb-rework-i2c-bit-access.patch
savagefb-vga-state-save-and-restore.patch
fbdev-link-vgastateo-using-kconfig.patch
fbcon-delay-screen-update-when-setting-the-mode-of.patch
nvidiafb-fix-sparse-warning.patch
rivafb-fix-io-access.patch
fbdev-kill-sparse-warning-in-deferred-io.patch
fbdev-add-sparse-annotations-in-svgalibc.patch
arcfb-kill-sparse-warning.patch
s3fb-add-sparse-annotations.patch
hecubafb-kill-sparse-warnings.patch
i810fb-fix-incorrect-frequency-mask.patch
vt-add-documentation-for-new-boot-sysfs-options.patch
skeletonfb-documentation-error-fixes.patch
fbdev-add-drawing-functions-for-framebuffers-in-system.patch
arcfb-use-sys-instead-of-cfb-drawing-functions.patch
hecubafb-use-sys-instead-of-cfb-drawing-functions.patch
vfb-use-sys-instead-of-cfb-drawing-functions.patch
fbdev-pass-struct-fb_info-to-fb_read-and-fb_write.patch
fbdev-add-fb_read-fb_write-functions-for-framebuffers.patch
arcfb-us-fb_sys_read.patch
hecubafb-us-fb_sys_read.patch
vfb-us-fb_sys_read-and-fb_sys_write.patch
fbdev-consolidate-common-drawing-functions-into-a.patch
fbdev-advertise-limitation-of-drawing-engine.patch
fbcon-font-setting-should-check-limitation-of-driver.patch
vga16fb-restrict-to-blit-rectangles-with-widths-of.patch
s3fb-limit-8x16-rectangles-when-tileblitting-is-enabled.patch
fbdev-add-tile-operation-to-get-the-maximum-length.patch
s3fb-implement-fb_get_tilemax.patch
fbcon-check-if-the-character-count-can-be-handled.patch
fbdev-save-the-activate-field-before-calling-fb_check_var.patch
s3fb-driver-fixes.patch
vmlfb-framebuffer-driver-for-intel-vermilion-range.patch
nvidiafb-rivafb-switch-to-pci_get-refcounting.patch
pm2fb-3dlabs-permedia-2v-reference-board-added.patch
pm2fb-permedia-2v-memory-clock-setting.patch
pm2fb-pixclock-setting-restriction.patch
nvidiafb-prevent-triggering-of-softlockup.patch
fbdev-fbcon-check-if-mode-can-handle-new-screen.patch
s3fb-implement-fb_get_caps.patch
vga-vgastate-fix.patch
nvidiafb-fix-return-value-of-nvidiafb_open.patch
atyfb-increase-spll-delay.patch
atyfb-reorganize-clock-init.patch
atyfb-halve-xclk-with-mobility-and-32bit-memory.patch
