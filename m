From: akpm@linux-foundation.org
Subject: [merged] eliminate-thousands-of-warnings-with-gcc-32-build.patch removed from -mm tree
Date: Thu, 07 May 2009 12:15:56 -0700
Message-ID: <200905071915.n47JFuMa019978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753091AbZEGTVR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:21:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, arjan@linux.intel.com, hannes@cmpxchg.org, hugh@veritas.com, jesper.nilsson@axis.com, mm-commits@vger.kernel.org


The patch titled
     Eliminate thousands of warnings with gcc 3.2 build
has been removed from the -mm tree.  Its filename was
     eliminate-thousands-of-warnings-with-gcc-32-build.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Eliminate thousands of warnings with gcc 3.2 build
From: Andi Kleen <andi@firstfloor.org>

When building with gcc 3.2 I get thousands of warnings such as

include/linux/gfp.h: In function `allocflags_to_migratetype':
include/linux/gfp.h:105: warning: null format string

due to passing a NULL format string to warn_slowpath() in

#define __WARN()		warn_slowpath(__FILE__, __LINE__, NULL)

Split this case out into a separate call.  This also shrinks the kernel
slightly:

          text    data     bss     dec     hex filename
       4802274  707668  712704 6222646  5ef336 vmlinux
          text    data     bss     dec     hex filename
       4799027  703572  712704 6215303  5ed687 vmlinux

due to removeing one argument from the commonly-called __WARN().

[akpm@linux-foundation.org: reduce scope of `empty']
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |    7 ++++---
 kernel/panic.c            |   13 ++++++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

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
@@ -367,7 +367,14 @@ void warn_slowpath(const char *file, int
 	print_oops_end_marker();
 	add_taint(TAINT_WARN);
 }
-EXPORT_SYMBOL(warn_slowpath);
+EXPORT_SYMBOL(warn_slowpath_fmt);
+
+void warn_slowpath_null(const char *file, int line)
+{
+	static const char *empty = "";
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
x86-srat-do-not-register-nodes-beyond-e820-map.patch
pagemap-document-clarifications.patch
pagemap-documentation-9-more-exported-page-flags.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch

