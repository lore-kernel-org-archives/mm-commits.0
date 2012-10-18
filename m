From: akpm@linux-foundation.org
Subject: + slab-ignore-internal-flags-in-cache-creation.patch added to -mm tree
Date: Thu, 18 Oct 2012 15:42:54 -0700
Message-ID: <20121018224255.1C7545C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:56316 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab2JRWm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 18:42:58 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so553169fae.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 15:42:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: glommer@parallels.com, cl@linux.com, penberg@cs.helsinki.fi, rientjes@google.com


The patch titled
     Subject: slab: ignore internal flags in cache creation
has been added to the -mm tree.  Its filename is
     slab-ignore-internal-flags-in-cache-creation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: slab: ignore internal flags in cache creation

Some flags are used internally by the allocators for management purposes. 
One example of that is the CFLGS_OFF_SLAB flag that slab uses to mark that
the metadata for that cache is stored outside of the slab.

No cache should ever pass those as a creation flags.  We can just ignore
this bit if it happens to be passed (such as when duplicating a cache in
the kmem memcg patches).

Because such flags can vary from allocator to allocator, we allow them to
make their own decisions on that, defining SLAB_AVAILABLE_FLAGS with all
flags that are valid at creation time.  Allocators that doesn't have any
specific flag requirement should define that to mean all flags.

Common code will mask out all flags not belonging to that set.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |   22 ----------------------
 mm/slab.h        |   25 +++++++++++++++++++++++++
 mm/slab_common.c |    7 +++++++
 mm/slub.c        |    3 ---
 4 files changed, 32 insertions(+), 25 deletions(-)

diff -puN mm/slab.c~slab-ignore-internal-flags-in-cache-creation mm/slab.c
--- a/mm/slab.c~slab-ignore-internal-flags-in-cache-creation
+++ a/mm/slab.c
@@ -162,23 +162,6 @@
  */
 static bool pfmemalloc_active __read_mostly;
 
-/* Legal flag mask for kmem_cache_create(). */
-#if DEBUG
-# define CREATE_MASK	(SLAB_RED_ZONE | \
-			 SLAB_POISON | SLAB_HWCACHE_ALIGN | \
-			 SLAB_CACHE_DMA | \
-			 SLAB_STORE_USER | \
-			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
-			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
-			 SLAB_DEBUG_OBJECTS | SLAB_NOLEAKTRACE | SLAB_NOTRACK)
-#else
-# define CREATE_MASK	(SLAB_HWCACHE_ALIGN | \
-			 SLAB_CACHE_DMA | \
-			 SLAB_RECLAIM_ACCOUNT | SLAB_PANIC | \
-			 SLAB_DESTROY_BY_RCU | SLAB_MEM_SPREAD | \
-			 SLAB_DEBUG_OBJECTS | SLAB_NOLEAKTRACE | SLAB_NOTRACK)
-#endif
-
 /*
  * kmem_bufctl_t:
  *
@@ -2378,11 +2361,6 @@ __kmem_cache_create (struct kmem_cache *
 	if (flags & SLAB_DESTROY_BY_RCU)
 		BUG_ON(flags & SLAB_POISON);
 #endif
-	/*
-	 * Always checks flags, a caller might be expecting debug support which
-	 * isn't available.
-	 */
-	BUG_ON(flags & ~CREATE_MASK);
 
 	/*
 	 * Check that size is in terms of words.  This is needed to avoid
diff -puN mm/slab.h~slab-ignore-internal-flags-in-cache-creation mm/slab.h
--- a/mm/slab.h~slab-ignore-internal-flags-in-cache-creation
+++ a/mm/slab.h
@@ -45,6 +45,31 @@ static inline struct kmem_cache *__kmem_
 #endif
 
 
+/* Legal flag mask for kmem_cache_create(), for various configurations */
+#define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | SLAB_PANIC | \
+			 SLAB_DESTROY_BY_RCU | SLAB_DEBUG_OBJECTS )
+
+#if defined(CONFIG_DEBUG_SLAB)
+#define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
+#elif defined(CONFIG_SLUB_DEBUG)
+#define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
+			  SLAB_TRACE | SLAB_DEBUG_FREE)
+#else
+#define SLAB_DEBUG_FLAGS (0)
+#endif
+
+#if defined(CONFIG_SLAB)
+#define SLAB_CACHE_FLAGS (SLAB_MEM_SPREAD | SLAB_NOLEAKTRACE | \
+			  SLAB_RECLAIM_ACCOUNT | SLAB_TEMPORARY | SLAB_NOTRACK)
+#elif defined(CONFIG_SLUB)
+#define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
+			  SLAB_TEMPORARY | SLAB_NOTRACK)
+#else
+#define SLAB_CACHE_FLAGS (0)
+#endif
+
+#define CACHE_CREATE_MASK (SLAB_CORE_FLAGS | SLAB_DEBUG_FLAGS | SLAB_CACHE_FLAGS)
+
 int __kmem_cache_shutdown(struct kmem_cache *);
 
 #endif
diff -puN mm/slab_common.c~slab-ignore-internal-flags-in-cache-creation mm/slab_common.c
--- a/mm/slab_common.c~slab-ignore-internal-flags-in-cache-creation
+++ a/mm/slab_common.c
@@ -107,6 +107,13 @@ struct kmem_cache *kmem_cache_create(con
 	if (!kmem_cache_sanity_check(name, size) == 0)
 		goto out_locked;
 
+	/*
+	 * Some allocators will constraint the set of valid flags to a subset
+	 * of all flags. We expect them to define CACHE_CREATE_MASK in this
+	 * case, and we'll just provide them with a sanitized version of the
+	 * passed flags.
+	 */
+	flags &= CACHE_CREATE_MASK;
 
 	s = __kmem_cache_alias(name, size, align, flags, ctor);
 	if (s)
diff -puN mm/slub.c~slab-ignore-internal-flags-in-cache-creation mm/slub.c
--- a/mm/slub.c~slab-ignore-internal-flags-in-cache-creation
+++ a/mm/slub.c
@@ -112,9 +112,6 @@
  * 			the fast path and disables lockless freelists.
  */
 
-#define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
-		SLAB_TRACE | SLAB_DEBUG_FREE)
