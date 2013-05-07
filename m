From: akpm@linux-foundation.org
Subject: [merged] kconfig-consolidate-config_debug_strict_user_copy_checks.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:53 -0700
Message-ID: <20130507175053.95F865A4525@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:36767 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3EGRuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:55 -0400
Received: by mail-qe0-f73.google.com with SMTP id a11so86395qen.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, arjan@linux.intel.com, arnd@arndb.de, cmetcalf@tilera.com, deller@gmx.de, heiko.carstens@de.ibm.com, hpa@zytor.com, mingo@kernel.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig: consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
has been removed from the -mm tree.  Its filename was
     kconfig-consolidate-config_debug_strict_user_copy_checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: Kconfig: consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS

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

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Helge Deller <deller@gmx.de>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/Kconfig             |    1 +
 arch/parisc/Kconfig.debug       |   14 --------------
 arch/s390/Kconfig               |    1 +
 arch/s390/Kconfig.debug         |   14 --------------
 arch/s390/lib/Makefile          |    1 -
 arch/s390/lib/usercopy.c        |    8 --------
 arch/sparc/lib/Makefile         |    1 -
 arch/sparc/lib/usercopy.c       |    9 ---------
 arch/tile/Kconfig               |    8 +-------
 arch/tile/include/asm/uaccess.h |    7 ++++++-
 arch/tile/lib/uaccess.c         |    8 --------
 arch/x86/Kconfig                |    1 +
 arch/x86/Kconfig.debug          |   14 --------------
 arch/x86/lib/usercopy_32.c      |    6 ------
 lib/Kconfig.debug               |   18 ++++++++++++++++++
 lib/Makefile                    |    1 +
 lib/usercopy.c                  |    9 +++++++++
 17 files changed, 38 insertions(+), 83 deletions(-)

diff -puN arch/parisc/Kconfig~kconfig-consolidate-config_debug_strict_user_copy_checks arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~kconfig-consolidate-config_debug_strict_user_copy_checks
+++ a/arch/parisc/Kconfig
@@ -1,5 +1,6 @@
 config PARISC
 	def_bool y
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_FUNCTION_TRACER if 64BIT
diff -puN arch/parisc/Kconfig.debug~kconfig-consolidate-config_debug_strict_user_copy_checks arch/parisc/Kconfig.debug
--- a/arch/parisc/Kconfig.debug~kconfig-consolidate-config_debug_strict_user_copy_checks
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
diff -puN arch/s390/Kconfig~kconfig-consolidate-config_debug_strict_user_copy_checks arch/s390/Kconfig
--- a/arch/s390/Kconfig~kconfig-consolidate-config_debug_strict_user_copy_checks
+++ a/arch/s390/Kconfig
@@ -91,6 +91,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select BUILDTIME_EXTABLE_SORT
diff -puN arch/s390/Kconfig.debug~kconfig-consolidate-config_debug_strict_user_copy_checks arch/s390/Kconfig.debug
--- a/arch/s390/Kconfig.debug~kconfig-consolidate-config_debug_strict_user_copy_checks
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
 config S390_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
diff -puN arch/s390/lib/Makefile~kconfig-consolidate-config_debug_strict_user_copy_checks arch/s390/lib/Makefile
--- a/arch/s390/lib/Makefile~kconfig-consolidate-config_debug_strict_user_copy_checks
+++ a/arch/s390/lib/Makefile
@@ -3,7 +3,6 @@
 #
 
 lib-y += delay.o string.o uaccess_std.o uaccess_pt.o
-obj-y += usercopy.o
 obj-$(CONFIG_32BIT) += div64.o qrnnd.o ucmpdi2.o mem32.o
 obj-$(CONFIG_64BIT) += mem64.o
 lib-$(CONFIG_64BIT) += uaccess_mvcos.o
diff -puN arch/s390/lib/usercopy.c~kconfig-consolidate-config_debug_strict_user_copy_checks /dev/null
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
diff -puN arch/sparc/lib/Makefile~kconfig-consolidate-config_debug_strict_user_copy_checks arch/sparc/lib/Makefile
--- a/arch/sparc/lib/Makefile~kconfig-consolidate-config_debug_strict_user_copy_checks
+++ a/arch/sparc/lib/Makefile
@@ -45,4 +45,3 @@ obj-y                 += iomap.o
 obj-$(CONFIG_SPARC32) += atomic32.o ucmpdi2.o
 obj-y                 += ksyms.o
 obj-$(CONFIG_SPARC64) += PeeCeeI.o
