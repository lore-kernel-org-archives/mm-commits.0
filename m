From: akpm@linux-foundation.org
Subject: + fix-timerfd-breakage-on-avr32-was-re-fix-variable-use-in-avr32-pte_alloc_one.patch added to -mm tree
Date: Sat, 26 Jan 2008 21:07:14 -0800
Message-ID: <200801270507.m0R57BaO030721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34070 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbYA0FHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jan 2008 00:07:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com


The patch titled
     Fix timerfd breakage on avr32
has been added to the -mm tree.  Its filename is
     fix-timerfd-breakage-on-avr32-was-re-fix-variable-use-in-avr32-pte_alloc_one.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-avr32.patch
fix-timerfd-breakage-on-avr32-was-re-fix-variable-use-in-avr32-pte_alloc_one.patch
git-mtd.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
gpiolib-avr32-at32ap-platform-support.patch
config_highpte-vs-sub-page-page-tables-avr32-fix.patch
read_current_time-cleanups.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
atmel_spi-throughput-improvement.patch
atmel_spi-chain-dma-transfers.patch
atmel_spi-chain-dma-transfers-update.patch
atmel_spi-fix-dmachain-oops-with-debug-enabled.patch
add-have_oprofile.patch
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
atmel_serial-use-container_of-instead-of-direct-cast.patch
atmel_serial-show-tty-name-in-proc-interrupts.patch
