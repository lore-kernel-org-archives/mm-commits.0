From: akpm@linux-foundation.org
Subject: - consolidate-config_debug_strict_user_copy_checks.patch removed from -mm tree
Date: Mon, 09 Jan 2012 13:59:14 -0800
Message-ID: <20120109224126.331ED1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:46444 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933412Ab2AIWl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2012 17:41:27 -0500
Received: by yhpp56 with SMTP id p56so203353yhp.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Jan 2012 14:41:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, arjan@linux.intel.com, arnd@arndb.de, cmetcalf@tilera.com, deller@gmx.de, heiko.carstens@de.ibm.com, hpa@zytor.com, mingo@elte.hu, sedat.dilek@gmail.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
has been removed from the -mm tree.  Its filename was
     consolidate-config_debug_strict_user_copy_checks.patch

This patch was dropped because I got tired of all the warnings

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS

The help text for this config is duplicated across the x86, parisc, and
s390 Kconfig.debug files.  Arnd Bergman noted that the help text was
slightly misleading and should be fixed to state that enabling this option
isn't a problem when using pre 4.4 gcc.

To simplify the rewording, consolidate the text into lib/Kconfig.debug and
modify it there to be more explicit about when you should say N to this
config.

Also, make the text a bit more generic by stating that this option enables
compile time checks so we can cover architectures which emit warnings vs. 
ones which emit errors.  The details of how an architecture decided to
implement the checks isn't as important as the concept of compile time
checking of copy_from_user() calls.

While we're doing this, remove all the copy_from_user_overflow() code
that's duplicated many times and place it into lib/ so that any
architecture supporting this option can get the function for free.

[sedat.dilek@googlemail.com: s/lib-/obj-/ for usercopy.o]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/Kconfig             |    1 +
 arch/parisc/Kconfig.debug       |   14 --------------
 arch/s390/Kconfig               |    1 +
 arch/s390/Kconfig.debug         |   14 --------------
 arch/s390/lib/Makefile          |    1 -
 arch/s390/lib/usercopy.c        |    8 --------
 arch/sparc/lib/Makefile         |    1 -
 arch/sparc/lib/usercopy.c       |    8 --------
 arch/tile/Kconfig               |    8 +-------
 arch/tile/include/asm/uaccess.h |    7 ++++++-
 arch/tile/lib/uaccess.c         |    8 --------
 arch/x86/Kconfig                |    1 +
 arch/x86/Kconfig.debug          |   14 --------------
 arch/x86/lib/usercopy_32.c      |    6 ------
 arch/x86/lib/usercopy_64.c      |    6 ------
 lib/Kconfig.debug               |   18 ++++++++++++++++++
 lib/Makefile                    |    1 +
 lib/usercopy.c                  |    8 ++++++++
 18 files changed, 37 insertions(+), 88 deletions(-)

diff -puN arch/parisc/Kconfig~consolidate-config_debug_strict_user_copy_checks arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~consolidate-config_debug_strict_user_copy_checks
+++ a/arch/parisc/Kconfig
@@ -7,6 +7,7 @@ config PARISC
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST if 64BIT
 	select RTC_CLASS
 	select RTC_DRV_GENERIC
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select INIT_ALL_POSSIBLE
 	select BUG
 	select HAVE_IRQ_WORK
diff -puN arch/parisc/Kconfig.debug~consolidate-config_debug_strict_user_copy_checks arch/parisc/Kconfig.debug
--- a/arch/parisc/Kconfig.debug~consolidate-config_debug_strict_user_copy_checks
+++ a/arch/parisc/Kconfig.debug
@@ -12,18 +12,4 @@ config DEBUG_RODATA
          portion of the kernel code won't be covered by a TLB anymore.
          If in doubt, say "N".
 
-config DEBUG_STRICT_USER_COPY_CHECKS
-	bool "Strict copy size checks"
-	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
-	---help---
-	  Enabling this option turns a certain set of sanity checks for user
-	  copy operations into compile time failures.
-
-	  The copy_from_user() etc checks are there to help test if there
-	  are sufficient security checks on the length argument of
-	  the copy operation, by having gcc prove that the argument is
-	  within bounds.
-
-	  If unsure, or if you run an older (pre 4.4) gcc, say N.
-
 endmenu
diff -puN arch/s390/Kconfig~consolidate-config_debug_strict_user_copy_checks arch/s390/Kconfig
--- a/arch/s390/Kconfig~consolidate-config_debug_strict_user_copy_checks
+++ a/arch/s390/Kconfig
@@ -122,6 +122,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff -puN arch/s390/Kconfig.debug~consolidate-config_debug_strict_user_copy_checks arch/s390/Kconfig.debug
--- a/arch/s390/Kconfig.debug~consolidate-config_debug_strict_user_copy_checks
+++ a/arch/s390/Kconfig.debug
@@ -17,20 +17,6 @@ config STRICT_DEVMEM
 
 	  If you are unsure, say Y.
 