-obj-y                 += usercopy.o
diff -puN arch/sparc/lib/usercopy.c~kconfig-consolidate-config_debug_strict_user_copy_checks /dev/null
--- a/arch/sparc/lib/usercopy.c
+++ /dev/null
@@ -1,9 +0,0 @@
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/bug.h>
-
-void copy_from_user_overflow(void)
-{
-	WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
diff -puN arch/tile/Kconfig~kconfig-consolidate-config_debug_strict_user_copy_checks arch/tile/Kconfig
--- a/arch/tile/Kconfig~kconfig-consolidate-config_debug_strict_user_copy_checks
+++ a/arch/tile/Kconfig
@@ -19,6 +19,7 @@ config TILE
 	select HAVE_SYSCALL_WRAPPERS if TILEGX
 	select VIRT_TO_BUS
 	select SYS_HYPERVISOR
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
@@ -114,13 +115,6 @@ config STRICT_DEVMEM
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
 	depends on TTY
 	select HVC_DRIVER
diff -puN arch/tile/include/asm/uaccess.h~kconfig-consolidate-config_debug_strict_user_copy_checks arch/tile/include/asm/uaccess.h
--- a/arch/tile/include/asm/uaccess.h~kconfig-consolidate-config_debug_strict_user_copy_checks
+++ a/arch/tile/include/asm/uaccess.h
@@ -395,7 +395,12 @@ _copy_from_user(void *to, const void __u
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
 
diff -puN arch/tile/lib/uaccess.c~kconfig-consolidate-config_debug_strict_user_copy_checks arch/tile/lib/uaccess.c
--- a/arch/tile/lib/uaccess.c~kconfig-consolidate-config_debug_strict_user_copy_checks
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
diff -puN arch/x86/Kconfig~kconfig-consolidate-config_debug_strict_user_copy_checks arch/x86/Kconfig
--- a/arch/x86/Kconfig~kconfig-consolidate-config_debug_strict_user_copy_checks
+++ a/arch/x86/Kconfig
@@ -20,6 +20,7 @@ config X86_64
 ### Arch settings
 config X86
 	def_bool y
+	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select HAVE_AOUT if X86_32
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select ARCH_SUPPORTS_NUMA_BALANCING
diff -puN arch/x86/Kconfig.debug~kconfig-consolidate-config_debug_strict_user_copy_checks arch/x86/Kconfig.debug
--- a/arch/x86/Kconfig.debug~kconfig-consolidate-config_debug_strict_user_copy_checks
+++ a/arch/x86/Kconfig.debug
@@ -292,20 +292,6 @@ config OPTIMIZE_INLINING
 
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
diff -puN arch/x86/lib/usercopy_32.c~kconfig-consolidate-config_debug_strict_user_copy_checks arch/x86/lib/usercopy_32.c
--- a/arch/x86/lib/usercopy_32.c~kconfig-consolidate-config_debug_strict_user_copy_checks
+++ a/arch/x86/lib/usercopy_32.c
@@ -689,9 +689,3 @@ _copy_from_user(void *to, const void __u
 	return n;
 }
 EXPORT_SYMBOL(_copy_from_user);
-
-void copy_from_user_overflow(void)
-{
-	WARN(1, "Buffer overflow detected!\n");
-}
-EXPORT_SYMBOL(copy_from_user_overflow);
diff -puN lib/Kconfig.debug~kconfig-consolidate-config_debug_strict_user_copy_checks lib/Kconfig.debug
--- a/lib/Kconfig.debug~kconfig-consolidate-config_debug_strict_user_copy_checks
+++ a/lib/Kconfig.debug
@@ -1292,6 +1292,24 @@ config LATENCYTOP
 	  Enable this option if you want to use the LatencyTOP tool
 	  to find out which userspace is blocking on what kernel operations.
 
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
 
diff -puN lib/Makefile~kconfig-consolidate-config_debug_strict_user_copy_checks lib/Makefile
--- a/lib/Makefile~kconfig-consolidate-config_debug_strict_user_copy_checks
+++ a/lib/Makefile
@@ -15,6 +15,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o
 
+obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
 
diff -puN /dev/null lib/usercopy.c
--- /dev/null
+++ a/lib/usercopy.c
@@ -0,0 +1,9 @@
+#include <linux/export.h>
+#include <linux/bug.h>
+#include <linux/uaccess.h>
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

