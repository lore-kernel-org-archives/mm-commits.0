From: akpm@linux-foundation.org
Subject: +
 mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj.patch
 added to -mm tree
Date: Sat, 20 Jun 2020 18:05:29 -0700
Message-ID: <20200621010529.TGSKt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728927AbgFUBFa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 21:05:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vjitta@codeaurora.org, vinmenon@codeaurora.org, rientjes@google.com, penberg@kernel.org, mjg59@google.com, keescook@chromium.org, jannh@google.com, iamjoonsoo.kim@lge.com, guro@fb.com, cl@linux.com, vbabka@suse.cz


The patch titled
     Subject: mm, slab/slub: improve error reporting and overhead of cache_from_obj()
has been added to the -mm tree.  Its filename is
     mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slab/slub: improve error reporting and overhead of cache_from_obj()

cache_from_obj() was added by commit b9ce5ef49f00 ("sl[au]b: always get
the cache from its page in kmem_cache_free()") to support kmemcg, where
per-memcg cache can be different from the root one, so we can't use the
kmem_cache pointer given to kmem_cache_free().

Prior to that commit, SLUB already had debugging check+warning that could
be enabled to compare the given kmem_cache pointer to one referenced by
the slab page where the object-to-be-freed resides.  This check was moved
to cache_from_obj().  Later the check was also enabled for
SLAB_FREELIST_HARDENED configs by commit 598a0717a816 ("mm/slab: validate
cache membership under freelist hardening").

These checks and warnings can be useful especially for the debugging,
which can be improved.  Commit 598a0717a816 changed the pr_err() with
WARN_ON_ONCE() to WARN_ONCE() so only the first hit is now reported,
others are silent.  This patch changes it to WARN() so that all errors are
reported.

It's also useful to print SLUB allocation/free tracking info for the
offending object, if tracking is enabled.  Thus, export the SLUB
print_tracking() function and provide an empty one for SLAB.

For SLUB we can also benefit from the static key check in
kmem_cache_debug_flags(), but we need to move this function to slab.h and
declare the static key there.

[1] https://lore.kernel.org/r/20200608230654.828134-18-guro@fb.com

Link: http://lkml.kernel.org/r/afeda7ac-748b-33d8-a905-56b708148ad5@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Garrett <mjg59@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 --------
 mm/slab.h |   45 +++++++++++++++++++++++++++++++++++++++++++++
 mm/slub.c |   37 +------------------------------------
 3 files changed, 46 insertions(+), 44 deletions(-)

--- a/mm/slab.c~mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj
+++ a/mm/slab.c
@@ -3672,14 +3672,6 @@ void *__kmalloc_track_caller(size_t size
 }
 EXPORT_SYMBOL(__kmalloc_track_caller);
 
-static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
-{
-	if (memcg_kmem_enabled())
-		return virt_to_cache(x);
-	else
-		return s;
-}
-
 /**
  * kmem_cache_free - Deallocate an object
  * @cachep: The cache the allocation was from.
--- a/mm/slab.h~mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj
+++ a/mm/slab.h
@@ -275,6 +275,34 @@ static inline int cache_vmstat_idx(struc
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE;
 }
 
+#ifdef CONFIG_SLUB_DEBUG
+#ifdef CONFIG_SLUB_DEBUG_ON
+DECLARE_STATIC_KEY_TRUE(slub_debug_enabled);
+#else
+DECLARE_STATIC_KEY_FALSE(slub_debug_enabled);
+#endif
+extern void print_tracking(struct kmem_cache *s, void *object);
+#else
+static inline void print_tracking(struct kmem_cache *s, void *object)
+{
+}
+#endif
+
+/*
+ * Returns true if any of the specified slub_debug flags is enabled for the
+ * cache. Use only for flags parsed by setup_slub_debug() as it also enables
+ * the static key.
+ */
+static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t flags)
+{
+	VM_WARN_ON_ONCE(!(flags & SLAB_DEBUG_FLAGS));
+#ifdef CONFIG_SLUB_DEBUG
+	if (static_branch_unlikely(&slub_debug_enabled))
+		return s->flags & flags;
+#endif
+	return false;
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 
 /* List of all root caches. */
@@ -503,6 +531,23 @@ static __always_inline void uncharge_sla
 	memcg_uncharge_slab(page, order, s);
 }
 
+static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
+{
+	struct kmem_cache *cachep;
+
+	if (!IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
+	    !memcg_kmem_enabled() &&
+	    !kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS))
+		return s;
+
+	cachep = virt_to_cache(x);
+	if (WARN(cachep && !slab_equal_or_root(cachep, s),
+		  "%s: Wrong slab cache. %s but object is from %s\n",
+		  __func__, s->name, cachep->name))
+		print_tracking(cachep, x);
+	return cachep;
+}
+
 static inline size_t slab_ksize(const struct kmem_cache *s)
 {
 #ifndef CONFIG_SLUB
--- a/mm/slub.c~mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj
+++ a/mm/slub.c
@@ -122,20 +122,6 @@ DEFINE_STATIC_KEY_FALSE(slub_debug_enabl
 #endif
 #endif
 
-/*
- * Returns true if any of the specified slub_debug flags is enabled for the
- * cache. Use only for flags parsed by setup_slub_debug() as it also enables
- * the static key.
- */
-static inline int kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t flags)
-{
-#ifdef CONFIG_SLUB_DEBUG
-	if (static_branch_unlikely(&slub_debug_enabled))
-		return s->flags & flags;
-#endif
-	return 0;
-}
-
 static inline int kmem_cache_debug(struct kmem_cache *s)
 {
 	return kmem_cache_debug_flags(s, SLAB_DEBUG_FLAGS);
@@ -652,7 +638,7 @@ static void print_track(const char *s, s
 #endif
 }
 
-static void print_tracking(struct kmem_cache *s, void *object)
+void print_tracking(struct kmem_cache *s, void *object)
 {
 	unsigned long pr_time = jiffies;
 	if (!(s->flags & SLAB_STORE_USER))
@@ -1524,10 +1510,6 @@ static bool freelist_corrupted(struct km
 {
 	return false;
 }
-
-static void print_tracking(struct kmem_cache *s, void *object)
-{
-}
 #endif /* CONFIG_SLUB_DEBUG */
 
 /*
@@ -3179,23 +3161,6 @@ void ___cache_free(struct kmem_cache *ca
 }
 #endif
 
-static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
-{
-	struct kmem_cache *cachep;
-
-	if (!IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
-	    !memcg_kmem_enabled() &&
-	    !kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS))
-		return s;
-
-	cachep = virt_to_cache(x);
-	if (WARN(cachep && !slab_equal_or_root(cachep, s),
-		  "%s: Wrong slab cache. %s but object is from %s\n",
-		  __func__, s->name, cachep->name))
-		print_tracking(cachep, x);
-	return cachep;
-}
