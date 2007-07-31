From: akpm@linux-foundation.org
Subject: - anon_inodes-shouldnt-be-user-visible.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:58:14 -0700
Message-ID: <200707312358.l6VNwE5P029533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59831 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760191AbXHAAQs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:16:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, davidel@xmailserver.org, mm-commits@vger.kernel.org


The patch titled
     ANON_INODES shouldn't be user visible
has been removed from the -mm tree.  Its filename was
     anon_inodes-shouldnt-be-user-visible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ANON_INODES shouldn't be user visible
From: Adrian Bunk <bunk@stusta.de>

There doesn't seem to be a good reason for ANON_INODES being
an user visible option.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Davide Libenzi <davidel@xmailserver.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN init/Kconfig~anon_inodes-shouldnt-be-user-visible init/Kconfig
--- a/init/Kconfig~anon_inodes-shouldnt-be-user-visible
+++ a/init/Kconfig
@@ -468,25 +468,19 @@ config FUTEX
 	  run glibc-based applications correctly.
 
 config ANON_INODES
-	bool "Enable anonymous inode source" if EMBEDDED
-	default y
-	help
-	  Anonymous inode source for pseudo-files like epoll, signalfd,
-	  timerfd and eventfd.
-
-	  If unsure, say Y.
+	bool
 
 config EPOLL
 	bool "Enable eventpoll support" if EMBEDDED
 	default y
-	depends on ANON_INODES
+	select ANON_INODES
 	help
 	  Disabling this option will cause the kernel to be built without
 	  support for epoll family of system calls.
 
 config SIGNALFD
 	bool "Enable signalfd() system call" if EMBEDDED
-	depends on ANON_INODES
+	select ANON_INODES
 	default y
 	help
 	  Enable the signalfd() system call that allows to receive signals
@@ -496,7 +490,7 @@ config SIGNALFD
 
 config TIMERFD
 	bool "Enable timerfd() system call" if EMBEDDED
-	depends on ANON_INODES
+	select ANON_INODES
 	default y
 	help
 	  Enable the timerfd() system call that allows to receive timer
@@ -506,7 +500,7 @@ config TIMERFD
 
 config EVENTFD
 	bool "Enable eventfd() system call" if EMBEDDED
-	depends on ANON_INODES
+	select ANON_INODES
 	default y
 	help
 	  Enable the eventfd() system call that allows to receive both
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
remove-the-arm26-port-fix.patch
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
git-mmc.patch
git-mtd.patch
mtd-onenand_simc-make-struct-info-static.patch
remove-fs-jffs2-ioctlc.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
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
