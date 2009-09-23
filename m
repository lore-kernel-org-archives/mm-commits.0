From: akpm@linux-foundation.org
Subject: [merged] matroxfb-get-rid-of-unneeded-macro-minfo_from.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:03:10 -0700
Message-ID: <200909232003.n8NK3ADi018646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012AbZIWUEC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:04:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, krzysztof.h1@poczta.fm, vandrove@vc.cvut.cz, mm-commits@vger.kernel.org


The patch titled
     matroxfb: get rid of unneeded macro MINFO_FROM
has been removed from the -mm tree.  Its filename was
     matroxfb-get-rid-of-unneeded-macro-minfo_from.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: matroxfb: get rid of unneeded macro MINFO_FROM
From: Jean Delvare <khali@linux-fr.org>

With multihead support always enabled, macros MINFO_FROM and
MINFO_FROM_INFO are no longer needed and make the code harder to read.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/matrox/matroxfb_accel.c |   10 +++++-----
 drivers/video/matrox/matroxfb_base.c  |   17 ++++++++---------
 drivers/video/matrox/matroxfb_base.h  |    4 ----
 drivers/video/matrox/matroxfb_crtc2.c |   16 ++++++++--------
 drivers/video/matrox/matroxfb_g450.c  |   10 +++++-----
 drivers/video/matrox/matroxfb_maven.c |   10 ++++++----
 6 files changed, 32 insertions(+), 35 deletions(-)

