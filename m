From: akpm@linux-foundation.org
Subject: + viafb-fix-crashes-due-to-4k-stack-overflow.patch added to -mm tree
Date: Wed, 12 Nov 2008 15:01:24 -0800
Message-ID: <200811122301.mACN1OKZ009330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbYKLXBd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 18:01:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bonbons@linux-vserver.org, JosephChan@via.com.tw, krzysztof.h1@poczta.fm


The patch titled
     viafb: fix crashes due to 4k stack overflow
has been added to the -mm tree.  Its filename is
     viafb-fix-crashes-due-to-4k-stack-overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: viafb: fix crashes due to 4k stack overflow
=46rom: Bruno Pr=E9mont <bonbons@linux-vserver.org>

During conversion of viafb_ioctl() I noticed the following:

Those two cases just copy_from_user and do nothing with copied data,
incomplete implementation?:
        case VIAFB_SET_PANEL_POSITION:
                if (copy_from_user(&u.panel_pos_size_para, argp,
                                   sizeof(u.panel_pos_size_para)))
                        return -EFAULT;
                break;
        case VIAFB_SET_PANEL_SIZE:
                if (copy_from_user(&u.panel_pos_size_para, argp,
                                   sizeof(u.panel_pos_size_para)))
                        return -EFAULT;
                break;

Handling of GET/SET GAMMA looks buggy:
In each case 256*4 bytes are allocated but only 4 bytes (size of pointe=
r)
are copied to/from userspace though viafb_(get|set)_gamma_table() opera=
tes
on the full 256 elements...
        case VIAFB_SET_GAMMA_LUT:
                viafb_gamma_table =3D kmalloc(256 * sizeof(u32), GFP_KE=
RNEL);
                if (!viafb_gamma_table)
                        return -ENOMEM;
                if (copy_from_user(viafb_gamma_table, argp,
                                sizeof(viafb_gamma_table))) {
                        kfree(viafb_gamma_table);
                        return -EFAULT;
                }
                viafb_set_gamma_table(viafb_bpp, viafb_gamma_table);
                kfree(viafb_gamma_table);
                break;

        case VIAFB_GET_GAMMA_LUT:
                viafb_gamma_table =3D kmalloc(256 * sizeof(u32), GFP_KE=
RNEL);
                if (!viafb_gamma_table)
                        return -ENOMEM;
                viafb_get_gamma_table(viafb_gamma_table);
                if (copy_to_user(argp, viafb_gamma_table,
                        sizeof(viafb_gamma_table))) {
                        kfree(viafb_gamma_table);
                        return -EFAULT;
                }
                kfree(viafb_gamma_table);
                break;

I don't know if there is a userspace app that uses these VIA IOCTLs...
so the ioctl part is just compile-tested.
After checking, fbset just uses some generic framebuffer IOCTLs outside
of viafb's scope, thus not passing through viafb_ioctl().

Signed-off-by: Bruno Pr=E9mont <bonbons@linux-vserver.org>
Cc: <JosephChan@via.com.tw>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |  258 +++++++++++++++++----------------
 1 file changed, 134 insertions(+), 124 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-fix-crashes-due-to-4k-stac=
