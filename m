Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F47C433E1
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6963B206C3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027003;
	bh=vaVNCJelq4dPq2kjRE0bNYe43iwKYxB4/lJ3di+t+M4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=m+sgGRwaXSfw1ZZrxGCBz7zietUVqJPG4cr+fxlJ3lEOvWP2ur3uRYBcZ7IqAFRHf
	 Wu3eCR4jPxcqgaUsyAlbu+QZZQBj1kV5t74x7mVZsUSFOFh0RT7eVVIR0gydc/VJhl
	 u/iKWUwUiBDY8RCoMyE8wl1GHtpji01WjliYhUws=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgHJCgn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCgn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0D482075D;
        Mon, 10 Aug 2020 02:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597027001;
        bh=vaVNCJelq4dPq2kjRE0bNYe43iwKYxB4/lJ3di+t+M4=;
        h=Date:From:To:Subject:From;
        b=G/W3Bp9rBydblWmVmd+nQHBW3Er7u6BmVPMNepePILBS3kdkbr3X7CjnwpPxDvxv0
         5aZaTX8QCOMoBh/WIOYqPFTmbjjm4c6AFFGlwGsRldUDGWYcBZgRcj1HHA7DAgbqDr
         GukoiznvVvmTPHVt0A7WtwyusezNk4gYGIkkNJHM=
Date:   Sun, 09 Aug 2020 19:36:41 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        vbabka@suse.cz
Subject:  [merged]
 mm-memcg-slab-charge-individual-slab-objects-instead-of-pages.patch removed
 from -mm tree
Message-ID: <20200810023641.3OTOTiJTg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: charge individual slab objects instead of pages
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-charge-individual-slab-objects-instead-of-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: charge individual slab objects instead of pages

Switch to per-object accounting of non-root slab objects.

Charging is performed using obj_cgroup API in the pre_alloc hook.
Obj_cgroup is charged with the size of the object and the size of
metadata: as now it's the size of an obj_cgroup pointer.  If the amount of
memory has been charged successfully, the actual allocation code is
executed.  Otherwise, -ENOMEM is returned.

In the post_alloc hook if the actual allocation succeeded, corresponding
vmstats are bumped and the obj_cgroup pointer is saved.  Otherwise, the
charge is canceled.

On the free path obj_cgroup pointer is obtained and used to uncharge the
size of the releasing object.

Memcg and lruvec counters are now representing only memory used by active
slab objects and do not include the free space.  The free space is shared
and doesn't belong to any specific cgroup.

Global per-node slab vmstats are still modified from
(un)charge_slab_page() functions.  The idea is to keep all slab pages
accounted as slab pages on system level.

Link: http://lkml.kernel.org/r/20200623174037.3951353-10-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |  174 +++++++++++++++++++++++-----------------------------
 1 file changed, 78 insertions(+), 96 deletions(-)

--- a/mm/slab.h~mm-memcg-slab-charge-individual-slab-objects-instead-of-pages
+++ a/mm/slab.h
@@ -382,72 +382,6 @@ static inline struct mem_cgroup *memcg_f
 	return NULL;
 }
 
-/*
- * Charge the slab page belonging to the non-root kmem_cache.
- * Can be called for non-root kmem_caches only.
- */
-static __always_inline int memcg_charge_slab(struct page *page,
-					     gfp_t gfp, int order,
-					     struct kmem_cache *s)
-{
-	int nr_pages = 1 << order;
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
-	int ret;
-
-	rcu_read_lock();
-	memcg = READ_ONCE(s->memcg_params.memcg);
-	while (memcg && !css_tryget_online(&memcg->css))
-		memcg = parent_mem_cgroup(memcg);
-	rcu_read_unlock();
-
-	if (unlikely(!memcg || mem_cgroup_is_root(memcg))) {
-		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    nr_pages << PAGE_SHIFT);
-		percpu_ref_get_many(&s->memcg_params.refcnt, nr_pages);
-		return 0;
-	}
-
-	ret = memcg_kmem_charge(memcg, gfp, nr_pages);
-	if (ret)
-		goto out;
-
-	lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
-	mod_lruvec_state(lruvec, cache_vmstat_idx(s), nr_pages << PAGE_SHIFT);
-
-	percpu_ref_get_many(&s->memcg_params.refcnt, nr_pages);
-out:
-	css_put(&memcg->css);
-	return ret;
-}
-
-/*
- * Uncharge a slab page belonging to a non-root kmem_cache.
- * Can be called for non-root kmem_caches only.
- */
-static __always_inline void memcg_uncharge_slab(struct page *page, int order,
-						struct kmem_cache *s)
-{
-	int nr_pages = 1 << order;
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
-
-	rcu_read_lock();
-	memcg = READ_ONCE(s->memcg_params.memcg);
-	if (likely(!mem_cgroup_is_root(memcg))) {
-		lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
-		mod_lruvec_state(lruvec, cache_vmstat_idx(s),
-				 -(nr_pages << PAGE_SHIFT));
-		memcg_kmem_uncharge(memcg, nr_pages);
-	} else {
-		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    -(nr_pages << PAGE_SHIFT));
-	}
-	rcu_read_unlock();
-
-	percpu_ref_put_many(&s->memcg_params.refcnt, nr_pages);
-}
-
 static inline int memcg_alloc_page_obj_cgroups(struct page *page,
 					       struct kmem_cache *s, gfp_t gfp)
 {
@@ -470,6 +404,48 @@ static inline void memcg_free_page_obj_c
 	page->obj_cgroups = NULL;
 }
 
