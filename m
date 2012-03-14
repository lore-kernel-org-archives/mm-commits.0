From: akpm@linux-foundation.org
Subject: [merged] slab-introduce-kmalloc_array.patch removed from -mm tree
Date: Wed, 14 Mar 2012 14:24:44 -0700
Message-ID: <20120314212444.8654AA076E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:55815 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965301Ab2CNVYr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Mar 2012 17:24:47 -0400
Received: by wibhj13 with SMTP id hj13so105420wib.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Mar 2012 14:24:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xi.wang@gmail.com, akpm@linux-foundation.org, axboe@kernel.dk, dan.carpenter@oracle.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: introduce kmalloc_array()
has been removed from the -mm tree.  Its filename was
     slab-introduce-kmalloc_array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xi Wang <xi.wang@gmail.com>
Subject: slab: introduce kmalloc_array()

Introduce a kmalloc_array() wrapper that performs integer overflow
checking without zeroing the memory.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN include/linux/slab.h~slab-introduce-kmalloc_array include/linux/slab.h
--- a/include/linux/slab.h~slab-introduce-kmalloc_array
+++ a/include/linux/slab.h
@@ -190,7 +190,7 @@ size_t ksize(const void *);
 #endif
 
 /**
- * kcalloc - allocate memory for an array. The memory is set to zero.
+ * kmalloc_array - allocate memory for an array.
  * @n: number of elements.
  * @size: element size.
  * @flags: the type of memory to allocate.
@@ -240,11 +240,22 @@ size_t ksize(const void *);
  * for general use, and so are not documented here. For a full list of
  * potential flags, always refer to linux/gfp.h.
  */
-static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
 {
 	if (size != 0 && n > ULONG_MAX / size)
 		return NULL;
-	return __kmalloc(n * size, flags | __GFP_ZERO);
+	return __kmalloc(n * size, flags);
+}
+
+/**
+ * kcalloc - allocate memory for an array. The memory is set to zero.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+{
+	return kmalloc_array(n, size, flags | __GFP_ZERO);
 }
 
 #if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB)
_

Patches currently in -mm which might be from xi.wang@gmail.com are

origin.patch
linux-next.patch

