From: akpm@osdl.org
Subject: - various-fbdev-files-mark-structs.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:22 -0800
Message-ID: <200612082013.kB8KDMfC003088@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59533 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946753AbWLHUNd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:13:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     various fbdev files: mark structs and array read-only
has been removed from the -mm tree.  Its filename was
     various-fbdev-files-mark-structs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: various fbdev files: mark structs and array read-only
From: Helge Deller <deller@gmx.de>

- move some structs and arrays to the read-only (.rodata) section

[akpm@osdl.org: build fix]
Signed-off-by: Helge Deller <deller@gmx.de>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/backlight/backlight.c |    2 +-
 drivers/video/backlight/lcd.c       |    2 +-
 drivers/video/cfbimgblt.c           |    8 ++++----
 drivers/video/console/sticon.c      |    2 +-
 drivers/video/fbcvt.c               |    2 +-
 drivers/video/fbmon.c               |    2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/video/backlight/backlight.c~various-fbdev-files-mark-structs drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~various-fbdev-files-mark-structs
+++ a/drivers/video/backlight/backlight.c
@@ -142,7 +142,7 @@ static struct class backlight_class = {
 	.store	= _store,					\
 }
 
-static struct class_device_attribute bl_class_device_attributes[] = {
+static const struct class_device_attribute bl_class_device_attributes[] = {
 	DECLARE_ATTR(power, 0644, backlight_show_power, backlight_store_power),
 	DECLARE_ATTR(brightness, 0644, backlight_show_brightness,
 		     backlight_store_brightness),
diff -puN drivers/video/backlight/lcd.c~various-fbdev-files-mark-structs drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~various-fbdev-files-mark-structs
+++ a/drivers/video/backlight/lcd.c
@@ -121,7 +121,7 @@ static struct class lcd_class = {
 	.store	= _store,					\
 }
 
-static struct class_device_attribute lcd_class_device_attributes[] = {
+static const struct class_device_attribute lcd_class_device_attributes[] = {
 	DECLARE_ATTR(power, 0644, lcd_show_power, lcd_store_power),
 	DECLARE_ATTR(contrast, 0644, lcd_show_contrast, lcd_store_contrast),
 	DECLARE_ATTR(max_contrast, 0444, lcd_show_max_contrast, NULL),
diff -puN drivers/video/cfbimgblt.c~various-fbdev-files-mark-structs drivers/video/cfbimgblt.c
--- a/drivers/video/cfbimgblt.c~various-fbdev-files-mark-structs
+++ a/drivers/video/cfbimgblt.c
@@ -42,7 +42,7 @@
 #define DPRINTK(fmt, args...)
 #endif
 
-static u32 cfb_tab8[] = {
+static const u32 cfb_tab8[] = {
 #if defined(__BIG_ENDIAN)
     0x00000000,0x000000ff,0x0000ff00,0x0000ffff,
     0x00ff0000,0x00ff00ff,0x00ffff00,0x00ffffff,
@@ -58,7 +58,7 @@ static u32 cfb_tab8[] = {
 #endif
 };
 
-static u32 cfb_tab16[] = {
+static const u32 cfb_tab16[] = {
 #if defined(__BIG_ENDIAN)
     0x00000000, 0x0000ffff, 0xffff0000, 0xffffffff
 #elif defined(__LITTLE_ENDIAN)
@@ -68,7 +68,7 @@ static u32 cfb_tab16[] = {
 #endif
 };
 
-static u32 cfb_tab32[] = {
+static const u32 cfb_tab32[] = {
 	0x00000000, 0xffffffff
 };
 
@@ -218,7 +218,7 @@ static inline void fast_imageblit(const 
 	u32 bit_mask, end_mask, eorx, shift;
 	const char *s = image->data, *src;
 	u32 __iomem *dst;
-	u32 *tab = NULL;
+	const u32 *tab = NULL;
 	int i, j, k;
 		
 	switch (bpp) {
diff -puN drivers/video/console/sticon.c~various-fbdev-files-mark-structs drivers/video/console/sticon.c
--- a/drivers/video/console/sticon.c~various-fbdev-files-mark-structs
+++ a/drivers/video/console/sticon.c
@@ -345,7 +345,7 @@ static void sticon_save_screen(struct vc
 {
 }
 
-static struct consw sti_con = {
+static const struct consw sti_con = {
 	.owner			= THIS_MODULE,
 	.con_startup		= sticon_startup,
 	.con_init		= sticon_init,
diff -puN drivers/video/fbcvt.c~various-fbdev-files-mark-structs drivers/video/fbcvt.c
--- a/drivers/video/fbcvt.c~various-fbdev-files-mark-structs
+++ a/drivers/video/fbcvt.c
@@ -57,7 +57,7 @@ struct fb_cvt_data {
 	u32 status;
 };
 
-static int fb_cvt_vbi_tab[] = {
+static const unsigned char fb_cvt_vbi_tab[] = {
 	4,        /* 4:3      */
 	5,        /* 16:9     */
 	6,        /* 16:10    */
diff -puN drivers/video/fbmon.c~various-fbdev-files-mark-structs drivers/video/fbmon.c
--- a/drivers/video/fbmon.c~various-fbdev-files-mark-structs
+++ a/drivers/video/fbmon.c
@@ -58,7 +58,7 @@ struct broken_edid {
 	u32 fix;
 };
 
-static struct broken_edid brokendb[] = {
+static const struct broken_edid brokendb[] = {
 	/* DEC FR-PCXAV-YZ */
 	{
 		.manufacturer = "DEC",
_

Patches currently in -mm which might be from deller@gmx.de are

origin.patch
various-fbdev-files-mark-structs.patch
constify-and-annotate-__read_mostly.patch
annotate-some-variables-in-vesafb.patch
constify-vga16fbc.patch

