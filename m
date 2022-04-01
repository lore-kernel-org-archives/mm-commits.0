Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC2FC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 18:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351040AbiDASap (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351035AbiDASaa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2022 14:30:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16721AE234
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 11:28:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9787AB825B3
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 18:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517E9C2BBE4;
        Fri,  1 Apr 2022 18:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648837717;
        bh=j3G5qLSFoKcDWuso+x7UqSY0ZG6NlWyASPqJ1eYQrJE=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=IS29QC+Uj+5Z5h4BR9dm0d9o0K+3G2FyggnRRiZcBYm6NWI4tFlozSC6Zp7TX92tL
         hU5YzlAMAsmLQg3wuaeWcmghTkq3+y3/sw88BjGprc2CGK0jN3ViRMOMK0ICBlFTiy
         QlkcCCXv2vYzT9DE7t1hpkhPr6GhR/3sw7briJNs=
Date:   Fri, 01 Apr 2022 11:28:36 -0700
To:     roman.gushchin@linux.dev, glider@google.com, elver@google.com,
        dvyukov@google.com, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220401112740.351496714b370467a92207a6@linux-foundation.org>
Subject: [patch 09/16] mm: kfence: fix objcgs vector allocation
Message-Id: <20220401182837.517E9C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: kfence: fix objcgs vector allocation

If the kfence object is allocated to be used for objects vector, then this
slot of the pool eventually being occupied permanently since the vector is
never freed.  The solutions could be 1) freeing vector when the kfence
object is freed or 2) allocating all vectors statically.  Since the memory
consumption of object vectors is low, it is better to chose 2) to fix the
issue and it is also can reduce overhead of vectors allocating in the
future.

Link: https://lkml.kernel.org/r/20220328132843.16624-1-songmuchun@bytedance.com
Fixes: d3fb45f370d9 ("mm, kfence: insert KFENCE hooks for SLAB")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c   |   11 ++++++++++-
 mm/kfence/kfence.h |    3 +++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/mm/kfence/core.c~mm-kfence-fix-objcgs-vector-allocation
+++ a/mm/kfence/core.c
@@ -566,6 +566,8 @@ static unsigned long kfence_init_pool(vo
 	 * enters __slab_free() slow-path.
 	 */
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
+		struct slab *slab = page_slab(&pages[i]);
+
 		if (!i || (i % 2))
 			continue;
 
@@ -573,7 +575,11 @@ static unsigned long kfence_init_pool(vo
 		if (WARN_ON(compound_head(&pages[i]) != &pages[i]))
 			return addr;
 
-		__SetPageSlab(&pages[i]);
+		__folio_set_slab(slab_folio(slab));
+#ifdef CONFIG_MEMCG
+		slab->memcg_data = (unsigned long)&kfence_metadata[i / 2 - 1].objcg |
+				   MEMCG_DATA_OBJCGS;
+#endif
 	}
 
 	/*
@@ -1033,6 +1039,9 @@ void __kfence_free(void *addr)
 {
 	struct kfence_metadata *meta = addr_to_metadata((unsigned long)addr);
 
+#ifdef CONFIG_MEMCG
+	KFENCE_WARN_ON(meta->objcg);
+#endif
 	/*
 	 * If the objects of the cache are SLAB_TYPESAFE_BY_RCU, defer freeing
 	 * the object, as the object page may be recycled for other-typed
--- a/mm/kfence/kfence.h~mm-kfence-fix-objcgs-vector-allocation
+++ a/mm/kfence/kfence.h
@@ -89,6 +89,9 @@ struct kfence_metadata {
 	struct kfence_track free_track;
 	/* For updating alloc_covered on frees. */
 	u32 alloc_stack_hash;
+#ifdef CONFIG_MEMCG
+	struct obj_cgroup *objcg;
+#endif
 };
 
 extern struct kfence_metadata kfence_metadata[CONFIG_KFENCE_NUM_OBJECTS];
_
