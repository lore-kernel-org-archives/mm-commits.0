From: akpm@linux-foundation.org
Subject: + backlight-make-2-structs-static.patch added to -mm tree
Date: Mon, 30 Jul 2007 15:07:04 -0700
Message-ID: <200707302207.l6UM74Ka000492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S939309AbXG3WHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 18:07:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     From: Adrian Bunk <bunk@stusta.de>
has been added to the -mm tree.  Its filename is
     backlight-make-2-structs-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: Adrian Bunk <bunk@stusta.de>


This patch makes two needlessly global structs static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |    2 +-
 drivers/video/backlight/lcd.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/backlight.c~backlight-make-2-structs-static drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-make-2-structs-static
+++ a/drivers/video/backlight/backlight.c
@@ -164,7 +164,7 @@ static ssize_t backlight_show_actual_bri
 	return rc;
 }
 
-struct class *backlight_class;
+static struct class *backlight_class;
 
 static void bl_device_release(struct device *dev)
 {
diff -puN drivers/video/backlight/lcd.c~backlight-make-2-structs-static drivers/video/backlight/lcd.c
--- a/drivers/video/backlight/lcd.c~backlight-make-2-structs-static
+++ a/drivers/video/backlight/lcd.c
@@ -149,7 +149,7 @@ static ssize_t lcd_show_max_contrast(str
 	return sprintf(buf, "%d\n", ld->props.max_contrast);
 }
 
-struct class *lcd_class;
+static struct class *lcd_class;
 
 static void lcd_device_release(struct device *dev)
 {
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
radeon_driver_vblank_do_wait-static.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
kernel-rtmutex-debugc-cleanups.patch
fs-nfsd-exportc-make-3-functions-static.patch
mm-page_allocc-make-code-static.patch
make-struct-sony_nc_ids-static.patch
make-pktgencget_ipsec_sa-static-and-non-inline.patch
make-nf_ct_ipv6_skip_exthdr-static.patch
net-unix-af_unixc-make-code-static.patch
drivers-usb-serial-sierrac-make-3-functions-static.patch
backlight-make-2-structs-static.patch
unexport-pm_power_off_prepare.patch
unexport-fb_prepare_logo.patch
