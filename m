From: akpm@linux-foundation.org
Subject: + pm3fb-possible-cleanups.patch added to -mm tree
Date: Tue, 05 Jun 2007 10:56:30 -0700
Message-ID: <200706051756.l55HuUUt032039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755228AbXFER4q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 13:56:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, adaplas@gmail.com


The patch titled
     pm3fb: possible cleanups
has been added to the -mm tree.  Its filename is
     pm3fb-possible-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pm3fb: possible cleanups
From: Adrian Bunk <bunk@stusta.de>

- remove the empty pm3fb_setup() and corresponding code

- pm3fb_init() can become static

[adaplas]
- retain call to fb_get_options() for global options

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/pm3fb.c |   29 ++---------------------------
 1 files changed, 2 insertions(+), 27 deletions(-)

diff -puN drivers/video/pm3fb.c~pm3fb-possible-cleanups drivers/video/pm3fb.c
--- a/drivers/video/pm3fb.c~pm3fb-possible-cleanups
+++ a/drivers/video/pm3fb.c
@@ -612,8 +612,6 @@ static void pm3fb_write_mode(struct fb_i
 /*
  * hardware independent functions
  */
-int pm3fb_init(void);
-
 static int pm3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	u32 lpitch;
@@ -1170,35 +1168,12 @@ static struct pci_driver pm3fb_driver = 
 
 MODULE_DEVICE_TABLE(pci, pm3fb_id_table);
 
-#ifndef MODULE
-	/*
-	 *  Setup
-	 */
-
-/*
- * Only necessary if your driver takes special options,
- * otherwise we fall back on the generic fb_setup().
- */
-static int __init pm3fb_setup(char *options)
+static int __init pm3fb_init(void)
 {
-	/* Parse user speficied options (`video=pm3fb:') */
-	return 0;
-}
-#endif /* MODULE */
-
-int __init pm3fb_init(void)
-{
-	/*
-	 *  For kernel boot options (in 'video=pm3fb:<options>' format)
-	 */
 #ifndef MODULE
-	char *option = NULL;
-
-	if (fb_get_options("pm3fb", &option))
+	if (fb_get_options("pm3fb", NULL))
 		return -ENODEV;
-	pm3fb_setup(option);
 #endif
-
 	return pci_register_driver(&pm3fb_driver);
 }
 
_

Patches currently in -mm which might be from bunk@stusta.de are

git-acpi.patch
make-drivers-char-hvc_consoleckhvcd-static.patch
fix-2-gregkh-driver-dmi-based-module-autoloading.patch
git-dvb-fix-the-tea5761-tuner-support.patch
git-input-make-xpad_play_effect-static.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
drivers-mtd-maps-nettelc-possible-cleanups.patch
git-battery.patch
unexport-pci_proc_attach_device.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
scsi-lpfc-lpfc_initc-remove-unused-variable.patch
git-unionfs.patch
git-wireless.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
maps2-add-proc-kpagemap-interface.patch
lumpy-reclaim-v4.patch
more-scheduled-oss-driver-removal.patch
remove-sonypi_camera_command.patch
ext2-reservations.patch
revoke-core-code.patch
oss-trident-fix-locking-around-write_voice_regs.patch
pm3fb-possible-cleanups.patch
vt8623fbc-make-code-static.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
