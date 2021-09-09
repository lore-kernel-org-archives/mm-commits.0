Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D576CC433EF
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD33A611B0
	for <mm-commits@archiver.kernel.org>; Thu,  9 Sep 2021 21:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbhIIVBh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Sep 2021 17:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245624AbhIIVBe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Sep 2021 17:01:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFE1861179;
        Thu,  9 Sep 2021 21:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631221225;
        bh=i0zteznFRxZOv1hb9v8+t2ZMNGqweJVo+ILocPBevHE=;
        h=Date:From:To:Subject:From;
        b=AqjFjt5DKFwWcbePUedA736ubmatbR/LfjFkQClum3Xi47Vbi9PN4xewxM8Y21oQh
         nV2OeeARDcIgc3rCEY24kfBCRWLXk+G5+rJWhhZzx4iXw9uqyDufSBvBxlVg/sJL0Y
         f2U8LAYQM8U7pCLafXHr0ONVXPeuebF2T4LUUt6Q=
Date:   Thu, 09 Sep 2021 14:00:24 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, vbabka@suse.cz
Subject:  [merged]
 mm-slub-extract-get_partial-from-new_slab_objects.patch removed from -mm
 tree
Message-ID: <20210909210024.Zd4TFtdBG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: extract get_partial() from new_slab_objects()
has been removed from the -mm tree.  Its filename was
     mm-slub-extract-get_partial-from-new_slab_objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: extract get_partial() from new_slab_objects()

The later patches will need more fine grained control over individual
actions in ___slab_alloc(), the only caller of new_slab_objects(), so this
is a first preparatory step with no functional change.

This adds a goto label that appears unnecessary at this point, but will be
useful for later changes.

Link: https://lkml.kernel.org/r/20210904105003.11688-7-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/slub.c~mm-slub-extract-get_partial-from-new_slab_objects
+++ a/mm/slub.c
@@ -2613,17 +2613,12 @@ slab_out_of_memory(struct kmem_cache *s,
 static inline void *new_slab_objects(struct kmem_cache *s, gfp_t flags,
 			int node, struct kmem_cache_cpu **pc)
 {
-	void *freelist;
+	void *freelist = NULL;
 	struct kmem_cache_cpu *c = *pc;
 	struct page *page;
 
 	WARN_ON_ONCE(s->ctor && (flags & __GFP_ZERO));
 
-	freelist = get_partial(s, flags, node, c);
-
-	if (freelist)
-		return freelist;
-
 	page = new_slab(s, flags, node);
 	if (page) {
 		c = raw_cpu_ptr(s->cpu_slab);
@@ -2787,6 +2782,10 @@ new_slab:
 		goto redo;
 	}
 
+	freelist = get_partial(s, gfpflags, node, c);
+	if (freelist)
+		goto check_new_page;
+
 	freelist = new_slab_objects(s, gfpflags, node, &c);
 
 	if (unlikely(!freelist)) {
@@ -2794,6 +2793,7 @@ new_slab:
 		return NULL;
 	}
 
+check_new_page:
 	page = c->page;
 	if (likely(!kmem_cache_debug(s) && pfmemalloc_match(page, gfpflags)))
 		goto load_freelist;
_

Patches currently in -mm which might be from vbabka@suse.cz are


