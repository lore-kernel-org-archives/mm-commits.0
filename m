From: akpm@linux-foundation.org
Subject: + radix-tree-test-suite-add-some-more-functionality.patch added
 to -mm tree
Date: Tue, 06 Dec 2016 12:51:20 -0800
Message-ID: <584724c8.J6phXukA/GsyCq7+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37088 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752273AbcLFUuv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 15:50:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: add some more functionality
has been added to the -mm tree.  Its filename is
     radix-tree-test-suite-add-some-more-functionality.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-test-suite-add-some-more-functionality.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-test-suite-add-some-more-functionality.patch

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
Subject: radix tree test suite: add some more functionality

IDR needs more functionality from the kernel: kmalloc()/kfree(), and xchg().

Link: http://lkml.kernel.org/r/1480369871-5271-67-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux.c        |   15 +++++++++++++++
 tools/testing/radix-tree/linux/kernel.h |    3 +++
 tools/testing/radix-tree/linux/slab.h   |    3 +++
 3 files changed, 21 insertions(+)

diff -puN tools/testing/radix-tree/linux.c~radix-tree-test-suite-add-some-more-functionality tools/testing/radix-tree/linux.c
--- a/tools/testing/radix-tree/linux.c~radix-tree-test-suite-add-some-more-functionality
+++ a/tools/testing/radix-tree/linux.c
@@ -54,6 +54,21 @@ void kmem_cache_free(struct kmem_cache *
 	free(objp);
 }
 
+void *kmalloc(size_t size, gfp_t gfp)
+{
+	void *ret = malloc(size);
+	uatomic_inc(&nr_allocated);
+	return ret;
+}
+
+void kfree(void *p)
+{
+	if (!p)
+		return;
+	uatomic_dec(&nr_allocated);
+	free(p);
+}
+
 struct kmem_cache *
 kmem_cache_create(const char *name, size_t size, size_t offset,
 	unsigned long flags, void (*ctor)(void *))
diff -puN tools/testing/radix-tree/linux/kernel.h~radix-tree-test-suite-add-some-more-functionality tools/testing/radix-tree/linux/kernel.h
--- a/tools/testing/radix-tree/linux/kernel.h~radix-tree-test-suite-add-some-more-functionality
+++ a/tools/testing/radix-tree/linux/kernel.h
@@ -8,6 +8,7 @@
 #include <limits.h>
 
 #include "../../include/linux/compiler.h"
+#include "../../include/linux/err.h"
 #include "../../../include/linux/kconfig.h"
 
 #ifdef BENCHMARK
@@ -58,4 +59,6 @@ static inline int in_interrupt(void)
 #define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
 #define round_down(x, y) ((x) & ~__round_mask(x, y))
 
+#define xchg(ptr, x)	uatomic_xchg(ptr, x)
+
 #endif /* _KERNEL_H */
diff -puN tools/testing/radix-tree/linux/slab.h~radix-tree-test-suite-add-some-more-functionality tools/testing/radix-tree/linux/slab.h
--- a/tools/testing/radix-tree/linux/slab.h~radix-tree-test-suite-add-some-more-functionality
+++ a/tools/testing/radix-tree/linux/slab.h
@@ -7,6 +7,9 @@
 #define SLAB_PANIC 2
 #define SLAB_RECLAIM_ACCOUNT    0x00020000UL            /* Objects are reclaimable */
 
+void *kmalloc(size_t size, gfp_t);
+void kfree(void *);
+
 struct kmem_cache {
 	int size;
 	void (*ctor)(void *);
_

Patches currently in -mm which might be from willy@linux.intel.com are

tools-add-warn_on_once.patch
radix-tree-test-suite-allow-gfp_atomic-allocations-to-fail.patch
tools-add-more-bitmap-functions.patch
radix-tree-test-suite-use-common-find-bit-code.patch
radix-tree-fix-typo.patch
radix-tree-create-node_tag_set.patch
radix-tree-make-radix_tree_find_next_bit-more-useful.patch
radix-tree-add-radix_tree_join.patch
radix-tree-add-radix_tree_split.patch
radix-tree-add-radix_tree_split_preload.patch
idr-add-ida_is_empty.patch
idr-reduce-the-number-of-bits-per-level-from-8-to-6.patch
radix-tree-test-suite-add-some-more-functionality.patch
reimplement-idr-and-ida-using-the-radix-tree.patch

