From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?dynamic=5Fdebug-add-an-option-to-enable-dynamic-debug-for-m?=
 =?US-ASCII?Q?odules-only-v2.patch?= added to -mm tree
Date: Mon, 20 Apr 2020 12:45:55 -0700
Message-ID: <20200420194555.y-2ERc7tT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725896AbgDTTp5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 20 Apr 2020 15:45:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: corbet@lwn.net, gregkh@linuxfoundation.org, jbaron@akamai.com, mm-commits@vger.kernel.org, orson.zhai@unisoc.com, pmladek@suse.com, rdunlap@infradead.org, rostedt@goodmis.org, sergey.senozhatsky@gmail.com


The patch titled
     Subject: dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only-v2
has been added to the -mm tree.  Its filename is
     dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only-v2.patch

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
Subject: dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only-v2

1) Change DEBUG_MODULE to DYNAMIC_DEBUG_MODULE.
2) Change more #if defined(DYNAMIC_DEBUG) condition (in net.h, netdevice.h
   and ib_verbs.h).
3) Rewrite description in howto document.

Link: http://lkml.kernel.org/r/1587408228-10861-1-git-send-email-orson.unisoc@gmail.com
Signed-off-by: Orson Zhai <orson.zhai@unisoc.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/dynamic-debug-howto.rst |   10 ++++++----
 include/linux/dev_printk.h                        |    4 ++--
 include/linux/net.h                               |    3 ++-
 include/linux/netdevice.h                         |    6 ++++--
 include/linux/printk.h                            |    8 ++++----
 include/rdma/ib_verbs.h                           |    6 ++++--
 lib/Kconfig.debug                                 |    6 +++---
 7 files changed, 25 insertions(+), 18 deletions(-)

--- a/Documentation/admin-guide/dynamic-debug-howto.rst~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only-v2
+++ a/Documentation/admin-guide/dynamic-debug-howto.rst
@@ -13,11 +13,13 @@ kernel code to obtain additional kernel
 ``print_hex_dump_debug()``/``print_hex_dump_bytes()`` calls can be dynamically
 enabled per-callsite.
 
-If ``CONFIG_DYNAMIC_DEBUG_CORE`` is set, only the modules with ``DEBUG_MODULE``
-defined will be tied into dynamic debug.
+If you do not want to enable dynamic debug globally (i.e. in some embedded
+system), you may set ``CONFIG_DYNAMIC_DEBUG_CORE`` as basic support of dynamic
+debug and add ``ccflags := -DDYNAMIC_DEBUG_MODULE`` into the Makefile of any
+modules which you'd like to dynamically debug later.
 
-If ``CONFIG_DYNAMIC_DEBUG`` or ``CONFIG_DYNAMIC_DEBUG_CORE`` is not set,
-``print_hex_dump_debug()`` is just shortcut for ``print_hex_dump(KERN_DEBUG)``.
+If ``CONFIG_DYNAMIC_DEBUG`` is not set, ``print_hex_dump_debug()`` is just
+shortcut for ``print_hex_dump(KERN_DEBUG)``.
 
 For ``print_hex_dump_debug()``/``print_hex_dump_bytes()``, format string is
 its ``prefix_str`` argument, if it is constant string; or ``hexdump``
--- a/include/linux/dev_printk.h~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only-v2
+++ a/include/linux/dev_printk.h
@@ -110,7 +110,7 @@ void _dev_info(const struct device *dev,
 	_dev_info(dev, dev_fmt(fmt), ##__VA_ARGS__)
 
 #if defined(CONFIG_DYNAMIC_DEBUG) || \
-	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DEBUG_MODULE))
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define dev_dbg(dev, fmt, ...)						\
 	dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
 #elif defined(DEBUG)
@@ -183,7 +183,7 @@ do {									\
 #define dev_info_ratelimited(dev, fmt, ...)				\
 	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
 #if defined(CONFIG_DYNAMIC_DEBUG) || \
-	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DEBUG_MODULE))
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 /* descriptor check is first to prevent flooding with "callbacks suppressed" */
 #define dev_dbg_ratelimited(dev, fmt, ...)				\
 do {									\
--- a/include/linux/netdevice.h~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only-v2
+++ a/include/linux/netdevice.h
@@ -4868,7 +4868,8 @@ do {								\
 #define MODULE_ALIAS_NETDEV(device) \
 	MODULE_ALIAS("netdev-" device)
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define netdev_dbg(__dev, format, args...)			\
 do {								\
 	dynamic_netdev_dbg(__dev, format, ##args);		\
@@ -4938,7 +4939,8 @@ do {								\
 #define netif_info(priv, type, dev, fmt, args...)		\
 	netif_level(info, priv, type, dev, fmt, ##args)
 
-#if defined(CONFIG_DYNAMIC_DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG) || \
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define netif_dbg(priv, type, netdev, format, args...)		\
 do {								\
 	if (netif_msg_##type(priv))				\
--- a/include/linux/net.h~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only-v2
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
--- a/include/linux/printk.h~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only-v2
+++ a/include/linux/printk.h
@@ -288,7 +288,7 @@ extern int kptr_restrict;
  * All of these will print unconditionally, although note that pr_debug()
  * and other debug macros are compiled out unless either DEBUG is defined,
  * CONFIG_DYNAMIC_DEBUG is set, or CONFIG_DYNAMIC_DEBUG_CORE is set when
- * DEBUG_MODULE being defined for any modules.
+ * DYNAMIC_DEBUG_MODULE being defined for any modules.
  */
 #define pr_emerg(fmt, ...) \
 	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
@@ -324,7 +324,7 @@ extern int kptr_restrict;
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(CONFIG_DYNAMIC_DEBUG) || \
-	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DEBUG_MODULE))
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #include <linux/dynamic_debug.h>
 
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
@@ -451,7 +451,7 @@ extern int kptr_restrict;
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(CONFIG_DYNAMIC_DEBUG) || \
-	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DEBUG_MODULE))
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 /* descriptor check is first to prevent flooding with "callbacks suppressed" */
 #define pr_debug_ratelimited(fmt, ...)					\
 do {									\
@@ -499,7 +499,7 @@ static inline void print_hex_dump_bytes(
 #endif
 
 #if defined(CONFIG_DYNAMIC_DEBUG) || \
-	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DEBUG_MODULE))
+	(defined(CONFIG_DYNAMIC_DEBUG_CORE) && defined(DYNAMIC_DEBUG_MODULE))
 #define print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
 			     groupsize, buf, len, ascii)	\
 	dynamic_hex_dump(prefix_str, prefix_type, rowsize,	\
--- a/include/rdma/ib_verbs.h~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only-v2
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
--- a/lib/Kconfig.debug~dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only-v2
+++ a/lib/Kconfig.debug
@@ -173,9 +173,9 @@ config DYNAMIC_DEBUG_CORE
 	help
 	  Enable core functional support of dynamic debug. It is useful
 	  when you want to tie dynamic debug to your kernel modules with
-	  DEBUG_MODULE defined for each of them, especially for the case
-	  of embedded system where the kernel image size is sensitive for
-	  people.
+	  DYNAMIC_DEBUG_MODULE defined for each of them, especially for
+	  the case of embedded system where the kernel image size is
+	  sensitive for people.
 
 config SYMBOLIC_ERRNAME
 	bool "Support symbolic error names in printf"
_

Patches currently in -mm which might be from orson.zhai@unisoc.com are

dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only.patch
dynamic_debug-add-an-option-to-enable-dynamic-debug-for-modules-only-v2.patch
