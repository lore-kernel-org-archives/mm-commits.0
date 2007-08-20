From: akpm@linux-foundation.org
Subject: - drivers-base-power-make-2-functions-static.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:12:06 -0700
Message-ID: <200708201912.l7KJC6L1018322@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55266 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760698AbXHTTVb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     drivers/base/power/: make 2 functions static
has been removed from the -mm tree.  Its filename was
     drivers-base-power-make-2-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
kernel-auditscc-fix-an-off-by-one.patch
w1-fix-w1_remove_master_device-searching.patch
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
git-alsa.patch
allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
git-dma.patch
git-drm.patch
git-dvb.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
git-mmc.patch
git-mtd.patch
remove-fs-jffs2-ioctlc.patch
git-netdev-all.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
git-backlight.patch
parisc-extern-inline-static-inline.patch
git-scsi-misc.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
git-cryptodev.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
unicode-diacritics-support-s390-fix.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
