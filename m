From: akpm@linux-foundation.org
Subject: +
 slab-infrastructure-for-bulk-object-allocation-and-freeing.patch added to
 -mm tree
Date: Thu, 09 Jul 2015 12:03:07 -0700
Message-ID: <559ec56b.KNWEIKWpOlFN9A9e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbbGITDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 15:03:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, brouer@redhat.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slab: infrastructure for bulk object allocation and freeing
has been added to the -mm tree.  Its filename is
     slab-infrastructure-for-bulk-object-allocation-and-freeing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/slab-infrastructure-for-bulk-object-allocation-and-freeing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/slab-infrastructure-for-bulk-object-allocation-and-freeing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Lameter <cl@linux.com>
Subject: slab: infrastructure for bulk object allocation and freeing

Add the basic infrastructure for alloc/free operations on pointer arrays. 
It includes a generic function in the common slab code that is used in
this infrastructure patch to create the unoptimized functionality for slab
bulk operations.

Allocators can then provide optimized allocation functions for situations
in which large numbers of objects are needed.  These optimization may
avoid taking locks repeatedly and bypass metadata creation if all objects
in slab pages can be used to provide the objects required.

Allocators can extend the skeletons provided and add their own code to the
bulk alloc and free functions.  They can keep the generic allocation and
freeing and just fall back to those if optimizations would not work (like
for example when debugging is on).

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   10 ++++++++++
 mm/slab.c            |   13 +++++++++++++
 mm/slab.h            |    9 +++++++++
 mm/slab_common.c     |   23 +++++++++++++++++++++++
 mm/slob.c            |   13 +++++++++++++
 mm/slub.c            |   14 ++++++++++++++
 6 files changed, 82 insertions(+)

diff -puN include/linux/slab.h~slab-infrastructure-for-bulk-object-allocation-and-freeing include/linux/slab.h
--- a/include/linux/slab.h~slab-infrastructure-for-bulk-object-allocation-and-freeing
+++ a/include/linux/slab.h
@@ -290,6 +290,16 @@ void *__kmalloc(size_t size, gfp_t flags
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t flags);
 void kmem_cache_free(struct kmem_cache *, void *);
 
+/*
+ * Bulk allocation and freeing operations. These are accellerated in an
+ * allocator specific way to avoid taking locks repeatedly or building
+ * metadata structures unnecessarily.
+ *
+ * Note that interrupts must be enabled when calling these functions.
+ */
+void kmem_cache_free_bulk(struct kmem_cache *, size_t, void **);
+bool kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, void **);
+
 #ifdef CONFIG_NUMA
 void *__kmalloc_node(size_t size, gfp_t flags, int node);
 void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
diff -puN mm/slab.c~slab-infrastructure-for-bulk-object-allocation-and-freeing mm/slab.c
--- a/mm/slab.c~slab-infrastructure-for-bulk-object-allocation-and-freeing
+++ a/mm/slab.c
@@ -3416,6 +3416,19 @@ void *kmem_cache_alloc(struct kmem_cache
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
+void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
+{
+	__kmem_cache_free_bulk(s, size, p);
+}
+EXPORT_SYMBOL(kmem_cache_free_bulk);
+
+bool kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
+								void **p)
+{
+	return __kmem_cache_alloc_bulk(s, flags, size, p);
+}
+EXPORT_SYMBOL(kmem_cache_alloc_bulk);
+
 #ifdef CONFIG_TRACING
 void *
 kmem_cache_alloc_trace(struct kmem_cache *cachep, gfp_t flags, size_t size)
diff -puN mm/slab.h~slab-infrastructure-for-bulk-object-allocation-and-freeing mm/slab.h
--- a/mm/slab.h~slab-infrastructure-for-bulk-object-allocation-and-freeing
+++ a/mm/slab.h
@@ -163,6 +163,15 @@ void slabinfo_show_stats(struct seq_file
 ssize_t slabinfo_write(struct file *file, const char __user *buffer,
 		       size_t count, loff_t *ppos);
 
+/*
+ * Generic implementation of bulk operations
+ * These are useful for situations in which the allocator cannot
+ * perform optimizations. In that case segments of the objecct listed
+ * may be allocated or freed using these operations.
+ */
+void __kmem_cache_free_bulk(struct kmem_cache *, size_t, void **);
+bool __kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, void **);
+
 #ifdef CONFIG_MEMCG_KMEM
 /*
  * Iterate over all memcg caches of the given root cache. The caller must hold
diff -puN mm/slab_common.c~slab-infrastructure-for-bulk-object-allocation-and-freeing mm/slab_common.c
--- a/mm/slab_common.c~slab-infrastructure-for-bulk-object-allocation-and-freeing
+++ a/mm/slab_common.c
@@ -105,6 +105,29 @@ static inline int kmem_cache_sanity_chec
 }
 #endif
 
+void __kmem_cache_free_bulk(struct kmem_cache *s, size_t nr, void **p)
+{
+	size_t i;
+
+	for (i = 0; i < nr; i++)
+		kmem_cache_free(s, p[i]);
+}
+
+bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t nr,
+								void **p)
+{
+	size_t i;
+
+	for (i = 0; i < nr; i++) {
+		void *x = p[i] = kmem_cache_alloc(s, flags);
+		if (!x) {
+			__kmem_cache_free_bulk(s, i, p);
+			return false;
+		}
+	}
+	return true;
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 void slab_init_memcg_params(struct kmem_cache *s)
 {
diff -puN mm/slob.c~slab-infrastructure-for-bulk-object-allocation-and-freeing mm/slob.c
--- a/mm/slob.c~slab-infrastructure-for-bulk-object-allocation-and-freeing
+++ a/mm/slob.c
@@ -611,6 +611,19 @@ void kmem_cache_free(struct kmem_cache *
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
+void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
+{
+	__kmem_cache_free_bulk(s, size, p);
+}
+EXPORT_SYMBOL(kmem_cache_free_bulk);
+
+bool kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
+								void **p)
+{
+	return __kmem_cache_alloc_bulk(s, flags, size, p);
+}
+EXPORT_SYMBOL(kmem_cache_alloc_bulk);
+
 int __kmem_cache_shutdown(struct kmem_cache *c)
 {
 	/* No way to check for remaining objects */
diff -puN mm/slub.c~slab-infrastructure-for-bulk-object-allocation-and-freeing mm/slub.c
--- a/mm/slub.c~slab-infrastructure-for-bulk-object-allocation-and-freeing
+++ a/mm/slub.c
@@ -2750,6 +2750,20 @@ void kmem_cache_free(struct kmem_cache *
 }
 EXPORT_SYMBOL(kmem_cache_free);
 
+void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
+{
+	__kmem_cache_free_bulk(s, size, p);
+}
+EXPORT_SYMBOL(kmem_cache_free_bulk);
+
+bool kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
+								void **p)
+{
+	return __kmem_cache_alloc_bulk(s, flags, size, p);
+}
+EXPORT_SYMBOL(kmem_cache_alloc_bulk);
+
+
 /*
  * Object placement in a slab is made very easy because we always start at
  * offset 0. If we tune the size of the object to the alignment then we can
_

Patches currently in -mm which might be from cl@linux.com are

slub-fix-spelling-succedd-to-succeed.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-improve-bulk-alloc-strategy.patch
slub-initial-bulk-free-implementation.patch
slub-add-support-for-kmem_cache_debug-in-bulk-calls.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
kmod-bunch-of-internal-functions-renames.patch
kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch
kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch

