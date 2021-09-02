Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79404C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66D1160E8B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347843AbhIBWAx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347763AbhIBWAx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:00:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F32E060F21;
        Thu,  2 Sep 2021 21:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619994;
        bh=ViDStTCz7Z8TyQQO4iJiePVQ6NLIUsl8TyTWolpn1xU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=aWL2owpTVws7zAe8PuyNMt26GpQzSOdn1mgviA9iMBDSDMFw9kLo5r1xB9dEL3zMy
         n9YKE5bD3L4JipD9Dmfr0mzeoWX2zT6LJlGTR6erxgpHliLG1lu648Y4O3DqOtNL9T
         GB/fCkXrW0TdZBhwN4JnVe+oTH1++gFnkkm+h3AQ=
Date:   Thu, 02 Sep 2021 14:59:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name,
        linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vbabka@suse.cz, wangkefeng.wang@huawei.com, willy@infradead.org,
        zangchunxin@bytedance.com
Subject:  [patch 187/212] mm, vmscan: guarantee drop_slab_node()
 termination
Message-ID: <20210902215953.otpQ1y0ro%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, vmscan: guarantee drop_slab_node() termination

drop_slab_node() is called as part of echo 2>/proc/sys/vm/drop_caches
operation.  It iterates over all memcgs and calls shrink_slab() which in
turn iterates over all slab shrinkers.  Freed objects are counted and as
long as the total number of freed objects from all memcgs and shrinkers is
higher than 10, drop_slab_node() loops for another full memcgs*shrinkers
iteration.

This arbitrary constant threshold of 10 can result in effectively an
infinite loop on a system with large number of memcgs and/or parallel
activity that allocates new objects.  This has been reported previously by
Chunxin Zang [1] and recently by our customer.

The previous report [1] has resulted in commit 069c411de40a ("mm/vmscan:
fix infinite loop in drop_slab_node") which added a check for signals
allowing the user to terminate the command writing to drop_caches.  At the
time it was also considered to make the threshold grow with each iteration
to guarantee termination, but such patch hasn't been formally proposed
yet.

This patch implements the dynamically growing threshold.  At first
iteration it's enough to free one object to continue, and this threshold
effectively doubles with each iteration.  Our customer's feedback was
positive.

There is always a risk that this change will result on some system in a
previously terminating drop_caches operation to terminate sooner and free
fewer objects.  Ideally the semantics would guarantee freeing all freeable
objects that existed at the moment of starting the operation, while not
looping forever for newly allocated objects, but that's not feasible to
track.  In the less ideal solution based on thresholds, arguably the
termination guarantee is more important than the exhaustiveness guarantee.
If there are reports of large regression wrt being exhaustive, we can
tune how fast the threshold grows.

[1] https://lore.kernel.org/lkml/20200909152047.27905-1-zangchunxin@bytedance.com/T/#u

[vbabka@suse.cz: avoid undefined shift behaviour]
  Link: https://lkml.kernel.org/r/2f034e6f-a753-550a-f374-e4e23899d3d5@suse.cz
Link: https://lkml.kernel.org/r/20210818152239.25502-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Chunxin Zang <zangchunxin@bytedance.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-guarantee-drop_slab_node-termination
+++ a/mm/vmscan.c
@@ -939,6 +939,7 @@ out:
 void drop_slab_node(int nid)
 {
 	unsigned long freed;
+	int shift = 0;
 
 	do {
 		struct mem_cgroup *memcg = NULL;
@@ -951,7 +952,7 @@ void drop_slab_node(int nid)
 		do {
 			freed += shrink_slab(GFP_KERNEL, nid, memcg, 0);
 		} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
-	} while (freed > 10);
+	} while ((freed >> shift++) > 1);
 }
 
 void drop_slab(void)
_
