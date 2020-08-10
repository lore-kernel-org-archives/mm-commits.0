Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B78F7C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D75C20723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027001;
	bh=8EsxySbn0EzpY8xMeV/mNvTESTZXP9QwDmH4rSb9QEo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pbGgt+SDd6id4bi+ezCYerAIRZSbI/z56RX981db1Ve0754cYIdXt1O4crCpooYbU
	 P8oDWbVSozrrmTvouWty+rCdhYTLm1V+4oBVevUw6wHncsf8egoK2sZPSl96wxi2ZU
	 eXaFMc7rceeNzn1Kc3sFEsNEjUbrvt3BReq4krKU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgHJCgl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCgl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:41 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BCBE2065D;
        Mon, 10 Aug 2020 02:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026999;
        bh=8EsxySbn0EzpY8xMeV/mNvTESTZXP9QwDmH4rSb9QEo=;
        h=Date:From:To:Subject:From;
        b=mXPoSoFpwCLYoCOoO4VHzey1f8Jq3ioxUFrWGZmP2Xh8FCTUHz4GRlGdcrR0WlMe/
         9uXlj5Z2aEuetkS2hoYPMLvlYnOXTKOLhVR7KbFexhtHJGkWR1hFq+zjnpF4bgjpbo
         g88w0plrOyiP7XT/gnbESego747CBOvXZzNTERqE=
Date:   Sun, 09 Aug 2020 19:36:39 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        vbabka@suse.cz
Subject:  [merged]
 mm-memcg-slab-save-obj_cgroup-for-non-root-slab-objects.patch removed from
 -mm tree
Message-ID: <20200810023639.wAxbhSZ2Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: save obj_cgroup for non-root slab objects
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-save-obj_cgroup-for-non-root-slab-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: save obj_cgroup for non-root slab objects

Store the obj_cgroup pointer in the corresponding place of
page->obj_cgroups for each allocated non-root slab object.  Make sure that
each allocated object holds a reference to obj_cgroup.

Objcg pointer is obtained from the memcg->objcg dereferencing in
memcg_kmem_get_cache() and passed from pre_alloc_hook to post_alloc_hook.
Then in case of successful allocation(s) it's getting stored in the
page->obj_cgroups vector.

The objcg obtaining part look a bit bulky now, but it will be simplified
by next commits in the series.

Link: http://lkml.kernel.org/r/20200623174037.3951353-9-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 +
 mm/memcontrol.c            |   14 +++++++-
 mm/slab.c                  |   18 ++++++----
 mm/slab.h                  |   60 +++++++++++++++++++++++++++++++----
 mm/slub.c                  |   14 +++++---
 5 files changed, 88 insertions(+), 21 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-save-obj_cgroup-for-non-root-slab-objects
+++ a/include/linux/memcontrol.h
@@ -1404,7 +1404,8 @@ static inline void memcg_set_shrinker_bi
 }
 #endif
 
-struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep);
+struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep,
+					struct obj_cgroup **objcgp);
 void memcg_kmem_put_cache(struct kmem_cache *cachep);
 
 #ifdef CONFIG_MEMCG_KMEM
