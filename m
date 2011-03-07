From: akpm@linux-foundation.org
Subject: [merged] pps-make-pps_gen_parport-depend-on-broken.patch removed from -mm tree
Date: Mon, 07 Mar 2011 13:31:04 -0800
Message-ID: <201103072131.p27LVlo2028063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756012Ab1CGVck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 16:32:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, giometti@linux.it, johnstul@us.ibm.com, lasaine@lvk.cs.msu.su, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     pps: make pps_gen_parport depend on BROKEN
has been removed from the -mm tree.  Its filename was
     pps-make-pps_gen_parport-depend-on-broken.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: make pps_gen_parport depend on BROKEN
From: Thomas Gleixner <tglx@linutronix.de>

This driver causes hard lockups, when the active clock soure is jiffies. 
The reason is that it loops with interrupts disabled waiting for a
timestamp to be reached by polling getnstimeofday().  Though with a
jiffies clocksource, when that code runs on the same CPU which is
responsible for updating jiffies, then we loop in circles for ever simply
because the timer interrupt cannot update jiffies.  So both UP and SMP can
be affected.

There is no easy fix for that problem so make it depend on BROKEN for now.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Rodolfo Giometti <giometti@linux.it>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/generators/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pps/generators/Kconfig~pps-make-pps_gen_parport-depend-on-broken drivers/pps/generators/Kconfig
--- a/drivers/pps/generators/Kconfig~pps-make-pps_gen_parport-depend-on-broken
+++ a/drivers/pps/generators/Kconfig
@@ -6,7 +6,7 @@ comment "PPS generators support"
 
 config PPS_GENERATOR_PARPORT
 	tristate "Parallel port PPS signal generator"
-	depends on PARPORT
+	depends on PARPORT && BROKEN
 	help
 	  If you say yes here you get support for a PPS signal generator which
 	  utilizes STROBE pin of a parallel port to send PPS signals. It uses
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
linux-next.patch
x86-fix-pgd_lock-deadlock.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
x86-fix-mmap-random-address-range.patch
drivers-dma-ipu-ipu_irqc-irq_data-conversion.patch
hpet-factor-timer-allocate-from-open.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
move-x86-specific-oops=panic-to-generic-code.patch
maintainers-remove-unused-clockeventsh.patch
maintainers-remove-unused-timekeeping-timekeepingh.patch
maintainers-update-scx200-file-pattern.patch
maintainers-update-sfi-pattern.patch
rtc-include-information-about-uie-and-pie-in-rtc-driver-proc.patch
pnp-only-assign-ioresource_dma-if-config_isa_dma_api-is-enabled.patch
x86-only-compile-8237a-if-config_isa_dma_api-is-enabled.patch
x86-only-compile-floppy-driver-if-config_isa_dma_api-is-enabled.patch
x86-allow-config_isa_dma_api-to-be-disabled.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch
asm-generic-change-little-endian-bitops-to-take-any-pointer-types.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