+static inline size_t obj_full_size(struct kmem_cache *s)
+{
+	/*
+	 * For each accounted object there is an extra space which is used
+	 * to store obj_cgroup membership. Charge it too.
+	 */
+	return s->size + sizeof(struct obj_cgroup *);
+}
+
+static inline struct kmem_cache *memcg_slab_pre_alloc_hook(struct kmem_cache *s,
+						struct obj_cgroup **objcgp,
+						size_t objects, gfp_t flags)
+{
+	struct kmem_cache *cachep;
+
+	cachep = memcg_kmem_get_cache(s, objcgp);
+	if (is_root_cache(cachep))
+		return s;
+
+	if (obj_cgroup_charge(*objcgp, flags, objects * obj_full_size(s))) {
+		obj_cgroup_put(*objcgp);
+		memcg_kmem_put_cache(cachep);
+		cachep = NULL;
+	}
+
+	return cachep;
+}
+
+static inline void mod_objcg_state(struct obj_cgroup *objcg,
+				   struct pglist_data *pgdat,
+				   int idx, int nr)
+{
+	struct mem_cgroup *memcg;
+	struct lruvec *lruvec;
+
+	rcu_read_lock();
+	memcg = obj_cgroup_memcg(objcg);
+	lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	mod_memcg_lruvec_state(lruvec, idx, nr);
+	rcu_read_unlock();
+}
+
 static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
 					      struct obj_cgroup *objcg,
 					      size_t size, void **p)
@@ -484,6 +460,10 @@ static inline void memcg_slab_post_alloc
 			off = obj_to_index(s, page, p[i]);
 			obj_cgroup_get(objcg);
 			page_obj_cgroups(page)[off] = objcg;
+			mod_objcg_state(objcg, page_pgdat(page),
+					cache_vmstat_idx(s), obj_full_size(s));
+		} else {
+			obj_cgroup_uncharge(objcg, obj_full_size(s));
 		}
 	}
 	obj_cgroup_put(objcg);
@@ -502,6 +482,11 @@ static inline void memcg_slab_free_hook(
 	off = obj_to_index(s, page, p);
 	objcg = page_obj_cgroups(page)[off];
 	page_obj_cgroups(page)[off] = NULL;
+
+	obj_cgroup_uncharge(objcg, obj_full_size(s));
+	mod_objcg_state(objcg, page_pgdat(page), cache_vmstat_idx(s),
+			-obj_full_size(s));
+
 	obj_cgroup_put(objcg);
 }
 
@@ -543,17 +528,6 @@ static inline struct mem_cgroup *memcg_f
 	return NULL;
 }
 
-static inline int memcg_charge_slab(struct page *page, gfp_t gfp, int order,
-				    struct kmem_cache *s)
-{
-	return 0;
-}
-
-static inline void memcg_uncharge_slab(struct page *page, int order,
-				       struct kmem_cache *s)
-{
-}
-
 static inline int memcg_alloc_page_obj_cgroups(struct page *page,
 					       struct kmem_cache *s, gfp_t gfp)
 {
@@ -564,6 +538,13 @@ static inline void memcg_free_page_obj_c
 {
 }
 
+static inline struct kmem_cache *memcg_slab_pre_alloc_hook(struct kmem_cache *s,
+						struct obj_cgroup **objcgp,
+						size_t objects, gfp_t flags)
+{
+	return NULL;
+}
+
 static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
 					      struct obj_cgroup *objcg,
 					      size_t size, void **p)
@@ -601,32 +582,33 @@ static __always_inline int charge_slab_p
 					    gfp_t gfp, int order,
 					    struct kmem_cache *s)
 {
-	int ret;
+#ifdef CONFIG_MEMCG_KMEM
+	if (memcg_kmem_enabled() && !is_root_cache(s)) {
+		int ret;
+
+		ret = memcg_alloc_page_obj_cgroups(page, s, gfp);
+		if (ret)
+			return ret;
 
-	if (is_root_cache(s)) {
-		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    PAGE_SIZE << order);
-		return 0;
+		percpu_ref_get_many(&s->memcg_params.refcnt, 1 << order);
 	}
-
-	ret = memcg_alloc_page_obj_cgroups(page, s, gfp);
-	if (ret)
-		return ret;
-
-	return memcg_charge_slab(page, gfp, order, s);
+#endif
+	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
+			    PAGE_SIZE << order);
+	return 0;
 }
 
 static __always_inline void uncharge_slab_page(struct page *page, int order,
 					       struct kmem_cache *s)
 {
-	if (is_root_cache(s)) {
-		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    -(PAGE_SIZE << order));
-		return;
+#ifdef CONFIG_MEMCG_KMEM
+	if (memcg_kmem_enabled() && !is_root_cache(s)) {
+		memcg_free_page_obj_cgroups(page);
+		percpu_ref_put_many(&s->memcg_params.refcnt, 1 << order);
 	}
-
-	memcg_free_page_obj_cgroups(page);
-	memcg_uncharge_slab(page, order, s);
+#endif
+	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
+			    -(PAGE_SIZE << order));
 }
 
 static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
@@ -692,7 +674,7 @@ static inline struct kmem_cache *slab_pr
 
 	if (memcg_kmem_enabled() &&
 	    ((flags & __GFP_ACCOUNT) || (s->flags & SLAB_ACCOUNT)))
-		return memcg_kmem_get_cache(s, objcgp);
+		return memcg_slab_pre_alloc_hook(s, objcgp, size, flags);
 
 	return s;
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

