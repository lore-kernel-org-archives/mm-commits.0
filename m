Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B1BBC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B9652075D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026919;
	bh=5YdBnZGplSZZk4fYzil9tI6BWf89SsKHOjY4mlnhxLY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pzZjd7dqvNO5dev8OQjpdAolwqAbwIbM+F1e0y4OgnCNLiTdmam2Pw1zqV/Zy5skx
	 IugKzlqi2ffmEuplpcPQdx7lg1bojKK9ldUZkVm9BPA0VD2vMzxgkFRPNet+VuA7lM
	 q/8eL1NLuveHWWsM57ya/4hX74VC3BHLGvBJczSY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgHJCfT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCfS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:35:18 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70E4D206C3;
        Mon, 10 Aug 2020 02:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026917;
        bh=5YdBnZGplSZZk4fYzil9tI6BWf89SsKHOjY4mlnhxLY=;
        h=Date:From:To:Subject:From;
        b=ZldOld4I9r+MQOZJs103vfS0cXo7L5/uJ30m1N6hhdNwoKeIfRjc8+n2B71WHVPlI
         PS/KggdtPkQUsYv/p8jlqavZ1dNNcNv5jPrX+n+QhVW+ft1wptWW2EFOoBfTcTCdxR
         jyAVrOKgLX90P1YqmD6hokigJ2YO6+QbClN9b6kY=
Date:   Sun, 09 Aug 2020 19:35:17 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, keescook@chromium.org, mjg59@google.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vinmenon@codeaurora.org,
        vjitta@codeaurora.org
Subject:  [merged]
 mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj.patch
 removed from -mm tree
Message-ID: <20200810023517.kx-jNhsKZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slab/slub: improve error reporting and overhead of cache_from_obj()
has been removed from the -mm tree.  Its filename was
     mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[vbabka@suse.cz: avoid bogus WARN()]
  Link: https://lore.kernel.org/r/20200623090213.GW5535@shao2-debian
  Link: http://lkml.kernel.org/r/b33e0fa7-cd28-4788-9e54-5927846329ef@suse.cz
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
 mm/slub.c |   38 +-------------------------------------
 3 files changed, 46 insertions(+), 45 deletions(-)

--- a/mm/slab.c~mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj
+++ a/mm/slab.c
@@ -3678,14 +3678,6 @@ void *__kmalloc_track_caller(size_t size
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
@@ -276,6 +276,34 @@ static inline int cache_vmstat_idx(struc
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
+#ifdef CONFIG_SLUB_DEBUG
+	VM_WARN_ON_ONCE(!(flags & SLAB_DEBUG_FLAGS));
+	if (static_branch_unlikely(&slub_debug_enabled))
+		return s->flags & flags;
+#endif
+	return false;
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 
 /* List of all root caches. */
@@ -504,6 +532,23 @@ static __always_inline void uncharge_sla
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
@@ -122,21 +122,6 @@ DEFINE_STATIC_KEY_FALSE(slub_debug_enabl
 #endif
 #endif
 
-/*
- * Returns true if any of the specified slub_debug flags is enabled for the
- * cache. Use only for flags parsed by setup_slub_debug() as it also enables
- * the static key.
- */
-static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t flags)
-{
-	VM_WARN_ON_ONCE(!(flags & SLAB_DEBUG_FLAGS));
-#ifdef CONFIG_SLUB_DEBUG
-	if (static_branch_unlikely(&slub_debug_enabled))
-		return s->flags & flags;
-#endif
-	return false;
-}
-
 static inline bool kmem_cache_debug(struct kmem_cache *s)
 {
 	return kmem_cache_debug_flags(s, SLAB_DEBUG_FLAGS);
@@ -653,7 +638,7 @@ static void print_track(const char *s, s
 #endif
 }
 
-static void print_tracking(struct kmem_cache *s, void *object)
+void print_tracking(struct kmem_cache *s, void *object)
 {
 	unsigned long pr_time = jiffies;
 	if (!(s->flags & SLAB_STORE_USER))
@@ -1525,10 +1510,6 @@ static bool freelist_corrupted(struct km
 {
 	return false;
 }
-
-static void print_tracking(struct kmem_cache *s, void *object)
-{
-}
 #endif /* CONFIG_SLUB_DEBUG */
 
 /*
@@ -3175,23 +3156,6 @@ void ___cache_free(struct kmem_cache *ca
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
-
 void kmem_cache_free(struct kmem_cache *s, void *x)
 {
 	s = cache_from_obj(s, x);
_

Patches currently in -mm which might be from vbabka@suse.cz are


