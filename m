From: akpm@linux-foundation.org
Subject: - arch-i386-mach-es7000-es7000platc-cleanups.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:33 -0700
Message-ID: <200708141914.l7EJEXu0016627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58307 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765585AbXHNTUi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     arch/i386/mach-es7000/es7000plat.c: cleanups
has been removed from the -mm tree.  Its filename was
     arch-i386-mach-es7000-es7000platc-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch/i386/mach-es7000/es7000plat.c: cleanups
From: Adrian Bunk <bunk@stusta.de>

This patch contains the following cleanups:
- make some needlessly global functions static
- #if 0 the unused es7000_stop_cpu()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/mach-es7000/es7000plat.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff -puN arch/i386/mach-es7000/es7000plat.c~arch-i386-mach-es7000-es7000platc-cleanups arch/i386/mach-es7000/es7000plat.c
--- a/arch/i386/mach-es7000/es7000plat.c~arch-i386-mach-es7000-es7000platc-cleanups
+++ a/arch/i386/mach-es7000/es7000plat.c
@@ -46,11 +46,11 @@
  * ES7000 Globals
  */
 
-volatile unsigned long	*psai = NULL;
-struct mip_reg		*mip_reg;
-struct mip_reg		*host_reg;
-int 			mip_port;
-unsigned long		mip_addr, host_addr;
+static volatile unsigned long	*psai = NULL;
+static struct mip_reg		*mip_reg;
+static struct mip_reg		*host_reg;
+static int 			mip_port;
+static unsigned long		mip_addr, host_addr;
 
 /*
  * GSI override for ES7000 platforms.
@@ -288,6 +288,7 @@ es7000_start_cpu(int cpu, unsigned long 
 
 }
 
+#if 0
 int
 es7000_stop_cpu(int cpu)
 {
@@ -307,6 +308,7 @@ es7000_stop_cpu(int cpu)
 	return 0;
 
 }
+#endif  /*  0  */
 
 void __init
 es7000_sw_apic()
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
kernel-auditscc-fix-an-off-by-one.patch
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
git-alsa.patch
allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default-kconfig-fix.patch
drivers-base-power-make-2-functions-static.patch
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
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
drivers-scsi-scsi_errorc-should-include.patch
drivers-scsi-constantsc-make-2-functions-static.patch
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
