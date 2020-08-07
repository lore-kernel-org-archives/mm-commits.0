Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68ABBC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4891B22C9F
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781259;
	bh=tRpWt0fuoKmDnpvqr7gt2u6u36gOZ6DN2arw5tvMfW8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=P83rGTItmVQMxjk7Dm4p3gekcXLM2R43XWTfDDF2ZxpGIplZe4qtx1BP9PkMomKN7
	 B2in3fl2G9DCFhdOTKgaWyp8E10ckQ7xx6Wx1o2d/VgUAM4tQtg6Em5lftn4mQAdVy
	 IgXNqe4ShKS10pTHrFIAr+R9nuWCtZ18iWc2szkM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgHGGU7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgHGGU6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:20:58 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB0EF221E5;
        Fri,  7 Aug 2020 06:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781257;
        bh=tRpWt0fuoKmDnpvqr7gt2u6u36gOZ6DN2arw5tvMfW8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PbJO9203JW/rEuNg/0NTqdqVhExIvTKJvGY0LZizonWO2MM9HUsgXRRsaE6ara5N/
         /QSf6JbGRhPoXT9qjzyDLbZLAwFZQfK/IIr9WdlQe9AJ+d4caKU8dbiDMove/7tMLX
         pSv0ax7gK9mer2a0SWNcTO/v38fxNjo2l4QzZmPM=
Date:   Thu, 06 Aug 2020 23:20:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 069/163] mm: memcg/slab: save obj_cgroup for
 non-root slab objects
Message-ID: <20200807062056.GMH1InlNM%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
