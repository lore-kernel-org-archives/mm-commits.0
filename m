From: akpm@linux-foundation.org
Subject: - add-a-warn-macro-this-is-warn_on-printk-arguments.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:22 -0700
Message-ID: <200807252255.m6PMtMwH002971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753003AbYGYWzy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:55:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, greg@kroah.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Add a WARN() macro; this is WARN_ON() + printk arguments
has been removed from the -mm tree.  Its filename was
     add-a-warn-macro-this-is-warn_on-printk-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add a WARN() macro; this is WARN_ON() + printk arguments
From: Arjan van de Ven <arjan@linux.intel.com>

Add a WARN() macro that acts like WARN_ON(), with the added feature that it
takes a printk like argument that is printed as part of the warning message.

[akpm@linux-foundation.org: fix printk arguments]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/bug.h |   22 ++++++++++++++++++++++
 kernel/panic.c            |   22 ++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff -puN include/asm-generic/bug.h~add-a-warn-macro-this-is-warn_on-printk-arguments include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~add-a-warn-macro-this-is-warn_on-printk-arguments
+++ a/include/asm-generic/bug.h
@@ -34,9 +34,14 @@ struct bug_entry {
 #ifndef __WARN
 #ifndef __ASSEMBLY__
 extern void warn_on_slowpath(const char *file, const int line);
+extern void warn_slowpath(const char *file, const int line,
+		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
 #define WANT_WARN_ON_SLOWPATH
 #endif
 #define __WARN() warn_on_slowpath(__FILE__, __LINE__)
+#define __WARN_printf(arg...) warn_slowpath(__FILE__, __LINE__, arg)
+#else
+#define __WARN_printf(arg...) __WARN()
 #endif
 
 #ifndef WARN_ON
@@ -48,6 +53,15 @@ extern void warn_on_slowpath(const char 
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
 #else /* !CONFIG_BUG */
 #ifndef HAVE_ARCH_BUG
 #define BUG()
@@ -63,6 +77,14 @@ extern void warn_on_slowpath(const char 
 	unlikely(__ret_warn_on);					\
 })
 #endif
+
+#ifndef WARN
+#define WARN(condition, format...) ({					\
+	int __ret_warn_on = !!(condition);				\
+	unlikely(__ret_warn_on);					\
+})
+#endif
+
 #endif
 
 #define WARN_ON_ONCE(condition)	({				\
diff -puN kernel/panic.c~add-a-warn-macro-this-is-warn_on-printk-arguments kernel/panic.c
--- a/kernel/panic.c~add-a-warn-macro-this-is-warn_on-printk-arguments
+++ a/kernel/panic.c
@@ -318,6 +318,28 @@ void warn_on_slowpath(const char *file, 
 	add_taint(TAINT_WARN);
 }
 EXPORT_SYMBOL(warn_on_slowpath);
+
+
+void warn_slowpath(const char *file, int line, const char *fmt, ...)
+{
+	va_list args;
+	char function[KSYM_SYMBOL_LEN];
+	unsigned long caller = (unsigned long)__builtin_return_address(0);
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
via-velocity-fix-sleep-with-spinlock-bug-during-mtu-change.patch
modules-extend-initcall_debug-functionality-to-the-module-loader.patch
use-warn-in-kernel-irq-managec.patch
use-warn-in-mm-vmallocc.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-kernel-irq-chipc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch
use-warn-in-block.patch
use-warn-in-drivers-base.patch
use-warn-in-lib.patch
use-warn-in-fs.patch
usr-warn-in-fs-sysfs.patch
use-warn-in-fs-proc.patch

