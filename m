Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82ADC433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A03D564F43
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhBYTZD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:25:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234302AbhBYTW6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:22:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B604464F5F;
        Thu, 25 Feb 2021 19:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280430;
        bh=PFyl/CiK8I19WGyuzmVUaKiSc++lVMYuuCS7urKVgJc=;
        h=Date:From:To:Subject:From;
        b=ZVlx5eSNdGEO/PEjjXCbNyoLc480wcQTbVXubx9HSvUnBDeXdxhAHkGIQA5HAjVQu
         ztg81VfDffBFLBbP4Gg7WSSre0zjvAfz5DddZnFqr2/1Q6Bp7cp+qU2PMJoA5ioXGV
         vWe//ZsvIcRW8VcUUaCfUz4moWb24acnlrJVmp1U=
Date:   Thu, 25 Feb 2021 11:13:49 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged]
 =?US-ASCII?Q?mm-memcg-slab-pre-allocate-obj=5Fcgroups-for-slab-caches-wit?=
 =?US-ASCII?Q?h-slab=5Faccount.patch?= removed from -mm tree
Message-ID: <20210225191349.lZ9_NZakK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: pre-allocate obj_cgroups for slab caches with SLAB_ACCOUNT
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: pre-allocate obj_cgroups for slab caches with SLAB_ACCOUNT

In general it's unknown in advance if a slab page will contain accounted
objects or not.  In order to avoid memory waste, an obj_cgroup vector is
allocated dynamically when a need to account of a new object arises.  Such
approach is memory efficient, but requires an expensive cmpxchg() to set
up the memcg/objcgs pointer, because an allocation can race with a
different allocation on another cpu.

But in some common cases it's known for sure that a slab page will contain
accounted objects: if the page belongs to a slab cache with a SLAB_ACCOUNT
flag set.  It includes such popular objects like vm_area_struct, anon_vma,
task_struct, etc.

In such cases we can pre-allocate the objcgs vector and simple assign it
to the page without any atomic operations, because at this early stage the
page is not visible to anyone else.

A very simplistic benchmark (allocating 10000000 64-bytes objects in a
row) shows ~15% win.  In the real life it seems that most workloads are
not very sensitive to the speed of (accounted) slab allocations.

[guro@fb.com: open-code set_page_objcgs() and add some comments, by Johannes]
  Link: https://lkml.kernel.org/r/20201113001926.GA2934489@carbon.dhcp.thefacebook.com
[akpm@linux-foundation.org: fix it for mm-slub-call-account_slab_page-after-slab-page-initialization-fix.patch]
Link: https://lkml.kernel.org/r/20201110195753.530157-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   19 -------------------
 mm/memcontrol.c            |   23 +++++++++++++++++++----
 mm/slab.c                  |    2 +-
 mm/slab.h                  |   14 ++++++++++----
 mm/slub.c                  |    2 +-
 5 files changed, 31 insertions(+), 29 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account
+++ a/include/linux/memcontrol.h
@@ -475,19 +475,6 @@ static inline struct obj_cgroup **page_o
 	return (struct obj_cgroup **)(memcg_data & ~MEMCG_DATA_FLAGS_MASK);
 }
 
