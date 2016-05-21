From: akpm@linux-foundation.org
Subject: [patch 100/162] radix tree test suite: fix build
Date: Fri, 20 May 2016 17:01:36 -0700
Message-ID: <573fa560.bOBhXMYrcd399dCN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbcEUABh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:01:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix tree test suite: fix build

Add an empty linux/init.h, and definitions for a few parts of the kernel
API either in use now, or to be used in the near future.  Start using the
common definitions in tools/include/linux, although more work needs to be
done here.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux/kernel.h |   12 ++++++++++--
 tools/testing/radix-tree/linux/slab.h   |    1 -
 tools/testing/radix-tree/linux/types.h  |    7 ++-----
 3 files changed, 12 insertions(+), 8 deletions(-)

diff -puN tools/testing/radix-tree/linux/kernel.h~radix-tree-test-suite-fix-build tools/testing/radix-tree/linux/kernel.h
--- a/tools/testing/radix-tree/linux/kernel.h~radix-tree-test-suite-fix-build
+++ a/tools/testing/radix-tree/linux/kernel.h
@@ -7,19 +7,25 @@
 #include <stddef.h>
 #include <limits.h>
 
+#include "../../include/linux/compiler.h"
+
 #ifndef NULL
 #define NULL	0
 #endif
 
 #define BUG_ON(expr)	assert(!(expr))
+#define WARN_ON(expr)	assert(!(expr))
 #define __init
 #define __must_check
 #define panic(expr)
 #define printk printf
 #define __force
-#define likely(c) (c)
-#define unlikely(c) (c)
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
+#define pr_debug printk
+
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define cpu_relax()	barrier()
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
 
@@ -28,6 +34,8 @@
 	(type *)( (char *)__mptr - offsetof(type, member) );})
 #define min(a, b) ((a) < (b) ? (a) : (b))
 
+#define cond_resched()	sched_yield()
+
 static inline int in_interrupt(void)
 {
 	return 0;
diff -puN tools/testing/radix-tree/linux/slab.h~radix-tree-test-suite-fix-build tools/testing/radix-tree/linux/slab.h
--- a/tools/testing/radix-tree/linux/slab.h~radix-tree-test-suite-fix-build
+++ a/tools/testing/radix-tree/linux/slab.h
@@ -3,7 +3,6 @@
 
 #include <linux/types.h>
 
-#define GFP_KERNEL 1
 #define SLAB_HWCACHE_ALIGN 1
 #define SLAB_PANIC 2
 #define SLAB_RECLAIM_ACCOUNT    0x00020000UL            /* Objects are reclaimable */
diff -puN tools/testing/radix-tree/linux/types.h~radix-tree-test-suite-fix-build tools/testing/radix-tree/linux/types.h
--- a/tools/testing/radix-tree/linux/types.h~radix-tree-test-suite-fix-build
+++ a/tools/testing/radix-tree/linux/types.h
@@ -1,15 +1,13 @@
 #ifndef _TYPES_H
 #define _TYPES_H
 
+#include "../../include/linux/types.h"
+
 #define __rcu
 #define __read_mostly
 
 #define BITS_PER_LONG (sizeof(long) * 8)
 
-struct list_head {
-	struct list_head *next, *prev;
-};
