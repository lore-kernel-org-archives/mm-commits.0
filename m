From: akpm@linux-foundation.org
Subject: + vt-vgacon-check-if-screen-resize-request-comes-from-userspace.patch added to -mm tree
Date: Wed, 03 Oct 2007 13:52:53 -0700
Message-ID: <200710032052.l93KqsKr008050@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44741 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758834AbXJCUw7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 16:52:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adaplas@gmail.com


The patch titled
     vt/vgacon: Check if screen resize request comes from userspace
has been added to the -mm tree.  Its filename is
     vt-vgacon-check-if-screen-resize-request-comes-from-userspace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vt/vgacon: Check if screen resize request comes from userspace
From: "Antonino A. Daplas" <adaplas@gmail.com>

Various console drivers are able to resize the screen via the con_resize()
hook.  This hook is also visible in userspace via the TIOCWINSZ, VT_RESIZE and
VT_RESIZEX ioctl's.  One particular utility, SVGATextMode, expects that
con_resize() of the VGA console will always return success even if the
resulting screen is not compatible with the hardware.  However, this
particular behavior of the VGA console, as reported in Kernel Bugzilla Bug
7513, can cause undefined behavior if the user starts with a console size
larger than 80x25.

To work around this problem, add an extra parameter to con_resize().  This
parameter is ignored by drivers except for vgacon.  If this parameter is
non-zero, then the resize request came from a VT_RESIZE or VT_RESIZEX ioctl
and vgacon will always return success.  If this parameter is zero, vgacon will
return -EINVAL if the requested size is not compatible with the hardware.  The
latter is the more correct behavior.

With this change, SVGATextMode should still work correctly while in-kernel and
stty resize calls can expect correct behavior from vgacon.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/char/vt.c~vt-vgacon-check-if-screen-resize-request-comes-from-userspace drivers/char/vt.c
--- a/drivers/char/vt.c~vt-vgacon-check-if-screen-resize-request-comes-from-userspace
+++ a/drivers/char/vt.c
@@ -786,13 +786,15 @@ int vc_allocate(unsigned int currcons)	/
 	return 0;
 }
 
-static inline int resize_screen(struct vc_data *vc, int width, int height)
+static inline int resize_screen(struct vc_data *vc, int width, int height,
+				int user)
 {
 	/* Resizes the resolution of the display adapater */
 	int err = 0;
 
 	if (vc->vc_mode != KD_GRAPHICS && vc->vc_sw->con_resize)
-		err = vc->vc_sw->con_resize(vc, width, height);
+		err = vc->vc_sw->con_resize(vc, width, height, user);
+
 	return err;
 }
 
