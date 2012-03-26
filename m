From: akpm@linux-foundation.org
Subject: [merged] nmi-watchdog-do-not-use-cpp-symbol-in-kconfig.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:13 -0700
Message-ID: <20120326192813.77F99A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:55374 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2CZT2Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:16 -0400
Received: by bkcjm19 with SMTP id jm19so288130bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, davem@davemloft.net, dhowells@redhat.com, dzickus@redhat.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nmi watchdog: do not use cpp symbol in Kconfig
has been removed from the -mm tree.  Its filename was
     nmi-watchdog-do-not-use-cpp-symbol-in-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: nmi watchdog: do not use cpp symbol in Kconfig

ARCH_HAS_NMI_WATCHDOG is a macro defined by arch, but config
HARDLOCKUP_DETECTOR depends on it.  This is wrong, ARCH_HAS_NMI_WATCHDOG
has to be a Kconfig config, and arch's need it should select it
explicitly.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: David Howells <dhowells@redhat.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                          |    3 +++
 arch/blackfin/Kconfig                 |    1 +
 arch/blackfin/include/asm/irq.h       |    4 ----
 arch/mn10300/Kconfig                  |    1 +
 arch/mn10300/include/asm/reset-regs.h |    4 ----
 arch/sparc/Kconfig                    |    1 +
 arch/sparc/include/asm/irq_64.h       |    1 -
 include/linux/nmi.h                   |    2 +-
 lib/Kconfig.debug                     |    2 +-
 9 files changed, 8 insertions(+), 11 deletions(-)

diff -puN arch/Kconfig~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig arch/Kconfig
--- a/arch/Kconfig~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig
+++ a/arch/Kconfig
@@ -120,6 +120,9 @@ config HAVE_KRETPROBES
 
 config HAVE_OPTPROBES
 	bool
+
+config HAVE_NMI_WATCHDOG
+	bool
 #
 # An arch should select this if it provides all these things:
 #
diff -puN arch/blackfin/Kconfig~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig
+++ a/arch/blackfin/Kconfig
@@ -36,6 +36,7 @@ config BLACKFIN
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_PROBE
 	select IRQ_PER_CPU if SMP
+	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
 
 config GENERIC_CSUM
 	def_bool y
diff -puN arch/blackfin/include/asm/irq.h~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig arch/blackfin/include/asm/irq.h
--- a/arch/blackfin/include/asm/irq.h~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig
+++ a/arch/blackfin/include/asm/irq.h
@@ -38,8 +38,4 @@
 
 #include <asm-generic/irq.h>
 
-#ifdef CONFIG_NMI_WATCHDOG
-# define ARCH_HAS_NMI_WATCHDOG
-#endif
-
 #endif				/* _BFIN_IRQ_H_ */
diff -puN arch/mn10300/Kconfig~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig
+++ a/arch/mn10300/Kconfig
@@ -5,6 +5,7 @@ config MN10300
 	select GENERIC_IRQ_SHOW
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_KGDB
+	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
 
 config AM33_2
 	def_bool n
diff -puN arch/mn10300/include/asm/reset-regs.h~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig arch/mn10300/include/asm/reset-regs.h
--- a/arch/mn10300/include/asm/reset-regs.h~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig
+++ a/arch/mn10300/include/asm/reset-regs.h
@@ -17,10 +17,6 @@
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_MN10300_WD_TIMER
-#define ARCH_HAS_NMI_WATCHDOG		/* See include/linux/nmi.h */
-#endif
-
 /*
  * watchdog timer registers
  */
diff -puN arch/sparc/Kconfig~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig
+++ a/arch/sparc/Kconfig
@@ -29,6 +29,7 @@ config SPARC
 	select GENERIC_IRQ_SHOW
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select GENERIC_PCI_IOMAP
+	select HAVE_NMI_WATCHDOG if SPARC64
 
 config SPARC32
 	def_bool !64BIT
diff -puN arch/sparc/include/asm/irq_64.h~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig arch/sparc/include/asm/irq_64.h
--- a/arch/sparc/include/asm/irq_64.h~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig
+++ a/arch/sparc/include/asm/irq_64.h
@@ -95,7 +95,6 @@ void arch_trigger_all_cpu_backtrace(void
 extern void *hardirq_stack[NR_CPUS];
 extern void *softirq_stack[NR_CPUS];
 #define __ARCH_HAS_DO_SOFTIRQ
-#define ARCH_HAS_NMI_WATCHDOG
 
 #define NO_IRQ		0xffffffff
 
diff -puN include/linux/nmi.h~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig include/linux/nmi.h
--- a/include/linux/nmi.h~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig
+++ a/include/linux/nmi.h
@@ -14,7 +14,7 @@
  * may be used to reset the timeout - for code which intentionally
  * disables interrupts for a long time. This call is stateless.
  */
-#if defined(ARCH_HAS_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
+#if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
 #include <asm/nmi.h>
 extern void touch_nmi_watchdog(void);
 #else
diff -puN lib/Kconfig.debug~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig lib/Kconfig.debug
--- a/lib/Kconfig.debug~nmi-watchdog-do-not-use-cpp-symbol-in-kconfig
+++ a/lib/Kconfig.debug
@@ -184,7 +184,7 @@ config LOCKUP_DETECTOR
 
 config HARDLOCKUP_DETECTOR
 	def_bool LOCKUP_DETECTOR && PERF_EVENTS && HAVE_PERF_EVENTS_NMI && \
-		 !ARCH_HAS_NMI_WATCHDOG
+		 !HAVE_NMI_WATCHDOG
 
 config BOOTPARAM_HARDLOCKUP_PANIC
 	bool "Panic (Reboot) On Hard Lockups"
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
linux-next.patch
cris-select-generic_atomic64.patch
proc-clean-up-proc-pid-environ-handling.patch
kdump-x86-fix-total-mem-size-calculation-for-reservation.patch

