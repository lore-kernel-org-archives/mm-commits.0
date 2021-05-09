Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 011A2C433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BED2761431
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 03:41:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhEIDmX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 23:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhEIDmX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 23:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AE7E61421;
        Sun,  9 May 2021 03:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620531680;
        bh=mZNnpY4NcgPMIHTuX510nfjeabH1LguTZ8bUabpMoVU=;
        h=Date:From:To:Subject:From;
        b=k9lLjoZY2K1j3oWWA6S01cH+0Xyrl7ubNURJinkEpFSUdfM63QPCl8gV+BStrlpnX
         Ygyv8fo2oxZtPXBClirGw5LWBiI9X7wxQQ1sVDKmxWESC12dh+YHW+pMPFqwSg2dap
         PBD8iWyM3ZaEYMI2Jz9eO5Pixyk0lG+VwHbgbGP0=
Date:   Sat, 08 May 2021 20:41:19 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, longman@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  +
 mm-memcg-slab-properly-set-up-gfp-flags-for-objcg-pointer-array.patch added
 to -mm tree
Message-ID: <20210509034119.iRTG3W-3h%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: properly set up gfp flags for objcg pointer array
has been added to the -mm tree.  Its filename is
     mm-memcg-slab-properly-set-up-gfp-flags-for-objcg-pointer-array.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-slab-properly-set-up-gfp-flags-for-objcg-pointer-array.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-slab-properly-set-up-gfp-flags-for-objcg-pointer-array.patch

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
@@ -2802,6 +2802,13 @@ retry:
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
@@ -2809,6 +2816,7 @@ int memcg_alloc_page_obj_cgroups(struct
 	unsigned long memcg_data;
 	void *vec;
 
+	gfp &= ~OBJCGS_CLEAR_MASK;
 	vec = kcalloc_node(objects, sizeof(struct obj_cgroup *), gfp,
 			   page_to_nid(page));
 	if (!vec)
--- a/mm/slab.h~mm-memcg-slab-properly-set-up-gfp-flags-for-objcg-pointer-array
+++ a/mm/slab.h
@@ -297,7 +297,6 @@ static inline void memcg_slab_post_alloc
 	if (!memcg_kmem_enabled() || !objcg)
 		return;
 
-	flags &= ~__GFP_ACCOUNT;
 	for (i = 0; i < size; i++) {
 		if (likely(p[i])) {
 			page = virt_to_head_page(p[i]);
_

Patches currently in -mm which might be from longman@redhat.com are

mm-memcg-move-mod_objcg_state-to-memcontrolc.patch
mm-memcg-cache-vmstat-data-in-percpu-memcg_stock_pcp.patch
mm-memcg-improve-refill_obj_stock-performance.patch
mm-memcg-optimize-user-context-object-stock-access.patch
mm-memcg-slab-properly-set-up-gfp-flags-for-objcg-pointer-array.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches.patch
mm-memcg-slab-disable-cache-merging-for-kmalloc_normal-caches.patch

