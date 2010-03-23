From: akpm@linux-foundation.org
Subject: + panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn.patch added to -mm tree
Date: Mon, 22 Mar 2010 22:47:41 -0400
Message-ID: <201003230548.o2N5mXHi016657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753410Ab0CWFtS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 01:49:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk, David.Woodhouse@intel.com, arnd@arndb.de, benh@kernel.crashing.org, ddaney@caviumnetworks.com, deller@gmx.de, heiko.carstens@de.ibm.com, jbarnes@virtuousgeek.org, jesper.nilsson@axis.com, lethal@linux-sh.org, matt@console-pimps.org, schwidefsky@de.ibm.com


The patch titled
     panic: allow taint flag for warnings to be changed from TAINT_WARN
has been added to the -mm tree.  Its filename is
     panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: panic: allow taint flag for warnings to be changed from TAINT_WARN
From: Ben Hutchings <ben@decadent.org.uk>

WARN() is used in some places to report firmware or hardware bugs that are
then worked-around.  These bugs do not affect the stability of the kernel
and should not set the usual TAINT_WARN flag.  To allow for this, add
WARN_TAINT() and WARN_TAINT_ONCE() macros that take a taint flag as
argument.

Architectures that implement warnings using trap instructions instead of
calls to warn_slowpath_*() now implement __WARN_TAINT(taint) instead of
__WARN().

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Helge Deller <deller@gmx.de>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/bug.h  |    8 +++----
 arch/powerpc/include/asm/bug.h |    6 ++---
 arch/s390/include/asm/bug.h    |    8 +++----
 arch/sh/include/asm/bug.h      |    4 +--
 include/asm-generic/bug.h      |   34 +++++++++++++++++++++++++++++--
 kernel/panic.c                 |   24 ++++++++++++++++++---
 lib/bug.c                      |    2 -
 7 files changed, 66 insertions(+), 20 deletions(-)

diff -puN arch/parisc/include/asm/bug.h~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn arch/parisc/include/asm/bug.h
--- a/arch/parisc/include/asm/bug.h~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn
+++ a/arch/parisc/include/asm/bug.h
@@ -44,7 +44,7 @@
 #endif
 
 #ifdef CONFIG_DEBUG_BUGVERBOSE
-#define __WARN()							\
+#define __WARN_TAINT(taint)						\
 	do {								\
 		asm volatile("\n"					\
 			     "1:\t" PARISC_BUG_BREAK_ASM "\n"		\
@@ -54,11 +54,11 @@
 			     "\t.org 2b+%c3\n"				\
 			     "\t.popsection"				\
 			     : : "i" (__FILE__), "i" (__LINE__),	\
-			     "i" (BUGFLAG_WARNING),			\
+			     "i" (BUGFLAG_TAINT(taint)), 		\
 			     "i" (sizeof(struct bug_entry)) );		\
 	} while(0)
 #else
-#define __WARN()							\
+#define __WARN_TAINT(taint)						\
 	do {								\
 		asm volatile("\n"					\
 			     "1:\t" PARISC_BUG_BREAK_ASM "\n"		\
@@ -67,7 +67,7 @@
 			     "\t.short %c0\n"				\
 			     "\t.org 2b+%c1\n"				\
 			     "\t.popsection"				\
-			     : : "i" (BUGFLAG_WARNING),			\
+			     : : "i" (BUGFLAG_TAINT(taint)),		\
 			     "i" (sizeof(struct bug_entry)) );		\
 	} while(0)
 #endif
diff -puN arch/powerpc/include/asm/bug.h~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn arch/powerpc/include/asm/bug.h
--- a/arch/powerpc/include/asm/bug.h~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn
+++ a/arch/powerpc/include/asm/bug.h
@@ -85,12 +85,12 @@
 	}							\
 } while (0)
 
-#define __WARN() do {						\
+#define __WARN_TAINT(taint) do {				\
 	__asm__ __volatile__(					\
 		"1:	twi 31,0,0\n"				\
 		_EMIT_BUG_ENTRY					\
 		: : "i" (__FILE__), "i" (__LINE__),		\
-		  "i" (BUGFLAG_WARNING),			\
+		  "i" (BUGFLAG_TAINT(taint)),			\
 		  "i" (sizeof(struct bug_entry)));		\
 } while (0)
 
