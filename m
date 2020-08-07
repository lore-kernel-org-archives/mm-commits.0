Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63EC8C433E8
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41FA822C9F
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781279;
	bh=TLUdxppDDB393KQgCT/k49c09HwP86rAwNffi0L8VdA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=bhrVQeHPBovagCc7QUL9xHyX3OF2uDo31gmkLaoirDOM5FkmdOJFNmFUKY8LNglJ1
	 LkdRX+eZgpjFkgXJkKl1ml0RJyLFdPR5DsOkosXG0TkLUHm65EMWS7lvTeufjr9cbq
	 CPEI9yPtd+DvAFQyrqMRTftlTJRvi8qPBx2oi6sY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHGGVT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgHGGVS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:21:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 156BB2177B;
        Fri,  7 Aug 2020 06:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781278;
        bh=TLUdxppDDB393KQgCT/k49c09HwP86rAwNffi0L8VdA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PIXyP8vNDfPHsWbeVrItcNMDW7PvdbThgTzAGqYzdTqEVgtGljZCoF0k+owhtA3E2
         EnsY9J9MCrd0JE1U0QZvdLP+Vx8I+5p8PbtfsjvI1RrsH9PRQoA6vySKM5N0NJzVWe
         p5gpL5DjRrMPn02ytgzFrQWyCnq1XvEe0Cuh9mis=
Date:   Thu, 06 Aug 2020 23:21:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 075/163] mm: memcg/slab: remove
 memcg_kmem_get_cache()
Message-ID: <20200807062117.-2gQ_1DHO%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg/slab: remove memcg_kmem_get_cache()

The memcg_kmem_get_cache() function became really trivial, so let's just
inline it into the single call point: memcg_slab_pre_alloc_hook().

It will make the code less bulky and can also help the compiler to
generate a better code.

Link: http://lkml.kernel.org/r/20200623174037.3951353-15-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 --
 mm/memcontrol.c            |   25 +------------------------
 mm/slab.h                  |   11 +++++++++--
 mm/slab_common.c           |    2 +-
 4 files changed, 11 insertions(+), 29 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-slab-remove-memcg_kmem_get_cache
+++ a/include/linux/memcontrol.h
@@ -1403,8 +1403,6 @@ static inline void memcg_set_shrinker_bi
 }
 #endif
 
-struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep);
-
 #ifdef CONFIG_MEMCG_KMEM
 int __memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
 			unsigned int nr_pages);
--- a/mm/memcontrol.c~mm-memcg-slab-remove-memcg_kmem_get_cache
+++ a/mm/memcontrol.c
@@ -393,7 +393,7 @@ void memcg_put_cache_ids(void)
 
 /*
  * A lot of the calls to the cache allocation functions are expected to be
- * inlined by the compiler. Since the calls to memcg_kmem_get_cache are
+ * inlined by the compiler. Since the calls to memcg_slab_pre_alloc_hook() are
  * conditional to this static branch, we'll have to allow modules that does
  * kmem_cache_alloc and the such to see this symbol as well
  */
@@ -2901,29 +2901,6 @@ static void memcg_free_cache_id(int id)
 }
 
 /**
- * memcg_kmem_get_cache: select memcg or root cache for allocation
- * @cachep: the original global kmem cache
- *
- * Return the kmem_cache we're supposed to use for a slab allocation.
- *
- * If the cache does not exist yet, if we are the first user of it, we
- * create it asynchronously in a workqueue and let the current allocation
- * go through with the original cache.
- */
-struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep)
-{
-	struct kmem_cache *memcg_cachep;
-
-	memcg_cachep = READ_ONCE(cachep->memcg_params.memcg_cache);
-	if (unlikely(!memcg_cachep)) {
-		queue_work(system_wq, &cachep->memcg_params.work);
-		return cachep;
-	}
-
-	return memcg_cachep;
-}
-
-/**
  * __memcg_kmem_charge: charge a number of kernel pages to a memcg
  * @memcg: memory cgroup to charge
  * @gfp: reclaim mode
--- a/mm/slab_common.c~mm-memcg-slab-remove-memcg_kmem_get_cache
+++ a/mm/slab_common.c
@@ -570,7 +570,7 @@ void memcg_create_kmem_cache(struct kmem
 	}
 
 	/*
-	 * Since readers won't lock (see memcg_kmem_get_cache()), we need a
+	 * Since readers won't lock (see memcg_slab_pre_alloc_hook()), we need a
 	 * barrier here to ensure nobody will see the kmem_cache partially
 	 * initialized.
 	 */
--- a/mm/slab.h~mm-memcg-slab-remove-memcg_kmem_get_cache
+++ a/mm/slab.h
@@ -365,9 +365,16 @@ static inline struct kmem_cache *memcg_s
 	if (memcg_kmem_bypass())
 		return s;
 
-	cachep = memcg_kmem_get_cache(s);
-	if (is_root_cache(cachep))
+	cachep = READ_ONCE(s->memcg_params.memcg_cache);
+	if (unlikely(!cachep)) {
+		/*
+		 * If memcg cache does not exist yet, we schedule it's
+		 * asynchronous creation and let the current allocation
+		 * go through with the root cache.
+		 */
+		queue_work(system_wq, &s->memcg_params.work);
 		return s;
+	}
 
 	objcg = get_obj_cgroup_from_current();
 	if (!objcg)
_
