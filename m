From: akpm@linux-foundation.org
Subject: [to-be-updated] eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build.patch removed from -mm tree
Date: Wed, 29 Apr 2009 12:34:27 -0700
Message-ID: <200904291934.n3TJYU94007144@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752679AbZD2Tho (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Apr 2009 15:37:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, arjan@linux.intel.com, hannes@cmpxchg.org, hugh@veritas.com, jesper.nilsson@axis.com, mm-commits@vger.kernel.org


The patch titled
     Eliminate thousands of warnings in WARN_ON with gcc 3.2 build
has been removed from the -mm tree.  Its filename was
     eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Eliminate thousands of warnings in WARN_ON with gcc 3.2 build
From: Andi Kleen <andi@firstfloor.org>

When building with gcc 3.2 I get thousands of warnings about passing a
NULL format string to warn_slowpath().  Split this case out into a
separate call.  This also shrinks the kernel slightly:

          text    data     bss     dec     hex filename
       4802274  707668  712704 6222646  5ef336 vmlinux
          text    data     bss     dec     hex filename
       4799027  703572  712704 6215303  5ed687 vmlinux

[hugh@veritas.com: Fix oopsing WARN_ON]
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    7 ++++---
 kernel/panic.c            |   11 +++++++++--
 2 files changed, 13 insertions(+), 5 deletions(-)

diff -puN include/asm-generic/bug.h~eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build
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
diff -puN kernel/panic.c~eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build kernel/panic.c
--- a/kernel/panic.c~eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build
+++ a/kernel/panic.c
@@ -340,7 +340,7 @@ void oops_exit(void)
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
-void warn_slowpath(const char *file, int line, const char *fmt, ...)
+void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
 {
 	va_list args;
 	char function[KSYM_SYMBOL_LEN];
@@ -367,7 +367,14 @@ void warn_slowpath(const char *file, int
 	print_oops_end_marker();
 	add_taint(TAINT_WARN);
 }
-EXPORT_SYMBOL(warn_slowpath);
+EXPORT_SYMBOL(warn_slowpath_fmt);
+
+void warn_slowpath_null(const char *file, int line)
+{
+	/* The { 0 } avoids a gcc format warning */
+	warn_slowpath_fmt(file, line, (const char *) { 0 });
+}
+EXPORT_SYMBOL(warn_slowpath_null);
 #endif
 
 #ifdef CONFIG_CC_STACKPROTECTOR
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
linux-next.patch
x86-simplify-highmem-related-kconfig-entries.patch
eliminate-thousands-of-warnings-in-warn_on-with-gcc-32-build.patch
pagemap-document-clarifications.patch
pagemap-documentation-9-more-exported-page-flags.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch

