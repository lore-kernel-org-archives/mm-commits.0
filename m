Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DD3C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 086EC61CFF
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:23:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbhF2AZo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:25:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhF2AZn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:25:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C073A61CF4;
        Tue, 29 Jun 2021 00:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926196;
        bh=kwqSZL4+jcU95Rp4+527nwLTRuAmNiYBAWz+fdNNT9k=;
        h=Date:From:To:Subject:From;
        b=uPTXVlAu7anibP9+t0mGSOU+V/zcJ5bY5aLYDV1jwfvmEHIypj+Miz8rs6G1NA70L
         02q4EnvjvmWyXKsZa7V3gDD/n2mFxfViz4PAIu2Nw8YgjZ2rX9amE0jtpukg2TcxU8
         Q3xpfkw7XvlZ4gCrge8kj5lNg1xY+tmlJPVbITZY=
Date:   Mon, 28 Jun 2021 17:23:15 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, hannes@cmpxchg.org,
        iamjoonsoo.kim@lge.com, longman@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com, vbabka@suse.cz,
        vdavydov.dev@gmail.com
Subject:  [folded-merged]
 mm-memcg-slab-disable-cache-merging-for-kmalloc_normal-caches.patch removed
 from -mm tree
Message-ID: <20210629002315.WR3W1xHur%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg/slab: disable cache merging for KMALLOC_NORMAL caches
has been removed from the -mm tree.  Its filename was
     mm-memcg-slab-disable-cache-merging-for-kmalloc_normal-caches.patch

This patch was dropped because it was folded into mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches.patch

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm: memcg/slab: disable cache merging for KMALLOC_NORMAL caches

The KMALLOC_NORMAL (kmalloc-<n>) caches are for unaccounted objects only
when CONFIG_MEMCG_KMEM is enabled.  To make sure that this condition
remains true, we will have to prevent KMALOC_NORMAL caches to merge with
other kmem caches.  This is now done by setting its refcount to -1 right
after its creation.

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

 mm/slab_common.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/slab_common.c~mm-memcg-slab-disable-cache-merging-for-kmalloc_normal-caches
+++ a/mm/slab_common.c
@@ -856,6 +856,13 @@ new_kmalloc_cache(int idx, enum kmalloc_
 					kmalloc_info[idx].name[type],
 					kmalloc_info[idx].size, flags, 0,
 					kmalloc_info[idx].size);
+
+	/*
+	 * If CONFIG_MEMCG_KMEM is enabled, disable cache merging for
+	 * KMALLOC_NORMAL caches.
+	 */
+	if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_NORMAL))
+		kmalloc_caches[type][idx]->refcount = -1;
 }
 
 /*
_

Patches currently in -mm which might be from longman@redhat.com are

mm-memcg-move-mod_objcg_state-to-memcontrolc.patch
mm-memcg-cache-vmstat-data-in-percpu-memcg_stock_pcp.patch
mm-memcg-improve-refill_obj_stock-performance.patch
mm-memcg-optimize-user-context-object-stock-access.patch
mm-memcg-slab-properly-set-up-gfp-flags-for-objcg-pointer-array.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches.patch