k-overflow drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-fix-crashes-due-to-4k-stack-ov=
erflow
+++ a/drivers/video/via/viafbdev.c
@@ -546,23 +546,25 @@ static int viafb_blank(int blank_mode, s
=20
 static int viafb_ioctl(struct fb_info *info, u_int cmd, u_long arg)
 {
-	struct viafb_ioctl_mode viamode;
-	struct viafb_ioctl_samm viasamm;
-	struct viafb_driver_version driver_version;
-	struct fb_var_screeninfo sec_var;
-	struct _panel_size_pos_info panel_pos_size_para;
+	union {
+		struct viafb_ioctl_mode viamode;
+		struct viafb_ioctl_samm viasamm;
+		struct viafb_driver_version driver_version;
+		struct fb_var_screeninfo sec_var;
+		struct _panel_size_pos_info panel_pos_size_para;
+		struct viafb_ioctl_setting viafb_setting;
+		struct device_t active_dev;
+	} u;
 	u32 state_info =3D 0;
-	u32 viainfo_size =3D sizeof(struct viafb_ioctl_info);
 	u32 *viafb_gamma_table;
 	char driver_name[] =3D "viafb";
=20
 	u32 __user *argp =3D (u32 __user *) arg;
 	u32 gpu32;
 	u32 video_dev_info =3D 0;
-	struct viafb_ioctl_setting viafb_setting =3D {};
-	struct device_t active_dev =3D {};
=20
 	DEBUG_MSG(KERN_INFO "viafb_ioctl: 0x%X !!\n", cmd);
+	memset(&u, 0, sizeof(u));
=20
 	switch (cmd) {
 	case VIAFB_GET_CHIP_INFO:
@@ -571,7 +573,7 @@ static int viafb_ioctl(struct fb_info *i
 			return -EFAULT;
 		break;
 	case VIAFB_GET_INFO_SIZE:
-		return put_user(viainfo_size, argp);
+		return put_user((u32)sizeof(struct viafb_ioctl_info), argp);
 	case VIAFB_GET_INFO:
 		return viafb_ioctl_get_viafb_info(arg);
 	case VIAFB_HOTPLUG:
@@ -584,60 +586,60 @@ static int viafb_ioctl(struct fb_info *i
 		viafb_hotplug =3D (gpu32) ? 1 : 0;
 		break;
 	case VIAFB_GET_RESOLUTION:
-		viamode.xres =3D (u32) viafb_hotplug_Xres;
-		viamode.yres =3D (u32) viafb_hotplug_Yres;
-		viamode.refresh =3D (u32) viafb_hotplug_refresh;
-		viamode.bpp =3D (u32) viafb_hotplug_bpp;
+		u.viamode.xres =3D (u32) viafb_hotplug_Xres;
+		u.viamode.yres =3D (u32) viafb_hotplug_Yres;
+		u.viamode.refresh =3D (u32) viafb_hotplug_refresh;
+		u.viamode.bpp =3D (u32) viafb_hotplug_bpp;
 		if (viafb_SAMM_ON =3D=3D 1) {
-			viamode.xres_sec =3D viafb_second_xres;
-			viamode.yres_sec =3D viafb_second_yres;
-			viamode.virtual_xres_sec =3D viafb_second_virtual_xres;
-			viamode.virtual_yres_sec =3D viafb_second_virtual_yres;
-			viamode.refresh_sec =3D viafb_refresh1;
-			viamode.bpp_sec =3D viafb_bpp1;
+			u.viamode.xres_sec =3D viafb_second_xres;
+			u.viamode.yres_sec =3D viafb_second_yres;
+			u.viamode.virtual_xres_sec =3D viafb_second_virtual_xres;
+			u.viamode.virtual_yres_sec =3D viafb_second_virtual_yres;
+			u.viamode.refresh_sec =3D viafb_refresh1;
+			u.viamode.bpp_sec =3D viafb_bpp1;
 		} else {
-			viamode.xres_sec =3D 0;
-			viamode.yres_sec =3D 0;
-			viamode.virtual_xres_sec =3D 0;
-			viamode.virtual_yres_sec =3D 0;
-			viamode.refresh_sec =3D 0;
-			viamode.bpp_sec =3D 0;
+			u.viamode.xres_sec =3D 0;
+			u.viamode.yres_sec =3D 0;
+			u.viamode.virtual_xres_sec =3D 0;
+			u.viamode.virtual_yres_sec =3D 0;
+			u.viamode.refresh_sec =3D 0;
+			u.viamode.bpp_sec =3D 0;
 		}
-		if (copy_to_user(argp, &viamode, sizeof(viamode)))
+		if (copy_to_user(argp, &u.viamode, sizeof(u.viamode)))
 			return -EFAULT;
 		break;
 	case VIAFB_GET_SAMM_INFO:
-		viasamm.samm_status =3D viafb_SAMM_ON;
+		u.viasamm.samm_status =3D viafb_SAMM_ON;
=20
 		if (viafb_SAMM_ON =3D=3D 1) {
 			if (viafb_dual_fb) {
-				viasamm.size_prim =3D viaparinfo->fbmem_free;
-				viasamm.size_sec =3D viaparinfo1->fbmem_free;
+				u.viasamm.size_prim =3D viaparinfo->fbmem_free;
+				u.viasamm.size_sec =3D viaparinfo1->fbmem_free;
 			} else {
 				if (viafb_second_size) {
-					viasamm.size_prim =3D
+					u.viasamm.size_prim =3D
 					    viaparinfo->fbmem_free -
 					    viafb_second_size * 1024 * 1024;
-					viasamm.size_sec =3D
+					u.viasamm.size_sec =3D
 					    viafb_second_size * 1024 * 1024;
 				} else {
-					viasamm.size_prim =3D
+					u.viasamm.size_prim =3D
 					    viaparinfo->fbmem_free >> 1;
-					viasamm.size_sec =3D
+					u.viasamm.size_sec =3D
 					    (viaparinfo->fbmem_free >> 1);
 				}
 			}
-			viasamm.mem_base =3D viaparinfo->fbmem;
-			viasamm.offset_sec =3D viafb_second_offset;
+			u.viasamm.mem_base =3D viaparinfo->fbmem;
+			u.viasamm.offset_sec =3D viafb_second_offset;
 		} else {
-			viasamm.size_prim =3D
+			u.viasamm.size_prim =3D
 			    viaparinfo->memsize - viaparinfo->fbmem_used;
-			viasamm.size_sec =3D 0;
-			viasamm.mem_base =3D viaparinfo->fbmem;
-			viasamm.offset_sec =3D 0;
+			u.viasamm.size_sec =3D 0;
+			u.viasamm.mem_base =3D viaparinfo->fbmem;
+			u.viasamm.offset_sec =3D 0;
 		}
=20
-		if (copy_to_user(argp, &viasamm, sizeof(viasamm)))
+		if (copy_to_user(argp, &u.viasamm, sizeof(u.viasamm)))
 			return -EFAULT;
=20
 		break;
@@ -662,74 +664,75 @@ static int viafb_ioctl(struct fb_info *i
 			viafb_lcd_disable();
 		break;
 	case VIAFB_SET_DEVICE:
-		if (copy_from_user(&active_dev, (void *)argp,
-			sizeof(active_dev)))
+		if (copy_from_user(&u.active_dev, (void *)argp,
+			sizeof(u.active_dev)))
 			return -EFAULT;
-		viafb_set_device(active_dev);
+		viafb_set_device(u.active_dev);
 		viafb_set_par(info);
 		break;
 	case VIAFB_GET_DEVICE:
-		active_dev.crt =3D viafb_CRT_ON;
-		active_dev.dvi =3D viafb_DVI_ON;
-		active_dev.lcd =3D viafb_LCD_ON;
-		active_dev.samm =3D viafb_SAMM_ON;
-		active_dev.primary_dev =3D viafb_primary_dev;
-
-		active_dev.lcd_dsp_cent =3D viafb_lcd_dsp_method;
-		active_dev.lcd_panel_id =3D viafb_lcd_panel_id;
-		active_dev.lcd_mode =3D viafb_lcd_mode;
-
-		active_dev.xres =3D viafb_hotplug_Xres;
-		active_dev.yres =3D viafb_hotplug_Yres;
-
-		active_dev.xres1 =3D viafb_second_xres;
-		active_dev.yres1 =3D viafb_second_yres;
-
-		active_dev.bpp =3D viafb_bpp;
-		active_dev.bpp1 =3D viafb_bpp1;
-		active_dev.refresh =3D viafb_refresh;
-		active_dev.refresh1 =3D viafb_refresh1;
-
-		active_dev.epia_dvi =3D viafb_platform_epia_dvi;
-		active_dev.lcd_dual_edge =3D viafb_device_lcd_dualedge;
-		active_dev.bus_width =3D viafb_bus_width;
+		u.active_dev.crt =3D viafb_CRT_ON;
+		u.active_dev.dvi =3D viafb_DVI_ON;
+		u.active_dev.lcd =3D viafb_LCD_ON;
+		u.active_dev.samm =3D viafb_SAMM_ON;
+		u.active_dev.primary_dev =3D viafb_primary_dev;
+
+		u.active_dev.lcd_dsp_cent =3D viafb_lcd_dsp_method;
+		u.active_dev.lcd_panel_id =3D viafb_lcd_panel_id;
+		u.active_dev.lcd_mode =3D viafb_lcd_mode;
+
+		u.active_dev.xres =3D viafb_hotplug_Xres;
+		u.active_dev.yres =3D viafb_hotplug_Yres;
+
+		u.active_dev.xres1 =3D viafb_second_xres;
+		u.active_dev.yres1 =3D viafb_second_yres;
+
+		u.active_dev.bpp =3D viafb_bpp;
+		u.active_dev.bpp1 =3D viafb_bpp1;
+		u.active_dev.refresh =3D viafb_refresh;
+		u.active_dev.refresh1 =3D viafb_refresh1;
+
+		u.active_dev.epia_dvi =3D viafb_platform_epia_dvi;
+		u.active_dev.lcd_dual_edge =3D viafb_device_lcd_dualedge;
+		u.active_dev.bus_width =3D viafb_bus_width;
=20
-		if (copy_to_user(argp, &active_dev, sizeof(active_dev)))
+		if (copy_to_user(argp, &u.active_dev, sizeof(u.active_dev)))
 			return -EFAULT;
 		break;
=20
 	case VIAFB_GET_DRIVER_VERSION:
-		driver_version.iMajorNum =3D VERSION_MAJOR;
-		driver_version.iKernelNum =3D VERSION_KERNEL;
-		driver_version.iOSNum =3D VERSION_OS;
-		driver_version.iMinorNum =3D VERSION_MINOR;
+		u.driver_version.iMajorNum =3D VERSION_MAJOR;
+		u.driver_version.iKernelNum =3D VERSION_KERNEL;
+		u.driver_version.iOSNum =3D VERSION_OS;
+		u.driver_version.iMinorNum =3D VERSION_MINOR;
=20
-		if (copy_to_user(argp, &driver_version,
-			sizeof(driver_version)))
+		if (copy_to_user(argp, &u.driver_version,
+			sizeof(u.driver_version)))
 			return -EFAULT;
=20
 		break;
=20
 	case VIAFB_SET_DEVICE_INFO:
-		if (copy_from_user(&viafb_setting,
-			argp, sizeof(viafb_setting)))
+		if (copy_from_user(&u.viafb_setting,
+			argp, sizeof(u.viafb_setting)))
 			return -EFAULT;
-		if (apply_device_setting(viafb_setting, info) < 0)
+		if (apply_device_setting(u.viafb_setting, info) < 0)
 			return -EINVAL;
=20
 		break;
=20
 	case VIAFB_SET_SECOND_MODE:
-		if (copy_from_user(&sec_var, argp, sizeof(sec_var)))
+		if (copy_from_user(&u.sec_var, argp, sizeof(u.sec_var)))
 			return -EFAULT;
-		apply_second_mode_setting(&sec_var);
+		apply_second_mode_setting(&u.sec_var);
 		break;
=20
 	case VIAFB_GET_DEVICE_INFO:
=20
-		retrieve_device_setting(&viafb_setting);
+		retrieve_device_setting(&u.viafb_setting);
=20
-		if (copy_to_user(argp, &viafb_setting, sizeof(viafb_setting)))
+		if (copy_to_user(argp, &u.viafb_setting,
+				 sizeof(u.viafb_setting)))
 			return -EFAULT;
=20
 		break;
@@ -806,51 +809,51 @@ static int viafb_ioctl(struct fb_info *i
 		break;
=20
 	case VIAFB_GET_PANEL_MAX_SIZE:
-		if (copy_from_user
-		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+		if (copy_from_user(&u.panel_pos_size_para, argp,
+				   sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
-		panel_pos_size_para.x =3D panel_pos_size_para.y =3D 0;
-		if (copy_to_user(argp, &panel_pos_size_para,
-		     sizeof(panel_pos_size_para)))
+		u.panel_pos_size_para.x =3D u.panel_pos_size_para.y =3D 0;
+		if (copy_to_user(argp, &u.panel_pos_size_para,
+		     sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
 		break;
 	case VIAFB_GET_PANEL_MAX_POSITION:
-		if (copy_from_user
-		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+		if (copy_from_user(&u.panel_pos_size_para, argp,
+				   sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
-		panel_pos_size_para.x =3D panel_pos_size_para.y =3D 0;
-		if (copy_to_user(argp, &panel_pos_size_para,
-		     sizeof(panel_pos_size_para)))
+		u.panel_pos_size_para.x =3D u.panel_pos_size_para.y =3D 0;
+		if (copy_to_user(argp, &u.panel_pos_size_para,
+				 sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
 		break;
=20
 	case VIAFB_GET_PANEL_POSITION:
-		if (copy_from_user
-		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+		if (copy_from_user(&u.panel_pos_size_para, argp,
+				   sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
-		panel_pos_size_para.x =3D panel_pos_size_para.y =3D 0;
-		if (copy_to_user(argp, &panel_pos_size_para,
-		     sizeof(panel_pos_size_para)))
+		u.panel_pos_size_para.x =3D u.panel_pos_size_para.y =3D 0;
+		if (copy_to_user(argp, &u.panel_pos_size_para,
+				 sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
 		break;
 	case VIAFB_GET_PANEL_SIZE:
-		if (copy_from_user
-		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+		if (copy_from_user(&u.panel_pos_size_para, argp,
+				   sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
-		panel_pos_size_para.x =3D panel_pos_size_para.y =3D 0;
-		if (copy_to_user(argp, &panel_pos_size_para,
-		     sizeof(panel_pos_size_para)))
+		u.panel_pos_size_para.x =3D u.panel_pos_size_para.y =3D 0;
+		if (copy_to_user(argp, &u.panel_pos_size_para,
+				 sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
 		break;
=20
 	case VIAFB_SET_PANEL_POSITION:
-		if (copy_from_user
-		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+		if (copy_from_user(&u.panel_pos_size_para, argp,
+				   sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
 		break;
 	case VIAFB_SET_PANEL_SIZE:
-		if (copy_from_user
-		    (&panel_pos_size_para, argp, sizeof(panel_pos_size_para)))
+		if (copy_from_user(&u.panel_pos_size_para, argp,
+				   sizeof(u.panel_pos_size_para)))
 			return -EFAULT;
 		break;
=20
@@ -1052,10 +1055,8 @@ static void viafb_imageblit(struct fb_in
=20
 static int viafb_cursor(struct fb_info *info, struct fb_cursor *cursor=
)
 {
-	u8 data[CURSOR_SIZE / 8];
-	u32 data_bak[CURSOR_SIZE / 32];
 	u32 temp, xx, yy, bg_col =3D 0, fg_col =3D 0;
-	int size, i, j =3D 0;
+	int i, j =3D 0;
 	static int hw_cursor;
 	struct viafb_par *p_viafb_par;
=20
@@ -1178,22 +1179,29 @@ static int viafb_cursor(struct fb_info *
 	}
=20
 	if (cursor->set & FB_CUR_SETSHAPE) {
-		size =3D
+		struct {
+			u8 data[CURSOR_SIZE / 8];
+			u32 bak[CURSOR_SIZE / 32];
+		} *cr_data =3D kzalloc(sizeof(*cr_data), GFP_ATOMIC);
+		int size =3D
 		    ((viacursor.image.width + 7) >> 3) *
 		    viacursor.image.height;
=20
+		if (cr_data =3D=3D NULL)
+			goto out;
+
 		if (MAX_CURS =3D=3D 32) {
 			for (i =3D 0; i < (CURSOR_SIZE / 32); i++) {
-				data_bak[i] =3D 0x0;
-				data_bak[i + 1] =3D 0xFFFFFFFF;
+				cr_data->bak[i] =3D 0x0;
+				cr_data->bak[i + 1] =3D 0xFFFFFFFF;
 				i +=3D 1;
 			}
 		} else if (MAX_CURS =3D=3D 64) {
 			for (i =3D 0; i < (CURSOR_SIZE / 32); i++) {
-				data_bak[i] =3D 0x0;
-				data_bak[i + 1] =3D 0x0;
-				data_bak[i + 2] =3D 0xFFFFFFFF;
-				data_bak[i + 3] =3D 0xFFFFFFFF;
+				cr_data->bak[i] =3D 0x0;
+				cr_data->bak[i + 1] =3D 0x0;
+				cr_data->bak[i + 2] =3D 0xFFFFFFFF;
+				cr_data->bak[i + 3] =3D 0xFFFFFFFF;
 				i +=3D 3;
 			}
 		}
@@ -1201,12 +1209,12 @@ static int viafb_cursor(struct fb_info *
 		switch (viacursor.rop) {
 		case ROP_XOR:
 			for (i =3D 0; i < size; i++)
-				data[i] =3D viacursor.mask[i];
+				cr_data->data[i] =3D viacursor.mask[i];
 			break;
 		case ROP_COPY:
=20
 			for (i =3D 0; i < size; i++)
-				data[i] =3D viacursor.mask[i];
+				cr_data->data[i] =3D viacursor.mask[i];
 			break;
 		default:
 			break;
@@ -1214,23 +1222,25 @@ static int viafb_cursor(struct fb_info *
=20
 		if (MAX_CURS =3D=3D 32) {
 			for (i =3D 0; i < size; i++) {
-				data_bak[j] =3D (u32) data[i];
-				data_bak[j + 1] =3D ~data_bak[j];
+				cr_data->bak[j] =3D (u32) cr_data->data[i];
+				cr_data->bak[j + 1] =3D ~cr_data->bak[j];
 				j +=3D 2;
 			}
 		} else if (MAX_CURS =3D=3D 64) {
 			for (i =3D 0; i < size; i++) {
-				data_bak[j] =3D (u32) data[i];
-				data_bak[j + 1] =3D 0x0;
-				data_bak[j + 2] =3D ~data_bak[j];
-				data_bak[j + 3] =3D ~data_bak[j + 1];
+				cr_data->bak[j] =3D (u32) cr_data->data[i];
+				cr_data->bak[j + 1] =3D 0x0;
+				cr_data->bak[j + 2] =3D ~cr_data->bak[j];
+				cr_data->bak[j + 3] =3D ~cr_data->bak[j + 1];
 				j +=3D 4;
 			}
 		}
=20
 		memcpy(((struct viafb_par *)(info->par))->fbmem_virt +
 		       ((struct viafb_par *)(info->par))->cursor_start,
-		       data_bak, CURSOR_SIZE);
+		       cr_data->bak, CURSOR_SIZE);
+out:
+		kfree(cr_data);
 	}
=20
 	if (viacursor.enable)
_

Patches currently in -mm which might be from bonbons@linux-vserver.org =
are

viafb-fix-crashes-due-to-4k-stack-overflow.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
