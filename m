From: akpm@linux-foundation.org
Subject: [merged] matroxfb-make-config_fb_matrox_multihead=y-mandatory.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:03:01 -0700
Message-ID: <200909232003.n8NK311q018352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbZIWUDm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:03:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, krzysztof.h1@poczta.fm, vandrove@vc.cvut.cz, mm-commits@vger.kernel.org


The patch titled
     matroxfb: make CONFIG_FB_MATROX_MULTIHEAD=y mandatory
has been removed from the -mm tree.  Its filename was
     matroxfb-make-config_fb_matrox_multihead=y-mandatory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: matroxfb: make CONFIG_FB_MATROX_MULTIHEAD=y mandatory
From: Jean Delvare <khali@linux-fr.org>

I would like to get rid of option CONFIG_FB_MATROX_MULTIHEAD and just
always enable it.  There are many reasons for doing this:

* CONFIG_FB_MATROX_MULTIHEAD=y is what all x86 distributions do, so it
  definitely works or we would know by now.

* Building the matroxfb driver with CONFIG_FB_MATROX_MULTIHEAD not set
  results in the following build warning:

drivers/video/matrox/matroxfb_crtc2.c: In function 'matroxfb_dh_open':
drivers/video/matrox/matroxfb_crtc2.c:265: warning: the address of 'matroxfb_global_mxinfo' will always evaluate as 'true'
drivers/video/matrox/matroxfb_crtc2.c: In function 'matroxfb_dh_release':
drivers/video/matrox/matroxfb_crtc2.c:285: warning: the address of 'matroxfb_global_mxinfo' will always evaluate as 'true'

This is nothing to be worried about, the driver will work fine, but build
warnings are still annoying.

* The trick to get multihead support without CONFIG_FB_MATROX_MULTIHEAD,
  which is described in the config help text, no longer works: you can't
  load the same kernel module more than once.

* I fail to see how CONFIG_FB_MATROX_MULTIHEAD=y would make the code
  significantly slower, contrary to what the help text says.  A few extra
  parameters on the stack here and there can't really slow things down in
  comaprison to the rest of the code, and register access.

* The driver built without CONFIG_FB_MATROX_MULTIHEAD is larger than the
  driver build with CONFIG_FB_MATROX_MULTIHEAD=y by 8%.

* One less configuration option makes things simpler.  We add options
  all the time, being able to remove one for once is nice.  It improves
  testing coverage.  And I don't think the Matrox adapters are still
  popular enough to warrant overdetailed configuration settings.

* We should be able to unobfuscate the driver code quite a bit after
  this change (patches follow.)

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Petr Vandrovec <vandrove@vc.cvut.cz>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/matroxfb.txt        |    4 +---
 drivers/video/Kconfig                |   20 --------------------
 drivers/video/matrox/matroxfb_base.c |   23 -----------------------
 drivers/video/matrox/matroxfb_base.h |   20 --------------------
 drivers/video/matrox/matroxfb_misc.c |    4 ----
 5 files changed, 1 insertion(+), 70 deletions(-)

diff -puN Documentation/fb/matroxfb.txt~matroxfb-make-config_fb_matrox_multihead=y-mandatory Documentation/fb/matroxfb.txt
--- a/Documentation/fb/matroxfb.txt~matroxfb-make-config_fb_matrox_multihead=y-mandatory
+++ a/Documentation/fb/matroxfb.txt
@@ -186,9 +186,7 @@ noinverse - show true colors on screen. 
 dev:X    - bind driver to device X. Driver numbers device from 0 up to N,
            where device 0 is first `known' device found, 1 second and so on.
 	   lspci lists devices in this order.
-	   Default is `every' known device for driver with multihead support
-	   and first working device (usually dev:0) for driver without
-	   multihead support.
+	   Default is `every' known device.
 nohwcursor - disables hardware cursor (use software cursor instead).
 hwcursor - enables hardware cursor. It is default. If you are using
            non-accelerated mode (`noaccel' or `fbset -accel false'), software
