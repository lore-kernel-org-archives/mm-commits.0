From: akpm@linux-foundation.org
Subject: - vt-vgacon-check-if-screen-resize-request-comes-from-userspace.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:44:52 -0700
Message-ID: <200710162044.l9GKiqcf016203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758790AbXJPVGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:06:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vt/vgacon: Check if screen resize request comes from userspace
has been removed from the -mm tree.  Its filename was
     vt-vgacon-check-if-screen-resize-request-comes-from-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 drivers/char/vt.c                       |   13 +++++++++----
 drivers/char/vt_ioctl.c                 |   15 +++++++++++++--
 drivers/usb/misc/sisusbvga/sisusb_con.c |    3 ++-
 drivers/video/console/fbcon.c           |    2 +-
 drivers/video/console/vgacon.c          |    7 ++++---
 include/linux/console.h                 |    3 ++-
 include/linux/console_struct.h          |    1 +
 7 files changed, 32 insertions(+), 12 deletions(-)

diff -puN drivers/char/vt.c~vt-vgacon-check-if-screen-resize-request-comes-from-userspace drivers/char/vt.c
--- a/drivers/char/vt.c~vt-vgacon-check-if-screen-resize-request-comes-from-userspace
+++ a/drivers/char/vt.c
@@ -750,13 +750,15 @@ int vc_allocate(unsigned int currcons)	/
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
 
@@ -772,7 +774,7 @@ int vc_resize(struct vc_data *vc, unsign
 	unsigned long old_origin, new_origin, new_scr_end, rlth, rrem, err = 0;
 	unsigned int old_cols, old_rows, old_row_size, old_screen_size;
 	unsigned int new_cols, new_rows, new_row_size, new_screen_size;
-	unsigned int end;
+	unsigned int end, user;
 	unsigned short *newscreen;
 
 	WARN_CONSOLE_UNLOCKED();
@@ -780,6 +782,9 @@ int vc_resize(struct vc_data *vc, unsign
 	if (!vc)
 		return -ENXIO;
 
+	user = vc->vc_resize_user;
+	vc->vc_resize_user = 0;
+
 	if (cols > VC_RESIZE_MAXCOL || lines > VC_RESIZE_MAXROW)
 		return -EINVAL;
 
@@ -800,7 +805,7 @@ int vc_resize(struct vc_data *vc, unsign
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
@@ -847,14 +847,24 @@ int vt_ioctl(struct tty_struct *tty, str
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
 
@@ -900,6 +910,7 @@ int vt_ioctl(struct tty_struct *tty, str
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

origin.patch
fbcon-delay-the-start-of-the-cursor-timer-until-a-con_switch.patch
cyber2000fb-checkpatch-fixes.patch
