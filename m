From: akpm@linux-foundation.org
Subject: - add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix-2.patch removed from -mm tree
Date: Thu, 06 Nov 2008 12:47:15 -0800
Message-ID: <200811062047.mA6KlFk2010458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353AbYKFUuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 15:50:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agust@denx.de, avorontsov@ru.mvista.com, dbaryshkov@gmail.com, krzysztof.h1@poczta.fm, m.fortini@selcomgroup.com, mm-commits@vger.kernel.org


The patch titled
     fbdev: Fujitsu MB862xx framebuffer driver i386 allmodconfig fix
has been removed from the -mm tree.  Its filename was
     add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix-2.patch

This patch was dropped because it was folded into add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev: Fujitsu MB862xx framebuffer driver i386 allmodconfig fix
From: Anatolij Gustschin <agust@denx.de>

Fix i386 allmodconfig build previously failed with:

drivers/video/mb862xx/mb862xxfb.h:65:2: error: #error "Select Lime GDC or CoralP/Carmine support, but not both together"
drivers/video/mb862xx/mb862xxfb.c:549: warning: 'struct of_device' declared inside parameter list
drivers/video/mb862xx/mb862xxfb.c:549: warning: its scope is only this definition or declaration, which is probably not what you want
...

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Matteo Fortini <m.fortini@selcomgroup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig             |    3 ++-
 drivers/video/mb862xx/mb862xxfb.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/video/Kconfig~add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix-2 drivers/video/Kconfig
--- a/drivers/video/Kconfig~add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix-2
+++ a/drivers/video/Kconfig
@@ -2094,7 +2094,7 @@ config FB_MB862XX
 
 config FB_MB862XX_PCI_GDC
 	bool "Carmine/Coral-P(A) GDC"
-	depends on FB_MB862XX
+	depends on PCI && FB_MB862XX
 	---help---
 	  This enables framebuffer support for Fujitsu Carmine/Coral-P(A)
 	  PCI graphics controller devices.
@@ -2102,6 +2102,7 @@ config FB_MB862XX_PCI_GDC
 config FB_MB862XX_LIME
 	bool "Lime GDC"
 	depends on FB_MB862XX
+	depends on OF && !FB_MB862XX_PCI_GDC
 	select FB_FOREIGN_ENDIAN
 	select FB_LITTLE_ENDIAN
 	---help---
diff -puN drivers/video/mb862xx/mb862xxfb.c~add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix-2 drivers/video/mb862xx/mb862xxfb.c
--- a/drivers/video/mb862xx/mb862xxfb.c~add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix-2
+++ a/drivers/video/mb862xx/mb862xxfb.c
@@ -554,7 +554,7 @@ static int __devinit of_platform_mb862xx
 	struct fb_info *info;
 	struct resource res;
 	resource_size_t res_size;
-	unsigned long ret;
+	unsigned long ret = -ENODEV;
 
 	if (of_address_to_resource(np, 0, &res)) {
 		dev_err(dev, "Invalid address\n");
_

Patches currently in -mm which might be from agust@denx.de are

add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs.patch
add-new-framebuffer-driver-for-fujitsu-mb862xx-gdcs-fix-2.patch

