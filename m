From: akpm@linux-foundation.org
Subject: + video-mmp-display-subsystem.patch added to -mm tree
Date: Fri, 01 Feb 2013 15:36:02 -0800
Message-ID: <20130201233602.AD6DD5A42F5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:55068 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab3BAXgF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 18:36:05 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so261158vea.4
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 15:36:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zzhu3@marvell.com, FlorianSchandinat@gmx.de, cldu@marvell.com, haojian.zhuang@gmail.com, ligq@marvell.com


The patch titled
     Subject: video: mmp display subsystem
has been added to the -mm tree.  Its filename is
     video-mmp-display-subsystem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhou Zhu <zzhu3@marvell.com>
Subject: video: mmp display subsystem

Add mmp display subsystem to support Marvell MMP display controllers.

This subsystem contains 4 parts:
--fb folder
--core.c
--hw folder
--panel folder

1. fb folder contains implementation of fb.  fb get path and overlay
   from common interface and operates on these structures.

2. core.c provides common interface for a hardware abstraction.  Major
   parts of this interface are:

   a) Path: path is a output device connected to a panel or HDMI TV.  Main
      operations of the path is set/get timing/output color.  fb operates
      output device through path structure.
   
   b) Ovly: Ovly is a buffer shown on the path.
   
      Ovly describes frame buffer and its source/destination size, offset,
      input color, buffer address, z-order, and so on.  Each fb device maps
      to one overlay.

3. hw folder contains implementation of hardware operations defined by
   core.c.  It registers paths for fb use.

4. panel folder contains implementation of panels.  It's connected to
   path.  Panel drivers would also regiester panels and linked to path
   when probe.

Signed-off-by: Zhou Zhu <zzhu3@marvell.com>
Signed-off-by: Lisa Du <cldu@marvell.com>
Cc: Guoqing Li <ligq@marvell.com>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig      |    1 
 drivers/video/Makefile     |    1 
 drivers/video/mmp/Kconfig  |    5 
 drivers/video/mmp/Makefile |    1 
 drivers/video/mmp/core.c   |  258 +++++++++++++++++++++++++
 include/video/mmp_disp.h   |  352 +++++++++++++++++++++++++++++++++++
 6 files changed, 618 insertions(+)

diff -puN drivers/video/Kconfig~video-mmp-display-subsystem drivers/video/Kconfig
--- a/drivers/video/Kconfig~video-mmp-display-subsystem
+++ a/drivers/video/Kconfig
@@ -2431,6 +2431,7 @@ config FB_PUV3_UNIGFX
 source "drivers/video/omap/Kconfig"
 source "drivers/video/omap2/Kconfig"
 source "drivers/video/exynos/Kconfig"
+source "drivers/video/mmp/Kconfig"
 source "drivers/video/backlight/Kconfig"
 
 if VT
diff -puN drivers/video/Makefile~video-mmp-display-subsystem drivers/video/Makefile
--- a/drivers/video/Makefile~video-mmp-display-subsystem
+++ a/drivers/video/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_FB_ASILIANT)	  += asiliantf
 obj-$(CONFIG_FB_PXA)		  += pxafb.o
 obj-$(CONFIG_FB_PXA168)		  += pxa168fb.o
 obj-$(CONFIG_PXA3XX_GCU)	  += pxa3xx-gcu.o
+obj-$(CONFIG_MMP_DISP)           += mmp/
 obj-$(CONFIG_FB_W100)		  += w100fb.o
 obj-$(CONFIG_FB_TMIO)		  += tmiofb.o
 obj-$(CONFIG_FB_AU1100)		  += au1100fb.o
