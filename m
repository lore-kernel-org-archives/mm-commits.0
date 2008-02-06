From: akpm@linux-foundation.org
Subject: - fix-timerfd-breakage-on-avr32-was-re-fix-variable-use-in-avr32-pte_alloc_one.patch removed from -mm tree
Date: Tue, 05 Feb 2008 23:04:54 -0800
Message-ID: <200802060704.m1674ZVA030906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59190 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755392AbYBFHGo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 02:06:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     Fix timerfd breakage on avr32
has been removed from the -mm tree.  Its filename was
     fix-timerfd-breakage-on-avr32-was-re-fix-variable-use-in-avr32-pte_alloc_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix timerfd breakage on avr32
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Hmm. Someone removed the timerfd() syscall...


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/syscall_table.S |    2 +-
 include/asm-avr32/unistd.h        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/avr32/kernel/syscall_table.S~fix-timerfd-breakage-on-avr32-was-re-fix-variable-use-in-avr32-pte_alloc_one arch/avr32/kernel/syscall_table.S
--- a/arch/avr32/kernel/syscall_table.S~fix-timerfd-breakage-on-avr32-was-re-fix-variable-use-in-avr32-pte_alloc_one
+++ a/arch/avr32/kernel/syscall_table.S
@@ -293,6 +293,6 @@ sys_call_table:
 	.long	sys_shmctl
 	.long	sys_utimensat
 	.long	sys_signalfd
-	.long	sys_timerfd		/* 280 */
+	.long	sys_ni_syscall		/* 280, was sys_timerfd */
 	.long	sys_eventfd
 	.long	sys_ni_syscall		/* r8 is saturated at nr_syscalls */
diff -puN include/asm-avr32/unistd.h~fix-timerfd-breakage-on-avr32-was-re-fix-variable-use-in-avr32-pte_alloc_one include/asm-avr32/unistd.h
--- a/include/asm-avr32/unistd.h~fix-timerfd-breakage-on-avr32-was-re-fix-variable-use-in-avr32-pte_alloc_one
+++ a/include/asm-avr32/unistd.h
@@ -297,7 +297,7 @@
 
 #define __NR_utimensat		278
 #define __NR_signalfd		279
-#define __NR_timerfd		280
+/* 280 was __NR_timerfd */
 #define __NR_eventfd		281
 
 #ifdef __KERNEL__
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
git-avr32.patch
git-md-accel.patch
git-mtd.patch
read_current_time-cleanups.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-chain-dma-transfers-update.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
atmel_lcdfb-validate-display-timings.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg_local-to-avr32.patch
tty-let-architectures-override-the-user-kernel-macros.patch
maintainers-add-haavard-as-maintainer-of-the-atmel_serial-driver.patch
atmel_serial-clean-up-the-code.patch
atmel_serial-use-cpu_relax-when-busy-waiting.patch
atmel_serial-use-existing-console-options-only-if-brg-is-running.patch
atmel_serial-fix-bugs-in-probe-error-path-and-remove.patch
atmel_serial-split-the-interrupt-handler.patch
atmel_serial-add-dma-support.patch
atmel_serial-add-dma-support-fix.patch
atmel_serial-fix-broken-rx-buffer-allocation.patch
atmel_serial-use-container_of-instead-of-direct-cast.patch
atmel_serial-show-tty-name-in-proc-interrupts.patch
basic-pwm-driver-for-avr32-and-at91.patch
basic-pwm-driver-for-avr32-and-at91-fix.patch
pwm-led-driver.patch