diff -puN drivers/video/Kconfig~matroxfb-make-config_fb_matrox_multihead=y-mandatory drivers/video/Kconfig
--- a/drivers/video/Kconfig~matroxfb-make-config_fb_matrox_multihead=y-mandatory
+++ a/drivers/video/Kconfig
@@ -1275,26 +1275,6 @@ config FB_MATROX_MAVEN
 	  painting procedures (the secondary head does not use acceleration
 	  engine).
 
-config FB_MATROX_MULTIHEAD
-	bool "Multihead support"
-	depends on FB_MATROX
-	---help---
-	  Say Y here if you have more than one (supported) Matrox device in
-	  your computer and you want to use all of them for different monitors
-	  ("multihead"). If you have only one device, you should say N because
-	  the driver compiled with Y is larger and a bit slower, especially on
-	  ia32 (ix86).
-
-	  If you said M to "Matrox unified accelerated driver" and N here, you
-	  will still be able to use several Matrox devices simultaneously:
-	  insert several instances of the module matroxfb into the kernel
-	  with insmod, supplying the parameter "dev=N" where N is 0, 1, etc.
-	  for the different Matrox devices. This method is slightly faster but
-	  uses 40 KB of kernel memory per Matrox card.
-
-	  There is no need for enabling 'Matrox multihead support' if you have
-	  only one Matrox card in the box.
-
 config FB_RADEON
 	tristate "ATI Radeon display support"
 	depends on FB && PCI
diff -puN drivers/video/matrox/matroxfb_base.c~matroxfb-make-config_fb_matrox_multihead=y-mandatory drivers/video/matrox/matroxfb_base.c
--- a/drivers/video/matrox/matroxfb_base.c~matroxfb-make-config_fb_matrox_multihead=y-mandatory
+++ a/drivers/video/matrox/matroxfb_base.c
@@ -379,9 +379,7 @@ static void matroxfb_remove(WPMINFO int 
 	mga_iounmap(ACCESS_FBINFO(video.vbase));
 	release_mem_region(ACCESS_FBINFO(video.base), ACCESS_FBINFO(video.len_maximum));
 	release_mem_region(ACCESS_FBINFO(mmio.base), 16384);
-#ifdef CONFIG_FB_MATROX_MULTIHEAD
 	kfree(minfo);
-#endif
 }
 
 	/*
@@ -644,9 +642,7 @@ static int matroxfb_setcolreg(unsigned r
 			      unsigned blue, unsigned transp,
 			      struct fb_info *fb_info)
 {
-#ifdef CONFIG_FB_MATROX_MULTIHEAD
 	struct matrox_fb_info* minfo = container_of(fb_info, struct matrox_fb_info, fbcon);
-#endif
 
 	DBG(__func__)
 
@@ -2011,9 +2007,6 @@ static int matroxfb_probe(struct pci_dev
 	struct matrox_fb_info* minfo;
 	int err;
 	u_int32_t cmd;
-#ifndef CONFIG_FB_MATROX_MULTIHEAD
-	static int registered = 0;
-#endif
 	DBG(__func__)
 
 	svid = pdev->subsystem_vendor;
@@ -2037,15 +2030,9 @@ static int matroxfb_probe(struct pci_dev
 		return -1;
 	}
 
-#ifdef CONFIG_FB_MATROX_MULTIHEAD
 	minfo = kmalloc(sizeof(*minfo), GFP_KERNEL);
 	if (!minfo)
 		return -1;
-#else
-	if (registered)	/* singlehead driver... */
-		return -1;
-	minfo = &matroxfb_global_mxinfo;
-#endif
 	memset(MINFO, 0, sizeof(*MINFO));
 
 	ACCESS_FBINFO(pcidev) = pdev;
@@ -2090,15 +2077,10 @@ static int matroxfb_probe(struct pci_dev
 
 	err = initMatrox2(PMINFO b);
 	if (!err) {
-#ifndef CONFIG_FB_MATROX_MULTIHEAD
-		registered = 1;
-#endif
 		matroxfb_register_device(MINFO);
 		return 0;
 	}
-#ifdef CONFIG_FB_MATROX_MULTIHEAD
 	kfree(minfo);
-#endif
 	return -1;
 }
 
