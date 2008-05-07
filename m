From: akpm@linux-foundation.org
Subject: + add-a-warn-macro-this-is-warn_on-printk-arguments.patch added to -mm tree
Date: Wed, 07 May 2008 14:44:42 -0700
Message-ID: <200805072144.m47LigNW017966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754804AbYEGVpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 17:45:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, greg@kroah.com


The patch titled
     Add a WARN() macro; this is WARN_ON() + printk arguments
has been added to the -mm tree.  Its filename is
     add-a-warn-macro-this-is-warn_on-printk-arguments.patch

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
Subject: Add a WARN() macro; this is WARN_ON() + printk arguments
From: Arjan van de Ven <arjan@linux.intel.com>

Add a WARN() macro that acts like WARN_ON(), with the added feature that it
takes a printk like argument that is printed as part of the warning message.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |   16 ++++++++++++++++
 kernel/panic.c            |   24 ++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff -puN include/asm-generic/bug.h~add-a-warn-macro-this-is-warn_on-printk-arguments include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~add-a-warn-macro-this-is-warn_on-printk-arguments
+++ a/include/asm-generic/bug.h
@@ -34,9 +34,13 @@ struct bug_entry {
 #ifndef __WARN
 #ifndef __ASSEMBLY__
 extern void warn_on_slowpath(const char *file, const int line);
+extern void warn_slowpath(const char *file, const int line, const char *fmt, ...);
 #define WANT_WARN_ON_SLOWPATH
 #endif
 #define __WARN() warn_on_slowpath(__FILE__, __LINE__)
+#define __WARN_printf(arg...) warn_slowpath(__FILE__, __LINE__, arg)
+#else
+#define __WARN_printf(arg...) __WARN()
 #endif
 
 #ifndef WARN_ON
@@ -48,6 +52,18 @@ extern void warn_on_slowpath(const char 
 })
 #endif
 
+#ifndef WARN
+#define WARN(condition, format...) ({						\
+	int __ret_warn_on = !!(condition);				\
+	if (unlikely(__ret_warn_on))					\
+		__WARN_printf(format);					\
+	unlikely(__ret_warn_on);					\
+})
+#endif
+
+
+
+
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
 #define BUG()
diff -puN kernel/panic.c~add-a-warn-macro-this-is-warn_on-printk-arguments kernel/panic.c
--- a/kernel/panic.c~add-a-warn-macro-this-is-warn_on-printk-arguments
+++ a/kernel/panic.c
@@ -321,6 +321,30 @@ void warn_on_slowpath(const char *file, 
 	add_taint(TAINT_WARN);
 }
 EXPORT_SYMBOL(warn_on_slowpath);
+
+
+void warn_slowpath(const char *file, int line, const char *fmt, ...)
+{
+	va_list args;
+
+
+	char function[KSYM_SYMBOL_LEN];
+	unsigned long caller = (unsigned long) __builtin_return_address(0);
+	sprint_symbol(function, caller);
+
+	printk(KERN_WARNING "------------[ cut here ]------------\n");
+	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
+		line, function);
+	va_start(args, fmt);
+	vprintk(fmt, args);
+	va_end(args);
+
+	print_modules();
+	dump_stack();
+	print_oops_end_marker();
+	add_taint(TAINT_WARN);
+}
+EXPORT_SYMBOL(warn_slowpath);
 #endif
 
 #ifdef CONFIG_CC_STACKPROTECTOR
_

Patches currently in -mm which might be from arjan@linux.intel.com are

origin.patch
linux-next.patch
rename-warn-to-warning-to-clear-the-namespace.patch
add-a-warn-macro-this-is-warn_on-printk-arguments.patch
example-use-of-warn.patch

