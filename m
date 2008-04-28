From: akpm@linux-foundation.org
Subject: - fb-add-support-for-foreign-endianness-add-support-for-choice-foreign-endianness.patch removed from -mm tree
Date: Mon, 28 Apr 2008 00:00:09 -0700
Message-ID: <200804280700.m3S709Ta012976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607AbYD1HAl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 03:00:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, Valdis.Kletnieks@vt.edu, adaplas@pol.net, benh@kernel.crashing.org, clemens.koller@anagramm.de, geert@linux-m68k.org, krzysztof.h1@poczta.fm, paulus@samba.org


The patch titled
     fb: add support for choice foreign endianness
has been removed from the -mm tree.  Its filename was
     fb-add-support-for-foreign-endianness-add-support-for-choice-foreign-endianness.patch

This patch was dropped because it was folded into fb-add-support-for-foreign-endianness.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fb: add support for choice foreign endianness
From: Anton Vorontsov <avorontsov@ru.mvista.com>

With this patch FB_FOREIGN_ENDIAN converted to menuconfig with the choice
inside: which type of foreign endianness we want to compile-in.

As a bonus, now fb subsystem will refuse to register framebuffer with
unsupported endianness, and will suggest a way to solve the problem.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |   27 +++++++++++++++++++++------
 drivers/video/fbmem.c |   38 ++++++++++++++++++++++++++++++--------
 include/linux/fb.h    |   14 +++++++++++---
 3 files changed, 62 insertions(+), 17 deletions(-)

diff -puN drivers/video/Kconfig~fb-add-support-for-foreign-endianness-add-support-for-choice-foreign-endianness drivers/video/Kconfig
--- a/drivers/video/Kconfig~fb-add-support-for-foreign-endianness-add-support-for-choice-foreign-endianness
+++ a/drivers/video/Kconfig
@@ -139,14 +139,29 @@ config FB_SYS_IMAGEBLIT
 	  blitting. This is used by drivers that don't provide their own
 	  (accelerated) version and the framebuffer is in system RAM.
 
-config FB_FOREIGN_ENDIAN
-	bool "Enable support for foreign endianness"
+menuconfig FB_FOREIGN_ENDIAN
+	bool "Framebuffer foreign endianness support"
 	depends on FB
 	---help---
-	  This option enables support for the framebuffers with non-native
-	  endianness (e.g. Little-Endian framebuffer on a Big-Endian machine).
-	  You probably don't have such hardware, so in most cases it's safe to
-	  say "n" here.
+	  This menu will let you enable support for the framebuffers with
+	  non-native endianness (e.g. Little-Endian framebuffer on a
+	  Big-Endian machine). Most probably you don't have such hardware,
+	  so it's safe to say "n" here.
+
+choice
+	prompt "Choice endianness support"
+	depends on FB_FOREIGN_ENDIAN
+
+config FB_BOTH_ENDIAN
+	bool "Support for Big- and Little-Endian framebuffers"
+
+config FB_BIG_ENDIAN
+	bool "Support for Big-Endian framebuffers only"
+
+config FB_LITTLE_ENDIAN
+	bool "Support for Little-Endian framebuffers only"
+
+endchoice
 
 config FB_SYS_FOPS
        tristate
diff -puN drivers/video/fbmem.c~fb-add-support-for-foreign-endianness-add-support-for-choice-foreign-endianness drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-add-support-for-foreign-endianness-add-support-for-choice-foreign-endianness
+++ a/drivers/video/fbmem.c
@@ -1352,6 +1352,32 @@ static const struct file_operations fb_f
 
 struct class *fb_class;
 EXPORT_SYMBOL(fb_class);