@@ -2510,13 +2492,8 @@ module_param(inv24, int, 0);
 MODULE_PARM_DESC(inv24, "Inverts clock polarity for 24bpp and loop frequency > 100MHz (default=do not invert polarity)");
 module_param(inverse, int, 0);
 MODULE_PARM_DESC(inverse, "Inverse (0 or 1) (default=0)");
-#ifdef CONFIG_FB_MATROX_MULTIHEAD
 module_param(dev, int, 0);
 MODULE_PARM_DESC(dev, "Multihead support, attach to device ID (0..N) (default=all working)");
-#else
-module_param(dev, int, 0);
-MODULE_PARM_DESC(dev, "Multihead support, attach to device ID (0..N) (default=first working)");
-#endif
 module_param(vesa, int, 0);
 MODULE_PARM_DESC(vesa, "Startup videomode (0x000-0x1FF) (default=0x101)");
 module_param(xres, int, 0);
diff -puN drivers/video/matrox/matroxfb_base.h~matroxfb-make-config_fb_matrox_multihead=y-mandatory drivers/video/matrox/matroxfb_base.h
--- a/drivers/video/matrox/matroxfb_base.h~matroxfb-make-config_fb_matrox_multihead=y-mandatory
+++ a/drivers/video/matrox/matroxfb_base.h
@@ -524,7 +524,6 @@ struct matrox_fb_info {
 
 #define info2minfo(info) container_of(info, struct matrox_fb_info, fbcon)
 
-#ifdef CONFIG_FB_MATROX_MULTIHEAD
 #define ACCESS_FBINFO2(info, x) (info->x)
 #define ACCESS_FBINFO(x) ACCESS_FBINFO2(minfo,x)
 
@@ -538,25 +537,6 @@ struct matrox_fb_info {
 #define PMINFO   PMINFO2 ,
 
 #define MINFO_FROM(x)	   struct matrox_fb_info* minfo = x
-#else
-
-extern struct matrox_fb_info matroxfb_global_mxinfo;
-
-#define ACCESS_FBINFO(x) (matroxfb_global_mxinfo.x)
-#define ACCESS_FBINFO2(info, x) (matroxfb_global_mxinfo.x)
-
-#define MINFO (&matroxfb_global_mxinfo)
-
-#define WPMINFO2 void
-#define WPMINFO
-#define CPMINFO2 void
-#define CPMINFO
-#define PMINFO2
-#define PMINFO
-
-#define MINFO_FROM(x)
-
-#endif
 
 #define MINFO_FROM_INFO(x) MINFO_FROM(info2minfo(x))
 
diff -puN drivers/video/matrox/matroxfb_misc.c~matroxfb-make-config_fb_matrox_multihead=y-mandatory drivers/video/matrox/matroxfb_misc.c
--- a/drivers/video/matrox/matroxfb_misc.c~matroxfb-make-config_fb_matrox_multihead=y-mandatory
+++ a/drivers/video/matrox/matroxfb_misc.c
@@ -784,10 +784,6 @@ EXPORT_SYMBOL(matroxfb_DAC_in);
 EXPORT_SYMBOL(matroxfb_DAC_out);
 EXPORT_SYMBOL(matroxfb_var2my);
 EXPORT_SYMBOL(matroxfb_PLL_calcclock);
-#ifndef CONFIG_FB_MATROX_MULTIHEAD
-struct matrox_fb_info matroxfb_global_mxinfo;
-EXPORT_SYMBOL(matroxfb_global_mxinfo);
-#endif
 EXPORT_SYMBOL(matroxfb_vgaHWinit);		/* DAC1064, Ti3026 */
 EXPORT_SYMBOL(matroxfb_vgaHWrestore);		/* DAC1064, Ti3026 */
 EXPORT_SYMBOL(matroxfb_read_pins);
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
hwmon-driver-for-texas-instruments-amc6821-chip.patch
rtc-set-wakeup-capability-for-i2c-and-spi-rtc-drivers.patch

