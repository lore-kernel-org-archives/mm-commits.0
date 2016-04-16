From: akpm@linux-foundation.org
Subject: + radix-tree-test-suite-fix-build.patch added to -mm tree
Date: Fri, 15 Apr 2016 22:57:58 -0700
Message-ID: <5711d466.e6N1SUD+YDP2zoal%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbcDPF57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 01:57:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: fix build
has been added to the -mm tree.  Its filename is
     radix-tree-test-suite-fix-build.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-test-suite-fix-build.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-test-suite-fix-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
-
 static inline void INIT_LIST_HEAD(struct list_head *list)
 {
 	list->next = list;
@@ -22,7 +20,6 @@ typedef struct {
 
 #define uninitialized_var(x) x = x
 
-typedef unsigned gfp_t;
 #include <linux/gfp.h>
 
 #endif
_

Patches currently in -mm which might be from willy@linux.intel.com are

radix-tree-introduce-radix_tree_empty.patch
radix-tree-test-suite-fix-build.patch
radix-tree-test-suite-add-tests-for-radix_tree_locate_item.patch
introduce-config_radix_tree_multiorder.patch
radix-tree-add-missing-sibling-entry-functionality.patch
radix-tree-fix-sibling-entry-insertion.patch
radix-tree-fix-deleting-a-multi-order-entry-through-an-alias.patch
radix-tree-remove-restriction-on-multi-order-entries.patch
radix-tree-introduce-radix_tree_load_root.patch
radix-tree-fix-extending-the-tree-for-multi-order-entries-at-offset-0.patch
radix-tree-test-suite-start-adding-multiorder-tests.patch
radix-tree-fix-several-shrinking-bugs-with-multiorder-entries.patch
radix-tree-rewrite-__radix_tree_lookup.patch
radix-tree-fix-multiorder-bug_on-in-radix_tree_insert.patch
radix-tree-fix-radix_tree_create-for-sibling-entries.patch
radix-tree-rewrite-radix_tree_locate_item.patch
radix-tree-fix-radix_tree_range_tag_if_tagged-for-multiorder-entries.patch
radix-tree-add-copyright-statements.patch