@@ -104,7 +104,7 @@
 		"1:	"PPC_TLNEI"	%4,0\n"			\
 		_EMIT_BUG_ENTRY					\
 		: : "i" (__FILE__), "i" (__LINE__),		\
-		  "i" (BUGFLAG_WARNING),			\
+		  "i" (BUGFLAG_TAINT(TAINT_WARN)),		\
 		  "i" (sizeof(struct bug_entry)),		\
 		  "r" (__ret_warn_on));				\
 	}							\
diff -puN arch/s390/include/asm/bug.h~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn arch/s390/include/asm/bug.h
--- a/arch/s390/include/asm/bug.h~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn
+++ a/arch/s390/include/asm/bug.h
@@ -46,18 +46,18 @@
 	unreachable();					\
 } while (0)
 
-#define __WARN() do {					\
-	__EMIT_BUG(BUGFLAG_WARNING);			\
+#define __WARN_TAINT(taint) do {			\
+	__EMIT_BUG(BUGFLAG_TAINT(taint));		\
 } while (0)
 
 #define WARN_ON(x) ({					\
 	int __ret_warn_on = !!(x);			\
 	if (__builtin_constant_p(__ret_warn_on)) {	\
 		if (__ret_warn_on)			\
-			__EMIT_BUG(BUGFLAG_WARNING);	\
+			__WARN();			\
 	} else {					\
 		if (unlikely(__ret_warn_on))		\
-			__EMIT_BUG(BUGFLAG_WARNING);	\
+			__WARN();			\
 	}						\
 	unlikely(__ret_warn_on);			\
 })
diff -puN arch/sh/include/asm/bug.h~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn arch/sh/include/asm/bug.h
--- a/arch/sh/include/asm/bug.h~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn
+++ a/arch/sh/include/asm/bug.h
@@ -48,7 +48,7 @@ do {							\
 		   "i" (sizeof(struct bug_entry)));	\
 } while (0)
 
-#define __WARN()					\
+#define __WARN_TAINT(taint)				\
 do {							\
 	__asm__ __volatile__ (				\
 		"1:\t.short %O0\n"			\
@@ -57,7 +57,7 @@ do {							\
 		 : "n" (TRAPA_BUG_OPCODE),		\
 		   "i" (__FILE__),			\
 		   "i" (__LINE__),			\
-		   "i" (BUGFLAG_WARNING),		\
+		   "i" (BUGFLAG_TAINT(taint)),		\
 		   "i" (sizeof(struct bug_entry)));	\
 } while (0)
 
diff -puN include/asm-generic/bug.h~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn
+++ a/include/asm-generic/bug.h
@@ -25,7 +25,10 @@ struct bug_entry {
 };
 #endif		/* __ASSEMBLY__ */
 
-#define BUGFLAG_WARNING	(1<<0)
+#define BUGFLAG_WARNING		(1 << 0)
+#define BUGFLAG_TAINT(taint)	(BUGFLAG_WARNING | ((taint) << 8))
+#define BUG_GET_TAINT(bug)	((bug)->flags >> 8)
+
 #endif	/* CONFIG_GENERIC_BUG */
 
 /*
@@ -56,17 +59,25 @@ struct bug_entry {
  * appear at runtime.  Use the versions with printk format strings
  * to provide better diagnostics.
  */
-#ifndef __WARN
+#ifndef __WARN_TAINT
 #ifndef __ASSEMBLY__
 extern void warn_slowpath_fmt(const char *file, const int line,
 		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
+extern void warn_slowpath_fmt_taint(const char *file, const int line,
+				    unsigned taint, const char *fmt, ...)
+	__attribute__((format(printf, 4, 5)));
 extern void warn_slowpath_null(const char *file, const int line);
 #define WANT_WARN_ON_SLOWPATH
 #endif
 #define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
 #define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
+#define __WARN_printf_taint(taint, arg...)				\
+	warn_slowpath_fmt_taint(__FILE__, __LINE__, taint, arg)
 #else
+#define __WARN()		__WARN_TAINT(TAINT_WARN)
 #define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
+#define __WARN_printf_taint(taint, arg...)				\
+	do { printk(arg); __WARN_TAINT(taint); } while (0)
 #endif
 
 #ifndef WARN_ON
@@ -87,6 +98,13 @@ extern void warn_slowpath_null(const cha
 })
 #endif
 
+#define WARN_TAINT(condition, taint, format...) ({			\
+	int __ret_warn_on = !!(condition);				\
+	if (unlikely(__ret_warn_on))					\
+		__WARN_printf_taint(taint, format);			\
+	unlikely(__ret_warn_on);					\
+})
+
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
 #define BUG() do {} while(0)
