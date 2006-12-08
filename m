From: akpm@osdl.org
Subject: - fbcmapc-mark-structs-const-or.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:13:19 -0800
Message-ID: <200612082013.kB8KDJ12003083@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59523 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946748AbWLHUNc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:13:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deller@gmx.de, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     fbcmap.c: mark structs const or __read_mostly
has been removed from the -mm tree.  Its filename was
     fbcmapc-mark-structs-const-or.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fbcmap.c: mark structs const or __read_mostly
From: Helge Deller <deller@gmx.de>

- Mark the default colormaps read-only, as nobody should be allowed to
  modify them

- Additionally mark color values as __read_mostly since they will only be
  modified (very seldom) by fb_invert_cmaps()

- Add named C99-initializers in fb_cmap structs and use the ARRAY_SIZE()
  macro

Signed-off-by: Helge Deller <deller@gmx.de>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/fbcmap.c |   55 +++++++++++++++++++--------------------
 include/linux/fb.h     |    6 ++--
 2 files changed, 31 insertions(+), 30 deletions(-)

diff -puN drivers/video/fbcmap.c~fbcmapc-mark-structs-const-or drivers/video/fbcmap.c
--- a/drivers/video/fbcmap.c~fbcmapc-mark-structs-const-or
+++ a/drivers/video/fbcmap.c
@@ -18,63 +18,64 @@
 
 #include <asm/uaccess.h>
 
