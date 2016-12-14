From: akpm@linux-foundation.org
Subject: [patch 110/114] radix tree test suite: add some more
 functionality
Date: Wed, 14 Dec 2016 15:09:25 -0800
Message-ID: <5851d125.OOVBR1BnbJYC19KZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35562 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933077AbcLNXJ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:09:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix tree test suite: add some more functionality

IDR needs more functionality from the kernel: kmalloc()/kfree(), and xchg().

Link: http://lkml.kernel.org/r/1480369871-5271-67-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
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
