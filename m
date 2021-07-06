Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC8FC07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87FEB61C72
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhGFTOE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:14:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230071AbhGFTOE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:14:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CE7861C6C;
        Tue,  6 Jul 2021 19:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598685;
        bh=uT9zPsbuyXSInyDkuC8w94pkuj0n3+s2rLoKqpOGdoE=;
        h=Date:From:To:Subject:From;
        b=HgQlUmpK2YIMiXbVc3l7vx9xKsNYh3Nv2oyVwNTYqVkfyJ0dQ2xLpvLuSSQ1HeaAb
         ozlqpMjMrJvoDELSenIpc/4WUkwjwC2GZCt6TQxNqD9S7Dk6rZjnyYsTnV+FoVIBgU
         au6TYAIdANgWMQDpQU3dnLZ59UJNoW7HZZPgeWOs=
Date:   Tue, 06 Jul 2021 12:11:25 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, longman@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcg-slab-properly-set-up-gfp-flags-for-objcg-pointer-array.patch
 removed from -mm tree
Message-ID: <20210706191125.5YsrD_ZVd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: properly set up gfp flags for objcg pointer array
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-properly-set-up-gfp-flags-for-objcg-pointer-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm: memcg/slab: properly set up gfp flags for objcg pointer array

Patch series "mm: memcg/slab: Fix objcg pointer array handling problem", v4.

Since the merging of the new slab memory controller in v5.9, the page
structure stores a pointer to objcg pointer array for slab pages.  When
the slab has no used objects, it can be freed in free_slab() which will
call kfree() to free the objcg pointer array in
memcg_alloc_page_obj_cgroups().  If it happens that the objcg pointer
array is the last used object in its slab, that slab may then be freed
which may caused kfree() to be called again.

With the right workload, the slab cache may be set up in a way that allows
the recursive kfree() calling loop to nest deep enough to cause a kernel
stack overflow and panic the system.  In fact, we have a reproducer that
can cause kernel stack overflow on a s390 system involving kmalloc-rcl-256
and kmalloc-rcl-128 slabs with the following kfree() loop recursively
called 74 times:

  [ 285.520739] [<000000000ec432fc>] kfree+0x4bc/0x560 [ 285.520740]
[<000000000ec43466>] __free_slab+0xc6/0x228 [ 285.520741]
[<000000000ec41fc2>] __slab_free+0x3c2/0x3e0 [ 285.520742]
[<000000000ec432fc>] kfree+0x4bc/0x560 : While investigating this issue, I
also found an issue on the allocation side.  If the objcg pointer array
happen to come from the same slab or a circular dependency linkage is
formed with multiple slabs, those affected slabs can never be freed again.

This patch series addresses these two issues by introducing a new set of
kmalloc-cg-<n> caches split from kmalloc-<n> caches.  The new set will
only contain non-reclaimable and non-dma objects that are accounted in
memory cgroups whereas the old set are now for unaccounted objects only. 
By making this split, all the objcg pointer arrays will come from the
kmalloc-<n> caches, but those caches will never hold any objcg pointer
array.  As a result, deeply nested kfree() call and the unfreeable slab
problems are now gone.


This patch (of 4):

Since the merging of the new slab memory controller in v5.9, the page
structure may store a pointer to obj_cgroup pointer array for slab pages. 
Currently, only the __GFP_ACCOUNT bit is masked off.  However, the array
is not readily reclaimable and doesn't need to come from the DMA buffer. 
So those GFP bits should be masked off as well.

Do the flag bit clearing at memcg_alloc_page_obj_cgroups() to make sure
that it is consistently applied no matter where it is called.

Link: https://lkml.kernel.org/r/20210505200610.13943-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20210505200610.13943-2-longman@redhat.com
Fixes: 286e04b8ed7a ("mm: memcg/slab: allocate obj_cgroups for non-root slab pages")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++++++
 mm/slab.h       |    1 -
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-slab-properly-set-up-gfp-flags-for-objcg-pointer-array
+++ a/mm/memcontrol.c
@@ -2803,6 +2803,13 @@ retry:
 }
 
 #ifdef CONFIG_MEMCG_KMEM
+/*
+ * The allocated objcg pointers array is not accounted directly.
+ * Moreover, it should not come from DMA buffer and is not readily
+ * reclaimable. So those GFP bits should be masked off.
+ */
+#define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)
+
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
 				 gfp_t gfp, bool new_page)
 {
@@ -2810,6 +2817,7 @@ int memcg_alloc_page_obj_cgroups(struct
 	unsigned long memcg_data;
 	void *vec;
 
+	gfp &= ~OBJCGS_CLEAR_MASK;
 	vec = kcalloc_node(objects, sizeof(struct obj_cgroup *), gfp,
 			   page_to_nid(page));
 	if (!vec)
--- a/mm/slab.h~mm-memcg-slab-properly-set-up-gfp-flags-for-objcg-pointer-array
+++ a/mm/slab.h
@@ -298,7 +298,6 @@ static inline void memcg_slab_post_alloc
 	if (!memcg_kmem_enabled() || !objcg)
 		return;
 
-	flags &= ~__GFP_ACCOUNT;
 	for (i = 0; i < size; i++) {
 		if (likely(p[i])) {
 			page = virt_to_head_page(p[i]);
_

Patches currently in -mm which might be from longman@redhat.com are