-config DEBUG_STRICT_USER_COPY_CHECKS
-	def_bool n
-	prompt "Strict user copy size checks"
-	---help---
-	  Enabling this option turns a certain set of sanity checks for user
-	  copy operations into compile time warnings.
-
-	  The copy_from_user() etc checks are there to help test if there
-	  are sufficient security checks on the length argument of
-	  the copy operation, by having gcc prove that the argument is
-	  within bounds.
-
-	  If unsure, or if you run an older (pre 4.4) gcc, say N.
-
 config DEBUG_SET_MODULE_RONX
 	def_bool y
 	depends on MODULES
diff -puN arch/s390/lib/Makefile~consolidate-config_debug_strict_user_copy_checks arch/s390/lib/Makefile
--- a/arch/s390/lib/Makefile~consolidate-config_debug_strict_user_copy_checks
+++ a/arch/s390/lib/Makefile
@@ -3,7 +3,6 @@
 #
 
 lib-y += delay.o string.o uaccess_std.o uaccess_pt.o
-obj-y += usercopy.o
 obj-$(CONFIG_32BIT) += div64.o qrnnd.o ucmpdi2.o
 lib-$(CONFIG_64BIT) += uaccess_mvcos.o
 lib-$(CONFIG_SMP) += spinlock.o
