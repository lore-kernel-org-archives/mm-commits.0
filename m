From: akpm@linux-foundation.org
Subject: - export-v4l2_int_device_unregister.patch removed from -mm tree
Date: Mon, 30 Jul 2007 23:33:21 -0700
Message-ID: <200707310633.l6V6XLiT019696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50150 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbXGaGdk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 02:33:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     export v4l2_int_device_{,un}register
has been removed from the -mm tree.  Its filename was
     export-v4l2_int_device_unregister.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: export v4l2_int_device_{,un}register
From: Adrian Bunk <bunk@stusta.de>

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
>  git-dvb.patch
>...
>  git trees
>...

This patch fixes the following build error:

<--  snip  -->

...
  MODPOST 2135 modules
ERROR: "v4l2_int_device_register" [drivers/media/video/tcm825x.ko] undefined!
ERROR: "v4l2_int_device_unregister" [drivers/media/video/tcm825x.ko] undefined!
make[2]: *** [__modpost] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/v4l2-int-device.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/media/video/v4l2-int-device.c~export-v4l2_int_device_unregister drivers/media/video/v4l2-int-device.c
--- a/drivers/media/video/v4l2-int-device.c~export-v4l2_int_device_unregister
+++ a/drivers/media/video/v4l2-int-device.c
@@ -101,6 +101,7 @@ int v4l2_int_device_register(struct v4l2
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(v4l2_int_device_register);
 
 void v4l2_int_device_unregister(struct v4l2_int_device *d)
 {
@@ -114,6 +115,7 @@ void v4l2_int_device_unregister(struct v
 	}
 	mutex_unlock(&mutex);
 }
+EXPORT_SYMBOL_GPL(v4l2_int_device_unregister);
 
 /* Adapted from search_extable in extable.c. */
 static v4l2_int_ioctl_func *find_ioctl(struct v4l2_int_slave *slave, int cmd,
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
remove-the-arm26-port.patch
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
make-struct-sony_nc_ids-static.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
mtd-onenand_simc-make-struct-info-static.patch
remove-fs-jffs2-ioctlc.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
git-net.patch
fore200e_param_bs_queue-must-be-__devinit.patch
backlight-make-2-structs-static.patch
git-ocfs2.patch
parisc-extern-inline-static-inline.patch
cpqphp_ctrlc-remove-dead-code.patch
kernel-schedc-make-code-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
make-scsi_host_link_pm_policy-static.patch
drivers-scsi-scsi_errorc-should-include.patch
drivers-scsi-constantsc-make-2-functions-static.patch
git-unionfs.patch
fix-gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-hosts.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
arch-i386-mm-discontigc-make-some-variables-static.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
acpi_ec_remove-fix-use-after-free.patch
acpi_battery_add-use-after-free.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-migratec-cleanups.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
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
