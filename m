From: akpm@linux-foundation.org
Subject: + slab-introduce-kmalloc_array.patch added to -mm tree
Date: Thu, 09 Feb 2012 13:25:12 -0800
Message-ID: <20120209212512.6DFE3A023F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:61598 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2BIVZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2012 16:25:13 -0500
Received: by yhgm50 with SMTP id m50so244932yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Feb 2012 13:25:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xi.wang@gmail.com, akpm@linux-foundation.org, axboe@kernel.dk, dan.carpenter@oracle.com, penberg@kernel.org


The patch titled
     Subject: slab: introduce kmalloc_array()
has been added to the -mm tree.  Its filename is
     slab-introduce-kmalloc_array.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: slab: introduce kmalloc_array()

Patches currently in -mm which might be from xi.wang@gmail.com are

linux-next.patch
slab-introduce-kmalloc_array.patch

