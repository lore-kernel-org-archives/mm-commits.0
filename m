From: akpm@linux-foundation.org
Subject: - slab-introduce-krealloc.patch removed from -mm tree
Date: Mon, 07 May 2007 17:01:18 -0700
Message-ID: <200705080001.l4801IXa008763@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967304AbXEHABp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:01:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, clameter@sgi.com, jsipek@fsl.cs.sunysb.edu, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     slab: introduce krealloc
has been removed from the -mm tree.  Its filename was
     slab-introduce-krealloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slab: introduce krealloc
From: Pekka Enberg <penberg@cs.helsinki.fi>

This introduce krealloc() that reallocates memory while keeping the contents
unchanged.  The allocator avoids reallocation if the new size fits the
currently used cache.  I also added a simple non-optimized version for
mm/slob.c for compatibility.

[akpm@linux-foundation.org: fix warnings]
Acked-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Acked-by: Matt Mackall <mpm@selenic.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    3 +-
 mm/slab.c            |   49 ++++++++++++++++++++++++++++++++++++++++-
 mm/slob.c            |   35 ++++++++++++++++++++++++++++-
 3 files changed, 84 insertions(+), 3 deletions(-)

diff -puN include/linux/slab.h~slab-introduce-krealloc include/linux/slab.h
--- a/include/linux/slab.h~slab-introduce-krealloc
+++ a/include/linux/slab.h
@@ -72,8 +72,9 @@ static inline void *kmem_cache_alloc_nod
  */
 void *__kmalloc(size_t, gfp_t);
 void *__kzalloc(size_t, gfp_t);
+void * __must_check krealloc(const void *, size_t, gfp_t);
 void kfree(const void *);
-unsigned int ksize(const void *);
+size_t ksize(const void *);
 
 /**
  * kcalloc - allocate memory for an array. The memory is set to zero.
diff -puN mm/slab.c~slab-introduce-krealloc mm/slab.c
--- a/mm/slab.c~slab-introduce-krealloc
+++ a/mm/slab.c
@@ -3740,6 +3740,53 @@ EXPORT_SYMBOL(__kmalloc);
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
@@ -4481,7 +4528,7 @@ const struct seq_operations slabstats_op
  * allocated with either kmalloc() or kmem_cache_alloc(). The object
  * must not be freed during the duration of the call.
  */
-unsigned int ksize(const void *objp)
+size_t ksize(const void *objp)
 {
 	if (unlikely(objp == NULL))
 		return 0;
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
@@ -219,7 +252,7 @@ void kfree(const void *block)
 
 EXPORT_SYMBOL(kfree);
 
-unsigned int ksize(const void *block)
+size_t ksize(const void *block)
 {
 	bigblock_t *bb;
 	unsigned long flags;
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
unionfs-fix-slab-abuses-with-krealloc.patch
increase-slab-redzone-to-64bits.patch
module-use-krealloc.patch
slab-use-cpu_lock_.patch
separate-freezer-from-pm-code-rev-2.patch
introduce-freezer-flags-rev-2.patch
revoke-special-mmap-handling.patch
revoke-special-mmap-handling-vs-fault-vs-invalidate.patch
revoke-core-code.patch
revoke-core-code-misc-fixes.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-core-code-move-magic.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
revoke-core-code-fix-shared-mapping-revoke-revoke-only-revoke-mappings-for-the-given-inode.patch
revoke-core-code-break-cow-for-private-mappings.patch
revoke-core-code-generic_file_revoke-stub-for-nommu.patch
revoke-core-code-break-cow-fixes.patch
revoke-core-code-mapping-revocation.patch
revoke-core-code-only-fput-unused-files.patch
revoke-core-code-rename-to-can_revoke_filevma.patch
revoke-core-code-change-revoke_table-to-fileset-and-revoke_details.patch
revoke-core-code-do_revoke-error-handling.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
slab-leaks3-default-y.patch
