From: akpm@linux-foundation.org
Subject: + drivers-base-power-make-2-functions-static.patch added to -mm tree
Date: Mon, 30 Jul 2007 14:58:58 -0700
Message-ID: <200707302158.l6ULwwLs032563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56878 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968364AbXG3V7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 17:59:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     drivers/base/power/: make 2 functions static
has been added to the -mm tree.  Its filename is
     drivers-base-power-make-2-functions-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/base/power/: make 2 functions static
From: Adrian Bunk <bunk@stusta.de>

suspend_device() and resume_device() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/power.h   |    6 ------
 drivers/base/power/resume.c  |    2 +-
 drivers/base/power/suspend.c |    2 +-
 3 files changed, 2 insertions(+), 8 deletions(-)

diff -puN drivers/base/power/power.h~drivers-base-power-make-2-functions-static drivers/base/power/power.h
--- a/drivers/base/power/power.h~drivers-base-power-make-2-functions-static
+++ a/drivers/base/power/power.h
@@ -55,12 +55,6 @@ extern void dpm_sysfs_remove(struct devi
 
 extern void dpm_resume(void);
 extern void dpm_power_up(void);
-extern int resume_device(struct device *);
-
-/*
- * suspend.c
- */
-extern int suspend_device(struct device *, pm_message_t);
 
 #else /* CONFIG_PM_SLEEP */
 
diff -puN drivers/base/power/resume.c~drivers-base-power-make-2-functions-static drivers/base/power/resume.c
--- a/drivers/base/power/resume.c~drivers-base-power-make-2-functions-static
+++ a/drivers/base/power/resume.c
@@ -20,7 +20,7 @@
  *
  */
 
-int resume_device(struct device * dev)
+static int resume_device(struct device * dev)
 {
 	int error = 0;
 
diff -puN drivers/base/power/suspend.c~drivers-base-power-make-2-functions-static drivers/base/power/suspend.c
--- a/drivers/base/power/suspend.c~drivers-base-power-make-2-functions-static
+++ a/drivers/base/power/suspend.c
@@ -54,7 +54,7 @@ suspend_device_dbg(struct device *dev, p
  *	@state:	Power state device is entering.
  */
 
-int suspend_device(struct device * dev, pm_message_t state)
+static int suspend_device(struct device * dev, pm_message_t state)
 {
 	int error = 0;
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
drivers-base-power-make-2-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
drivers-i2c-i2c-corec-make-code-static.patch