-/*
- * set_page_objcgs - associate a page with a object cgroups vector
- * @page: a pointer to the page struct
- * @objcgs: a pointer to the object cgroups vector
- *
- * Atomically associates a page with a vector of object cgroups.
- */
-static inline bool set_page_objcgs(struct page *page,
-					struct obj_cgroup **objcgs)
-{
-	return !cmpxchg(&page->memcg_data, 0, (unsigned long)objcgs |
-			MEMCG_DATA_OBJCGS);
-}
 #else
 static inline struct obj_cgroup **page_objcgs(struct page *page)
 {
@@ -498,12 +485,6 @@ static inline struct obj_cgroup **page_o
 {
 	return NULL;
 }
-
-static inline bool set_page_objcgs(struct page *page,
-					struct obj_cgroup **objcgs)
-{
-	return true;
-}
 #endif
 
 static __always_inline bool memcg_stat_item_in_bytes(int idx)
--- a/mm/memcontrol.c~mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account
+++ a/mm/memcontrol.c
@@ -2935,9 +2935,10 @@ static void commit_charge(struct page *p
 
 #ifdef CONFIG_MEMCG_KMEM
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
-				 gfp_t gfp)
+				 gfp_t gfp, bool new_page)
 {
 	unsigned int objects = objs_per_slab_page(s, page);
+	unsigned long memcg_data;
 	void *vec;
 
 	vec = kcalloc_node(objects, sizeof(struct obj_cgroup *), gfp,
@@ -2945,11 +2946,25 @@ int memcg_alloc_page_obj_cgroups(struct
 	if (!vec)
 		return -ENOMEM;
 
-	if (!set_page_objcgs(page, vec))
+	memcg_data = (unsigned long) vec | MEMCG_DATA_OBJCGS;
+	if (new_page) {
+		/*
+		 * If the slab page is brand new and nobody can yet access
+		 * it's memcg_data, no synchronization is required and
+		 * memcg_data can be simply assigned.
+		 */
+		page->memcg_data = memcg_data;
+	} else if (cmpxchg(&page->memcg_data, 0, memcg_data)) {
+		/*
+		 * If the slab page is already in use, somebody can allocate
+		 * and assign obj_cgroups in parallel. In this case the existing
+		 * objcg vector should be reused.
+		 */
 		kfree(vec);
-	else
-		kmemleak_not_leak(vec);
+		return 0;
+	}
 
+	kmemleak_not_leak(vec);
 	return 0;
 }
 
--- a/mm/slab.c~mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account
+++ a/mm/slab.c
@@ -1379,7 +1379,7 @@ static struct page *kmem_getpages(struct
 		return NULL;
 	}
 
-	account_slab_page(page, cachep->gfporder, cachep);
+	account_slab_page(page, cachep->gfporder, cachep, flags);
 	__SetPageSlab(page);
 	/* Record if ALLOC_NO_WATERMARKS was set when allocating the slab */
 	if (sk_memalloc_socks() && page_is_pfmemalloc(page))
--- a/mm/slab.h~mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account
+++ a/mm/slab.h
@@ -238,7 +238,7 @@ static inline bool kmem_cache_debug_flag
 
 #ifdef CONFIG_MEMCG_KMEM
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
-				 gfp_t gfp);
+				 gfp_t gfp, bool new_page);
 
 static inline void memcg_free_page_obj_cgroups(struct page *page)
 {
@@ -315,7 +315,8 @@ static inline void memcg_slab_post_alloc
 			page = virt_to_head_page(p[i]);
 
 			if (!page_objcgs(page) &&
-			    memcg_alloc_page_obj_cgroups(page, s, flags)) {
+			    memcg_alloc_page_obj_cgroups(page, s, flags,
+							 false)) {
 				obj_cgroup_uncharge(objcg, obj_full_size(s));
 				continue;
 			}
@@ -379,7 +380,8 @@ static inline struct mem_cgroup *memcg_f
 }
 
 static inline int memcg_alloc_page_obj_cgroups(struct page *page,
-					       struct kmem_cache *s, gfp_t gfp)
+					       struct kmem_cache *s, gfp_t gfp,
+					       bool new_page)
 {
 	return 0;
 }
@@ -420,8 +422,12 @@ static inline struct kmem_cache *virt_to
 }
 
 static __always_inline void account_slab_page(struct page *page, int order,
-					      struct kmem_cache *s)
+					      struct kmem_cache *s,
+					      gfp_t gfp)
 {
+	if (memcg_kmem_enabled() && (s->flags & SLAB_ACCOUNT))
+		memcg_alloc_page_obj_cgroups(page, s, gfp, true);
+
 	mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
 			    PAGE_SIZE << order);
 }
--- a/mm/slub.c~mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account
+++ a/mm/slub.c
@@ -1785,7 +1785,7 @@ static struct page *allocate_slab(struct
 
 	page->objects = oo_objects(oo);
 
-	account_slab_page(page, oo_order(oo), s);
+	account_slab_page(page, oo_order(oo), s, flags);
 
 	page->slab_cache = s;
 	__SetPageSlab(page);
_

Patches currently in -mm which might be from guro@fb.com are

mm-cma-allocate-cma-areas-bottom-up.patch
mm-cma-allocate-cma-areas-bottom-up-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-2.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

