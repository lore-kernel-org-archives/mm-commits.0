From: akpm@linux-foundation.org
Subject: [merged] dynamic_debug-only-add-header-when-used.patch removed
 from -mm tree
Date: Wed, 03 Aug 2016 11:11:56 -0700
Message-ID: <57a233ec.kCsKkdvdXzCB3ChB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564AbcHCSN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luisbg@osg.samsung.com, bp@suse.de, hidehiro.kawai.ez@hitachi.com, joe@perches.com, linux@rasmusvillemoes.dk, mina86@mina86.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: dynamic_debug: only add header when used
has been removed from the -mm tree.  Its filename was
     dynamic_debug-only-add-header-when-used.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: dynamic_debug: only add header when used

kernel.h header doesn't directly use dynamic debug, instead we can include
it in module.c (which used it via kernel.h).  printk.h only uses it if
CONFIG_DYNAMIC_DEBUG is on, changing the inclusion to only happen in that
case.

Link: http://lkml.kernel.org/r/1468429793-16917-1-git-send-email-luisbg@osg.samsung.com
[luisbg@osg.samsung.com: include dynamic_debug.h in drb_int.h]
  Link: http://lkml.kernel.org/r/1468447828-18558-2-git-send-email-luisbg@osg.samsung.com
Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_actlog.c |    1 -
 drivers/block/drbd/drbd_int.h    |    1 +
 include/linux/kernel.h           |    1 -
 include/linux/printk.h           |    3 ++-
 kernel/module.c                  |    1 +
 5 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/block/drbd/drbd_actlog.c~dynamic_debug-only-add-header-when-used drivers/block/drbd/drbd_actlog.c
--- a/drivers/block/drbd/drbd_actlog.c~dynamic_debug-only-add-header-when-used
+++ a/drivers/block/drbd/drbd_actlog.c
@@ -27,7 +27,6 @@
 #include <linux/crc32c.h>
 #include <linux/drbd.h>
 #include <linux/drbd_limits.h>
-#include <linux/dynamic_debug.h>
 #include "drbd_int.h"
 
 
diff -puN drivers/block/drbd/drbd_int.h~dynamic_debug-only-add-header-when-used drivers/block/drbd/drbd_int.h
--- a/drivers/block/drbd/drbd_int.h~dynamic_debug-only-add-header-when-used
+++ a/drivers/block/drbd/drbd_int.h
@@ -41,6 +41,7 @@
 #include <linux/backing-dev.h>
 #include <linux/genhd.h>
 #include <linux/idr.h>
+#include <linux/dynamic_debug.h>
 #include <net/tcp.h>
 #include <linux/lru_cache.h>
 #include <linux/prefetch.h>
diff -puN include/linux/kernel.h~dynamic_debug-only-add-header-when-used include/linux/kernel.h
--- a/include/linux/kernel.h~dynamic_debug-only-add-header-when-used
+++ a/include/linux/kernel.h
@@ -11,7 +11,6 @@
 #include <linux/log2.h>
 #include <linux/typecheck.h>
 #include <linux/printk.h>
-#include <linux/dynamic_debug.h>
 #include <asm/byteorder.h>
 #include <uapi/linux/kernel.h>
 
diff -puN include/linux/printk.h~dynamic_debug-only-add-header-when-used include/linux/printk.h
--- a/include/linux/printk.h~dynamic_debug-only-add-header-when-used
+++ a/include/linux/printk.h
@@ -289,10 +289,11 @@ extern asmlinkage void dump_stack(void)
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
-#include <linux/dynamic_debug.h>
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(CONFIG_DYNAMIC_DEBUG)
+#include <linux/dynamic_debug.h>
+
 /* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
 #define pr_debug(fmt, ...) \
 	dynamic_pr_debug(fmt, ##__VA_ARGS__)
diff -puN kernel/module.c~dynamic_debug-only-add-header-when-used kernel/module.c
--- a/kernel/module.c~dynamic_debug-only-add-header-when-used
+++ a/kernel/module.c
@@ -60,6 +60,7 @@
 #include <linux/jump_label.h>
 #include <linux/pfn.h>
 #include <linux/bsearch.h>
+#include <linux/dynamic_debug.h>
 #include <uapi/linux/module.h>
 #include "module-internal.h"
 
_

Patches currently in -mm which might be from luisbg@osg.samsung.com are


