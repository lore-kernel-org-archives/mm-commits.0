From: akpm@linux-foundation.org
Subject: - pm3fb-possible-cleanups.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:55 -0700
Message-ID: <200707172307.l6HN7tuG012231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32898 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936055AbXGQXP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pm3fb: possible cleanups
has been removed from the -mm tree.  Its filename was
     pm3fb-possible-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 insertions(+), 27 deletions(-)

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

origin.patch
git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
git-dvb.patch
git-hwmon.patch
git-kbuild.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mtd.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-wd33c93c-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
fix-x86_64-mm-xen-xen-event-channels.patch
arch-i386-xen-mmuc-must-include-linux-schedh.patch
make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
arch-i386-kernel-i8253c-should-include-asm-timerh.patch
make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
i386-remove-support-for-the-rise-cpu.patch
i386-make-arch-i386-mm-pgtablecpgd_cdtor-static.patch
xen-fix-x86-config-dependencies.patch
xen-suppress-abs-symbol-warnings-for-unused-reloc-pointers.patch
xen-cant-support-numa-yet.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
maps2-add-proc-kpagemap-interface.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
fs-reiserfs-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
mm-variable-length-argument-support.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
kernel-relayc-make-functions-static.patch
drivers-edac-core-make-functions-static.patch
lockstat-human-readability-tweaks.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