--- a/mm/memcontrol.c~mm-memcg-slab-save-obj_cgroup-for-non-root-slab-objects
+++ a/mm/memcontrol.c
@@ -2973,7 +2973,8 @@ static inline bool memcg_kmem_bypass(voi
  * done with it, memcg_kmem_put_cache() must be called to release the
  * reference.
  */
-struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep)
+struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep,
+					struct obj_cgroup **objcgp)
 {
 	struct mem_cgroup *memcg;
 	struct kmem_cache *memcg_cachep;
@@ -3029,8 +3030,17 @@ struct kmem_cache *memcg_kmem_get_cache(
 	 */
 	if (unlikely(!memcg_cachep))
 		memcg_schedule_kmem_cache_create(memcg, cachep);
-	else if (percpu_ref_tryget(&memcg_cachep->memcg_params.refcnt))
+	else if (percpu_ref_tryget(&memcg_cachep->memcg_params.refcnt)) {
+		struct obj_cgroup *objcg = rcu_dereference(memcg->objcg);
+
+		if (!objcg || !obj_cgroup_tryget(objcg)) {
+			percpu_ref_put(&memcg_cachep->memcg_params.refcnt);
+			goto out_unlock;
+		}
+
+		*objcgp = objcg;
 		cachep = memcg_cachep;
+	}
 out_unlock:
 	rcu_read_unlock();
 	return cachep;
--- a/mm/slab.c~mm-memcg-slab-save-obj_cgroup-for-non-root-slab-objects
+++ a/mm/slab.c
@@ -3228,9 +3228,10 @@ slab_alloc_node(struct kmem_cache *cache
 	unsigned long save_flags;
 	void *ptr;
 	int slab_node = numa_mem_id();
+	struct obj_cgroup *objcg = NULL;
 
 	flags &= gfp_allowed_mask;
-	cachep = slab_pre_alloc_hook(cachep, flags);
+	cachep = slab_pre_alloc_hook(cachep, &objcg, 1, flags);
 	if (unlikely(!cachep))
 		return NULL;
 
@@ -3266,7 +3267,7 @@ slab_alloc_node(struct kmem_cache *cache
 	if (unlikely(slab_want_init_on_alloc(flags, cachep)) && ptr)
 		memset(ptr, 0, cachep->object_size);
 
-	slab_post_alloc_hook(cachep, flags, 1, &ptr);
+	slab_post_alloc_hook(cachep, objcg, flags, 1, &ptr);
 	return ptr;
 }
 
@@ -3307,9 +3308,10 @@ slab_alloc(struct kmem_cache *cachep, gf
 {
 	unsigned long save_flags;
 	void *objp;
+	struct obj_cgroup *objcg = NULL;
 
 	flags &= gfp_allowed_mask;
-	cachep = slab_pre_alloc_hook(cachep, flags);
+	cachep = slab_pre_alloc_hook(cachep, &objcg, 1, flags);
 	if (unlikely(!cachep))
 		return NULL;
 
@@ -3323,7 +3325,7 @@ slab_alloc(struct kmem_cache *cachep, gf
 	if (unlikely(slab_want_init_on_alloc(flags, cachep)) && objp)
 		memset(objp, 0, cachep->object_size);
 
-	slab_post_alloc_hook(cachep, flags, 1, &objp);
+	slab_post_alloc_hook(cachep, objcg, flags, 1, &objp);
 	return objp;
 }
 
@@ -3450,6 +3452,7 @@ void ___cache_free(struct kmem_cache *ca
 		memset(objp, 0, cachep->object_size);
 	kmemleak_free_recursive(objp, cachep->flags);
 	objp = cache_free_debugcheck(cachep, objp, caller);
+	memcg_slab_free_hook(cachep, virt_to_head_page(objp), objp);
 
 	/*
 	 * Skip calling cache_free_alien() when the platform is not numa.
@@ -3515,8 +3518,9 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 			  void **p)
 {
 	size_t i;
+	struct obj_cgroup *objcg = NULL;
 
-	s = slab_pre_alloc_hook(s, flags);
+	s = slab_pre_alloc_hook(s, &objcg, size, flags);
 	if (!s)
 		return 0;
 
@@ -3539,13 +3543,13 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 		for (i = 0; i < size; i++)
 			memset(p[i], 0, s->object_size);
 
-	slab_post_alloc_hook(s, flags, size, p);
+	slab_post_alloc_hook(s, objcg, flags, size, p);
 	/* FIXME: Trace call missing. Christoph would like a bulk variant */
 	return size;
 error:
 	local_irq_enable();
 	cache_alloc_debugcheck_after_bulk(s, flags, i, p, _RET_IP_);
-	slab_post_alloc_hook(s, flags, i, p);
+	slab_post_alloc_hook(s, objcg, flags, i, p);
 	__kmem_cache_free_bulk(s, i, p);
 	return 0;
 }
--- a/mm/slab.h~mm-memcg-slab-save-obj_cgroup-for-non-root-slab-objects
+++ a/mm/slab.h
@@ -470,6 +470,41 @@ static inline void memcg_free_page_obj_c
 	page->obj_cgroups = NULL;
 }
 
+static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
+					      struct obj_cgroup *objcg,
+					      size_t size, void **p)
+{
+	struct page *page;
+	unsigned long off;
+	size_t i;
+
+	for (i = 0; i < size; i++) {
+		if (likely(p[i])) {
+			page = virt_to_head_page(p[i]);
+			off = obj_to_index(s, page, p[i]);
+			obj_cgroup_get(objcg);
+			page_obj_cgroups(page)[off] = objcg;
+		}
+	}
+	obj_cgroup_put(objcg);
+	memcg_kmem_put_cache(s);
+}
+
+static inline void memcg_slab_free_hook(struct kmem_cache *s, struct page *page,
+					void *p)
+{
+	struct obj_cgroup *objcg;
+	unsigned int off;
+
+	if (!memcg_kmem_enabled() || is_root_cache(s))
+		return;
+
+	off = obj_to_index(s, page, p);
+	objcg = page_obj_cgroups(page)[off];
+	page_obj_cgroups(page)[off] = NULL;
+	obj_cgroup_put(objcg);
+}
+
 extern void slab_init_memcg_params(struct kmem_cache *);
 extern void memcg_link_cache(struct kmem_cache *s, struct mem_cgroup *memcg);
 
@@ -529,6 +564,17 @@ static inline void memcg_free_page_obj_c
 {
 }
 
+static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
+					      struct obj_cgroup *objcg,
+					      size_t size, void **p)
+{
+}
+
+static inline void memcg_slab_free_hook(struct kmem_cache *s, struct page *page,
+					void *p)
+{
+}
+
 static inline void slab_init_memcg_params(struct kmem_cache *s)
 {
 }
@@ -631,7 +677,8 @@ static inline size_t slab_ksize(const st
 }
 
 static inline struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s,
-						     gfp_t flags)
+						     struct obj_cgroup **objcgp,
+						     size_t size, gfp_t flags)
 {
 	flags &= gfp_allowed_mask;
 
@@ -645,13 +692,14 @@ static inline struct kmem_cache *slab_pr
 
 	if (memcg_kmem_enabled() &&
 	    ((flags & __GFP_ACCOUNT) || (s->flags & SLAB_ACCOUNT)))
-		return memcg_kmem_get_cache(s);
+		return memcg_kmem_get_cache(s, objcgp);
 
 	return s;
 }
 
