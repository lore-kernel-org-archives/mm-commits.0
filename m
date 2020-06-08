From: akpm@linux-foundation.org
Subject: [merged]
 dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only.patch
 removed from -mm tree
Date: Mon, 08 Jun 2020 15:31:35 -0700
Message-ID: <20200608223135.u4qgtF9AV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbgFHWbh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 18:31:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, gregkh@linuxfoundation.org, jbaron@akamai.com, mm-commits@vger.kernel.org, orson.zhai@unisoc.com, pmladek@suse.com, rdunlap@infradead.org, rostedt@goodmis.org, sergey.senozhatsky@gmail.com


The patch titled
     Subject: dynamic_debug: add an option to enable dynamic debug for modules only
has been removed from the -mm tree.  Its filename was
     dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Orson Zhai <orson.zhai@unisoc.com>
Subject: dynamic_debug: add an option to enable dynamic debug for modules only

Instead of enabling dynamic debug globally with CONFIG_DYNAMIC_DEBUG,
CONFIG_DYNAMIC_DEBUG_CORE will only enable core function of dynamic debug.
With the DYNAMIC_DEBUG_MODULE defined for any modules, dynamic debug will
be tied to them.

This is useful for people who only want to enable dynamic debug for kernel
modules without worrying about kernel image size and memory consumption is
increasing too much.

[orson.zhai@unisoc.com: v2]
  Link: http://lkml.kernel.org/r/1587408228-10861-1-git-send-email-orson.unisoc@gmail.com
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

 Documentation/admin-guide/dynamic-debug-howto.rst |    5 +++++
 include/linux/dev_printk.h                        |    6 ++++--
 include/linux/dynamic_debug.h                     |    2 +-
 include/linux/net.h                               |    3 ++-
 include/linux/netdevice.h                         |    6 ++++--
 include/linux/printk.h                            |    9 ++++++---
 include/rdma/ib_verbs.h                           |    6 ++++--
 lib/Kconfig.debug                                 |   12 ++++++++++++
 lib/Makefile                                      |    2 +-
 lib/dynamic_debug.c                               |    9 +++++++--
 10 files changed, 46 insertions(+), 14 deletions(-)

--- a/Documentation/admin-guide/dynamic-debug-howto.rst~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only
+++ a/Documentation/admin-guide/dynamic-debug-howto.rst
@@ -13,6 +13,11 @@ kernel code to obtain additional kernel
 ``print_hex_dump_debug()``/``print_hex_dump_bytes()`` calls can be dynamically
 enabled per-callsite.
 
+If you do not want to enable dynamic debug globally (i.e. in some embedded
+system), you may set ``CONFIG_DYNAMIC_DEBUG_CORE`` as basic support of dynamic
+debug and add ``ccflags := -DDYNAMIC_DEBUG_MODULE`` into the Makefile of any
+modules which you'd like to dynamically debug later.
+
 If ``CONFIG_DYNAMIC_DEBUG`` is not set, ``print_hex_dump_debug()`` is just
 shortcut for ``print_hex_dump(KERN_DEBUG)``.
 
--- a/include/linux/dev_printk.h~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only
+++ a/include/linux/dev_printk.h
@@ -109,7 +109,8 @@ void _dev_info(const struct device *dev,
 #define dev_info(dev, fmt, ...)						\
 	_dev_info(dev, dev_fmt(fmt), ##__VA_ARGS__)
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define dev_dbg(dev, fmt, ...)						\
 	dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
 #elif defined(DEBUG)
@@ -181,7 +182,8 @@ do {									\
 	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
 #define dev_info_ratelimited(dev, fmt, ...)				\
 	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
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
--- a/include/linux/netdevice.h~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only
+++ a/include/linux/netdevice.h
@@ -4942,7 +4942,8 @@ do {								\
 #define MODULE_ALIAS_NETDEV(device) \
 	MODULE_ALIAS("netdev-" device)
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define netdev_dbg(__dev, format, args...)			\
 do {								\
 	dynamic_netdev_dbg(__dev, format, ##args);		\
@@ -5012,7 +5013,8 @@ do {								\
 #define netif_info(priv, type, dev, fmt, args...)		\
 	netif_level(info, priv, type, dev, fmt, ##args)
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define netif_dbg(priv, type, netdev, format, args...)		\
 do {								\
 	if (netif_msg_##type(priv))				\
--- a/include/linux/net.h~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only
+++ a/include/linux/net.h
@@ -264,7 +264,8 @@ do {								\
 	net_ratelimited_function(pr_warn, fmt, ##__VA_ARGS__)
 #define net_info_ratelimited(fmt, ...)				\
 	net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define net_dbg_ratelimited(fmt, ...)					\
 do {									\
 	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
--- a/include/linux/printk.h~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only
+++ a/include/linux/printk.h
@@ -399,7 +399,8 @@ extern int kptr_restrict;
 
 
 /* If you are writing a driver, please use dev_dbg instead */
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #include <linux/dynamic_debug.h>
 
 /**
@@ -535,7 +536,8 @@ extern int kptr_restrict;
 #endif
 
 /* If you are writing a driver, please use dev_dbg instead */
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 /* descriptor check is first to prevent flooding with "callbacks suppressed" */
 #define pr_debug_ratelimited(fmt, ...)					\
 do {									\
@@ -582,7 +584,8 @@ static inline void print_hex_dump_bytes(
 
 #endif
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
 			     groupsize, buf, len, ascii)	\
 	dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
--- a/include/rdma/ib_verbs.h~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only
+++ a/include/rdma/ib_verbs.h
@@ -100,7 +100,8 @@ void ibdev_notice(const struct ib_device
 __printf(2, 3) __cold
 void ibdev_info(const struct ib_device *ibdev, const char *format, ...);
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define ibdev_dbg(__dev, format, args...)                       \
 	dynamic_ibdev_dbg(__dev, format, ##args)
 #else
@@ -133,7 +134,8 @@ do {
 #define ibdev_info_ratelimited(ibdev, fmt, ...) \
 	ibdev_level_ratelimited(ibdev_info, ibdev, fmt, ##__VA_ARGS__)
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 /* descriptor check is first to prevent flooding with "callbacks suppressed" */
 #define ibdev_dbg_ratelimited(ibdev, fmt, ...)                          \
 do {                                                                    \
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
+	  DYNAMIC_DEBUG_MODULE defined for each of them, especially for
+	  the case of embedded system where the kernel image size is
+	  sensitive for people.
+
 config SYMBOLIC_ERRNAME
 	bool "Support symbolic error names in printf"
 	default y if PRINTK
--- a/lib/Makefile~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only
+++ a/lib/Makefile
@@ -190,7 +190,7 @@ lib-$(CONFIG_GENERIC_BUG) += bug.o
 
 obj-$(CONFIG_HAVE_ARCH_TRACEHOOK) += syscall.o
 
-obj-$(CONFIG_DYNAMIC_DEBUG) += dynamic_debug.o
+obj-$(CONFIG_DYNAMIC_DEBUG_CORE) += dynamic_debug.o
 obj-$(CONFIG_SYMBOLIC_ERRNAME) += errname.o
 
 obj-$(CONFIG_NLATTR) += nlattr.o
_

Patches currently in -mm which might be from orson.zhai@unisoc.com are
