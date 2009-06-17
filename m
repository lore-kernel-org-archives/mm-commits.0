From: akpm@linux-foundation.org
Subject: [merged] fbdev-move-logo-externs-to-header-file.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:04 -0700
Message-ID: <200906171839.n5HId4dq005131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756371AbZFQSv5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:51:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, jsimmons@infradead.org, krzysztof.h1@poczta.fm, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     fbdev: move logo externs to header file
has been removed from the -mm tree.  Its filename was
     fbdev-move-logo-externs-to-header-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: move logo externs to header file
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Now we have __initconst, we can finally move the external declarations for
the various Linux logo structures to <linux/linux_logo.h>.

James' ack dates back to the previous submission (way to long ago), when the
logos were still __initdata, which caused failures on some platforms with some
toolchain versions.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Acked-by: James Simmons <jsimmons@infradead.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/prom_init.c        |    3 ---
 arch/powerpc/platforms/cell/spu_base.c |   11 +----------
 arch/um/include/shared/init.h          |    2 +-
 drivers/video/logo/logo.c              |   15 ---------------
 include/linux/init.h                   |    2 +-
 include/linux/linux_logo.h             |   16 ++++++++++++++++
 scripts/pnmtologo.c                    |   18 +++++++++---------
 7 files changed, 28 insertions(+), 39 deletions(-)

diff -puN arch/powerpc/kernel/prom_init.c~fbdev-move-logo-externs-to-header-file arch/powerpc/kernel/prom_init.c
--- a/arch/powerpc/kernel/prom_init.c~fbdev-move-logo-externs-to-header-file
+++ a/arch/powerpc/kernel/prom_init.c
@@ -44,10 +44,7 @@
 #include <asm/sections.h>
 #include <asm/machdep.h>
 
-#ifdef CONFIG_LOGO_LINUX_CLUT224
 #include <linux/linux_logo.h>
-extern const struct linux_logo logo_linux_clut224;
-#endif
 
 /*
  * Properties whose value is longer than this get excluded from our
diff -puN arch/powerpc/platforms/cell/spu_base.c~fbdev-move-logo-externs-to-header-file arch/powerpc/platforms/cell/spu_base.c
--- a/arch/powerpc/platforms/cell/spu_base.c~fbdev-move-logo-externs-to-header-file
+++ a/arch/powerpc/platforms/cell/spu_base.c
@@ -752,17 +752,8 @@ static int __init init_spu_base(void)
 		goto out_unregister_sysdev_class;
 	}
 
-	if (ret > 0) {
-		/*
-		 * We cannot put the forward declaration in
-		 * <linux/linux_logo.h> because of conflicting session type
-		 * conflicts for const and __initdata with different compiler
-		 * versions
-		 */
-		extern const struct linux_logo logo_spe_clut224;
-
+	if (ret > 0)
 		fb_append_extra_logo(&logo_spe_clut224, ret);
-	}
 
 	mutex_lock(&spu_full_list_mutex);
 	xmon_register_spus(&spu_full_list);
diff -puN arch/um/include/shared/init.h~fbdev-move-logo-externs-to-header-file arch/um/include/shared/init.h
--- a/arch/um/include/shared/init.h~fbdev-move-logo-externs-to-header-file
+++ a/arch/um/include/shared/init.h
@@ -27,7 +27,7 @@
  * sign followed by value, e.g.:
  *
  * static int init_variable __initdata = 0;
- * static char linux_logo[] __initdata = { 0x32, 0x36, ... };
+ * static const char linux_logo[] __initconst = { 0x32, 0x36, ... };
  *
  * Don't forget to initialize data not at file scope, i.e. within a function,
  * as gcc otherwise puts the data into the bss section and not into the init
diff -puN drivers/video/logo/logo.c~fbdev-move-logo-externs-to-header-file drivers/video/logo/logo.c
--- a/drivers/video/logo/logo.c~fbdev-move-logo-externs-to-header-file
+++ a/drivers/video/logo/logo.c
@@ -21,21 +21,6 @@
 #include <asm/bootinfo.h>
 #endif
 
-extern const struct linux_logo logo_linux_mono;
-extern const struct linux_logo logo_linux_vga16;
-extern const struct linux_logo logo_linux_clut224;
-extern const struct linux_logo logo_blackfin_vga16;
-extern const struct linux_logo logo_blackfin_clut224;
-extern const struct linux_logo logo_dec_clut224;
-extern const struct linux_logo logo_mac_clut224;
-extern const struct linux_logo logo_parisc_clut224;
-extern const struct linux_logo logo_sgi_clut224;
-extern const struct linux_logo logo_sun_clut224;
-extern const struct linux_logo logo_superh_mono;
-extern const struct linux_logo logo_superh_vga16;
-extern const struct linux_logo logo_superh_clut224;
-extern const struct linux_logo logo_m32r_clut224;
-
 static int nologo;
 module_param(nologo, bool, 0);
 MODULE_PARM_DESC(nologo, "Disables startup logo");
