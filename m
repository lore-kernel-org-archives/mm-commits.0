From: akpm@linux-foundation.org
Subject: - drivers-video-macmodescmac_find_mode-mustnt-be.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:08:15 -0700
Message-ID: <200707172308.l6HN8FsP012268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50695 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936595AbXGQXQA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, adaplas@pol.net, michal.k.k.piotrowski@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/macmodes.c:mac_find_mode() mustn't be __devinit
has been removed from the -mm tree.  Its filename was
     drivers-video-macmodescmac_find_mode-mustnt-be.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/video/macmodes.c:mac_find_mode() mustn't be __devinit
From: Adrian Bunk <bunk@stusta.de>

If it's EXPORT_SYMBOL'ed it can't be __devinit.

Reported by Mikael Pettersson.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/macmodes.c |    5 ++---
 drivers/video/macmodes.h |    8 ++++----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/video/macmodes.c~drivers-video-macmodescmac_find_mode-mustnt-be drivers/video/macmodes.c
--- a/drivers/video/macmodes.c~drivers-video-macmodescmac_find_mode-mustnt-be
+++ a/drivers/video/macmodes.c
@@ -369,9 +369,8 @@ EXPORT_SYMBOL(mac_map_monitor_sense);
  *
  */
 
-int __devinit mac_find_mode(struct fb_var_screeninfo *var,
-			    struct fb_info *info, const char *mode_option,
-			    unsigned int default_bpp)
+int mac_find_mode(struct fb_var_screeninfo *var, struct fb_info *info,
+		  const char *mode_option, unsigned int default_bpp)
 {
     const struct fb_videomode *db = NULL;
     unsigned int dbsize = 0;
diff -puN drivers/video/macmodes.h~drivers-video-macmodescmac_find_mode-mustnt-be drivers/video/macmodes.h
--- a/drivers/video/macmodes.h~drivers-video-macmodescmac_find_mode-mustnt-be
+++ a/drivers/video/macmodes.h
@@ -55,10 +55,10 @@ extern int mac_vmode_to_var(int vmode, i
 extern int mac_var_to_vmode(const struct fb_var_screeninfo *var, int *vmode,
 			    int *cmode);
 extern int mac_map_monitor_sense(int sense);
-extern int __devinit mac_find_mode(struct fb_var_screeninfo *var,
-				   struct fb_info *info,
-				   const char *mode_option,
-				   unsigned int default_bpp);
+extern int mac_find_mode(struct fb_var_screeninfo *var,
+			 struct fb_info *info,
+			 const char *mode_option,
+			 unsigned int default_bpp);
 
 
     /*
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