+
+static int fb_check_foreignness(struct fb_info *fi)
+{
+	const bool foreign_endian = fi->flags & FBINFO_FOREIGN_ENDIAN;
+
+	fi->flags &= ~FBINFO_FOREIGN_ENDIAN;
+
+#ifdef __BIG_ENDIAN
+	fi->flags |= foreign_endian ? 0 : FBINFO_BE_MATH;
+#else
+	fi->flags |= foreign_endian ? FBINFO_BE_MATH : 0;
+#endif /* __BIG_ENDIAN */
+
+	if (fi->flags & FBINFO_BE_MATH && !fb_be_math(fi)) {
+		pr_err("%s: enable CONFIG_FB_BIG_ENDIAN to "
+		       "support this framebuffer\n", fi->fix.id);
+		return -ENOSYS;
+	} else if (!(fi->flags & FBINFO_BE_MATH) && fb_be_math(fi)) {
+		pr_err("%s: enable CONFIG_FB_LITTLE_ENDIAN to "
+		       "support this framebuffer\n", fi->fix.id);
+		return -ENOSYS;
+	}
+
+	return 0;
+}
+
 /**
  *	register_framebuffer - registers a frame buffer device
  *	@fb_info: frame buffer info structure
@@ -1368,10 +1394,13 @@ register_framebuffer(struct fb_info *fb_
 	int i;
 	struct fb_event event;
 	struct fb_videomode mode;
-	const bool foreign_endian = fb_info->flags & FBINFO_FOREIGN_ENDIAN;
 
 	if (num_registered_fb == FB_MAX)
 		return -ENXIO;
+
+	if (fb_check_foreignness(fb_info))
+		return -ENOSYS;
+
 	num_registered_fb++;
 	for (i = 0 ; i < FB_MAX; i++)
 		if (!registered_fb[i])
@@ -1405,13 +1434,6 @@ register_framebuffer(struct fb_info *fb_
 	if (!fb_info->pixmap.blit_y)
 		fb_info->pixmap.blit_y = ~(u32)0;
 
-	fb_info->flags &= ~FBINFO_FOREIGN_ENDIAN;
-#ifdef __BIG_ENDIAN
-	fb_info->flags |= foreign_endian ? 0 : FBINFO_BE_MATH;
-#else
-	fb_info->flags |= foreign_endian ? FBINFO_BE_MATH : 0;
-#endif
-
 	if (!fb_info->modelist.prev || !fb_info->modelist.next)
 		INIT_LIST_HEAD(&fb_info->modelist);
 
diff -puN include/linux/fb.h~fb-add-support-for-foreign-endianness-add-support-for-choice-foreign-endianness include/linux/fb.h
--- a/include/linux/fb.h~fb-add-support-for-foreign-endianness-add-support-for-choice-foreign-endianness
+++ a/include/linux/fb.h
@@ -979,13 +979,21 @@ extern int fb_deferred_io_fsync(struct f
 
 static inline bool fb_be_math(struct fb_info *info)
 {
-#if defined(CONFIG_FB_FOREIGN_ENDIAN)
+#ifdef CONFIG_FB_FOREIGN_ENDIAN
+#if defined(CONFIG_FB_BOTH_ENDIAN)
 	return info->flags & FBINFO_BE_MATH;
-#elif defined(__BIG_ENDIAN)
+#elif defined(CONFIG_FB_BIG_ENDIAN)
+	return true;
+#elif defined(CONFIG_FB_LITTLE_ENDIAN)
+	return false;
+#endif /* CONFIG_FB_BOTH_ENDIAN */
+#else
+#ifdef __BIG_ENDIAN
 	return true;
 #else
 	return false;
-#endif
+#endif /* __BIG_ENDIAN */
+#endif /* CONFIG_FB_FOREIGN_ENDIAN */
 }
 
 /* drivers/video/fbsysfs.c */
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
gpiolib-dynamic-gpio-number-allocation.patch
gpiochip_reserve.patch
fb-add-support-for-foreign-endianness.patch
fb-add-support-for-foreign-endianness-add-support-for-choice-foreign-endianness.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
powerpc-offb-add-support-for-foreign-endianness.patch

