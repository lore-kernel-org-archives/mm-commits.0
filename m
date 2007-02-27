From: akpm@linux-foundation.org
Subject: + slab-introduce-krealloc.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:34:08 -0800
Message-ID: <200702272034.l1RKYBMU027549@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50683 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbXB0Ueb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:34:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: penberg@cs.helsinki.fi, clameter@sgi.com, jsipek@fsl.cs.sunysb.edu, mpm@selenic.com


The patch titled
     slab: introduce krealloc
has been added to the -mm tree.  Its filename is
     slab-introduce-krealloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slab: introduce krealloc
From: Pekka Enberg <penberg@cs.helsinki.fi>

This introduce krealloc() that reallocates memory while keeping the contents
unchanged.  The allocator avoids reallocation if the new size fits the
currently used cache.  I also added a simple non-optimized version for
mm/slob.c for compatibility.

Acked-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Acked-by: Matt Mackall <mpm@selenic.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    1 
 mm/slab.c            |   47 +++++++++++++++++++++++++++++++++++++++++
 mm/slob.c            |   33 ++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+)

diff -puN include/linux/slab.h~slab-introduce-krealloc include/linux/slab.h
--- a/include/linux/slab.h~slab-introduce-krealloc
+++ a/include/linux/slab.h
@@ -72,6 +72,7 @@ static inline void *kmem_cache_alloc_nod
  */
 void *__kmalloc(size_t, gfp_t);
 void *__kzalloc(size_t, gfp_t);
+void * __must_check krealloc(const void *, size_t, gfp_t);
 void kfree(const void *);
 unsigned int ksize(const void *);
 
diff -puN mm/slab.c~slab-introduce-krealloc mm/slab.c
--- a/mm/slab.c~slab-introduce-krealloc
+++ a/mm/slab.c
@@ -3737,6 +3737,53 @@ EXPORT_SYMBOL(__kmalloc);
 #endif
 
 /**
+ * krealloc - reallocate memory. The contents will remain unchanged.
+ *
+ * @p: object to reallocate memory for.
+ * @new_size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate.
+ *
+ * The contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.  If @p is %NULL, krealloc()
+ * behaves exactly like kmalloc().  If @size is 0 and @p is not a
+ * %NULL pointer, the object pointed to is freed.
+ */
+void *krealloc(const void *p, size_t new_size, gfp_t flags)
+{
+	struct kmem_cache *cache, *new_cache;
+	void *ret;
+
+	if (unlikely(!p))
+		return kmalloc_track_caller(new_size, flags);
+
+	if (unlikely(!new_size)) {
+		kfree(p);
+		return NULL;
+	}
+
+	cache = virt_to_cache(p);
+	new_cache = __find_general_cachep(new_size, flags);
+
+	/*
+ 	 * If new size fits in the current cache, bail out.
+ 	 */
+	if (likely(cache == new_cache))
+		return (void *)p;
+
+	/*
+ 	 * We are on the slow-path here so do not use __cache_alloc
+ 	 * because it bloats kernel text.
+ 	 */
+	ret = kmalloc_track_caller(new_size, flags);
+	if (ret) {
+		memcpy(ret, p, min(new_size, ksize(p)));
+		kfree(p);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(krealloc);
+
+/**
  * kmem_cache_free - Deallocate an object
  * @cachep: The cache the allocation was from.
  * @objp: The previously allocated object.
diff -puN mm/slob.c~slab-introduce-krealloc mm/slob.c
--- a/mm/slob.c~slab-introduce-krealloc
+++ a/mm/slob.c
@@ -190,6 +190,39 @@ void *__kmalloc(size_t size, gfp_t gfp)
 }
 EXPORT_SYMBOL(__kmalloc);
 
+/**
+ * krealloc - reallocate memory. The contents will remain unchanged.
+ *
+ * @p: object to reallocate memory for.
+ * @new_size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate.
+ *
+ * The contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.  If @p is %NULL, krealloc()
+ * behaves exactly like kmalloc().  If @size is 0 and @p is not a
+ * %NULL pointer, the object pointed to is freed.
+ */
+void *krealloc(const void *p, size_t new_size, gfp_t flags)
+{
+	void *ret;
+
+	if (unlikely(!p))
+		return kmalloc_track_caller(new_size, flags);
+
+	if (unlikely(!new_size)) {
+		kfree(p);
+		return NULL;
+	}
+
+	ret = kmalloc_track_caller(new_size, flags);
+	if (ret) {
+		memcpy(ret, p, min(new_size, ksize(p)));
+		kfree(p);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(krealloc);
+
 void kfree(const void *block)
 {
 	bigblock_t *bb, **last = &bigblocks;
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

slab-introduce-krealloc.patch
unionfs-fix-slab-abuses-with-krealloc.patch
slab-ensure-cache_alloc_refill-terminates.patch
slab-remove-colouroff-from-struct-slab.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
slab-leaks3-default-y.patch
