From: akpm@linux-foundation.org
Subject: - i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:14:37 -0700
Message-ID: <200708141914.l7EJEboM016633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42588 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932154AbXHNTUq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: no need to make enable_cpu_hotplug a variable
has been removed from the -mm tree.  Its filename was
     i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: no need to make enable_cpu_hotplug a variable
From: Adrian Bunk <bunk@stusta.de>

As long as there's no write access to this variable there's no reason to let
gcc check it at runtime.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/topology.c |    2 --
 include/asm-i386/cpu.h      |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/i386/kernel/topology.c~i386-no-need-to-make-enable_cpu_hotplug-a-variable arch/i386/kernel/topology.c
--- a/arch/i386/kernel/topology.c~i386-no-need-to-make-enable_cpu_hotplug-a-variable
+++ a/arch/i386/kernel/topology.c
@@ -51,8 +51,6 @@ int arch_register_cpu(int num)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-int enable_cpu_hotplug = 1;
-
 void arch_unregister_cpu(int num) {
 	return unregister_cpu(&cpu_devices[num].cpu);
 }
diff -puN include/asm-i386/cpu.h~i386-no-need-to-make-enable_cpu_hotplug-a-variable include/asm-i386/cpu.h
--- a/include/asm-i386/cpu.h~i386-no-need-to-make-enable_cpu_hotplug-a-variable
+++ a/include/asm-i386/cpu.h
@@ -13,7 +13,7 @@ struct i386_cpu {
 extern int arch_register_cpu(int num);
 #ifdef CONFIG_HOTPLUG_CPU
 extern void arch_unregister_cpu(int);
-extern int enable_cpu_hotplug;
+#define enable_cpu_hotplug	1
 #else
 #define enable_cpu_hotplug	0
 #endif
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