-static inline void slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
-					size_t size, void **p)
+static inline void slab_post_alloc_hook(struct kmem_cache *s,
+					struct obj_cgroup *objcg,
+					gfp_t flags, size_t size, void **p)
 {
 	size_t i;
 
@@ -663,8 +711,8 @@ static inline void slab_post_alloc_hook(
 					 s->flags, flags);
 	}
 
-	if (memcg_kmem_enabled())
-		memcg_kmem_put_cache(s);
+	if (memcg_kmem_enabled() && !is_root_cache(s))
+		memcg_slab_post_alloc_hook(s, objcg, size, p);
 }
 
 #ifndef CONFIG_SLOB
--- a/mm/slub.c~mm-memcg-slab-save-obj_cgroup-for-non-root-slab-objects
+++ a/mm/slub.c
@@ -2817,8 +2817,9 @@ static __always_inline void *slab_alloc_
 	struct kmem_cache_cpu *c;
 	struct page *page;
 	unsigned long tid;
+	struct obj_cgroup *objcg = NULL;
 
-	s = slab_pre_alloc_hook(s, gfpflags);
+	s = slab_pre_alloc_hook(s, &objcg, 1, gfpflags);
 	if (!s)
 		return NULL;
 redo:
@@ -2894,7 +2895,7 @@ redo:
 	if (unlikely(slab_want_init_on_alloc(gfpflags, s)) && object)
 		memset(object, 0, s->object_size);
 
-	slab_post_alloc_hook(s, gfpflags, 1, &object);
+	slab_post_alloc_hook(s, objcg, gfpflags, 1, &object);
 
 	return object;
 }
@@ -3099,6 +3100,8 @@ static __always_inline void do_slab_free
 	void *tail_obj = tail ? : head;
 	struct kmem_cache_cpu *c;
 	unsigned long tid;
+
+	memcg_slab_free_hook(s, page, head);
 redo:
 	/*
 	 * Determine the currently cpus per cpu slab.
@@ -3278,9 +3281,10 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 {
 	struct kmem_cache_cpu *c;
 	int i;
+	struct obj_cgroup *objcg = NULL;
 
 	/* memcg and kmem_cache debug support */
-	s = slab_pre_alloc_hook(s, flags);
+	s = slab_pre_alloc_hook(s, &objcg, size, flags);
 	if (unlikely(!s))
 		return false;
 	/*
@@ -3334,11 +3338,11 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	}
 
 	/* memcg and kmem_cache debug support */
-	slab_post_alloc_hook(s, flags, size, p);
+	slab_post_alloc_hook(s, objcg, flags, size, p);
 	return i;
 error:
 	local_irq_enable();
-	slab_post_alloc_hook(s, flags, i, p);
+	slab_post_alloc_hook(s, objcg, flags, i, p);
 	__kmem_cache_free_bulk(s, i, p);
 	return 0;
 }
_

Patches currently in -mm which might be from guro@fb.com are

percpu-return-number-of-released-bytes-from-pcpu_free_area.patch
mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics.patch
mm-memcg-percpu-per-memcg-percpu-memory-statistics-v3.patch
mm-memcg-charge-memcg-percpu-memory-to-the-parent-cgroup.patch
kselftests-cgroup-add-perpcu-memory-accounting-test.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

