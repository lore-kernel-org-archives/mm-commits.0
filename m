Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8145CC11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 645DA61D0B
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhF2CkG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:40:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231809AbhF2CkF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:40:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5810C61D04;
        Tue, 29 Jun 2021 02:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934258;
        bh=CaNm4vNDR3KTJsf3X0s8Brc7Ur/yvhfd38eVU5bAIYg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=t9rkEgUOnd6le4e8FAcfFdqv6VyH367DQ3TP0W2yDGcv5z7AEexWXRu6DBcD2AiBA
         kTvT72Rz/edrJuwfSkZzrQpAa6b9YG5TVeQrTd3v2NhZ3OVztUERJFLv4KL2f0fCAf
         SBhkfMJEQC4Lb+k2biXdQORgjeQx2jP562XrYYtE=
Date:   Mon, 28 Jun 2021 19:37:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        longman@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, shakeelb@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  [patch 082/192] mm: memcg/slab: create a new set of
 kmalloc-cg-<n> caches
Message-ID: <20210629023738.MBexNoCOI%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Waiman Long <longman@redhat.com>
Subject: mm: memcg/slab: create a new set of kmalloc-cg-<n> caches

There are currently two problems in the way the objcg pointer array
(memcg_data) in the page structure is being allocated and freed.

On its allocation, it is possible that the allocated objcg pointer
array comes from the same slab that requires memory accounting. If this
happens, the slab will never become empty again as there is at least
one object left (the obj_cgroup array) in the slab.

When it is freed, the objcg pointer array object may be the last one
in its slab and hence causes kfree() to be called again. With the
right workload, the slab cache may be set up in a way that allows the
recursive kfree() calling loop to nest deep enough to cause a kernel
stack overflow and panic the system.

One way to solve this problem is to split the kmalloc-<n> caches
(KMALLOC_NORMAL) into two separate sets - a new set of kmalloc-<n>
(KMALLOC_NORMAL) caches for unaccounted objects only and a new set of
kmalloc-cg-<n> (KMALLOC_CGROUP) caches for accounted objects only. All
the other caches can still allow a mix of accounted and unaccounted
objects.

With this change, all the objcg pointer array objects will come from
KMALLOC_NORMAL caches which won't have their objcg pointer arrays. So
both the recursive kfree() problem and non-freeable slab problem are
gone.

Since both the KMALLOC_NORMAL and KMALLOC_CGROUP caches no longer have
mixed accounted and unaccounted objects, this will slightly reduce the
number of objcg pointer arrays that need to be allocated and save a bit
of memory. On the other hand, creating a new set of kmalloc caches does
have the effect of reducing cache utilization. So it is properly a wash.

The new KMALLOC_CGROUP is added between KMALLOC_NORMAL and
KMALLOC_RECLAIM so that the first for loop in create_kmalloc_caches()
will include the newly added caches without change.

