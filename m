From: akpm@linux-foundation.org
Subject: + arch-i386-mach-es7000-es7000platc-cleanups.patch added to -mm tree
Date: Mon, 30 Jul 2007 14:58:52 -0700
Message-ID: <200707302158.l6ULwqSH032552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47670 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968301AbXG3V7I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 17:59:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     arch/i386/mach-es7000/es7000plat.c: cleanups
has been added to the -mm tree.  Its filename is
     arch-i386-mach-es7000-es7000platc-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
