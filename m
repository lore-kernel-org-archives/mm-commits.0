From: akpm@linux-foundation.org
Subject: - powerpc-clean-out-a-bunch-of-duplicate-includes.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:11:57 -0700
Message-ID: <200708201911.l7KJBvq8018302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50000 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759415AbXHTTVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: clean out a bunch of duplicate includes
has been removed from the -mm tree.  Its filename was
     powerpc-clean-out-a-bunch-of-duplicate-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: clean out a bunch of duplicate includes
From: Jesper Juhl <jesper.juhl@gmail.com>

Clean out a bunch of duplicate includes from arch/powerpc/

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/btext.c                |    1 -
 arch/powerpc/kernel/crash.c                |    1 -
 arch/powerpc/kernel/iommu.c                |    1 -
 arch/powerpc/kernel/prom.c                 |    1 -
 arch/powerpc/kernel/time.c                 |    1 -
 arch/powerpc/mm/hash_utils_64.c            |    1 -
 arch/powerpc/mm/hugetlbpage.c              |    3 ---
 arch/powerpc/mm/init_32.c                  |    1 -
 arch/powerpc/mm/mem.c                      |    1 -
 arch/powerpc/platforms/52xx/mpc52xx_pic.c  |    1 -
 arch/powerpc/platforms/chrp/setup.c        |    1 -
 arch/powerpc/platforms/chrp/smp.c          |    1 -
 arch/powerpc/platforms/iseries/setup.c     |    1 -
 arch/powerpc/platforms/powermac/low_i2c.c  |    1 -
 arch/powerpc/platforms/powermac/udbg_adb.c |    1 -
 arch/powerpc/platforms/pseries/lpar.c      |    1 -
 16 files changed, 18 deletions(-)

diff -puN arch/powerpc/kernel/btext.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/kernel/btext.c
--- a/arch/powerpc/kernel/btext.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/kernel/btext.c
@@ -11,7 +11,6 @@
 #include <asm/sections.h>
 #include <asm/prom.h>
 #include <asm/btext.h>
-#include <asm/prom.h>
 #include <asm/page.h>
 #include <asm/mmu.h>
 #include <asm/pgtable.h>
diff -puN arch/powerpc/kernel/crash.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/kernel/crash.c
--- a/arch/powerpc/kernel/crash.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/kernel/crash.c
@@ -24,7 +24,6 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/types.h>
-#include <linux/irq.h>
 
 #include <asm/processor.h>
 #include <asm/machdep.h>
diff -puN arch/powerpc/kernel/iommu.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/kernel/iommu.c
--- a/arch/powerpc/kernel/iommu.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/kernel/iommu.c
@@ -30,7 +30,6 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/dma-mapping.h>
-#include <linux/init.h>
 #include <linux/bitops.h>
 #include <asm/io.h>
 #include <asm/prom.h>
diff -puN arch/powerpc/kernel/prom.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/kernel/prom.c
--- a/arch/powerpc/kernel/prom.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/kernel/prom.c
@@ -52,7 +52,6 @@
 #include <asm/pSeries_reconfig.h>
 #include <asm/pci-bridge.h>
 #include <asm/kexec.h>
-#include <asm/system.h>
 
 #ifdef DEBUG
 #define DBG(fmt...) printk(KERN_ERR fmt)
diff -puN arch/powerpc/kernel/time.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/kernel/time.c
--- a/arch/powerpc/kernel/time.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/kernel/time.c
@@ -72,7 +72,6 @@
 #include <asm/iseries/it_lp_queue.h>
 #include <asm/iseries/hv_call_xm.h>
 #endif
-#include <asm/smp.h>
 
 /* keep track of when we need to update the rtc */
 time_t last_rtc_update;
diff -puN arch/powerpc/mm/hash_utils_64.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/mm/hash_utils_64.c
--- a/arch/powerpc/mm/hash_utils_64.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/mm/hash_utils_64.c
@@ -49,7 +49,6 @@
 #include <asm/tlb.h>
 #include <asm/cacheflush.h>
 #include <asm/cputable.h>
-#include <asm/abs_addr.h>
 #include <asm/sections.h>
 #include <asm/spu.h>
 
diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -22,11 +22,8 @@
 #include <asm/mmu_context.h>
 #include <asm/machdep.h>
 #include <asm/cputable.h>
-#include <asm/tlb.h>
 #include <asm/spu.h>
 
-#include <linux/sysctl.h>
-
 #define NUM_LOW_AREAS	(0x100000000UL >> SID_SHIFT)
 #define NUM_HIGH_AREAS	(PGTABLE_RANGE >> HTLB_AREA_SHIFT)
 