-static u16 red2[] = {
+static u16 red2[] __read_mostly = {
     0x0000, 0xaaaa
 };
-static u16 green2[] = {
+static u16 green2[] __read_mostly = {
     0x0000, 0xaaaa
 };
-static u16 blue2[] = {
+static u16 blue2[] __read_mostly = {
     0x0000, 0xaaaa
 };
 
-static u16 red4[] = {
+static u16 red4[] __read_mostly = {
     0x0000, 0xaaaa, 0x5555, 0xffff
 };
-static u16 green4[] = {
+static u16 green4[] __read_mostly = {
     0x0000, 0xaaaa, 0x5555, 0xffff
 };
-static u16 blue4[] = {
+static u16 blue4[] __read_mostly = {
     0x0000, 0xaaaa, 0x5555, 0xffff
 };
 
-static u16 red8[] = {
+static u16 red8[] __read_mostly = {
     0x0000, 0x0000, 0x0000, 0x0000, 0xaaaa, 0xaaaa, 0xaaaa, 0xaaaa
 };
-static u16 green8[] = {
+static u16 green8[] __read_mostly = {
     0x0000, 0x0000, 0xaaaa, 0xaaaa, 0x0000, 0x0000, 0x5555, 0xaaaa
 };
-static u16 blue8[] = {
+static u16 blue8[] __read_mostly = {
     0x0000, 0xaaaa, 0x0000, 0xaaaa, 0x0000, 0xaaaa, 0x0000, 0xaaaa
 };
 
-static u16 red16[] = {
+static u16 red16[] __read_mostly = {
     0x0000, 0x0000, 0x0000, 0x0000, 0xaaaa, 0xaaaa, 0xaaaa, 0xaaaa,
     0x5555, 0x5555, 0x5555, 0x5555, 0xffff, 0xffff, 0xffff, 0xffff
 };
-static u16 green16[] = {
+static u16 green16[] __read_mostly = {
     0x0000, 0x0000, 0xaaaa, 0xaaaa, 0x0000, 0x0000, 0x5555, 0xaaaa,
     0x5555, 0x5555, 0xffff, 0xffff, 0x5555, 0x5555, 0xffff, 0xffff
 };
-static u16 blue16[] = {
+static u16 blue16[] __read_mostly = {
     0x0000, 0xaaaa, 0x0000, 0xaaaa, 0x0000, 0xaaaa, 0x0000, 0xaaaa,
     0x5555, 0xffff, 0x5555, 0xffff, 0x5555, 0xffff, 0x5555, 0xffff
 };
 
-static struct fb_cmap default_2_colors = {
-    0, 2, red2, green2, blue2, NULL
+static const struct fb_cmap default_2_colors = {
+    .len=2, .red=red2, .green=green2, .blue=blue2
 };
-static struct fb_cmap default_8_colors = {
-    0, 8, red8, green8, blue8, NULL
+static const struct fb_cmap default_8_colors = {
+    .len=8, .red=red8, .green=green8, .blue=blue8
 };
-static struct fb_cmap default_4_colors = {
-    0, 4, red4, green4, blue4, NULL
+static const struct fb_cmap default_4_colors = {
+    .len=4, .red=red4, .green=green4, .blue=blue4
 };
-static struct fb_cmap default_16_colors = {
-    0, 16, red16, green16, blue16, NULL
+static const struct fb_cmap default_16_colors = {
+    .len=16, .red=red16, .green=green16, .blue=blue16
 };
 
 
+
 /**
  *	fb_alloc_cmap - allocate a colormap
  *	@cmap: frame buffer colormap structure
@@ -146,7 +147,7 @@ void fb_dealloc_cmap(struct fb_cmap *cma
  *	Copy contents of colormap from @from to @to.
  */
 
-int fb_copy_cmap(struct fb_cmap *from, struct fb_cmap *to)
+int fb_copy_cmap(const struct fb_cmap *from, struct fb_cmap *to)
 {
 	int tooff = 0, fromoff = 0;
 	int size;
@@ -170,7 +171,7 @@ int fb_copy_cmap(struct fb_cmap *from, s
 	return 0;
 }
 
-int fb_cmap_to_user(struct fb_cmap *from, struct fb_cmap_user *to)
+int fb_cmap_to_user(const struct fb_cmap *from, struct fb_cmap_user *to)
 {
 	int tooff = 0, fromoff = 0;
 	int size;
@@ -282,7 +283,7 @@ int fb_set_user_cmap(struct fb_cmap_user
  *
  */
 
-struct fb_cmap *fb_default_cmap(int len)
+const struct fb_cmap *fb_default_cmap(int len)
 {
     if (len <= 2)
 	return &default_2_colors;
@@ -305,22 +306,22 @@ void fb_invert_cmaps(void)
 {
     u_int i;
 
-    for (i = 0; i < 2; i++) {
+    for (i = 0; i < ARRAY_SIZE(red2); i++) {
 	red2[i] = ~red2[i];
 	green2[i] = ~green2[i];
 	blue2[i] = ~blue2[i];
     }
-    for (i = 0; i < 4; i++) {
+    for (i = 0; i < ARRAY_SIZE(red4); i++) {
 	red4[i] = ~red4[i];
 	green4[i] = ~green4[i];
 	blue4[i] = ~blue4[i];
     }
-    for (i = 0; i < 8; i++) {
+    for (i = 0; i < ARRAY_SIZE(red8); i++) {
 	red8[i] = ~red8[i];
 	green8[i] = ~green8[i];
 	blue8[i] = ~blue8[i];
     }
-    for (i = 0; i < 16; i++) {
+    for (i = 0; i < ARRAY_SIZE(red16); i++) {
 	red16[i] = ~red16[i];
 	green16[i] = ~green16[i];
 	blue16[i] = ~blue16[i];
diff -puN include/linux/fb.h~fbcmapc-mark-structs-const-or include/linux/fb.h
--- a/include/linux/fb.h~fbcmapc-mark-structs-const-or
+++ a/include/linux/fb.h
@@ -970,11 +970,11 @@ extern struct fb_videomode *fb_find_best
 /* drivers/video/fbcmap.c */
 extern int fb_alloc_cmap(struct fb_cmap *cmap, int len, int transp);
 extern void fb_dealloc_cmap(struct fb_cmap *cmap);
-extern int fb_copy_cmap(struct fb_cmap *from, struct fb_cmap *to);
-extern int fb_cmap_to_user(struct fb_cmap *from, struct fb_cmap_user *to);
+extern int fb_copy_cmap(const struct fb_cmap *from, struct fb_cmap *to);
+extern int fb_cmap_to_user(const struct fb_cmap *from, struct fb_cmap_user *to);
 extern int fb_set_cmap(struct fb_cmap *cmap, struct fb_info *fb_info);
 extern int fb_set_user_cmap(struct fb_cmap_user *cmap, struct fb_info *fb_info);
-extern struct fb_cmap *fb_default_cmap(int len);
+extern const struct fb_cmap *fb_default_cmap(int len);
 extern void fb_invert_cmaps(void);
 
 struct fb_videomode {
_

Patches currently in -mm which might be from deller@gmx.de are

origin.patch
fbcmapc-mark-structs-const-or.patch
various-fbdev-files-mark-structs.patch
constify-and-annotate-__read_mostly.patch
annotate-some-variables-in-vesafb.patch
constify-vga16fbc.patch

