From: akpm@linux-foundation.org
Subject: + mm-slab-slub-move-and-improve-cache_from_obj.patch added
 to -mm tree
Date: Wed, 17 Jun 2020 09:57:18 -0700
Message-ID: <20200617165718.BnCDn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgFQQ5T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 12:57:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vjitta@codeaurora.org, rientjes@google.com, penberg@kernel.org, keescook@chromium.org, jannh@google.com, iamjoonsoo.kim@lge.com, cl@linux.com, vbabka@suse.cz


The patch titled
     Subject: mm, slab/slub: move and improve cache_from_obj()
has been added to the -mm tree.  Its filename is
     mm-slab-slub-move-and-improve-cache_from_obj.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-slub-move-and-improve-cache_from_obj.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-slub-move-and-improve-cache_from_obj.patch

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
Subject: mm, slab/slub: move and improve cache_from_obj()

The function cache_from_obj() was added by commit b9ce5ef49f00 ("sl[au]b:
always get the cache from its page in kmem_cache_free()") to support
kmemcg, where per-memcg cache can be different from the root one, so we
can't use the kmem_cache pointer given to kmem_cache_free().

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
offending object, if tracking is enabled.  We could export the SLUB
print_tracking() function and provide an empty one for SLAB, or realize
that both the debugging and hardening cases in cache_from_obj() are only
supported by SLUB anyway.  So this patch moves cache_from_obj() from
slab.h to separate instances in slab.c and slub.c, where the SLAB version
only does the kmemcg lookup and even could be completely removed once the
kmemcg rework [1] is merged.  The SLUB version can thus easily use the
print_tracking() function.  It can also use the kmem_cache_debug_flags()
static key check for improved performance in kernels without the hardening
and with debugging not enabled on boot.

[1] https://lore.kernel.org/r/20200608230654.828134-18-guro@fb.com

Link: http://lkml.kernel.org/r/20200610163135.17364-10-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 ++++++++
 mm/slab.h |   23 -----------------------
 mm/slub.c |   21 +++++++++++++++++++++
 3 files changed, 29 insertions(+), 23 deletions(-)

--- a/mm/slab.c~mm-slab-slub-move-and-improve-cache_from_obj
+++ a/mm/slab.c
@@ -3672,6 +3672,14 @@ void *__kmalloc_track_caller(size_t size
 }
 EXPORT_SYMBOL(__kmalloc_track_caller);
 
+static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
+{
+	if (memcg_kmem_enabled())
+		return virt_to_cache(x);
+	else
+		return s;
+}
+
 /**
  * kmem_cache_free - Deallocate an object
  * @cachep: The cache the allocation was from.
--- a/mm/slab.h~mm-slab-slub-move-and-improve-cache_from_obj
+++ a/mm/slab.h
@@ -503,29 +503,6 @@ static __always_inline void uncharge_sla
 	memcg_uncharge_slab(page, order, s);
 }
 
-static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
-{
-	struct kmem_cache *cachep;
-
-	/*
-	 * When kmemcg is not being used, both assignments should return the
-	 * same value. but we don't want to pay the assignment price in that
-	 * case. If it is not compiled in, the compiler should be smart enough
-	 * to not do even the assignment. In that case, slab_equal_or_root
-	 * will also be a constant.
-	 */
-	if (!memcg_kmem_enabled() &&
-	    !IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) &&
-	    !unlikely(s->flags & SLAB_CONSISTENCY_CHECKS))
-		return s;
-
-	cachep = virt_to_cache(x);
-	WARN_ONCE(cachep && !slab_equal_or_root(cachep, s),
-		  "%s: Wrong slab cache. %s but object is from %s\n",
-		  __func__, s->name, cachep->name);
-	return cachep;
-}
-
 static inline size_t slab_ksize(const struct kmem_cache *s)
 {
 #ifndef CONFIG_SLUB
--- a/mm/slub.c~mm-slab-slub-move-and-improve-cache_from_obj
+++ a/mm/slub.c
@@ -1524,6 +1524,10 @@ static bool freelist_corrupted(struct km
 {
 	return false;
 }
+
+static void print_tracking(struct kmem_cache *s, void *object)
+{
+}
 #endif /* CONFIG_SLUB_DEBUG */
 
 /*
@@ -3175,6 +3179,23 @@ void ___cache_free(struct kmem_cache *ca
 }
 #endif
 
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
 void kmem_cache_free(struct kmem_cache *s, void *x)
 {
 	s = cache_from_obj(s, x);
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch
mm-slub-make-some-slub_debug-related-attributes-read-only.patch
mm-slub-remove-runtime-allocation-order-changes.patch
mm-slub-make-remaining-slub_debug-related-attributes-read-only.patch
mm-slub-make-reclaim_account-attribute-read-only.patch
mm-slub-introduce-static-key-for-slub_debug.patch
mm-slub-introduce-kmem_cache_debug_flags.patch
mm-slub-extend-checks-guarded-by-slub_debug-static-key.patch
mm-slab-slub-move-and-improve-cache_from_obj.patch