[vbabka@suse.cz: don't create kmalloc-cg caches with cgroup.memory=nokmem]
Link: https://lkml.kernel.org/r/20210512145107.6208-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20210505200610.13943-3-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
[longman@redhat.com: fix for CONFIG_ZONE_DMA=n]
  Link: https://lkml.kernel.org/r/20210512145107.6208-1-longman@redhat.com
[akpm@linux-foundation.org: un-fat-finger v5 delta creation]
[longman@redhat.com: disable cache merging for KMALLOC_NORMAL caches]
  Link: https://lkml.kernel.org/r/20210505200610.13943-4-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Suggested-by: Roman Gushchin <guro@fb.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   42 ++++++++++++++++++++++++++++++++---------
 mm/internal.h        |    5 ++++
 mm/memcontrol.c      |    2 -
 mm/slab_common.c     |   32 ++++++++++++++++++++++---------
 4 files changed, 62 insertions(+), 19 deletions(-)

--- a/include/linux/slab.h~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches
+++ a/include/linux/slab.h
@@ -305,9 +305,21 @@ static inline void __check_heap_object(c
 /*
  * Whenever changing this, take care of that kmalloc_type() and
  * create_kmalloc_caches() still work as intended.
+ *
+ * KMALLOC_NORMAL can contain only unaccounted objects whereas KMALLOC_CGROUP
+ * is for accounted but unreclaimable and non-dma objects. All the other
+ * kmem caches can have both accounted and unaccounted objects.
  */
 enum kmalloc_cache_type {
 	KMALLOC_NORMAL = 0,
+#ifndef CONFIG_ZONE_DMA
+	KMALLOC_DMA = KMALLOC_NORMAL,
+#endif
+#ifndef CONFIG_MEMCG_KMEM
+	KMALLOC_CGROUP = KMALLOC_NORMAL,
+#else
+	KMALLOC_CGROUP,
+#endif
 	KMALLOC_RECLAIM,
 #ifdef CONFIG_ZONE_DMA
 	KMALLOC_DMA,
@@ -319,24 +331,36 @@ enum kmalloc_cache_type {
 extern struct kmem_cache *
 kmalloc_caches[NR_KMALLOC_TYPES][KMALLOC_SHIFT_HIGH + 1];
 
+/*
+ * Define gfp bits that should not be set for KMALLOC_NORMAL.
+ */
+#define KMALLOC_NOT_NORMAL_BITS					\
+	(__GFP_RECLAIMABLE |					\
+	(IS_ENABLED(CONFIG_ZONE_DMA)   ? __GFP_DMA : 0) |	\
+	(IS_ENABLED(CONFIG_MEMCG_KMEM) ? __GFP_ACCOUNT : 0))
+
 static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags)
 {
-#ifdef CONFIG_ZONE_DMA
 	/*
 	 * The most common case is KMALLOC_NORMAL, so test for it
-	 * with a single branch for both flags.
+	 * with a single branch for all the relevant flags.
 	 */
-	if (likely((flags & (__GFP_DMA | __GFP_RECLAIMABLE)) == 0))
+	if (likely((flags & KMALLOC_NOT_NORMAL_BITS) == 0))
 		return KMALLOC_NORMAL;
 
 	/*
-	 * At least one of the flags has to be set. If both are, __GFP_DMA
-	 * is more important.
+	 * At least one of the flags has to be set. Their priorities in
+	 * decreasing order are:
+	 *  1) __GFP_DMA
+	 *  2) __GFP_RECLAIMABLE
+	 *  3) __GFP_ACCOUNT
 	 */
-	return flags & __GFP_DMA ? KMALLOC_DMA : KMALLOC_RECLAIM;
-#else
-	return flags & __GFP_RECLAIMABLE ? KMALLOC_RECLAIM : KMALLOC_NORMAL;
-#endif
+	if (IS_ENABLED(CONFIG_ZONE_DMA) && (flags & __GFP_DMA))
+		return KMALLOC_DMA;
+	if (!IS_ENABLED(CONFIG_MEMCG_KMEM) || (flags & __GFP_RECLAIMABLE))
+		return KMALLOC_RECLAIM;
+	else
+		return KMALLOC_CGROUP;
 }
 
 /*
--- a/mm/internal.h~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches
+++ a/mm/internal.h
@@ -116,6 +116,11 @@ extern void putback_lru_page(struct page
 extern pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
 
 /*
+ * in mm/memcontrol.c:
+ */
+extern bool cgroup_memory_nokmem;
+
+/*
  * in mm/page_alloc.c
  */
 
--- a/mm/memcontrol.c~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches
+++ a/mm/memcontrol.c
@@ -83,7 +83,7 @@ DEFINE_PER_CPU(struct mem_cgroup *, int_
 static bool cgroup_memory_nosocket;
 
 /* Kernel memory accounting disabled? */
-static bool cgroup_memory_nokmem;
+bool cgroup_memory_nokmem;
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
--- a/mm/slab_common.c~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches
+++ a/mm/slab_common.c
@@ -738,21 +738,25 @@ struct kmem_cache *kmalloc_slab(size_t s
 }
 
 #ifdef CONFIG_ZONE_DMA
-#define INIT_KMALLOC_INFO(__size, __short_size)			\
-{								\
-	.name[KMALLOC_NORMAL]  = "kmalloc-" #__short_size,	\
-	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #__short_size,	\
-	.name[KMALLOC_DMA]     = "dma-kmalloc-" #__short_size,	\
-	.size = __size,						\
-}
+#define KMALLOC_DMA_NAME(sz)	.name[KMALLOC_DMA] = "dma-kmalloc-" #sz,
 #else
+#define KMALLOC_DMA_NAME(sz)
+#endif
+
+#ifdef CONFIG_MEMCG_KMEM
+#define KMALLOC_CGROUP_NAME(sz)	.name[KMALLOC_CGROUP] = "kmalloc-cg-" #sz,
+#else
+#define KMALLOC_CGROUP_NAME(sz)
+#endif
+
 #define INIT_KMALLOC_INFO(__size, __short_size)			\
 {								\
 	.name[KMALLOC_NORMAL]  = "kmalloc-" #__short_size,	\
 	.name[KMALLOC_RECLAIM] = "kmalloc-rcl-" #__short_size,	\
+	KMALLOC_CGROUP_NAME(__short_size)			\
+	KMALLOC_DMA_NAME(__short_size)				\
 	.size = __size,						\
 }
-#endif
 
 /*
  * kmalloc_info[] is to make slub_debug=,kmalloc-xx option work at boot time.
@@ -838,8 +842,15 @@ void __init setup_kmalloc_cache_index_ta
 static void __init
 new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
 {
-	if (type == KMALLOC_RECLAIM)
+	if (type == KMALLOC_RECLAIM) {
 		flags |= SLAB_RECLAIM_ACCOUNT;
+	} else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP)) {
+		if (cgroup_memory_nokmem) {
+			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
+			return;
+		}
+		flags |= SLAB_ACCOUNT;
+	}
 
 	kmalloc_caches[type][idx] = create_kmalloc_cache(
 					kmalloc_info[idx].name[type],
@@ -857,6 +868,9 @@ void __init create_kmalloc_caches(slab_f
 	int i;
 	enum kmalloc_cache_type type;
 
+	/*
+	 * Including KMALLOC_CGROUP if CONFIG_MEMCG_KMEM defined
+	 */
 	for (type = KMALLOC_NORMAL; type <= KMALLOC_RECLAIM; type++) {
 		for (i = KMALLOC_SHIFT_LOW; i <= KMALLOC_SHIFT_HIGH; i++) {
 			if (!kmalloc_caches[type][i])
_