diff -puN drivers/video/matrox/matroxfb_accel.c~matroxfb-get-rid-of-unneeded-macro-minfo_from drivers/video/matrox/matroxfb_accel.c
--- a/drivers/video/matrox/matroxfb_accel.c~matroxfb-get-rid-of-unneeded-macro-minfo_from
+++ a/drivers/video/matrox/matroxfb_accel.c
@@ -275,7 +275,7 @@ static void matrox_accel_bmove_lin(struc
 }
 
 static void matroxfb_cfb4_copyarea(struct fb_info* info, const struct fb_copyarea* area) {
-	MINFO_FROM_INFO(info);
+	struct matrox_fb_info *minfo = info2minfo(info);
 
 	if ((area->sx | area->dx | area->width) & 1)
 		cfb_copyarea(info, area);
@@ -284,7 +284,7 @@ static void matroxfb_cfb4_copyarea(struc
 }
 
 static void matroxfb_copyarea(struct fb_info* info, const struct fb_copyarea* area) {
-	MINFO_FROM_INFO(info);
+	struct matrox_fb_info *minfo = info2minfo(info);
 
 	matrox_accel_bmove(minfo, minfo->fbcon.var.xres_virtual, area->sy, area->sx, area->dy, area->dx, area->height, area->width);
 }
@@ -309,7 +309,7 @@ static void matroxfb_accel_clear(struct 
 }
 
 static void matroxfb_fillrect(struct fb_info* info, const struct fb_fillrect* rect) {
-	MINFO_FROM_INFO(info);
+	struct matrox_fb_info *minfo = info2minfo(info);
 
 	switch (rect->rop) {
 		case ROP_COPY:
@@ -376,7 +376,7 @@ static void matroxfb_cfb4_clear(struct m
 }
 
 static void matroxfb_cfb4_fillrect(struct fb_info* info, const struct fb_fillrect* rect) {
-	MINFO_FROM_INFO(info);
+	struct matrox_fb_info *minfo = info2minfo(info);
 
 	switch (rect->rop) {
 		case ROP_COPY:
@@ -478,7 +478,7 @@ static void matroxfb_1bpp_imageblit(stru
 
 
 static void matroxfb_imageblit(struct fb_info* info, const struct fb_image* image) {
-	MINFO_FROM_INFO(info);
+	struct matrox_fb_info *minfo = info2minfo(info);
 
 	DBG_HEAVY(__func__);
 
diff -puN drivers/video/matrox/matroxfb_base.c~matroxfb-get-rid-of-unneeded-macro-minfo_from drivers/video/matrox/matroxfb_base.c
--- a/drivers/video/matrox/matroxfb_base.c~matroxfb-get-rid-of-unneeded-macro-minfo_from
+++ a/drivers/video/matrox/matroxfb_base.c
@@ -204,8 +204,7 @@ static irqreturn_t matrox_irq(int irq, v
 {
 	u_int32_t status;
 	int handled = 0;
-
-	MINFO_FROM(dev_id);
+	struct matrox_fb_info *minfo = dev_id;
 
 	status = mga_inl(M_STATUS);
 
@@ -396,7 +395,7 @@ static void matroxfb_remove(struct matro
 
 static int matroxfb_open(struct fb_info *info, int user)
 {
-	MINFO_FROM_INFO(info);
+	struct matrox_fb_info *minfo = info2minfo(info);
 
 	DBG_LOOP(__func__)
 
@@ -412,7 +411,7 @@ static int matroxfb_open(struct fb_info 
 
 static int matroxfb_release(struct fb_info *info, int user)
 {
-	MINFO_FROM_INFO(info);
+	struct matrox_fb_info *minfo = info2minfo(info);
 
 	DBG_LOOP(__func__)
 
@@ -429,7 +428,7 @@ static int matroxfb_release(struct fb_in
 
 static int matroxfb_pan_display(struct fb_var_screeninfo *var,
 		struct fb_info* info) {
-	MINFO_FROM_INFO(info);
+	struct matrox_fb_info *minfo = info2minfo(info);
 
 	DBG(__func__)
 
@@ -749,7 +748,7 @@ static int matroxfb_check_var(struct fb_
 	int visual;
 	int cmap_len;
 	unsigned int ydstorg;
-	MINFO_FROM_INFO(info);
+	struct matrox_fb_info *minfo = info2minfo(info);
 
 	if (minfo->dead) {
 		return -ENXIO;
@@ -766,7 +765,7 @@ static int matroxfb_set_par(struct fb_in
 	int cmap_len;
 	unsigned int ydstorg;
 	struct fb_var_screeninfo *var;
-	MINFO_FROM_INFO(info);
+	struct matrox_fb_info *minfo = info2minfo(info);
 
 	DBG(__func__)
 
@@ -890,7 +889,7 @@ static int matroxfb_ioctl(struct fb_info
 			  unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
-	MINFO_FROM_INFO(info);
+	struct matrox_fb_info *minfo = info2minfo(info);
 
 	DBG(__func__)
 
@@ -1189,7 +1188,7 @@ static int matroxfb_blank(int blank, str
 	int seq;
 	int crtc;
 	CRITFLAGS
-	MINFO_FROM_INFO(info);
+	struct matrox_fb_info *minfo = info2minfo(info);
 
 	DBG(__func__)
 
diff -puN drivers/video/matrox/matroxfb_base.h~matroxfb-get-rid-of-unneeded-macro-minfo_from drivers/video/matrox/matroxfb_base.h
--- a/drivers/video/matrox/matroxfb_base.h~matroxfb-get-rid-of-unneeded-macro-minfo_from
+++ a/drivers/video/matrox/matroxfb_base.h
@@ -524,10 +524,6 @@ struct matrox_fb_info {
 
 #define info2minfo(info) container_of(info, struct matrox_fb_info, fbcon)
 
-#define MINFO_FROM(x)	   struct matrox_fb_info* minfo = x
-
-#define MINFO_FROM_INFO(x) MINFO_FROM(info2minfo(x))
-
 struct matrox_switch {
 	int	(*preinit)(struct matrox_fb_info *minfo);
 	void	(*reset)(struct matrox_fb_info *minfo);
diff -puN drivers/video/matrox/matroxfb_crtc2.c~matroxfb-get-rid-of-unneeded-macro-minfo_from drivers/video/matrox/matroxfb_crtc2.c
--- a/drivers/video/matrox/matroxfb_crtc2.c~matroxfb-get-rid-of-unneeded-macro-minfo_from
+++ a/drivers/video/matrox/matroxfb_crtc2.c
@@ -65,7 +65,7 @@ static void matroxfb_dh_restore(struct m
 		unsigned int pos) {
 	u_int32_t tmp;
 	u_int32_t datactl;
-	MINFO_FROM(m2info->primary_dev);
+	struct matrox_fb_info *minfo = m2info->primary_dev;
 
 	switch (mode) {
 		case 15:
@@ -157,7 +157,7 @@ static void matroxfb_dh_restore(struct m
 }
 
 static void matroxfb_dh_disable(struct matroxfb_dh_fb_info* m2info) {
-	MINFO_FROM(m2info->primary_dev);
+	struct matrox_fb_info *minfo = m2info->primary_dev;
 
 	mga_outl(0x3C10, 0x00000004);	/* disable CRTC2, CRTC1->DAC1, PLL as clock source */
 	minfo->hw.crtc2.ctl = 0x00000004;
@@ -168,7 +168,7 @@ static void matroxfb_dh_pan_var(struct m
 	unsigned int pos;
 	unsigned int linelen;
 	unsigned int pixelsize;
-	MINFO_FROM(m2info->primary_dev);
+	struct matrox_fb_info *minfo = m2info->primary_dev;
 
 	m2info->fbcon.var.xoffset = var->xoffset;
 	m2info->fbcon.var.yoffset = var->yoffset;
@@ -260,7 +260,7 @@ static int matroxfb_dh_decode_var(struct
 
 static int matroxfb_dh_open(struct fb_info* info, int user) {
 #define m2info (container_of(info, struct matroxfb_dh_fb_info, fbcon))
-	MINFO_FROM(m2info->primary_dev);
+	struct matrox_fb_info *minfo = m2info->primary_dev;
 
 	if (minfo) {
 		int err;
@@ -280,7 +280,7 @@ static int matroxfb_dh_open(struct fb_in
 static int matroxfb_dh_release(struct fb_info* info, int user) {
 #define m2info (container_of(info, struct matroxfb_dh_fb_info, fbcon))
 	int err = 0;
-	MINFO_FROM(m2info->primary_dev);
+	struct matrox_fb_info *minfo = m2info->primary_dev;
 
 	if (minfo) {
 		err = minfo->fbops.fb_release(&minfo->fbcon, user);
@@ -326,7 +326,7 @@ static int matroxfb_dh_set_par(struct fb
 	int mode;
 	int err;
 	struct fb_var_screeninfo* var = &info->var;
-	MINFO_FROM(m2info->primary_dev);
+	struct matrox_fb_info *minfo = m2info->primary_dev;
 
 	if ((err = matroxfb_dh_decode_var(m2info, var, &visual, &cmap_len, &mode)) != 0)
 		return err;
@@ -399,7 +399,7 @@ static int matroxfb_dh_pan_display(struc
 }
 
 static int matroxfb_dh_get_vblank(const struct matroxfb_dh_fb_info* m2info, struct fb_vblank* vblank) {
-	MINFO_FROM(m2info->primary_dev);
+	struct matrox_fb_info *minfo = m2info->primary_dev;
 
 	matroxfb_enable_irq(minfo, 0);
 	memset(vblank, 0, sizeof(*vblank));
@@ -423,7 +423,7 @@ static int matroxfb_dh_ioctl(struct fb_i
 		unsigned long arg)
 {
 #define m2info (container_of(info, struct matroxfb_dh_fb_info, fbcon))
-	MINFO_FROM(m2info->primary_dev);
+	struct matrox_fb_info *minfo = m2info->primary_dev;
 
 	DBG(__func__)
 
diff -puN drivers/video/matrox/matroxfb_g450.c~matroxfb-get-rid-of-unneeded-macro-minfo_from drivers/video/matrox/matroxfb_g450.c
--- a/drivers/video/matrox/matroxfb_g450.c~matroxfb-get-rid-of-unneeded-macro-minfo_from
+++ a/drivers/video/matrox/matroxfb_g450.c
@@ -161,7 +161,7 @@ static int g450_query_ctrl(void* md, str
 
 static int g450_set_ctrl(void* md, struct v4l2_control *p) {
 	int i;
-	MINFO_FROM(md);
+	struct matrox_fb_info *minfo = md;
 	
 	i = get_ctrl_id(p->id);
 	if (i < 0) return -EINVAL;
@@ -215,7 +215,7 @@ static int g450_set_ctrl(void* md, struc
 
 static int g450_get_ctrl(void* md, struct v4l2_control *p) {
 	int i;
-	MINFO_FROM(md);
+	struct matrox_fb_info *minfo = md;
 	
 	i = get_ctrl_id(p->id);
 	if (i < 0) return -EINVAL;
@@ -518,7 +518,7 @@ static void cve2_init_TV(struct matrox_f
 }
 
 static int matroxfb_g450_compute(void* md, struct my_timming* mt) {
-	MINFO_FROM(md);
+	struct matrox_fb_info *minfo = md;
 
 	dprintk(KERN_DEBUG "Computing, mode=%u\n", minfo->outputs[1].mode);
 
@@ -556,7 +556,7 @@ static int matroxfb_g450_compute(void* m
 }
 
 static int matroxfb_g450_program(void* md) {
-	MINFO_FROM(md);
+	struct matrox_fb_info *minfo = md;
 	
 	if (minfo->outputs[1].mode != MATROXFB_OUTPUT_MODE_MONITOR) {
 		cve2_init_TV(minfo, &minfo->hw.maven);
@@ -575,7 +575,7 @@ static int matroxfb_g450_verify_mode(voi
 }
 
 static int g450_dvi_compute(void* md, struct my_timming* mt) {
-	MINFO_FROM(md);
+	struct matrox_fb_info *minfo = md;
 
 	if (mt->mnp < 0) {
 		mt->mnp = matroxfb_g450_setclk(minfo, mt->pixclock, (mt->crtc == MATROXFB_SRC_CRTC1) ? M_PIXEL_PLL_C : M_VIDEO_PLL);
diff -puN drivers/video/matrox/matroxfb_maven.c~matroxfb-get-rid-of-unneeded-macro-minfo_from drivers/video/matrox/matroxfb_maven.c
--- a/drivers/video/matrox/matroxfb_maven.c~matroxfb-get-rid-of-unneeded-macro-minfo_from
+++ a/drivers/video/matrox/matroxfb_maven.c
@@ -458,7 +458,7 @@ static void maven_init_TVdata(const stru
 		0x00,	/* 3E written multiple times */
 		0x00,	/* never written */
 	}, MATROXFB_OUTPUT_MODE_NTSC, 525, 60 };
-	MINFO_FROM(md->primary_head);
+	struct matrox_fb_info *minfo = md->primary_head;
 
 	if (minfo->outputs[1].mode == MATROXFB_OUTPUT_MODE_PAL)
 		*data = palregs;
@@ -741,7 +741,7 @@ static inline int maven_compute_timming(
 		struct mavenregs* m) {
 	unsigned int tmpi;
 	unsigned int a, bv, c;
-	MINFO_FROM(md->primary_head);
+	struct matrox_fb_info *minfo = md->primary_head;
 
 	m->mode = minfo->outputs[1].mode;
 	if (m->mode != MATROXFB_OUTPUT_MODE_MONITOR) {
@@ -1184,7 +1184,9 @@ static struct matrox_altout maven_altout
 
 static int maven_init_client(struct i2c_client* clnt) {
 	struct maven_data* md = i2c_get_clientdata(clnt);
-	MINFO_FROM(container_of(clnt->adapter, struct i2c_bit_adapter, adapter)->minfo);
+	struct matrox_fb_info *minfo = container_of(clnt->adapter,
+						    struct i2c_bit_adapter,
+						    adapter)->minfo;
 
 	md->primary_head = minfo;
 	md->client = clnt;
@@ -1218,7 +1220,7 @@ static int maven_shutdown_client(struct 
 	struct maven_data* md = i2c_get_clientdata(clnt);
 
 	if (md->primary_head) {
-		MINFO_FROM(md->primary_head);
+		struct matrox_fb_info *minfo = md->primary_head;
 
 		down_write(&minfo->altout.lock);
 		minfo->outputs[1].src = MATROXFB_SRC_NONE;
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
hwmon-driver-for-texas-instruments-amc6821-chip.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