diff -puN arch/powerpc/mm/init_32.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/mm/init_32.c
--- a/arch/powerpc/mm/init_32.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/mm/init_32.c
@@ -41,7 +41,6 @@
 #include <asm/machdep.h>
 #include <asm/btext.h>
 #include <asm/tlb.h>
-#include <asm/prom.h>
 #include <asm/lmb.h>
 #include <asm/sections.h>
 
diff -puN arch/powerpc/mm/mem.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/mm/mem.c
@@ -42,7 +42,6 @@
 #include <asm/machdep.h>
 #include <asm/btext.h>
 #include <asm/tlb.h>
-#include <asm/prom.h>
 #include <asm/lmb.h>
 #include <asm/sections.h>
 #include <asm/vdso.h>
diff -puN arch/powerpc/platforms/52xx/mpc52xx_pic.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/platforms/52xx/mpc52xx_pic.c
--- a/arch/powerpc/platforms/52xx/mpc52xx_pic.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/platforms/52xx/mpc52xx_pic.c
@@ -22,7 +22,6 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
-#include <linux/stddef.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/hardirq.h>
diff -puN arch/powerpc/platforms/chrp/setup.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/platforms/chrp/setup.c
--- a/arch/powerpc/platforms/chrp/setup.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/platforms/chrp/setup.c
@@ -32,7 +32,6 @@
 #include <linux/seq_file.h>
 #include <linux/root_dev.h>
 #include <linux/initrd.h>
-#include <linux/module.h>
 #include <linux/timer.h>
 
 #include <asm/io.h>
diff -puN arch/powerpc/platforms/chrp/smp.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/platforms/chrp/smp.c
--- a/arch/powerpc/platforms/chrp/smp.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/platforms/chrp/smp.c
@@ -29,7 +29,6 @@
 #include <asm/residual.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
-#include <asm/smp.h>
 #include <asm/mpic.h>
 #include <asm/rtas.h>
 
diff -puN arch/powerpc/platforms/iseries/setup.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/platforms/iseries/setup.c
--- a/arch/powerpc/platforms/iseries/setup.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/platforms/iseries/setup.c
@@ -41,7 +41,6 @@
 #include <asm/time.h>
 #include <asm/paca.h>
 #include <asm/cache.h>
-#include <asm/sections.h>
 #include <asm/abs_addr.h>
 #include <asm/iseries/hv_lp_config.h>
 #include <asm/iseries/hv_call_event.h>
diff -puN arch/powerpc/platforms/powermac/low_i2c.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/platforms/powermac/low_i2c.c
--- a/arch/powerpc/platforms/powermac/low_i2c.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/platforms/powermac/low_i2c.c
@@ -40,7 +40,6 @@
 #include <linux/completion.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
-#include <linux/completion.h>
 #include <linux/timer.h>
 #include <linux/mutex.h>
 #include <asm/keylargo.h>
diff -puN arch/powerpc/platforms/powermac/udbg_adb.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/platforms/powermac/udbg_adb.c
--- a/arch/powerpc/platforms/powermac/udbg_adb.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/platforms/powermac/udbg_adb.c
@@ -12,7 +12,6 @@
 #include <asm/xmon.h>
 #include <asm/prom.h>
 #include <asm/bootx.h>
-#include <asm/machdep.h>
 #include <asm/errno.h>
 #include <asm/pmac_feature.h>
 #include <asm/processor.h>
diff -puN arch/powerpc/platforms/pseries/lpar.c~powerpc-clean-out-a-bunch-of-duplicate-includes arch/powerpc/platforms/pseries/lpar.c
--- a/arch/powerpc/platforms/pseries/lpar.c~powerpc-clean-out-a-bunch-of-duplicate-includes
+++ a/arch/powerpc/platforms/pseries/lpar.c
@@ -35,7 +35,6 @@
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include <asm/prom.h>
-#include <asm/abs_addr.h>
 #include <asm/cputable.h>
 #include <asm/udbg.h>
 #include <asm/smp.h>
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
git-alsa.patch
git-agpgart.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-powerpc.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
git-gfs2-nmw.patch
clean-up-duplicate-includes-in-drivers-input.patch
scripts-ver_linux-correct-printing-of-binutils-version.patch
improve-scripts-gcc-versionsh-output-a-bit-when-called-without-args.patch
git-mtd.patch
git-ubi.patch
git-netdev-all.patch
eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch
avoid-possible-null-pointer-deref-in-3c359-driver.patch
git-backlight.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-scsi-misc.patch
mpt-fusion-fix-two-potential-mem-leaks.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
git-watchdog.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
clean-up-duplicate-includes-in-drivers-spi.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
