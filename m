Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9774C43334
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379824AbiFQCto (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379799AbiFQCta (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9B465417
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B5AC61D19
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EBEC34114;
        Fri, 17 Jun 2022 02:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434168;
        bh=OM0Fm7GcwSfnHqdaOuHQ3xl9idSdV72x2EeNvDnKwXc=;
        h=Date:To:From:Subject:From;
        b=LQjk1Ip/p+OYNsIGqZsalQnSxUIcRQhBfirAJuNMU2P/y1YVEOtoLoeOnWF2AIyDF
         23kggyNIY5+Db3apqG3ahF1F00P2KXL226zOn0O1clsmUCBqmk6ZWP9iRtrQkpRDWz
         6qKIVLv5NomXY4i/MFO5zU7IvVLpGyTjT4kWVOR8=
Date:   Thu, 16 Jun 2022 19:49:27 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        roman.gushchin@linux.dev, rientjes@google.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, daniel.vetter@intel.com, cl@linux.com,
        daniel.vetter@ffwll.ch, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-slab-delete-cache_alloc_debugcheck_before.patch removed from -mm tree
Message-Id: <20220617024928.89EBEC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/slab: delete cache_alloc_debugcheck_before()
has been removed from the -mm tree.  Its filename was
     mm-slab-delete-cache_alloc_debugcheck_before.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: mm/slab: delete cache_alloc_debugcheck_before()
Date: Sun, 5 Jun 2022 17:25:38 +0200

It only does a might_sleep_if(GFP_RECLAIM) check, which is already covered
by the might_alloc() in slab_pre_alloc_hook().  And all callers of
cache_alloc_debugcheck_before() call that beforehand already.

Link: https://lkml.kernel.org/r/20220605152539.3196045-2-daniel.vetter@ffwll.ch
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/mm/slab.c~mm-slab-delete-cache_alloc_debugcheck_before
+++ a/mm/slab.c
@@ -2958,12 +2958,6 @@ direct_grow:
 	return ac->entry[--ac->avail];
 }
 
-static inline void cache_alloc_debugcheck_before(struct kmem_cache *cachep,
-						gfp_t flags)
-{
-	might_sleep_if(gfpflags_allow_blocking(flags));
-}
-
 #if DEBUG
 static void *cache_alloc_debugcheck_after(struct kmem_cache *cachep,
 				gfp_t flags, void *objp, unsigned long caller)
@@ -3205,7 +3199,6 @@ slab_alloc_node(struct kmem_cache *cache
 	if (unlikely(ptr))
 		goto out_hooks;
 
-	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
 
 	if (nodeid == NUMA_NO_NODE)
@@ -3290,7 +3283,6 @@ slab_alloc(struct kmem_cache *cachep, st
 	if (unlikely(objp))
 		goto out;
 
-	cache_alloc_debugcheck_before(cachep, flags);
 	local_irq_save(save_flags);
 	objp = __do_cache_alloc(cachep, flags);
 	local_irq_restore(save_flags);
@@ -3527,8 +3519,6 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 	if (!s)
 		return 0;
 
-	cache_alloc_debugcheck_before(s, flags);
-
 	local_irq_disable();
 	for (i = 0; i < size; i++) {
 		void *objp = kfence_alloc(s, s->object_size, flags) ?: __do_cache_alloc(s, flags);
_

Patches currently in -mm which might be from daniel.vetter@ffwll.ch are


