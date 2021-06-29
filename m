Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16FD6C11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED9DA61CFA
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhF2AZg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:25:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhF2AZg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:25:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C02F061CF9;
        Tue, 29 Jun 2021 00:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926190;
        bh=4WhhRb85kX0mX4p3Br6yORcrRwcMCMKFYyrmFpmZpm4=;
        h=Date:From:To:Subject:From;
        b=YVmzvrGmevWPFeH/zRM2qn9ZEF567PVQzpQrYxq701ZbzfdC9dKaEK/nPm3xSZpJY
         GAds2s2gKSFexw8xNXhdCuZ9AzGYqSIbSVJKq/yspfRbjPV1btDCShIW/QdT2c51A1
         9ThyWMWX6VmmCED0yP6CAMl3AGrdulFljdpwMvXU=
Date:   Mon, 28 Jun 2021 17:23:09 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, longman@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sfr@canb.auug.org.au, shakeelb@google.com,
        vbabka@suse.cz, vdavydov.dev@gmail.com
Subject:  [folded-merged]
 mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5.patch removed from
 -mm tree
Message-ID: <20210629002309.irYNx-Bbm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5.patch

This patch was dropped because it was folded into mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches.patch

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5

It turns out that the previous patch doesn't work if CONFIG_ZONE_DMA isn't
defined.

Link: https://lkml.kernel.org/r/20210512145107.6208-1-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
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
@@ -842,15 +842,10 @@ void __init setup_kmalloc_cache_index_ta
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
mm-memcg-slab-disable-cache-merging-for-kmalloc_normal-caches.patch