@@ -110,6 +128,8 @@ extern void warn_slowpath_null(const cha
 })
 #endif
 
+#define WARN_TAINT(condition, taint, format...) WARN_ON(condition)
+
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
@@ -132,6 +152,16 @@ extern void warn_slowpath_null(const cha
 	unlikely(__ret_warn_once);				\
 })
 
+#define WARN_TAINT_ONCE(condition, taint, format...)	({	\
+	static bool __warned;					\
+	int __ret_warn_once = !!(condition);			\
+								\
+	if (unlikely(__ret_warn_once))				\
+		if (WARN_TAINT(!__warned, taint, format))	\
+			__warned = true;			\
+	unlikely(__ret_warn_once);				\
+})
+
 #define WARN_ON_RATELIMIT(condition, state)			\
 		WARN_ON((condition) && __ratelimit(state))
 
diff -puN kernel/panic.c~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn kernel/panic.c
--- a/kernel/panic.c~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn
+++ a/kernel/panic.c
@@ -365,7 +365,8 @@ struct slowpath_args {
 	va_list args;
 };
 
-static void warn_slowpath_common(const char *file, int line, void *caller, struct slowpath_args *args)
+static void warn_slowpath_common(const char *file, int line, void *caller,
+				 unsigned taint, struct slowpath_args *args)
 {
 	const char *board;
 
@@ -381,7 +382,7 @@ static void warn_slowpath_common(const c
 	print_modules();
 	dump_stack();
 	print_oops_end_marker();
-	add_taint(TAINT_WARN);
+	add_taint(taint);
 }
 
 void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
@@ -390,14 +391,29 @@ void warn_slowpath_fmt(const char *file,
 
 	args.fmt = fmt;
 	va_start(args.args, fmt);
-	warn_slowpath_common(file, line, __builtin_return_address(0), &args);
+	warn_slowpath_common(file, line, __builtin_return_address(0),
+			     TAINT_WARN, &args);
 	va_end(args.args);
 }
 EXPORT_SYMBOL(warn_slowpath_fmt);
 
+void warn_slowpath_fmt_taint(const char *file, int line,
+			     unsigned taint, const char *fmt, ...)
+{
+	struct slowpath_args args;
+
+	args.fmt = fmt;
+	va_start(args.args, fmt);
+	warn_slowpath_common(file, line, __builtin_return_address(0),
+			     taint, &args);
+	va_end(args.args);
+}
+EXPORT_SYMBOL(warn_slowpath_fmt_taint);
+
 void warn_slowpath_null(const char *file, int line)
 {
-	warn_slowpath_common(file, line, __builtin_return_address(0), NULL);
+	warn_slowpath_common(file, line, __builtin_return_address(0),
+			     TAINT_WARN, NULL);
 }
 EXPORT_SYMBOL(warn_slowpath_null);
 #endif
diff -puN lib/bug.c~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn lib/bug.c
--- a/lib/bug.c~panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn
+++ a/lib/bug.c
@@ -165,7 +165,7 @@ enum bug_trap_type report_bug(unsigned l
 			       (void *)bugaddr);
 
 		show_regs(regs);
-		add_taint(TAINT_WARN);
+		add_taint(BUG_GET_TAINT(bug));
 		return BUG_TRAP_TYPE_WARN;
 	}
 
_

Patches currently in -mm which might be from ben@decadent.org.uk are

linux-next.patch
mptscsih-fix-first-line-of-kernel-doc-for-a-few-functions.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn.patch
panic-add-taint-flag-taint_firmware_workaround-i.patch
pci-dmar-combine-the-bios-dmar-table-warning-messages.patch
pci-dmar-tone-down-warnings-about-invalid-bios-dmar-tables.patch

