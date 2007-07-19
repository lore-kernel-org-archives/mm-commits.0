From: akpm@linux-foundation.org
Subject: - unregister_chrdev-ignore-the-return-value.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:00:47 -0700
Message-ID: <200707192000.l6JK0lSf019474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37236 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932952AbXGSU0r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:26:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, davem@davemloft.net, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     unregister_chrdev(): ignore the return value
has been removed from the -mm tree.  Its filename was
     unregister_chrdev-ignore-the-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: unregister_chrdev(): ignore the return value
From: Akinobu Mita <akinobu.mita@gmail.com>

unregister_chrdev() always returns 0.  There is no need to check the return
value.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/drivers/pcf8563.c |    4 +---
 arch/cris/arch-v32/drivers/pcf8563.c |    4 +---
 arch/sparc64/solaris/socksys.c       |    3 +--
 drivers/char/ip2/ip2main.c           |    4 +---
 drivers/char/mbcs.c                  |    7 +------
 drivers/char/stallion.c              |    5 +----
 drivers/char/viotape.c               |    7 +------
 drivers/net/ppp_generic.c            |    3 +--
 sound/core/sound.c                   |    3 +--
 9 files changed, 9 insertions(+), 31 deletions(-)

diff -puN arch/cris/arch-v10/drivers/pcf8563.c~unregister_chrdev-ignore-the-return-value arch/cris/arch-v10/drivers/pcf8563.c
--- a/arch/cris/arch-v10/drivers/pcf8563.c~unregister_chrdev-ignore-the-return-value
+++ a/arch/cris/arch-v10/drivers/pcf8563.c
@@ -180,9 +180,7 @@ err:
 void __exit
 pcf8563_exit(void)
 {
-	if (unregister_chrdev(PCF8563_MAJOR, DEVICE_NAME) < 0) {
-		printk(KERN_INFO "%s: Unable to unregister device.\n", PCF8563_NAME);
-	}
+	unregister_chrdev(PCF8563_MAJOR, DEVICE_NAME);
 }
 
 /*
diff -puN arch/cris/arch-v32/drivers/pcf8563.c~unregister_chrdev-ignore-the-return-value arch/cris/arch-v32/drivers/pcf8563.c
--- a/arch/cris/arch-v32/drivers/pcf8563.c~unregister_chrdev-ignore-the-return-value
+++ a/arch/cris/arch-v32/drivers/pcf8563.c
@@ -193,9 +193,7 @@ err:
 void __exit
 pcf8563_exit(void)
 {
-	if (unregister_chrdev(PCF8563_MAJOR, DEVICE_NAME) < 0) {
-		printk(KERN_INFO "%s: Unable to unregister device.\n", PCF8563_NAME);
-	}
+	unregister_chrdev(PCF8563_MAJOR, DEVICE_NAME);
 }
 
 /*
diff -puN arch/sparc64/solaris/socksys.c~unregister_chrdev-ignore-the-return-value arch/sparc64/solaris/socksys.c
--- a/arch/sparc64/solaris/socksys.c~unregister_chrdev-ignore-the-return-value
+++ a/arch/sparc64/solaris/socksys.c
@@ -199,6 +199,5 @@ int __init init_socksys(void)
 
 void __exit cleanup_socksys(void)
 {
-	if (unregister_chrdev(30, "socksys"))
-		printk ("Couldn't unregister socksys character device\n");
+	unregister_chrdev(30, "socksys");
 }
diff -puN drivers/char/ip2/ip2main.c~unregister_chrdev-ignore-the-return-value drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~unregister_chrdev-ignore-the-return-value
+++ a/drivers/char/ip2/ip2main.c
@@ -425,9 +425,7 @@ cleanup_module(void)
 		printk(KERN_ERR "IP2: failed to unregister tty driver (%d)\n", err);
 	}
 	put_tty_driver(ip2_tty_driver);
-	if ( ( err = unregister_chrdev ( IP2_IPL_MAJOR, pcIpl ) ) ) {
-		printk(KERN_ERR "IP2: failed to unregister IPL driver (%d)\n", err);
-	}
+	unregister_chrdev(IP2_IPL_MAJOR, pcIpl);
 	remove_proc_entry("ip2mem", &proc_root);
 
 	// free memory
diff -puN drivers/char/mbcs.c~unregister_chrdev-ignore-the-return-value drivers/char/mbcs.c
--- a/drivers/char/mbcs.c~unregister_chrdev-ignore-the-return-value
+++ a/drivers/char/mbcs.c
@@ -816,12 +816,7 @@ struct cx_drv mbcs_driver = {
 
 static void __exit mbcs_exit(void)
 {
-	int rv;
-
-	rv = unregister_chrdev(mbcs_major, DEVICE_NAME);
-	if (rv < 0)
-		DBG(KERN_ALERT "Error in unregister_chrdev: %d\n", rv);
-
+	unregister_chrdev(mbcs_major, DEVICE_NAME);
 	cx_driver_unregister(&mbcs_driver);
 }
 
diff -puN drivers/char/stallion.c~unregister_chrdev-ignore-the-return-value drivers/char/stallion.c
--- a/drivers/char/stallion.c~unregister_chrdev-ignore-the-return-value
+++ a/drivers/char/stallion.c
@@ -4795,7 +4795,6 @@ static void __exit stallion_module_exit(
 {
 	struct stlbrd *brdp;
 	unsigned int i, j;
-	int retval;
 
 	pr_debug("cleanup_module()\n");
 
@@ -4818,9 +4817,7 @@ static void __exit stallion_module_exit(
 
 	for (i = 0; i < 4; i++)
 		class_device_destroy(stallion_class, MKDEV(STL_SIOMEMMAJOR, i));
-	if ((retval = unregister_chrdev(STL_SIOMEMMAJOR, "staliomem")))
-		printk("STALLION: failed to un-register serial memory device, "
-			"errno=%d\n", -retval);
+	unregister_chrdev(STL_SIOMEMMAJOR, "staliomem");
 	class_destroy(stallion_class);
 
 	pci_unregister_driver(&stl_pcidriver);
diff -puN drivers/char/viotape.c~unregister_chrdev-ignore-the-return-value drivers/char/viotape.c
--- a/drivers/char/viotape.c~unregister_chrdev-ignore-the-return-value
+++ a/drivers/char/viotape.c
@@ -1098,15 +1098,10 @@ static int chg_state(int index, unsigned
 /* Cleanup */
 static void __exit viotap_exit(void)
 {
-	int ret;
-
 	remove_proc_entry("iSeries/viotape", NULL);
 	vio_unregister_driver(&viotape_driver);
 	class_destroy(tape_class);
-	ret = unregister_chrdev(VIOTAPE_MAJOR, "viotape");
-	if (ret < 0)
-		printk(VIOTAPE_KERN_WARN "Error unregistering device: %d\n",
-				ret);
+	unregister_chrdev(VIOTAPE_MAJOR, "viotape");
 	if (viotape_unitinfo)
 		dma_free_coherent(iSeries_vio_dev,
 				sizeof(viotape_unitinfo[0]) * VIOTAPE_MAX_TAPE,
diff -puN drivers/net/ppp_generic.c~unregister_chrdev-ignore-the-return-value drivers/net/ppp_generic.c
--- a/drivers/net/ppp_generic.c~unregister_chrdev-ignore-the-return-value
+++ a/drivers/net/ppp_generic.c
@@ -2684,8 +2684,7 @@ static void __exit ppp_cleanup(void)
 	if (atomic_read(&ppp_unit_count) || atomic_read(&channel_count))
 		printk(KERN_ERR "PPP: removing module but units remain!\n");
 	cardmap_destroy(&all_ppp_units);
-	if (unregister_chrdev(PPP_MAJOR, "ppp") != 0)
-		printk(KERN_ERR "PPP: failed to unregister PPP device\n");
+	unregister_chrdev(PPP_MAJOR, "ppp");
 	device_destroy(ppp_class, MKDEV(PPP_MAJOR, 0));
 	class_destroy(ppp_class);
 }
diff -puN sound/core/sound.c~unregister_chrdev-ignore-the-return-value sound/core/sound.c
--- a/sound/core/sound.c~unregister_chrdev-ignore-the-return-value
+++ a/sound/core/sound.c
@@ -446,8 +446,7 @@ static void __exit alsa_sound_exit(void)
 {
 	snd_info_minor_unregister();
 	snd_info_done();
-	if (unregister_chrdev(major, "alsa") != 0)
-		snd_printk(KERN_ERR "unable to unregister major device number %d\n", major);
+	unregister_chrdev(major, "alsa");
 }
 
 module_init(alsa_sound_init)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
