From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only.patch
 added to -mm tree
Date: Mon, 13 Apr 2020 17:52:48 -0700
Message-ID: <20200414005248.a7HtAxYN8%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390654AbgDNAww (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Apr 2020 20:52:52 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, gregkh@linuxfoundation.org, jbaron@akamai.com, mm-commits@vger.kernel.org, orson.zhai@unisoc.com, pmladek@suse.com, rdunlap@infradead.org, rostedt@goodmis.org, sergey.senozhatsky@gmail.com


The patch titled
     Subject: dynamic_debug: add an option to enable dynamic debug for modules only
has been added to the -mm tree.  Its filename is
     dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Orson Zhai <orson.zhai@unisoc.com>
Subject: dynamic_debug: add an option to enable dynamic debug for modules only

Instead of enabling dynamic debug globally with CONFIG_DYNAMIC_DEBUG,
CONFIG_DYNAMIC_DEBUG_CORE will only enable core function of dynamic debug.
With the DEBUG_MODULE defined for any modules, dynamic debug will be tied
to them.

This is useful for people who only want to enable dynamic debug for kernel
modules without worrying about kernel image size and memory consumption
increasing too much.

Link: http://lkml.kernel.org/r/1586521984-5890-1-git-send-email-orson.unisoc@gmail.com
Signed-off-by: Orson Zhai <orson.zhai@unisoc.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/dynamic-debug-howto.rst |    7 ++++--
 include/linux/dev_printk.h                        |    6 +++--
 include/linux/dynamic_debug.h                     |    2 -
 include/linux/printk.h                            |   14 +++++++-----
 lib/Kconfig.debug                                 |   12 ++++++++++
 lib/Makefile                                      |    2 -
 lib/dynamic_debug.c                               |    9 ++++++-
 7 files changed, 39 insertions(+), 13 deletions(-)

--- a/Documentation/admin-guide/dynamic-debug-howto.rst~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only
+++ a/Documentation/admin-guide/dynamic-debug-howto.rst
@@ -13,8 +13,11 @@ kernel code to obtain additional kernel
 ``print_hex_dump_debug()``/``print_hex_dump_bytes()`` calls can be dynamically
 enabled per-callsite.
 
-If ``CONFIG_DYNAMIC_DEBUG`` is not set, ``print_hex_dump_debug()`` is just
-shortcut for ``print_hex_dump(KERN_DEBUG)``.
+If ``CONFIG_DYNAMIC_DEBUG_CORE`` is set, only the modules with ``DEBUG_MODULE``
+defined will be tied into dynamic debug.
+
+If ``CONFIG_DYNAMIC_DEBUG`` or ``CONFIG_DYNAMIC_DEBUG_CORE`` is not set,
+``print_hex_dump_debug()`` is just shortcut for ``print_hex_dump(KERN_DEBUG)``.
 
 For ``print_hex_dump_debug()``/``print_hex_dump_bytes()``, format string is
 its ``prefix_str`` argument, if it is constant string; or ``hexdump``
--- a/include/linux/dev_printk.h~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only
+++ a/include/linux/dev_printk.h
@@ -109,7 +109,8 @@ void _dev_info(const struct device *dev,
 #define dev_info(dev, fmt, ...)						\
 	_dev_info(dev, dev_fmt(fmt), ##__VA_ARGS__)
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DEBUG_MODULE))
 #define dev_dbg(dev, fmt, ...)						\
 	dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
 #elif defined(DEBUG)
@@ -181,7 +182,8 @@ do {									\
 	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
 #define dev_info_ratelimited(dev, fmt, ...)				\
 	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DEBUG_MODULE))
 /* descriptor check is first to prevent flooding with "callbacks suppressed" */
 #define dev_dbg_ratelimited(dev, fmt, ...)				\
 do {									\
--- a/include/linux/dynamic_debug.h~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only
+++ a/include/linux/dynamic_debug.h
@@ -48,7 +48,7 @@ struct _ddebug {
 
 
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG_CORE)
 int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 				const char *modname);
 extern int ddebug_remove_module(const char *mod_name);