@@ -808,7 +810,7 @@ int vc_resize(struct vc_data *vc, unsign
 	unsigned long old_origin, new_origin, new_scr_end, rlth, rrem, err = 0;
 	unsigned int old_cols, old_rows, old_row_size, old_screen_size;
 	unsigned int new_cols, new_rows, new_row_size, new_screen_size;
-	unsigned int end;
+	unsigned int end, user;
 	unsigned short *newscreen;
 
 	WARN_CONSOLE_UNLOCKED();
@@ -816,6 +818,9 @@ int vc_resize(struct vc_data *vc, unsign
 	if (!vc)
 		return -ENXIO;
 
+	user = vc->vc_resize_user;
+	vc->vc_resize_user = 0;
+
 	if (cols > VC_RESIZE_MAXCOL || lines > VC_RESIZE_MAXROW)
 		return -EINVAL;
 
@@ -836,7 +841,7 @@ int vc_resize(struct vc_data *vc, unsign
 	old_row_size = vc->vc_size_row;
 	old_screen_size = vc->vc_screenbuf_size;
 
-	err = resize_screen(vc, new_cols, new_rows);
+	err = resize_screen(vc, new_cols, new_rows, user);
 	if (err) {
 		kfree(newscreen);
 		return err;
diff -puN drivers/char/vt_ioctl.c~vt-vgacon-check-if-screen-resize-request-comes-from-userspace drivers/char/vt_ioctl.c
--- a/drivers/char/vt_ioctl.c~vt-vgacon-check-if-screen-resize-request-comes-from-userspace
+++ a/drivers/char/vt_ioctl.c
@@ -889,14 +889,24 @@ int vt_ioctl(struct tty_struct *tty, str
 	case VT_RESIZE:
 	{
 		struct vt_sizes __user *vtsizes = up;
+		struct vc_data *vc;
+
 		ushort ll,cc;
 		if (!perm)
 			return -EPERM;
 		if (get_user(ll, &vtsizes->v_rows) ||
 		    get_user(cc, &vtsizes->v_cols))
 			return -EFAULT;
-		for (i = 0; i < MAX_NR_CONSOLES; i++)
-			vc_lock_resize(vc_cons[i].d, cc, ll);
+
+		for (i = 0; i < MAX_NR_CONSOLES; i++) {
+			vc = vc_cons[i].d;
+
+			if (vc) {
+				vc->vc_resize_user = 1;
+				vc_lock_resize(vc_cons[i].d, cc, ll);
+			}
+		}
+
 		return 0;
 	}
 
@@ -942,6 +952,7 @@ int vt_ioctl(struct tty_struct *tty, str
 				vc_cons[i].d->vc_scan_lines = vlin;
 			if (clin)
 				vc_cons[i].d->vc_font.height = clin;
+			vc_cons[i].d->vc_resize_user = 1;
 			vc_resize(vc_cons[i].d, cc, ll);
 			release_console_sem();
 		}
diff -puN drivers/usb/misc/sisusbvga/sisusb_con.c~vt-vgacon-check-if-screen-resize-request-comes-from-userspace drivers/usb/misc/sisusbvga/sisusb_con.c
--- a/drivers/usb/misc/sisusbvga/sisusb_con.c~vt-vgacon-check-if-screen-resize-request-comes-from-userspace
+++ a/drivers/usb/misc/sisusbvga/sisusb_con.c
@@ -1042,7 +1042,8 @@ sisusbcon_set_origin(struct vc_data *c)
 
 /* Interface routine */
 static int
-sisusbcon_resize(struct vc_data *c, unsigned int newcols, unsigned int newrows)
+sisusbcon_resize(struct vc_data *c, unsigned int newcols, unsigned int newrows,
+		 unsigned int user)
 {
 	struct sisusb_usb_data *sisusb;
 	int fh;
diff -puN drivers/video/console/fbcon.c~vt-vgacon-check-if-screen-resize-request-comes-from-userspace drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~vt-vgacon-check-if-screen-resize-request-comes-from-userspace
+++ a/drivers/video/console/fbcon.c
@@ -2168,7 +2168,7 @@ static __inline__ void updatescrollmode(
 }
 
 static int fbcon_resize(struct vc_data *vc, unsigned int width, 
-			unsigned int height)
+			unsigned int height, unsigned int user)
 {
 	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
 	struct fbcon_ops *ops = info->fbcon_par;
diff -puN drivers/video/console/vgacon.c~vt-vgacon-check-if-screen-resize-request-comes-from-userspace drivers/video/console/vgacon.c
--- a/drivers/video/console/vgacon.c~vt-vgacon-check-if-screen-resize-request-comes-from-userspace
+++ a/drivers/video/console/vgacon.c
@@ -1278,13 +1278,14 @@ static int vgacon_font_get(struct vc_dat
 #endif
 
 static int vgacon_resize(struct vc_data *c, unsigned int width,
-				unsigned int height)
+			 unsigned int height, unsigned int user)
 {
 	if (width % 2 || width > ORIG_VIDEO_COLS ||
 	    height > (ORIG_VIDEO_LINES * vga_default_font_height)/
 	    c->vc_font.height)
-		/* let svgatextmode tinker with video timings */
-		return 0;
+		/* let svgatextmode tinker with video timings and
+		   return success */
+		return (user) ? 0 : -EINVAL;
 
 	if (CON_IS_VISIBLE(c) && !vga_is_gfx) /* who knows */
 		vgacon_doresize(c, width, height);
diff -puN include/linux/console.h~vt-vgacon-check-if-screen-resize-request-comes-from-userspace include/linux/console.h
--- a/include/linux/console.h~vt-vgacon-check-if-screen-resize-request-comes-from-userspace
+++ a/include/linux/console.h
@@ -45,7 +45,8 @@ struct consw {
 	int	(*con_font_get)(struct vc_data *, struct console_font *);
 	int	(*con_font_default)(struct vc_data *, struct console_font *, char *);
 	int	(*con_font_copy)(struct vc_data *, int);
-	int	(*con_resize)(struct vc_data *, unsigned int, unsigned int);
+	int     (*con_resize)(struct vc_data *, unsigned int, unsigned int,
+			       unsigned int);
 	int	(*con_set_palette)(struct vc_data *, unsigned char *);
 	int	(*con_scrolldelta)(struct vc_data *, int);
 	int	(*con_set_origin)(struct vc_data *);
diff -puN include/linux/console_struct.h~vt-vgacon-check-if-screen-resize-request-comes-from-userspace include/linux/console_struct.h
--- a/include/linux/console_struct.h~vt-vgacon-check-if-screen-resize-request-comes-from-userspace
+++ a/include/linux/console_struct.h
@@ -100,6 +100,7 @@ struct vc_data {
 	unsigned char 	vc_G1_charset;
 	unsigned char 	vc_saved_G0;
 	unsigned char 	vc_saved_G1;
+	unsigned int    vc_resize_user;         /* resize request from user */
 	unsigned int	vc_bell_pitch;		/* Console bell pitch */
 	unsigned int	vc_bell_duration;	/* Console bell duration */
 	struct vc_data **vc_display_fg;		/* [!] Ptr to var holding fg console for this display */
_

Patches currently in -mm which might be from adaplas@gmail.com are

fbdev-export-fb_destroy_modelist.patch
connector-change-connectors-max-message-size.patch
uvesafb-add-connector-entries.patch
uvesafb-the-driver-core.patch
uvesafb-documentation.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
pm2fb-mtrr-support-and-noaccel-option.patch
pm2fb-mtrr-support-and-noaccel-option-pm2fb-lowsyncs-section-mismatch-fix.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
sm501fb-update-suspend-and-resume-code.patch
sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch
sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch
mbxfb-improvements-and-new-features.patch
pxafb-add-support-for-other-palette-formats.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
fbdev-fix-incorrect-timings-in-some-modedb-entries.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
tdfxfb-mtrr-support-fix.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
fbdev-fb_create_modedb-non-static-int-first-=-1.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
pm2fb-permedia-2v-hardware-cursor-support.patch
pm3fb-hardware-cursor-support.patch
s3c2410fb-code-cleanup.patch
s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
s3c2410fb-multi-display-support.patch
s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
s3c2410fb-use-new-margin-fields.patch
s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
s3c2410fb-use-vertical-margins-values.patch
s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
s3c2410fb-fix-missing-registers-offset.patch
s3c2410fb-byte-ordering-fixes.patch
atyfb-atyfb-unshare-pseudo_palette.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers-update.patch
vt-fix-warnings-in-selectionh.patch
fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
s3c2410fb-source-code-improvements.patch
s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
s3c2410fb-make-use-of-default_display-settings.patch
cirrusfb-checkpatchpl-cleanup.patch
cirrusfb-remove-typedefs.patch
cirrusfb-remove-fields-from-cirrusfb_info.patch
cirrusfb-code-improvements.patch
cirrusfb-code-improvement-2nd-part.patch
pm3fb-header-file-cleanup.patch
pm2fb-hardware-cursor-support-for-the-permedia2.patch
pm2fb-panning-and-hardware-cursor-fixes.patch
vfb-make-virtual-framebuffer-mmapable.patch
fbdev-find-mode-with-the-highest-safest-refresh-rate-in-fb_find_mode.patch
nvidiafb-add-boot-option-to-reverse-i2c-port-assignment.patch
fbdev-support-for-byte-reversed-framebuffer-formats.patch
ps3-fix-black-and-white-stripes.patch
ps3fb-fix-spurious-mode-change-failures.patch
fbdev-update-documentation-fb-00-index.patch
tdfxfb-replace-busy-waiting-with-cpu_relax.patch
pm2fb-replace-busy-waiting-with-cpu_relax.patch
pm3fb-replace-busy-waiting-with-cpu_relax.patch
tdfxfb-checkpatch-fixes.patch
vt-vgacon-check-if-screen-resize-request-comes-from-userspace.patch
nvidiafb-correctly-assign-the-i2c-class-with-the-port-reversal.patch
pmagb-b-fb-improve-diagnostics.patch
fbcon-logo-disable-logo-at-boot.patch
platinumfb-fix-resource-management.patch
bf54x-lq043fb-framebuffer-driver-for-blackfin-bf54x-framebuffer-device-driver.patch
video-gfx-merge-kconfig-menus.patch
ps3av-eliminate-unneeded-temporary-variables.patch
ps3av-eliminate-ps3av_debug.patch
ps3av-use-ps3-video-mode-ids-in-autodetect-code.patch
ps3av-treat-dvi-d-like-hdmi-in-autodetect.patch
ps3av-add-autodetection-for-vesa-modes.patch
ps3av-add-quirk-database-for-broken-monitors.patch
ps3av-remove-unused-ps3av_set_mode.patch
ps3av-dont-distinguish-between-boot-and-non-boot-autodetection.patch
imxfb-fast-read-flag-and-nonstandard-field-configurable.patch
cyber2000fb-checkpatch-fixes.patch
