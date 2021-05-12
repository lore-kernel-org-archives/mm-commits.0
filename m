Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD89C433ED
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 23:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B95F361206
	for <mm-commits@archiver.kernel.org>; Wed, 12 May 2021 23:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243981AbhELX5V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 May 2021 19:57:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235865AbhELXpV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 May 2021 19:45:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0C6D61405;
        Wed, 12 May 2021 23:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620863052;
        bh=kdI4fMVRxDbccet7pLb6vGPngjZzNmT6UfizLUBkC0A=;
        h=Date:From:To:Subject:From;
        b=P5RfOh3zOfZFc3KSa5ku7Cuk58FzXGtfgciOo3wgw8jpG3/FcXU/LoqSmjEyuipWY
         LOem1AkcOjK80v2q/mj7fl4rxWz5vjalC8sQqMBWkaUpRvEDEv5YFPYkAc1pHr+vrg
         7a07XBBMnER1qyfomuN7s/afYBPhmOKI4lo7+Upw=
Date:   Wed, 12 May 2021 16:44:11 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, longman@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  +
 mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5.patch added to -mm
 tree
Message-ID: <20210512234411.E8Hh78uFR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5

It turns out that the previous patch doesn't work if CONFIG_ZONE_DMA isn't
defined.

Link: https://lkml.kernel.org/r/20210512145107.6208-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   11 ++++++-----
 mm/internal.h        |    5 -----
 mm/memcontrol.c      |    2 +-
 mm/slab_common.c     |    9 ++-------
 4 files changed, 9 insertions(+), 18 deletions(-)

--- a/include/linux/slab.h~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5
+++ a/include/linux/slab.h
@@ -312,16 +312,17 @@ static inline void __check_heap_object(c
  */
 enum kmalloc_cache_type {
 	KMALLOC_NORMAL = 0,
-#ifdef CONFIG_MEMCG_KMEM
-	KMALLOC_CGROUP,
-#else
+#ifndef CONFIG_ZONE_DMA
+	KMALLOC_DMA = KMALLOC_NORMAL,
+#endif
+#ifndef CONFIG_MEMCG_KMEM
 	KMALLOC_CGROUP = KMALLOC_NORMAL,
+#else
+	KMALLOC_CGROUP,
 #endif
 	KMALLOC_RECLAIM,
 #ifdef CONFIG_ZONE_DMA
 	KMALLOC_DMA,
-#else
-	KMALLOC_DMA = KMALLOC_NORMAL,
 #endif
 	NR_KMALLOC_TYPES
 };
--- a/mm/internal.h~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5
+++ a/mm/internal.h
@@ -116,11 +116,6 @@ extern void putback_lru_page(struct page
 extern pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
 
 /*
- * in mm/memcontrol.c:
- */
-extern bool cgroup_memory_nokmem;
-
-/*
  * in mm/page_alloc.c
  */
 
--- a/mm/memcontrol.c~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5
+++ a/mm/memcontrol.c
@@ -83,7 +83,7 @@ DEFINE_PER_CPU(struct mem_cgroup *, int_
 static bool cgroup_memory_nosocket;
 
 /* Kernel memory accounting disabled? */
-bool cgroup_memory_nokmem;
+static bool cgroup_memory_nokmem;
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
--- a/mm/slab_common.c~mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5
+++ a/mm/slab_common.c
@@ -841,15 +841,10 @@ void __init setup_kmalloc_cache_index_ta
 static void __init
 new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
 {
-	if (type == KMALLOC_RECLAIM) {
+	if (type == KMALLOC_RECLAIM)
 		flags |= SLAB_RECLAIM_ACCOUNT;
-	} else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP)) {
-		if (cgroup_memory_nokmem) {
-			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
-			return;
-		}
+	else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP))
 		flags |= SLAB_ACCOUNT;
-	}
 
 	kmalloc_caches[type][idx] = create_kmalloc_cache(
 					kmalloc_info[idx].name[type],
_

Patches currently in -mm which might be from longman@redhat.com are

mm-memcg-move-mod_objcg_state-to-memcontrolc.patch
mm-memcg-cache-vmstat-data-in-percpu-memcg_stock_pcp.patch
mm-memcg-improve-refill_obj_stock-performance.patch
mm-memcg-optimize-user-context-object-stock-access.patch
mm-memcg-slab-properly-set-up-gfp-flags-for-objcg-pointer-array.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5.patch
mm-memcg-slab-disable-cache-merging-for-kmalloc_normal-caches.patch