--- a/include/linux/printk.h~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only
+++ a/include/linux/printk.h
@@ -286,8 +286,9 @@ extern int kptr_restrict;
 /*
  * These can be used to print at the various log levels.
  * All of these will print unconditionally, although note that pr_debug()
- * and other debug macros are compiled out unless either DEBUG is defined
- * or CONFIG_DYNAMIC_DEBUG is set.
+ * and other debug macros are compiled out unless either DEBUG is defined,
+ * CONFIG_DYNAMIC_DEBUG is set, or CONFIG_DYNAMIC_DEBUG_CORE is set when
+ * DEBUG_MODULE being defined for any modules.
  */
 #define pr_emerg(fmt, ...) \
 	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
@@ -322,7 +323,8 @@ extern int kptr_restrict;
 
 
 /* If you are writing a driver, please use dev_dbg instead */
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DEBUG_MODULE))
 #include <linux/dynamic_debug.h>
 
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
@@ -448,7 +450,8 @@ extern int kptr_restrict;
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DEBUG_MODULE))
 /* descriptor check is first to prevent flooding with "callbacks suppressed" */
 #define pr_debug_ratelimited(fmt, ...)					\
 do {									\
@@ -495,7 +498,8 @@ static inline void print_hex_dump_bytes(
 
 #endif
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DEBUG_MODULE))
 #define print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
 			     groupsize, buf, len, ascii)	\
 	dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
--- a/lib/dynamic_debug.c~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only
+++ a/lib/dynamic_debug.c
@@ -1032,8 +1032,13 @@ static int __init dynamic_debug_init(voi
 	int verbose_bytes = 0;
 
 	if (&__start___verbose == &__stop___verbose) {
-		pr_warn("_ddebug table is empty in a CONFIG_DYNAMIC_DEBUG build\n");
-		return 1;
+		if (IS_ENABLED(CONFIG_DYNAMIC_DEBUG)) {
+			pr_warn("_ddebug table is empty in a CONFIG_DYNAMIC_DEBUG build\n");
+			return 1;
+		}
+		pr_info("Ignore empty _ddebug table in a CONFIG_DYNAMIC_DEBUG_CORE build\n");
+		ddebug_init_success = 1;
+		return 0;
 	}
 	iter = __start___verbose;
 	modname = iter->modname;
--- a/lib/Kconfig.debug~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only
+++ a/lib/Kconfig.debug
@@ -99,6 +99,7 @@ config DYNAMIC_DEBUG
 	default n
 	depends on PRINTK
 	depends on (DEBUG_FS || PROC_FS)
+	select DYNAMIC_DEBUG_CORE
 	help
 
 	  Compiles debug level messages into the kernel, which would not
@@ -165,6 +166,17 @@ config DYNAMIC_DEBUG
 	  See Documentation/admin-guide/dynamic-debug-howto.rst for additional
 	  information.
 
+config DYNAMIC_DEBUG_CORE
+	bool "Enable core function of dynamic debug support"
+	depends on PRINTK
+	depends on (DEBUG_FS || PROC_FS)
+	help
+	  Enable core functional support of dynamic debug. It is useful
+	  when you want to tie dynamic debug to your kernel modules with
+	  DEBUG_MODULE defined for each of them, especially for the case
+	  of embedded system where the kernel image size is sensitive for
+	  people.
+
 config SYMBOLIC_ERRNAME
 	bool "Support symbolic error names in printf"
 	default y if PRINTK
--- a/lib/Makefile~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only
+++ a/lib/Makefile
@@ -186,7 +186,7 @@ lib-$(CONFIG_GENERIC_BUG) += bug.o
 
 obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += syscall.o
 
-obj-$(CONFIG_DYNAMIC_DEBUG) += dynamic_debug.o
+obj-$(CONFIG_DYNAMIC_DEBUG_CORE) += dynamic_debug.o
 obj-$(CONFIG_SYMBOLIC_ERRNAME) += errname.o
 
 obj-$(CONFIG_NLATTR) += nlattr.o
_

Patches currently in -mm which might be from orson.zhai@unisoc.com are

dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only.patch
