From: akpm@linux-foundation.org
Subject: +
 radix-tree-test-suite-allow-gfp_atomic-allocations-to-fail.patch added to
 -mm tree
Date: Tue, 06 Dec 2016 12:50:12 -0800
Message-ID: <58472484.7/BXSbEtC8GehDou%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36854 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751905AbcLFUtm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 15:49:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: allow GFP_ATOMIC allocations to fail
has been added to the -mm tree.  Its filename is
     radix-tree-test-suite-allow-gfp_atomic-allocations-to-fail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-test-suite-allow-gfp_atomic-allocations-to-fail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-test-suite-allow-gfp_atomic-allocations-to-fail.patch

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