diff -puN /dev/null drivers/video/mmp/Kconfig
--- /dev/null
+++ a/drivers/video/mmp/Kconfig
@@ -0,0 +1,5 @@
+menuconfig MMP_DISP
+        tristate "Marvell MMP Display Subsystem support"
+        depends on CPU_PXA910 || CPU_MMP2 || CPU_MMP3 || CPU_PXA988
+        help
+	  Marvell Display Subsystem support.
diff -puN /dev/null drivers/video/mmp/Makefile
--- /dev/null
+++ a/drivers/video/mmp/Makefile
@@ -0,0 +1 @@
+obj-y += core.o
diff -puN /dev/null drivers/video/mmp/core.c
--- /dev/null
+++ a/drivers/video/mmp/core.c
@@ -0,0 +1,258 @@
+/*
+ * linux/drivers/video/mmp/common.c
+ * This driver is a common framework for Marvell Display Controller
+ *
+ * Copyright (C) 2012 Marvell Technology Group Ltd.
+ * Authors: Zhou Zhu <zzhu3@marvell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+#include <linux/export.h>
+#include <video/mmp_disp.h>
+
+static struct mmp_overlay *path_get_overlay(struct mmp_path *path,
+		int overlay_id)
+{
+	if (path && overlay_id < path->overlay_num)
+		return &path->overlays[overlay_id];
+	return 0;
+}
+
+static int path_check_status(struct mmp_path *path)
+{
+	int i;
+	for (i = 0; i < path->overlay_num; i++)
+		if (path->overlays[i].status)
+			return 1;
+
+	return 0;
+}
+
+/*
+ * Get modelist write pointer of modelist.
+ * It also returns modelist number
+ * this function fetches modelist from phy/panel:
+ *   for HDMI/parallel or dsi to hdmi cases, get from phy
+ *   or get from panel
+ */
+static int path_get_modelist(struct mmp_path *path,
+		struct mmp_mode **modelist)
+{
+	BUG_ON(!path || !modelist);
+
+	if (path->panel && path->panel->get_modelist)
+		return path->panel->get_modelist(path->panel, modelist);
+
+	return 0;
+}
+
+/*
+ * panel list is used to pair panel/path when path/panel registered
+ * path list is used for both buffer driver and platdriver
+ * plat driver do path register/unregister
+ * panel driver do panel register/unregister
+ * buffer driver get registered path
+ */
+static LIST_HEAD(panel_list);
+static LIST_HEAD(path_list);
+static DEFINE_MUTEX(disp_lock);
+
+/*
+ * mmp_register_panel - register panel to panel_list and connect to path
+ * @p: panel to be registered
+ *
+ * this function provides interface for panel drivers to register panel
+ * to panel_list and connect to path which matchs panel->plat_path_name.
+ * no error returns when no matching path is found as path register after
+ * panel register is permitted.
+ */
+void mmp_register_panel(struct mmp_panel *panel)
+{
+	struct mmp_path *path;
+
+	mutex_lock(&disp_lock);
+
+	/* add */
+	list_add_tail(&panel->node, &panel_list);
+
+	/* try to register to path */
+	list_for_each_entry(path, &path_list, node) {
+		if (!strcmp(panel->plat_path_name, path->name)) {
+			dev_info(panel->dev, "connect to path %s\n",
+				path->name);
+			path->panel = panel;
+			break;
+		}
+	}
+
+	mutex_unlock(&disp_lock);
+}
+EXPORT_SYMBOL_GPL(mmp_register_panel);
+
+/*
+ * mmp_unregister_panel - unregister panel from panel_list and disconnect
+ * @p: panel to be unregistered
+ *
+ * this function provides interface for panel drivers to unregister panel
+ * from panel_list and disconnect from path.
+ */
+void mmp_unregister_panel(struct mmp_panel *panel)
+{
+	struct mmp_path *path;
+
+	mutex_lock(&disp_lock);
+	list_del(&panel->node);
+
+	list_for_each_entry(path, &path_list, node) {
+		if (path->panel && path->panel == panel) {
+			dev_info(panel->dev, "disconnect from path %s\n",
+				path->name);
+			path->panel = NULL;
+			break;
+		}
+	}
+	mutex_unlock(&disp_lock);
+}
+EXPORT_SYMBOL_GPL(mmp_unregister_panel);
+
+/*
+ * mmp_get_path - get path by name
+ * @p: path name
+ *
+ * this function checks path name in path_list and return matching path
+ * return NULL if no matching path
+ */
+struct mmp_path *mmp_get_path(const char *name)
+{
+	struct mmp_path *path;
+	int found = 0;
+
+	mutex_lock(&disp_lock);
+	list_for_each_entry(path, &path_list, node) {
+		if (!strcmp(name, path->name)) {
+			found = 1;
+			break;
+		}
+	}
+	mutex_unlock(&disp_lock);
+
+	return found ? path : NULL;
+}
+EXPORT_SYMBOL_GPL(mmp_get_path);
+
+/*
+ * mmp_register_path - init and register path by path_info
+ * @p: path info provided by display controller
+ *
+ * this function init by path info and register path to path_list
+ * this function also try to connect path with panel by name
+ */
+struct mmp_path *mmp_register_path(struct mmp_path_info *info)
+{
+	int i;
+	size_t size;
+	struct mmp_path *path = NULL;
+	struct mmp_panel *panel;
+
+	size = sizeof(struct mmp_path)
+		+ sizeof(struct mmp_overlay) * info->overlay_num;
+	path = kzalloc(size, GFP_KERNEL);
+	if (!path)
+		goto failed;
+
+	/* path set */
+	mutex_init(&path->access_ok);
+	path->dev = info->dev;
+	path->id = info->id;
+	path->name = info->name;
+	path->output_type = info->output_type;
+	path->overlay_num = info->overlay_num;
+	path->plat_data = info->plat_data;
+	path->ops.set_mode = info->set_mode;
+
+	mutex_lock(&disp_lock);
+	/* get panel */
+	list_for_each_entry(panel, &panel_list, node) {
+		if (!strcmp(info->name, panel->plat_path_name)) {
+			dev_info(path->dev, "get panel %s\n", panel->name);
+			path->panel = panel;
+			break;
+		}
+	}
+
+	dev_info(path->dev, "register %s, overlay_num %d\n",
+			path->name, path->overlay_num);
+
+	/* default op set: if already set by driver, never cover it */
+	if (!path->ops.check_status)
+		path->ops.check_status = path_check_status;
+	if (!path->ops.get_overlay)
+		path->ops.get_overlay = path_get_overlay;
+	if (!path->ops.get_modelist)
+		path->ops.get_modelist = path_get_modelist;
+
+	/* step3: init overlays */
+	for (i = 0; i < path->overlay_num; i++) {
+		path->overlays[i].path = path;
+		path->overlays[i].id = i;
+		mutex_init(&path->overlays[i].access_ok);
+		path->overlays[i].ops = info->overlay_ops;
+	}
+
+	/* add to pathlist */
+	list_add_tail(&path->node, &path_list);
+
+	mutex_unlock(&disp_lock);
+	return path;
+
+failed:
+	kfree(path);
+	mutex_unlock(&disp_lock);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(mmp_register_path);
+
+/*
+ * mmp_unregister_path - unregister and destory path
+ * @p: path to be destoried.
+ *
+ * this function registers path and destorys it.
+ */
+void mmp_unregister_path(struct mmp_path *path)
+{
+	int i;
+
+	if (!path)
+		return;
+
+	mutex_lock(&disp_lock);
+	/* del from pathlist */
+	list_del(&path->node);
+
+	/* deinit overlays */
+	for (i = 0; i < path->overlay_num; i++)
+		mutex_destroy(&path->overlays[i].access_ok);
+
+	mutex_destroy(&path->access_ok);
+
+	kfree(path);
+	mutex_unlock(&disp_lock);
+
+	dev_info(path->dev, "de-register %s\n", path->name);
+}
+EXPORT_SYMBOL_GPL(mmp_unregister_path);
diff -puN /dev/null include/video/mmp_disp.h
--- /dev/null
+++ a/include/video/mmp_disp.h
@@ -0,0 +1,352 @@
+/*
+ * linux/include/video/mmp_disp.h
+ * Header file for Marvell MMP Display Controller
+ *
+ * Copyright (C) 2012 Marvell Technology Group Ltd.
+ * Authors: Zhou Zhu <zzhu3@marvell.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#ifndef _MMP_DISP_H_
+#define _MMP_DISP_H_
+#include <linux/kthread.h>
+
+enum {
+	PIXFMT_UYVY = 0,
+	PIXFMT_VYUY,
+	PIXFMT_YUYV,
+	PIXFMT_YUV422P,
+	PIXFMT_YVU422P,
+	PIXFMT_YUV420P,
+	PIXFMT_YVU420P,
+	PIXFMT_RGB565 = 0x100,
+	PIXFMT_BGR565,
+	PIXFMT_RGB1555,
+	PIXFMT_BGR1555,
+	PIXFMT_RGB888PACK,
+	PIXFMT_BGR888PACK,
+	PIXFMT_RGB888UNPACK,
+	PIXFMT_BGR888UNPACK,
+	PIXFMT_RGBA888,
+	PIXFMT_BGRA888,
+	PIXFMT_RGB666, /* for output usage */
+	PIXFMT_PSEUDOCOLOR = 0x200,
+};
+
+static inline int pixfmt_to_stride(int pix_fmt)
+{
+	switch (pix_fmt) {
+	case PIXFMT_RGB565:
+	case PIXFMT_BGR565:
+	case PIXFMT_RGB1555:
+	case PIXFMT_BGR1555:
+	case PIXFMT_UYVY:
+	case PIXFMT_VYUY:
+	case PIXFMT_YUYV:
+		return 2;
+	case PIXFMT_RGB888UNPACK:
+	case PIXFMT_BGR888UNPACK:
+	case PIXFMT_RGBA888:
+	case PIXFMT_BGRA888:
+		return 4;
+	case PIXFMT_RGB888PACK:
+	case PIXFMT_BGR888PACK:
+		return 3;
+	case PIXFMT_YUV422P:
+	case PIXFMT_YVU422P:
+	case PIXFMT_YUV420P:
+	case PIXFMT_YVU420P:
+	case PIXFMT_PSEUDOCOLOR:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+/* parameters used by path/overlay */
+/* overlay related para: win/addr */
+struct mmp_win {
+	/* position/size of window */
+	u16	xsrc;
+	u16	ysrc;
+	u16	xdst;
+	u16	ydst;
+	u16	xpos;
+	u16	ypos;
+	u16	left_crop;
+	u16	right_crop;
+	u16	up_crop;
+	u16	bottom_crop;
+	int	pix_fmt;
+};
+
+struct mmp_addr {
+	/* phys address */
+	u32	phys[6];
+};
+
+/* path related para: mode */
+struct mmp_mode {
+	const char *name;
+	u32 refresh;
+	u32 xres;
+	u32 yres;
+	u32 left_margin;
+	u32 right_margin;
+	u32 upper_margin;
+	u32 lower_margin;
+	u32 hsync_len;
+	u32 vsync_len;
+	u32 hsync_invert;
+	u32 vsync_invert;
+	u32 invert_pixclock;
+	u32 pixclock_freq;
+	int pix_fmt_out;
+};
+
+/* main structures */
+struct mmp_path;
+struct mmp_overlay;
+struct mmp_panel;
+
+/* status types */
+enum {
+	MMP_OFF = 0,
+	MMP_ON,
+};
+
+static inline const char *stat_name(int stat)
+{
+	switch (stat) {
+	case MMP_OFF:
+		return "OFF";
+	case MMP_ON:
+		return "ON";
+	default:
+		return "UNKNOWNSTAT";
+	}
+}
+
+struct mmp_overlay_ops {
+	/* should be provided by driver */
+	void (*set_fetch)(struct mmp_overlay *overlay, int fetch_id);
+	void (*set_onoff)(struct mmp_overlay *overlay, int status);
+	void (*set_win)(struct mmp_overlay *overlay, struct mmp_win *win);
+	int (*set_addr)(struct mmp_overlay *overlay, struct mmp_addr *addr);
+};
+
+/* overlay describes a z-order indexed slot in each path. */
+struct mmp_overlay {
+	int id;
+	const char *name;
+	struct mmp_path *path;
+
+	/* overlay info: private data */
+	int dmafetch_id;
+	struct mmp_addr addr;
+	struct mmp_win win;
+
+	/* state */
+	int open_count;
+	int status;
+	struct mutex access_ok;
+
+	struct mmp_overlay_ops *ops;
+};
+
+/* panel type */
+enum {
+	PANELTYPE_ACTIVE = 0,
+	PANELTYPE_SMART,
+	PANELTYPE_TV,
+	PANELTYPE_DSI_CMD,
+	PANELTYPE_DSI_VIDEO,
+};
+
+struct mmp_panel {
+	/* use node to register to list */
+	struct list_head node;
+	const char *name;
+	/* path name used to connect to proper path configed */
+	const char *plat_path_name;
+	struct device *dev;
+	int panel_type;
+	void *plat_data;
+	int (*get_modelist)(struct mmp_panel *panel,
+			struct mmp_mode **modelist);
+	void (*set_mode)(struct mmp_panel *panel,
+			struct mmp_mode *mode);
+	void (*set_onoff)(struct mmp_panel *panel,
+			int status);
+};
+
+struct mmp_path_ops {
+	int (*check_status)(struct mmp_path *path);
+	struct mmp_overlay *(*get_overlay)(struct mmp_path *path,
+			int overlay_id);
+	int (*get_modelist)(struct mmp_path *path,
+			struct mmp_mode **modelist);
+
+	/* follow ops should be provided by driver */
+	void (*set_mode)(struct mmp_path *path, struct mmp_mode *mode);
+	void (*set_onoff)(struct mmp_path *path, int status);
+	/* todo: add query */
+};
+
+/* path output types */
+enum {
+	PATH_OUT_PARALLEL,
+	PATH_OUT_DSI,
+	PATH_OUT_HDMI,
+};
+
+/* path is main part of mmp-disp */
+struct mmp_path {
+	/* use node to register to list */
+	struct list_head node;
+
+	/* init data */
+	struct device *dev;
+
+	int id;
+	const char *name;
+	int output_type;
+	struct mmp_panel *panel;
+	void *plat_data;
+
+	/* dynamic use */
+	struct mmp_mode mode;
+
+	/* state */
+	int open_count;
+	int status;
+	struct mutex access_ok;
+
+	struct mmp_path_ops ops;
+
+	/* layers */
+	int overlay_num;
+	struct mmp_overlay overlays[0];
+};
+
+extern struct mmp_path *mmp_get_path(const char *name);
+static inline void mmp_path_set_mode(struct mmp_path *path,
+		struct mmp_mode *mode)
+{
+	if (path)
+		path->ops.set_mode(path, mode);
+}
+static inline void mmp_path_set_onoff(struct mmp_path *path, int status)
+{
+	if (path)
+		path->ops.set_onoff(path, status);
+}
+static inline int mmp_path_get_modelist(struct mmp_path *path,
+		struct mmp_mode **modelist)
+{
+	if (path)
+		return path->ops.get_modelist(path, modelist);
+	return 0;
+}
+static inline struct mmp_overlay *mmp_path_get_overlay(
+		struct mmp_path *path, int overlay_id)
+{
+	if (path)
+		return path->ops.get_overlay(path, overlay_id);
+	return NULL;
+}
+static inline void mmp_overlay_set_fetch(struct mmp_overlay *overlay,
+		int fetch_id)
+{
+	if (overlay)
+		overlay->ops->set_fetch(overlay, fetch_id);
+}
+static inline void mmp_overlay_set_onoff(struct mmp_overlay *overlay,
+		int status)
+{
+	if (overlay)
+		overlay->ops->set_onoff(overlay, status);
+}
+static inline void mmp_overlay_set_win(struct mmp_overlay *overlay,
+		struct mmp_win *win)
+{
+	if (overlay)
+		overlay->ops->set_win(overlay, win);
+}
+static inline int mmp_overlay_set_addr(struct mmp_overlay *overlay,
+		struct mmp_addr *addr)
+{
+	if (overlay)
+		return overlay->ops->set_addr(overlay, addr);
+	return 0;
+}
+
+/*
+ * driver data is set from each detailed ctrl driver for path usage
+ * it defined a common interface that plat driver need to implement
+ */
+struct mmp_path_info {
+	/* driver data, set when registed*/
+	const char *name;
+	struct device *dev;
+	int id;
+	int output_type;
+	int overlay_num;
+	void (*set_mode)(struct mmp_path *path, struct mmp_mode *mode);
+	void (*set_onoff)(struct mmp_path *path, int status);
+	struct mmp_overlay_ops *overlay_ops;
+	void *plat_data;
+};
+
+extern struct mmp_path *mmp_register_path(
+		struct mmp_path_info *info);
+extern void mmp_unregister_path(struct mmp_path *path);
+extern void mmp_register_panel(struct mmp_panel *panel);
+extern void mmp_unregister_panel(struct mmp_panel *panel);
+
+/* defintions for platform data */
+/* interface for buffer driver */
+struct mmp_buffer_driver_mach_info {
+	const char	*name;
+	const char	*path_name;
+	int	overlay_id;
+	int	dmafetch_id;
+	int	default_pixfmt;
+};
+
+/* interface for controllers driver */
+struct mmp_mach_path_config {
+	const char *name;
+	int overlay_num;
+	int output_type;
+	u32 path_config;
+	u32 link_config;
+};
+
+struct mmp_mach_plat_info {
+	const char *name;
+	const char *clk_name;
+	int path_num;
+	struct mmp_mach_path_config *paths;
+};
+
+/* interface for panel drivers */
+struct mmp_mach_panel_info {
+	const char *name;
+	void (*plat_set_onoff)(int status);
+	const char *plat_path_name;
+};
+#endif	/* _MMP_DISP_H_ */
_

Patches currently in -mm which might be from zzhu3@marvell.com are

video-mmp-display-subsystem.patch
video-mmp-fb-support.patch
video-mmp-display-controller-support.patch
video-mmp-add-tpo-hvga-panel-supported.patch
video-mmpdisp-add-spi-port-in-display-controller.patch
arm-mmp-added-device-for-display-controller.patch
arm-mmp-enable-display-in-ttc_dkb.patch
arm-mmp-add-display-and-fb-support-in-pxa910-defconfig.patch