diff -puN include/linux/init.h~fbdev-move-logo-externs-to-header-file include/linux/init.h
--- a/include/linux/init.h~fbdev-move-logo-externs-to-header-file
+++ a/include/linux/init.h
@@ -29,7 +29,7 @@
  * sign followed by value, e.g.:
  *
  * static int init_variable __initdata = 0;
- * static char linux_logo[] __initdata = { 0x32, 0x36, ... };
+ * static const char linux_logo[] __initconst = { 0x32, 0x36, ... };
  *
  * Don't forget to initialize data not at file scope, i.e. within a function,
  * as gcc otherwise puts the data into the bss section and not into the init
diff -puN include/linux/linux_logo.h~fbdev-move-logo-externs-to-header-file include/linux/linux_logo.h
--- a/include/linux/linux_logo.h~fbdev-move-logo-externs-to-header-file
+++ a/include/linux/linux_logo.h
@@ -32,6 +32,22 @@ struct linux_logo {
 	const unsigned char *data;
 };
 
+extern const struct linux_logo logo_linux_mono;
+extern const struct linux_logo logo_linux_vga16;
+extern const struct linux_logo logo_linux_clut224;
+extern const struct linux_logo logo_blackfin_vga16;
+extern const struct linux_logo logo_blackfin_clut224;
+extern const struct linux_logo logo_dec_clut224;
+extern const struct linux_logo logo_mac_clut224;
+extern const struct linux_logo logo_parisc_clut224;
+extern const struct linux_logo logo_sgi_clut224;
+extern const struct linux_logo logo_sun_clut224;
+extern const struct linux_logo logo_superh_mono;
+extern const struct linux_logo logo_superh_vga16;
+extern const struct linux_logo logo_superh_clut224;
+extern const struct linux_logo logo_m32r_clut224;
+extern const struct linux_logo logo_spe_clut224;
+
 extern const struct linux_logo *fb_find_logo(int depth);
 #ifdef CONFIG_FB_LOGO_EXTRA
 extern void fb_append_extra_logo(const struct linux_logo *logo,
diff -puN scripts/pnmtologo.c~fbdev-move-logo-externs-to-header-file scripts/pnmtologo.c
--- a/scripts/pnmtologo.c~fbdev-move-logo-externs-to-header-file
+++ a/scripts/pnmtologo.c
@@ -237,22 +237,22 @@ static void write_header(void)
     fprintf(out, " *  Linux logo %s\n", logoname);
     fputs(" */\n\n", out);
     fputs("#include <linux/linux_logo.h>\n\n", out);
-    fprintf(out, "static unsigned char %s_data[] __initdata = {\n",
+    fprintf(out, "static const unsigned char %s_data[] __initconst = {\n",
 	    logoname);
 }
 
 static void write_footer(void)
 {
     fputs("\n};\n\n", out);
-    fprintf(out, "struct linux_logo %s __initdata = {\n", logoname);
-    fprintf(out, "    .type\t= %s,\n", logo_types[logo_type]);
-    fprintf(out, "    .width\t= %d,\n", logo_width);
-    fprintf(out, "    .height\t= %d,\n", logo_height);
+    fprintf(out, "const struct linux_logo %s __initconst = {\n", logoname);
+    fprintf(out, "\t.type\t\t= %s,\n", logo_types[logo_type]);
+    fprintf(out, "\t.width\t\t= %d,\n", logo_width);
+    fprintf(out, "\t.height\t\t= %d,\n", logo_height);
     if (logo_type == LINUX_LOGO_CLUT224) {
-	fprintf(out, "    .clutsize\t= %d,\n", logo_clutsize);
-	fprintf(out, "    .clut\t= %s_clut,\n", logoname);
+	fprintf(out, "\t.clutsize\t= %d,\n", logo_clutsize);
+	fprintf(out, "\t.clut\t\t= %s_clut,\n", logoname);
     }
-    fprintf(out, "    .data\t= %s_data\n", logoname);
+    fprintf(out, "\t.data\t\t= %s_data\n", logoname);
     fputs("};\n\n", out);
 
     /* close logo file */
@@ -374,7 +374,7 @@ static void write_logo_clut224(void)
     fputs("\n};\n\n", out);
 
     /* write logo clut */
-    fprintf(out, "static unsigned char %s_clut[] __initdata = {\n",
+    fprintf(out, "static const unsigned char %s_clut[] __initconst = {\n",
 	    logoname);
     write_hex_cnt = 0;
     for (i = 0; i < logo_clutsize; i++) {
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
linux-next.patch

