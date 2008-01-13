From: akpm@linux-foundation.org
Subject: - bugh-remove-have_arch_bug--have_arch_warn.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:25:15 -0800
Message-ID: <200801131124.m0DBOtdr009495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33769 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751381AbYAMLZB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:25:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olof@lixom.net, linux-arch@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     bug.h: Remove HAVE_ARCH_BUG.* / HAVE_ARCH_WARN.*
has been removed from the -mm tree.  Its filename was
     bugh-remove-have_arch_bug--have_arch_warn.patch

This patch was dropped because git-x86 changes wrecked it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bug.h: Remove HAVE_ARCH_BUG.* / HAVE_ARCH_WARN.*
From: Olof Johansson <olof@lixom.net>

No need to have the HAVE_ARCH_BUG.* / HAVE_ARCH_WARN.* defines, when
the generic implementation can just use #ifndef on the macros themselves.

Also, introduce __WARN() in the generic case, so the generic WARN_ON()
can use arch-specific code for when the condition is true.

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/bug.h   |    1 -
 include/asm-arm/bug.h     |    1 -
 include/asm-avr32/bug.h   |    3 ---
 include/asm-frv/bug.h     |    1 -
 include/asm-generic/bug.h |   27 ++++++++++++++++-----------
 include/asm-ia64/bug.h    |    1 -
 include/asm-m68k/bug.h    |    1 -
 include/asm-mips/bug.h    |    4 ----
 include/asm-parisc/bug.h  |    2 --
 include/asm-powerpc/bug.h |    3 ---
 include/asm-s390/bug.h    |    2 --
 include/asm-sh/bug.h      |    2 --
 include/asm-sparc/bug.h   |    1 -
 include/asm-sparc64/bug.h |    1 -
 include/asm-v850/bug.h    |    1 -
 include/asm-x86/bug.h     |    1 -
 16 files changed, 16 insertions(+), 36 deletions(-)

diff -puN include/asm-alpha/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-alpha/bug.h
--- a/include/asm-alpha/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-alpha/bug.h
@@ -10,7 +10,6 @@
   __asm__ __volatile__("call_pal %0  # bugchk\n\t"".long %1\n\t.8byte %2" \
 		       : : "i" (PAL_bugchk), "i"(__LINE__), "i"(__FILE__))
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
diff -puN include/asm-arm/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-arm/bug.h
--- a/include/asm-arm/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-arm/bug.h
@@ -16,7 +16,6 @@ extern void __bug(const char *file, int 
 
 #endif
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
diff -puN include/asm-avr32/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-avr32/bug.h
--- a/include/asm-avr32/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-avr32/bug.h
@@ -63,9 +63,6 @@
 		unlikely(__ret_warn_on);				\
 	})
 
-#define HAVE_ARCH_BUG
-#define HAVE_ARCH_WARN_ON
-
 #endif /* CONFIG_BUG */
 
 #include <asm-generic/bug.h>
diff -puN include/asm-frv/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-frv/bug.h
--- a/include/asm-frv/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-frv/bug.h
@@ -32,7 +32,6 @@ do {						\
 	asm volatile("nop");			\
 } while(0)
 
-#define HAVE_ARCH_BUG
 #define BUG()					\
 do {						\
 	_debug_bug_printk();			\
diff -puN include/asm-generic/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-generic/bug.h
@@ -20,39 +20,44 @@ struct bug_entry {
 #define BUGFLAG_WARNING	(1<<0)
 #endif	/* CONFIG_GENERIC_BUG */
 
-#ifndef HAVE_ARCH_BUG
+#ifndef BUG
 #define BUG() do { \
 	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
 	panic("BUG!"); \
 } while (0)
 #endif
 
-#ifndef HAVE_ARCH_BUG_ON
+#ifndef BUG_ON
 #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
 #endif
 
-#ifndef HAVE_ARCH_WARN_ON
+#ifndef __WARN
+#define __WARN() do {							\
+	printk("WARNING: at %s:%d %s()\n", __FILE__,			\
+		__LINE__, __FUNCTION__);				\
+	dump_stack();							\
+} while (0)
+#endif
+
+#ifndef WARN_ON
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
-	if (unlikely(__ret_warn_on)) {					\
-		printk("WARNING: at %s:%d %s()\n", __FILE__,		\
-			__LINE__, __FUNCTION__);			\
-		dump_stack();						\
-	}								\
+	if (unlikely(__ret_warn_on))					\
+		__WARN();						\
 	unlikely(__ret_warn_on);					\
 })
 #endif
 
 #else /* !CONFIG_BUG */
-#ifndef HAVE_ARCH_BUG
+#ifndef BUG
 #define BUG()
 #endif
 
-#ifndef HAVE_ARCH_BUG_ON
+#ifndef BUG_ON
 #define BUG_ON(condition) do { if (condition) ; } while(0)
 #endif
 
-#ifndef HAVE_ARCH_WARN_ON
+#ifndef WARN_ON
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
 	unlikely(__ret_warn_on);					\
