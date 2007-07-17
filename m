From: akpm@linux-foundation.org
Subject: - cell-draw-spe-helper-penguin-logos.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:08:13 -0700
Message-ID: <200707172308.l6HN8Dkq012265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33677 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936817AbXGQXRE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:17:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, adaplas@pol.net, arnd@arndb.de, benh@kernel.crashing.org, geoffrey.levand@am.sony.com, jsimmons@infradead.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Cell: Draw SPE helper penguin logos
has been removed from the -mm tree.  Its filename was
     cell-draw-spe-helper-penguin-logos.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Cell: Draw SPE helper penguin logos
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Let spu_management_ops.enumerate_spus() return the number of found SPEs
and use that information to draw some little helper penguin logos.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-By: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spu_base.c   |   15 ++++++++++++++-
 arch/powerpc/platforms/cell/spu_manage.c |    4 +++-
 arch/powerpc/platforms/ps3/spu.c         |    6 ++++--
 drivers/video/logo/Kconfig               |    1 +
 4 files changed, 22 insertions(+), 4 deletions(-)

diff -puN arch/powerpc/platforms/cell/spu_base.c~cell-draw-spe-helper-penguin-logos arch/powerpc/platforms/cell/spu_base.c
--- a/arch/powerpc/platforms/cell/spu_base.c~cell-draw-spe-helper-penguin-logos
+++ a/arch/powerpc/platforms/cell/spu_base.c
@@ -31,6 +31,7 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 #include <linux/mutex.h>
+#include <linux/linux_logo.h>
 #include <asm/spu.h>
 #include <asm/spu_priv1.h>
 #include <asm/xmon.h>
@@ -656,12 +657,24 @@ static int __init init_spu_base(void)
 
 	ret = spu_enumerate_spus(create_spu);
 
-	if (ret) {
+	if (ret < 0) {
 		printk(KERN_WARNING "%s: Error initializing spus\n",
 			__FUNCTION__);
 		goto out_unregister_sysdev_class;
 	}
 
+	if (ret > 0) {
+		/*
+		 * We cannot put the forward declaration in
+		 * <linux/linux_logo.h> because of conflicting session type
+		 * conflicts for const and __initdata with different compiler
+		 * versions
+		 */
+		extern const struct linux_logo logo_spe_clut224;
+
+		fb_append_extra_logo(&logo_spe_clut224, ret);
+	}
+
 	xmon_register_spus(&spu_full_list);
 
 	spu_add_sysdev_attr(&attr_stat);
diff -puN arch/powerpc/platforms/cell/spu_manage.c~cell-draw-spe-helper-penguin-logos arch/powerpc/platforms/cell/spu_manage.c
--- a/arch/powerpc/platforms/cell/spu_manage.c~cell-draw-spe-helper-penguin-logos
+++ a/arch/powerpc/platforms/cell/spu_manage.c
@@ -279,6 +279,7 @@ static int __init of_enumerate_spus(int 
 {
 	int ret;
 	struct device_node *node;
+	unsigned int n = 0;
 
 	ret = -ENODEV;
 	for (node = of_find_node_by_type(NULL, "spe");
@@ -289,8 +290,9 @@ static int __init of_enumerate_spus(int 
 				__FUNCTION__, node->name);
 			break;
 		}
+		n++;
 	}
-	return ret;
+	return ret ? ret : n;
 }
 
 static int __init of_create_spu(struct spu *spu, void *data)
diff -puN arch/powerpc/platforms/ps3/spu.c~cell-draw-spe-helper-penguin-logos arch/powerpc/platforms/ps3/spu.c
--- a/arch/powerpc/platforms/ps3/spu.c~cell-draw-spe-helper-penguin-logos
+++ a/arch/powerpc/platforms/ps3/spu.c
@@ -405,11 +405,13 @@ static int __init ps3_enumerate_spus(int
 		}
 	}
 
-	if (result)
+	if (result) {
 		printk(KERN_WARNING "%s:%d: Error initializing spus\n",
 			__func__, __LINE__);
+		return result;
+	}
 
-	return result;
+	return num_resource_id;
 }
 
 const struct spu_management_ops spu_management_ps3_ops = {
diff -puN drivers/video/logo/Kconfig~cell-draw-spe-helper-penguin-logos drivers/video/logo/Kconfig
--- a/drivers/video/logo/Kconfig~cell-draw-spe-helper-penguin-logos
+++ a/drivers/video/logo/Kconfig
@@ -13,6 +13,7 @@ if LOGO
 config FB_LOGO_EXTRA
 	bool
 	depends on FB
+	default y if SPU_BASE
 
 config LOGO_LINUX_MONO
 	bool "Standard black and white Linux logo"
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
