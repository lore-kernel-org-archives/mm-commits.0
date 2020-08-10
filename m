Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3AAC433E1
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3B1D20723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597027000;
	bh=yFa1TqIJ3qaViVZuAdSGXz2XeUpaeNAPFaMxJQqiWN8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=p39la7UMTDgiluMTlMwk0EGNdfGFa3EB6AaSnIZOy65fl2WYiM1hV+VonFYZIOtGt
	 yxU6Rlsl4EqFyV8WwZENFzIjT4ieeu7i/t7p5NMIrF99HQ320CxY6j5PccHM8K6Mwj
	 IzK1WVBRa6RYxkjF1aS/9cLqhylyZDrytfcsnKDk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgHJCgk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbgHJCgj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:39 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92A5C206CD;
        Mon, 10 Aug 2020 02:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026997;
        bh=yFa1TqIJ3qaViVZuAdSGXz2XeUpaeNAPFaMxJQqiWN8=;
        h=Date:From:To:Subject:From;
        b=wCxdNbsmPzCKUhv/2tJttuXQpKi0Vq8QbybvZlCzgw4AbaCcThFbftJ6GK5vWMNxs
         x5CTGpjmY6wcpnsXkPejljIpkxbjc8c1KuHhKJVLAIcrDMQot87ZlViT1IwITjdM5D
         0Rz32EZXXASCMtdhJPW4Kj9EwJdQMa+f6pa6HH+A=
Date:   Sun, 09 Aug 2020 19:36:37 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        vbabka@suse.cz
Subject:  [merged]
 mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages.patch removed
 from -mm tree
Message-ID: <20200810023637.Ye-MT7wAw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: allocate obj_cgroups for non-root slab pages
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: allocate obj_cgroups for non-root slab pages

Allocate and release memory to store obj_cgroup pointers for each non-root
slab page. Reuse page->mem_cgroup pointer to store a pointer to the
allocated space.

This commit temporarily increases the memory footprint of the kernel memory
accounting. To store obj_cgroup pointers we'll need a place for an
objcg_pointer for each allocated object. However, the following patches
in the series will enable sharing of slab pages between memory cgroups,
which will dramatically increase the total slab utilization. And the final
memory footprint will be significantly smaller than before.

To distinguish between obj_cgroups and memcg pointers in case when it's
not obvious which one is used (as in page_cgroup_ino()), let's always set
the lowest bit in the obj_cgroup case. The original obj_cgroups
pointer is marked to be ignored by kmemleak, which otherwise would
report a memory leak for each allocated vector.

Link: http://lkml.kernel.org/r/20200623174037.3951353-8-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    5 ++-
 include/linux/slab_def.h |    6 ++++
 include/linux/slub_def.h |    5 +++
 mm/memcontrol.c          |   17 +++++++++---
 mm/slab.h                |   52 +++++++++++++++++++++++++++++++++++++
 5 files changed, 81 insertions(+), 4 deletions(-)