diff -puN arch/s390/lib/usercopy.c~consolidate-config_debug_strict_user_copy_checks /dev/null
--- a/arch/s390/lib/usercopy.c
+++ /dev/null
@@ -1,8 +0,0 @@
-#include <linux/module.h>
-#include <linux/bug.h>
-
-void copy_from_user_overflow(void)
-{
-	WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
diff -puN arch/sparc/lib/Makefile~consolidate-config_debug_strict_user_copy_checks arch/sparc/lib/Makefile
--- a/arch/sparc/lib/Makefile~consolidate-config_debug_strict_user_copy_checks
+++ a/arch/sparc/lib/Makefile
@@ -43,4 +43,3 @@ obj-y                 += iomap.o
 obj-$(CONFIG_SPARC32) += atomic32.o
 obj-y                 += ksyms.o
 obj-$(CONFIG_SPARC64) += PeeCeeI.o
-obj-y                 += usercopy.o
diff -puN arch/sparc/lib/usercopy.c~consolidate-config_debug_strict_user_copy_checks /dev/null
--- a/arch/sparc/lib/usercopy.c
+++ /dev/null
@@ -1,8 +0,0 @@
-#include <linux/module.h>
-#include <linux/bug.h>
-
-void copy_from_user_overflow(void)
-{
-	WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
diff -puN arch/tile/Kconfig~consolidate-config_debug_strict_user_copy_checks arch/tile/Kconfig
--- a/arch/tile/Kconfig~consolidate-config_debug_strict_user_copy_checks
+++ a/arch/tile/Kconfig
@@ -7,6 +7,7 @@ config TILE
 	select GENERIC_FIND_FIRST_BIT
 	select USE_GENERIC_SMP_HELPERS
 	select CC_OPTIMIZE_FOR_SIZE
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
@@ -94,13 +95,6 @@ config STRICT_DEVMEM
 config SMP
 	def_bool y
 
-# Allow checking for compile-time determined overflow errors in
-# copy_from_user().  There are still unprovable places in the
-# generic code as of 2.6.34, so this option is not really compatible
-# with -Werror, which is more useful in general.
-config DEBUG_COPY_FROM_USER
-	def_bool n
-
 config HVC_TILE
 	select HVC_DRIVER
 	def_bool y
diff -puN arch/tile/include/asm/uaccess.h~consolidate-config_debug_strict_user_copy_checks arch/tile/include/asm/uaccess.h
--- a/arch/tile/include/asm/uaccess.h~consolidate-config_debug_strict_user_copy_checks
+++ a/arch/tile/include/asm/uaccess.h
@@ -353,7 +353,12 @@ _copy_from_user(void *to, const void __u
 	return n;
 }
 
-#ifdef CONFIG_DEBUG_COPY_FROM_USER
+#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
+/*
+ * There are still unprovable places in the generic code as of 2.6.34, so this
+ * option is not really compatible with -Werror, which is more useful in
+ * general.
+ */
 extern void copy_from_user_overflow(void)
 	__compiletime_warning("copy_from_user() size is not provably correct");
 
diff -puN arch/tile/lib/uaccess.c~consolidate-config_debug_strict_user_copy_checks arch/tile/lib/uaccess.c
--- a/arch/tile/lib/uaccess.c~consolidate-config_debug_strict_user_copy_checks
+++ a/arch/tile/lib/uaccess.c
@@ -22,11 +22,3 @@ int __range_ok(unsigned long addr, unsig
 		 is_arch_mappable_range(addr, size));
 }
 EXPORT_SYMBOL(__range_ok);
-
-#ifdef CONFIG_DEBUG_COPY_FROM_USER
-void copy_from_user_overflow(void)
-{
-       WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
-#endif
diff -puN arch/x86/Kconfig~consolidate-config_debug_strict_user_copy_checks arch/x86/Kconfig
--- a/arch/x86/Kconfig~consolidate-config_debug_strict_user_copy_checks
+++ a/arch/x86/Kconfig
@@ -72,6 +72,7 @@ config X86
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CLOCKEVENTS_MIN_ADJUST
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_BPF_JIT if (X86_64 && NET)
diff -puN arch/x86/Kconfig.debug~consolidate-config_debug_strict_user_copy_checks arch/x86/Kconfig.debug
--- a/arch/x86/Kconfig.debug~consolidate-config_debug_strict_user_copy_checks
+++ a/arch/x86/Kconfig.debug
@@ -273,20 +273,6 @@ config OPTIMIZE_INLINING
 
 	  If unsure, say N.
 
-config DEBUG_STRICT_USER_COPY_CHECKS
-	bool "Strict copy size checks"
-	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
-	---help---
-	  Enabling this option turns a certain set of sanity checks for user
-	  copy operations into compile time failures.
-
-	  The copy_from_user() etc checks are there to help test if there
-	  are sufficient security checks on the length argument of
-	  the copy operation, by having gcc prove that the argument is
-	  within bounds.
-
-	  If unsure, or if you run an older (pre 4.4) gcc, say N.
-
 config DEBUG_NMI_SELFTEST
 	bool "NMI Selftest"
 	depends on DEBUG_KERNEL && X86_LOCAL_APIC
diff -puN arch/x86/lib/usercopy_32.c~consolidate-config_debug_strict_user_copy_checks arch/x86/lib/usercopy_32.c
--- a/arch/x86/lib/usercopy_32.c~consolidate-config_debug_strict_user_copy_checks
+++ a/arch/x86/lib/usercopy_32.c
@@ -883,9 +883,3 @@ _copy_from_user(void *to, const void __u
 	return n;
 }
 EXPORT_SYMBOL(_copy_from_user);
-
-void copy_from_user_overflow(void)
-{
-	WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
diff -puN arch/x86/lib/usercopy_64.c~consolidate-config_debug_strict_user_copy_checks arch/x86/lib/usercopy_64.c
--- a/arch/x86/lib/usercopy_64.c~consolidate-config_debug_strict_user_copy_checks
+++ a/arch/x86/lib/usercopy_64.c
@@ -181,9 +181,3 @@ copy_user_handle_tail(char *to, char *fr
 			break;
 	return len;
 }
-
-void copy_from_user_overflow(void)
-{
-	WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
diff -puN lib/Kconfig.debug~consolidate-config_debug_strict_user_copy_checks lib/Kconfig.debug
--- a/lib/Kconfig.debug~consolidate-config_debug_strict_user_copy_checks
+++ a/lib/Kconfig.debug
@@ -1121,6 +1121,24 @@ config SYSCTL_SYSCALL_CHECK
 	  to properly maintain and use. This enables checks that help
 	  you to keep things correct.
 
+config ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	bool
+
+config DEBUG_STRICT_USER_COPY_CHECKS
+	bool "Strict user copy size checks"
+	depends on ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
+	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
+	help
+	  Enabling this option turns a certain set of sanity checks for user
+	  copy operations into compile time failures.
+
+	  The copy_from_user() etc checks are there to help test if there
+	  are sufficient security checks on the length argument of
+	  the copy operation, by having gcc prove that the argument is
+	  within bounds.
+
+	  If unsure, say N.
+
 source mm/Kconfig.debug
 source kernel/trace/Kconfig
 
diff -puN lib/Makefile~consolidate-config_debug_strict_user_copy_checks lib/Makefile
--- a/lib/Makefile~consolidate-config_debug_strict_user_copy_checks
+++ a/lib/Makefile
@@ -14,6 +14,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o
 
+obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 
diff -puN /dev/null lib/usercopy.c
--- /dev/null
+++ a/lib/usercopy.c
@@ -0,0 +1,8 @@
+#include <linux/module.h>
+#include <linux/bug.h>
+
+void copy_from_user_overflow(void)
+{
+	WARN(1, "Buffer overflow detected!\n");
+}
+EXPORT_SYMBOL(copy_from_user_overflow);
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch
linux-next.patch
debugobjects-fix-selftest-for-static-warnings.patch
drivers-scsi-sgc-convert-to-kstrtoul_from_user.patch
kprobes-silence-debug_strict_user_copy_checks=y-warning.patch

