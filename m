From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 04 Oct 2016 12:43:54 -0700
Message-ID: <57f4067a.HAk3DD0BTQ11sMBy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36803 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbcJDTnz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2016 15:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                       |    3 ---
 arch/arm/include/asm/arch_gicv3.h |    4 ----
 arch/x86/mm/fault.c               |    4 ----
 drivers/clk/meson/gxbb.h          |    4 ----
 drivers/dma/imx-sdma.c            |    8 --------
 5 files changed, 23 deletions(-)

diff -puN MAINTAINERS~linux-next-git-rejects MAINTAINERS
--- a/MAINTAINERS~linux-next-git-rejects
+++ a/MAINTAINERS
@@ -7940,8 +7940,6 @@ S:	Maintained
 F:	drivers/tty/serial/atmel_serial.c
 F:	include/linux/atmel_serial.h
 
-<<<<<<< HEAD
-=======
 MICROCHIP / ATMEL ISC DRIVER
 M:	Songjun Wu <songjun.wu@microchip.com>
 L:	linux-media@vger.kernel.org
@@ -7950,7 +7948,6 @@ F:	drivers/media/platform/atmel/atmel-is
 F:	drivers/media/platform/atmel/atmel-isc-regs.h
 F:	devicetree/bindings/media/atmel-isc.txt
 
->>>>>>> linux-next/akpm-base
 MICROSOFT SURFACE PRO 3 BUTTON DRIVER
 M:	Chen Yu <yu.c.chen@intel.com>
 L:	platform-driver-x86@vger.kernel.org
diff -puN arch/arm/include/asm/arch_gicv3.h~linux-next-git-rejects arch/arm/include/asm/arch_gicv3.h
--- a/arch/arm/include/asm/arch_gicv3.h~linux-next-git-rejects
+++ a/arch/arm/include/asm/arch_gicv3.h
@@ -219,15 +219,11 @@ static inline void gic_write_sre(u32 val
 
 static inline void gic_write_bpr1(u32 val)
 {
-<<<<<<< HEAD
-	asm volatile("mcr " __stringify(ICC_BPR1) : : "r" (val));
-=======
 #if defined(__write_sysreg) && defined(ICC_BPR1)
 	write_sysreg(val, ICC_BPR1);
 #else
 	asm volatile("mcr " __stringify(ICC_BPR1) : : "r" (val));
 #endif
->>>>>>> linux-next/akpm-base
 }
 
 /*
diff -puN arch/x86/mm/fault.c~linux-next-git-rejects arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~linux-next-git-rejects
+++ a/arch/x86/mm/fault.c
@@ -5,11 +5,7 @@
  */
 #include <linux/sched.h>		/* test_thread_flag(), ...	*/
 #include <linux/kdebug.h>		/* oops_begin/end, ...		*/
-<<<<<<< HEAD
-#include <linux/extable.h>		/* search_exception_table	*/
-=======
 #include <linux/extable.h>		/* search_exception_tables	*/
->>>>>>> linux-next/akpm-base
 #include <linux/bootmem.h>		/* max_low_pfn			*/
 #include <linux/kprobes.h>		/* NOKPROBE_SYMBOL, ...		*/
 #include <linux/mmiotrace.h>		/* kmmio_handler, ...		*/
diff -puN drivers/clk/meson/gxbb.h~linux-next-git-rejects drivers/clk/meson/gxbb.h
--- a/drivers/clk/meson/gxbb.h~linux-next-git-rejects
+++ a/drivers/clk/meson/gxbb.h
@@ -261,11 +261,7 @@
 #define CLKID_AO_AHB_SRAM	  90
 #define CLKID_AO_AHB_BUS	  91
 #define CLKID_AO_IFACE		  92
-<<<<<<< HEAD
 #define CLKID_AO_I2C		  93
-=======
-/* CLKID_AO_I2C */
->>>>>>> linux-next/akpm-base
 /* CLKID_SD_EMMC_A */
 /* CLKID_SD_EMMC_B */
 /* CLKID_SD_EMMC_C */
diff -puN drivers/dma/imx-sdma.c~linux-next-git-rejects drivers/dma/imx-sdma.c
--- a/drivers/dma/imx-sdma.c~linux-next-git-rejects
+++ a/drivers/dma/imx-sdma.c
@@ -670,14 +670,6 @@ static void sdma_event_disable(struct sd
 	writel_relaxed(val, sdma->regs + chnenbl);
 }
 
-<<<<<<< HEAD
-=======
-static void sdma_handle_channel_loop(struct sdma_channel *sdmac)
-{
-	dmaengine_desc_get_callback_invoke(&sdmac->desc, NULL);
-}
-
->>>>>>> linux-next/akpm-base
 static void sdma_update_channel_loop(struct sdma_channel *sdmac)
 {
 	struct sdma_buffer_descriptor *bd;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix.patch
mm-page_ioc-replace-some-bug_ons-with-vm_bug_on_page.patch
mm-memcontrol-consolidate-cgroup-socket-tracking-checkpatch-fixes.patch
mmksm-add-__gfp_high-to-the-allocation-in-alloc_stable_node-v2-fix.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
lib-bitmapc-enhance-bitmap-syntax-fix.patch
relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