diff -puN include/asm-ia64/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-ia64/bug.h
--- a/include/asm-ia64/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-ia64/bug.h
@@ -6,7 +6,6 @@
 #define BUG() do { printk("kernel BUG at %s:%d!\n", __FILE__, __LINE__); ia64_abort(); } while (0)
 
 /* should this BUG be made generic? */
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
diff -puN include/asm-m68k/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-m68k/bug.h
--- a/include/asm-m68k/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-m68k/bug.h
@@ -21,7 +21,6 @@
 } while (0)
 #endif
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
diff -puN include/asm-mips/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-mips/bug.h
--- a/include/asm-mips/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-mips/bug.h
@@ -12,8 +12,6 @@ do {									\
 	__asm__ __volatile__("break %0" : : "i" (BRK_BUG));		\
 } while (0)
 
-#define HAVE_ARCH_BUG
-
 #if (_MIPS_ISA > _MIPS_ISA_MIPS1)
 
 #define BUG_ON(condition)						\
@@ -22,8 +20,6 @@ do {									\
 			     : : "r" (condition), "i" (BRK_BUG));	\
 } while (0)
 
-#define HAVE_ARCH_BUG_ON
-
 #endif /* _MIPS_ISA > _MIPS_ISA_MIPS1 */
 
 #endif
diff -puN include/asm-parisc/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-parisc/bug.h
--- a/include/asm-parisc/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-parisc/bug.h
@@ -7,8 +7,6 @@
  */
 
 #ifdef CONFIG_BUG
-#define HAVE_ARCH_BUG
-#define HAVE_ARCH_WARN_ON
 
 /* the break instruction is used as BUG() marker.  */
 #define	PARISC_BUG_BREAK_ASM	"break 0x1f, 0x1fff"
diff -puN include/asm-powerpc/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-powerpc/bug.h
--- a/include/asm-powerpc/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-powerpc/bug.h
@@ -109,9 +109,6 @@
 	unlikely(__ret_warn_on);				\
 })
 
-#define HAVE_ARCH_BUG
-#define HAVE_ARCH_BUG_ON
-#define HAVE_ARCH_WARN_ON
 #endif /* __ASSEMBLY __ */
 #endif /* CONFIG_BUG */
 
diff -puN include/asm-s390/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-s390/bug.h
--- a/include/asm-s390/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-s390/bug.h
@@ -61,8 +61,6 @@
 	unlikely(__ret_warn_on);			\
 })
 
-#define HAVE_ARCH_BUG
-#define HAVE_ARCH_WARN_ON
 #endif /* CONFIG_BUG */
 
 #include <asm-generic/bug.h>
diff -puN include/asm-sh/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-sh/bug.h
--- a/include/asm-sh/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-sh/bug.h
@@ -4,8 +4,6 @@
 #define TRAPA_BUG_OPCODE	0xc33e	/* trapa #0x3e */
 
 #ifdef CONFIG_GENERIC_BUG
-#define HAVE_ARCH_BUG
-#define HAVE_ARCH_WARN_ON
 
 /**
  * _EMIT_BUG_ENTRY
diff -puN /dev/null /dev/null
diff -puN include/asm-sparc/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-sparc/bug.h
--- a/include/asm-sparc/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-sparc/bug.h
@@ -26,7 +26,6 @@ extern void do_BUG(const char *file, int
 #define BUG()		__bug_trap()
 #endif
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
diff -puN include/asm-sparc64/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-sparc64/bug.h
--- a/include/asm-sparc64/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-sparc64/bug.h
@@ -14,7 +14,6 @@ extern void do_BUG(const char *file, int
 #define BUG()		__builtin_trap()
 #endif
 
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
diff -puN include/asm-v850/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-v850/bug.h
--- a/include/asm-v850/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-v850/bug.h
@@ -17,7 +17,6 @@
 #ifdef CONFIG_BUG
 extern void __bug (void) __attribute__ ((noreturn));
 #define BUG()		__bug()
-#define HAVE_ARCH_BUG
 #endif
 
 #include <asm-generic/bug.h>
diff -puN include/asm-x86/bug.h~bugh-remove-have_arch_bug--have_arch_warn include/asm-x86/bug.h
--- a/include/asm-x86/bug.h~bugh-remove-have_arch_bug--have_arch_warn
+++ a/include/asm-x86/bug.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_BUG_H
 
 #ifdef CONFIG_BUG
-#define HAVE_ARCH_BUG
 
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 
_

Patches currently in -mm which might be from olof@lixom.net are

git-powerpc.patch
git-mtd.patch
git-netdev-all.patch
pcmcia-convert-some-internal-only-ioaddr_t-to-unsigned-int.patch
pcmcia-replace-kio_addr_t-with-unsigned-int-everywhere.patch
drivers-pcmcia-add-missing-iounmap.patch
git-x86.patch
bugh-remove-have_arch_bug--have_arch_warn.patch
powerpc-switch-to-generic-warn_on-bug_on.patch
