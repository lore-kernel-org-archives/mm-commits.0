From: akpm@linux-foundation.org
Subject: [patch 081/114] radix tree test suite: allow GFP_ATOMIC
 allocations to fail
Date: Wed, 14 Dec 2016 15:07:59 -0800
Message-ID: <5851d0cf.9/p31u6TwKH5GaEP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35222 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753036AbcLNXIA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:08:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix tree test suite: allow GFP_ATOMIC allocations to fail

In order to test the preload code, it is necessary to fail GFP_ATOMIC
allocations, which requires defining GFP_KERNEL and GFP_ATOMIC properly. 
Remove the obsolete __GFP_WAIT and copy the definitions of the __GFP flags
which are used from the kernel include files.  We also need the real
definition of gfpflags_allow_blocking() to persuade the radix tree to
actually use its preallocated nodes.

Link: http://lkml.kernel.org/r/1480369871-5271-38-git-send-email-mawilcox@linuxonhyperv.com
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux.c      |    7 ++++++-
 tools/testing/radix-tree/linux/gfp.h  |   22 +++++++++++++++++++---
 tools/testing/radix-tree/linux/slab.h |    5 -----
 3 files changed, 25 insertions(+), 9 deletions(-)

diff -puN tools/testing/radix-tree/linux.c~radix-tree-test-suite-allow-gfp_atomic-allocations-to-fail tools/testing/radix-tree/linux.c
--- a/tools/testing/radix-tree/linux.c~radix-tree-test-suite-allow-gfp_atomic-allocations-to-fail
+++ a/tools/testing/radix-tree/linux.c
@@ -33,7 +33,12 @@ mempool_t *mempool_create(int min_nr, me
 
 void *kmem_cache_alloc(struct kmem_cache *cachep, int flags)
 {
-	void *ret = malloc(cachep->size);
+	void *ret;
+
+	if (flags & __GFP_NOWARN)
+		return NULL;
+
+	ret = malloc(cachep->size);
 	if (cachep->ctor)
 		cachep->ctor(ret);
 	uatomic_inc(&nr_allocated);
diff -puN tools/testing/radix-tree/linux/gfp.h~radix-tree-test-suite-allow-gfp_atomic-allocations-to-fail tools/testing/radix-tree/linux/gfp.h
--- a/tools/testing/radix-tree/linux/gfp.h~radix-tree-test-suite-allow-gfp_atomic-allocations-to-fail
+++ a/tools/testing/radix-tree/linux/gfp.h
@@ -3,8 +3,24 @@
 
 #define __GFP_BITS_SHIFT 26
 #define __GFP_BITS_MASK ((gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
-#define __GFP_WAIT 1
-#define __GFP_ACCOUNT 0
-#define __GFP_NOWARN 0
+
+#define __GFP_HIGH		0x20u
+#define __GFP_IO		0x40u
+#define __GFP_FS		0x80u
+#define __GFP_NOWARN		0x200u
+#define __GFP_ATOMIC		0x80000u
+#define __GFP_ACCOUNT		0x100000u
+#define __GFP_DIRECT_RECLAIM	0x400000u
+#define __GFP_KSWAPD_RECLAIM	0x2000000u
+
+#define __GFP_RECLAIM		(__GFP_DIRECT_RECLAIM|__GFP_KSWAPD_RECLAIM)
+
+#define GFP_ATOMIC		(__GFP_HIGH|__GFP_ATOMIC|__GFP_KSWAPD_RECLAIM)
+#define GFP_KERNEL		(__GFP_RECLAIM | __GFP_IO | __GFP_FS)
+
+static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
+{
+	return !!(gfp_flags & __GFP_DIRECT_RECLAIM);
+}
 
 #endif
diff -puN tools/testing/radix-tree/linux/slab.h~radix-tree-test-suite-allow-gfp_atomic-allocations-to-fail tools/testing/radix-tree/linux/slab.h
--- a/tools/testing/radix-tree/linux/slab.h~radix-tree-test-suite-allow-gfp_atomic-allocations-to-fail
+++ a/tools/testing/radix-tree/linux/slab.h
@@ -7,11 +7,6 @@
 #define SLAB_PANIC 2
 #define SLAB_RECLAIM_ACCOUNT    0x00020000UL            /* Objects are reclaimable */
 
-static inline int gfpflags_allow_blocking(gfp_t mask)
-{
-	return 1;
-}