--- a/include/linux/mm_types.h~mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages
+++ a/include/linux/mm_types.h
@@ -198,7 +198,10 @@ struct page {
 	atomic_t _refcount;
 
 #ifdef CONFIG_MEMCG
-	struct mem_cgroup *mem_cgroup;
+	union {
+		struct mem_cgroup *mem_cgroup;
+		struct obj_cgroup **obj_cgroups;
+	};
 #endif
 
 	/*
--- a/include/linux/slab_def.h~mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages
+++ a/include/linux/slab_def.h
@@ -114,4 +114,10 @@ static inline unsigned int obj_to_index(
 	return reciprocal_divide(offset, cache->reciprocal_buffer_size);
 }
 
+static inline int objs_per_slab_page(const struct kmem_cache *cache,
+				     const struct page *page)
+{
+	return cache->num;
+}
+
 #endif	/* _LINUX_SLAB_DEF_H */
--- a/include/linux/slub_def.h~mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages
+++ a/include/linux/slub_def.h
@@ -198,4 +198,9 @@ static inline unsigned int obj_to_index(
 	return __obj_to_index(cache, page_address(page), obj);
 }
 
+static inline int objs_per_slab_page(const struct kmem_cache *cache,
+				     const struct page *page)
+{
+	return page->objects;
+}
 #endif /* _LINUX_SLUB_DEF_H */
--- a/mm/memcontrol.c~mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages
+++ a/mm/memcontrol.c
@@ -569,10 +569,21 @@ ino_t page_cgroup_ino(struct page *page)
 	unsigned long ino = 0;
 
 	rcu_read_lock();
-	if (PageSlab(page) && !PageTail(page))
+	if (PageSlab(page) && !PageTail(page)) {
 		memcg = memcg_from_slab_page(page);
-	else
-		memcg = READ_ONCE(page->mem_cgroup);
+	} else {
+		memcg = page->mem_cgroup;
+
+		/*
+		 * The lowest bit set means that memcg isn't a valid
+		 * memcg pointer, but a obj_cgroups pointer.
+		 * In this case the page is shared and doesn't belong
+		 * to any specific memory cgroup.
+		 */
+		if ((unsigned long) memcg & 0x1UL)
+			memcg = NULL;
+	}
+
 	while (memcg && !(memcg->css.flags & CSS_ONLINE))
 		memcg = parent_mem_cgroup(memcg);
 	if (memcg)
--- a/mm/slab.h~mm-memcg-slab-allocate-obj_cgroups-for-non-root-slab-pages
+++ a/mm/slab.h
@@ -109,6 +109,7 @@ struct memcg_cache_params {
 #include <linux/kmemleak.h>
 #include <linux/random.h>
 #include <linux/sched/mm.h>
+#include <linux/kmemleak.h>
 
 /*
  * State of the slab allocator.
@@ -348,6 +349,18 @@ static inline struct kmem_cache *memcg_r
 	return s->memcg_params.root_cache;
 }
 
+static inline struct obj_cgroup **page_obj_cgroups(struct page *page)
+{
+	/*
+	 * page->mem_cgroup and page->obj_cgroups are sharing the same
+	 * space. To distinguish between them in case we don't know for sure
+	 * that the page is a slab page (e.g. page_cgroup_ino()), let's
+	 * always set the lowest bit of obj_cgroups.
+	 */
+	return (struct obj_cgroup **)
+		((unsigned long)page->obj_cgroups & ~0x1UL);
+}
+
 /*
  * Expects a pointer to a slab page. Please note, that PageSlab() check
  * isn't sufficient, as it returns true also for tail compound slab pages,
@@ -435,6 +448,28 @@ static __always_inline void memcg_unchar
 	percpu_ref_put_many(&s->memcg_params.refcnt, nr_pages);
 }
 
+static inline int memcg_alloc_page_obj_cgroups(struct page *page,
+					       struct kmem_cache *s, gfp_t gfp)
+{
+	unsigned int objects = objs_per_slab_page(s, page);
+	void *vec;
+
+	vec = kcalloc_node(objects, sizeof(struct obj_cgroup *), gfp,
+			   page_to_nid(page));
+	if (!vec)
+		return -ENOMEM;
+
+	kmemleak_not_leak(vec);
+	page->obj_cgroups = (struct obj_cgroup **) ((unsigned long)vec | 0x1UL);
+	return 0;
+}
+
+static inline void memcg_free_page_obj_cgroups(struct page *page)
+{
+	kfree(page_obj_cgroups(page));
+	page->obj_cgroups = NULL;
+}
+
 extern void slab_init_memcg_params(struct kmem_cache *);
 extern void memcg_link_cache(struct kmem_cache *s, struct mem_cgroup *memcg);
 
@@ -484,6 +519,16 @@ static inline void memcg_uncharge_slab(s
 {
 }
 
+static inline int memcg_alloc_page_obj_cgroups(struct page *page,
+					       struct kmem_cache *s, gfp_t gfp)
+{
+	return 0;
+}
+
+static inline void memcg_free_page_obj_cgroups(struct page *page)
+{
+}
+
 static inline void slab_init_memcg_params(struct kmem_cache *s)
 {
 }
@@ -510,12 +555,18 @@ static __always_inline int charge_slab_p
 					    gfp_t gfp, int order,
 					    struct kmem_cache *s)
 {
+	int ret;
+
 	if (is_root_cache(s)) {
 		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
 				    PAGE_SIZE << order);
 		return 0;
 	}
 
+	ret = memcg_alloc_page_obj_cgroups(page, s, gfp);
+	if (ret)
+		return ret;
+
 	return memcg_charge_slab(page, gfp, order, s);
 }
 
@@ -528,6 +579,7 @@ static __always_inline void uncharge_sla
 		return;
 	}
 
+	memcg_free_page_obj_cgroups(page);
 	memcg_uncharge_slab(page, order, s);
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

