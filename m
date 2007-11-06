From: akpm@linux-foundation.org
Subject: + sisusb-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:24:47 -0800
Message-ID: <200711060224.lA62Olu7031686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59476 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755066AbXKFCYx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:24:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, adaplas@pol.net, thomas@winischhofer.net


The patch titled
     sisusb: *_ioctl32_conversion functions do not exist in recent kernels
has been added to the -mm tree.  Its filename is
     sisusb-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sisusb: *_ioctl32_conversion functions do not exist in recent kernels
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Remove dead code while at it.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/sis/sis.h      |    8 -----
 drivers/video/sis/sis_main.c |   48 ---------------------------------
 2 files changed, 56 deletions(-)

diff -puN drivers/video/sis/sis.h~sisusb-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels drivers/video/sis/sis.h
--- a/drivers/video/sis/sis.h~sisusb-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels
+++ a/drivers/video/sis/sis.h
@@ -39,12 +39,7 @@
 #include <linux/spinlock.h>
 
 #ifdef CONFIG_COMPAT
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,10)
-#include <linux/ioctl32.h>
-#define SIS_OLD_CONFIG_COMPAT
-#else
 #define SIS_NEW_CONFIG_COMPAT
-#endif
 #endif	/* CONFIG_COMPAT */
 
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,8)
@@ -607,9 +602,6 @@ struct sis_video_info {
 	int		haveXGIROM;
 	int		registered;
 	int		warncount;
-#ifdef SIS_OLD_CONFIG_COMPAT
-	int		ioctl32registered;
-#endif
 
 	int		sisvga_engine;
 	int		hwcursor_size;
diff -puN drivers/video/sis/sis_main.c~sisusb-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels drivers/video/sis/sis_main.c
--- a/drivers/video/sis/sis_main.c~sisusb-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels
+++ a/drivers/video/sis/sis_main.c
@@ -5805,9 +5805,6 @@ sisfb_probe(struct pci_dev *pdev, const 
 	ivideo->pcifunc = PCI_FUNC(pdev->devfn);
 	ivideo->subsysvendor = pdev->subsystem_vendor;
 	ivideo->subsysdevice = pdev->subsystem_device;
-#ifdef SIS_OLD_CONFIG_COMPAT
-	ivideo->ioctl32registered = 0;
-#endif
 
 #ifndef MODULE
 	if(sisfb_mode_idx == -1) {
@@ -6420,30 +6417,6 @@ error_3:	vfree(ivideo->bios_abase);
 		ivideo->next = card_list;
 		card_list = ivideo;
 
-#ifdef SIS_OLD_CONFIG_COMPAT
-		{
-		int ret;
-		/* Our ioctls are all "32/64bit compatible" */
-		ret =  register_ioctl32_conversion(FBIO_ALLOC,             NULL);
-		ret |= register_ioctl32_conversion(FBIO_FREE,              NULL);
-		ret |= register_ioctl32_conversion(FBIOGET_VBLANK,         NULL);
-		ret |= register_ioctl32_conversion(SISFB_GET_INFO_SIZE,    NULL);
-		ret |= register_ioctl32_conversion(SISFB_GET_INFO,         NULL);
-		ret |= register_ioctl32_conversion(SISFB_GET_TVPOSOFFSET,  NULL);
-		ret |= register_ioctl32_conversion(SISFB_SET_TVPOSOFFSET,  NULL);
-		ret |= register_ioctl32_conversion(SISFB_SET_LOCK,         NULL);
-		ret |= register_ioctl32_conversion(SISFB_GET_VBRSTATUS,    NULL);
-		ret |= register_ioctl32_conversion(SISFB_GET_AUTOMAXIMIZE, NULL);
-		ret |= register_ioctl32_conversion(SISFB_SET_AUTOMAXIMIZE, NULL);
-		ret |= register_ioctl32_conversion(SISFB_COMMAND,          NULL);
-		if(ret)
-			printk(KERN_ERR
-				"sisfb: Error registering ioctl32 translations\n");
-		else
-			ivideo->ioctl32registered = 1;
-		}
-#endif
-
 		printk(KERN_INFO "sisfb: 2D acceleration is %s, y-panning %s\n",
 			ivideo->sisfb_accel ? "enabled" : "disabled",
 			ivideo->sisfb_ypan  ?
@@ -6473,27 +6446,6 @@ static void __devexit sisfb_remove(struc
 	int			registered = ivideo->registered;
 	int			modechanged = ivideo->modechanged;
 
-#ifdef SIS_OLD_CONFIG_COMPAT
-	if(ivideo->ioctl32registered) {
-		int ret;
-		ret =  unregister_ioctl32_conversion(FBIO_ALLOC);
-		ret |= unregister_ioctl32_conversion(FBIO_FREE);
-		ret |= unregister_ioctl32_conversion(FBIOGET_VBLANK);
-		ret |= unregister_ioctl32_conversion(SISFB_GET_INFO_SIZE);
-		ret |= unregister_ioctl32_conversion(SISFB_GET_INFO);
-		ret |= unregister_ioctl32_conversion(SISFB_GET_TVPOSOFFSET);
-		ret |= unregister_ioctl32_conversion(SISFB_SET_TVPOSOFFSET);
-		ret |= unregister_ioctl32_conversion(SISFB_SET_LOCK);
-		ret |= unregister_ioctl32_conversion(SISFB_GET_VBRSTATUS);
-		ret |= unregister_ioctl32_conversion(SISFB_GET_AUTOMAXIMIZE);
-		ret |= unregister_ioctl32_conversion(SISFB_SET_AUTOMAXIMIZE);
-		ret |= unregister_ioctl32_conversion(SISFB_COMMAND);
-		if(ret)
-			printk(KERN_ERR
-			     "sisfb: Error unregistering ioctl32 translations\n");
-	}
-#endif
-
 	/* Unmap */
 	iounmap(ivideo->mmio_vbase);
 	iounmap(ivideo->video_vbase);
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

sis-fb-driver-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels.patch
sisusb-_ioctl32_conversion-functions-do-not-exist-in-recent-kernels.patch
