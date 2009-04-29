From: akpm@linux-foundation.org
Subject: + eliminate-thousands-of-warnings-with-gcc-32-build.patch added to -mm tree
Date: Wed, 29 Apr 2009 12:37:08 -0700
Message-ID: <200904291937.n3TJb829008562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756345AbZD2TkK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:40:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, arjan@linux.intel.com, hannes@cmpxchg.org, hugh@veritas.com, jesper.nilsson@axis.com


The patch titled
     Eliminate thousands of warnings with gcc 3.2 build
has been added to the -mm tree.  Its filename is
     eliminate-thousands-of-warnings-with-gcc-32-build.patch

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
Subject: Eliminate thousands of warnings with gcc 3.2 build
From: Andi Kleen <andi@firstfloor.org>

When building with gcc 3.2 I get thousands of warnings about passing a
NULL format string to warn_slowpath() due to

#define __WARN()		warn_slowpath(__FILE__, __LINE__, NULL)

Split this case out into a separate call.  This also shrinks the kernel
slightly:

          text    data     bss     dec     hex filename
       4802274  707668  712704 6222646  5ef336 vmlinux
          text    data     bss     dec     hex filename
       4799027  703572  712704 6215303  5ed687 vmlinux

due to removeing one argument from the commonly-called __WARN().

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    7 ++++---
 kernel/panic.c            |   14 +++++++++++---
 2 files changed, 15 insertions(+), 6 deletions(-)

diff -puN include/asm-generic/bug.h~eliminate-thousands-of-warnings-with-gcc-32-build include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~eliminate-thousands-of-warnings-with-gcc-32-build
+++ a/include/asm-generic/bug.h
@@ -58,12 +58,13 @@ struct bug_entry {
  */
 #ifndef __WARN
 #ifndef __ASSEMBLY__
-extern void warn_slowpath(const char *file, const int line,
+extern void warn_slowpath_fmt(const char *file, const int line,
 		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
+extern void warn_slowpath_null(const char *file, const int line);
 #define WANT_WARN_ON_SLOWPATH
 #endif
-#define __WARN()		warn_slowpath(__FILE__, __LINE__, NULL)
-#define __WARN_printf(arg...)	warn_slowpath(__FILE__, __LINE__, arg)
+#define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
+#define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
 #else
 #define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
 #endif
diff -puN kernel/panic.c~eliminate-thousands-of-warnings-with-gcc-32-build kernel/panic.c
--- a/kernel/panic.c~eliminate-thousands-of-warnings-with-gcc-32-build
+++ a/kernel/panic.c
@@ -340,7 +340,7 @@ void oops_exit(void)
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
-void warn_slowpath(const char *file, int line, const char *fmt, ...)
+void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
 {
 	va_list args;
 	char function[KSYM_SYMBOL_LEN];
@@ -356,7 +356,7 @@ void warn_slowpath(const char *file, int
 	if (board)
 		printk(KERN_WARNING "Hardware name: %s\n", board);
 
-	if (fmt) {
+	if (*fmt) {
 		va_start(args, fmt);
 		vprintk(fmt, args);
 		va_end(args);
@@ -367,7 +367,15 @@ void warn_slowpath(const char *file, int
 	print_oops_end_marker();
 	add_taint(TAINT_WARN);
 }
-EXPORT_SYMBOL(warn_slowpath);
+EXPORT_SYMBOL(warn_slowpath_fmt);
+
+static const char *empty = "";
+
+void warn_slowpath_null(const char *file, int line)
+{
+	warn_slowpath_fmt(file, line, empty);
+}
+EXPORT_SYMBOL(warn_slowpath_null);
 #endif
 
 #ifdef CONFIG_CC_STACKPROTECTOR
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
linux-next.patch
x86-simplify-highmem-related-kconfig-entries.patch
eliminate-thousands-of-warnings-with-gcc-32-build.patch
pagemap-document-clarifications.patch
pagemap-documentation-9-more-exported-page-flags.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch

