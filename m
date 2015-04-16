From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:52:15 -0700
Message-ID: <552fe8bf.FQ/yoqsIvrGyVumW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbbDPQqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, catalin.marinas@arm.com, hch@lst.de, mpatocka@redhat.com, sebott@linux.vnet.ibm.com, shaggy@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mempool: disallow mempools based on slab caches with constructors
has been removed from the -mm tree.  Its filename was
     mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mempool: disallow mempools based on slab caches with constructors

All occurrences of mempools based on slab caches with object constructors
have been removed from the tree, so disallow creating them.

We can only dereference mem->ctor in mm/mempool.c without including
mm/slab.h in include/linux/mempool.h.  So simply note the restriction,
just like the comment restricting usage of __GFP_ZERO, and warn on kernels
with CONFIG_DEBUG_VM() if such a mempool is allocated from.

We don't want to incur this check on every element allocation, so use
VM_BUG_ON().

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempool.h |    3 ++-
 mm/mempool.c            |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/mempool.h~mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors include/linux/mempool.h
--- a/include/linux/mempool.h~mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors
+++ a/include/linux/mempool.h
@@ -36,7 +36,8 @@ extern void mempool_free(void *element,
 
 /*
  * A mempool_alloc_t and mempool_free_t that get the memory from
- * a slab that is passed in through pool_data.
+ * a slab cache that is passed in through pool_data.
+ * Note: the slab cache may not have a ctor function.
  */
 void *mempool_alloc_slab(gfp_t gfp_mask, void *pool_data);
 void mempool_free_slab(void *element, void *pool_data);
diff -puN mm/mempool.c~mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors mm/mempool.c
--- a/mm/mempool.c~mm-mempool-disallow-mempools-based-on-slab-caches-with-constructors
+++ a/mm/mempool.c
@@ -15,6 +15,7 @@
 #include <linux/mempool.h>
 #include <linux/blkdev.h>
 #include <linux/writeback.h>
+#include "slab.h"
 
 static void add_element(mempool_t *pool, void *element)
 {
@@ -334,6 +335,7 @@ EXPORT_SYMBOL(mempool_free);
 void *mempool_alloc_slab(gfp_t gfp_mask, void *pool_data)
 {
 	struct kmem_cache *mem = pool_data;
+	VM_BUG_ON(mem->ctor);
 	return kmem_cache_alloc(mem, gfp_mask);
 }
 EXPORT_SYMBOL(mempool_alloc_slab);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-bulk-allocation-from-per-cpu-partial-pages.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
cxgb4-drop-__gfp_nofail-allocation.patch

