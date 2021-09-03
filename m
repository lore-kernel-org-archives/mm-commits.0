Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36667C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 229CC610C8
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349941AbhICVB7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:01:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235957AbhICVB7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:01:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A659B60E8B;
        Fri,  3 Sep 2021 21:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702858;
        bh=+edqL0pSZvzTpGKWNnbLE4fykLBJYdi/hR7Bc6fmBQw=;
        h=Date:From:To:Subject:From;
        b=ZUvtmbNx8BUt+/kKv6AjoTziTReHsAWS2IlU1tDuaNu67XIsYNdv14GO4LPRssSqW
         OarFKgwNQX66Jm9GxZwLdugPPGcLE78dOV8VTmowB8W+/tWRJ/1shcRcCq/vcDfHgI
         ZGcL4p4A1Xy7GipmK+9apHnjw/eibTTqI8LZ0G3E=
Date:   Fri, 03 Sep 2021 14:00:58 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, mhocko@kernel.org,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        vbabka@suse.cz, wangkefeng.wang@huawei.com, willy@infradead.org,
        zangchunxin@bytedance.com
Subject:  [merged]
 mm-vmscan-guarantee-drop_slab_node-termination.patch removed from -mm tree
Message-ID: <20210903210058.YiUa9MbFK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: guarantee drop_slab_node() termination
has been removed from the -mm tree.  Its filename was
     mm-vmscan-guarantee-drop_slab_node-termination.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-dont-call-flush_all-from-slab_debug_trace_open.patch
mm-slub-allocate-private-object-map-for-debugfs-listings.patch
mm-slub-allocate-private-object-map-for-validate_slab_cache.patch
mm-slub-dont-disable-irq-for-debug_check_no_locks_freed.patch
mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial.patch
mm-slub-unify-cmpxchg_double_slab-and-__cmpxchg_double_slab.patch
mm-slub-extract-get_partial-from-new_slab_objects.patch
mm-slub-dissolve-new_slab_objects-into-___slab_alloc.patch
mm-slub-return-slab-page-from-get_partial-and-set-c-page-afterwards.patch
mm-slub-restructure-new-page-checks-in-___slab_alloc.patch
mm-slub-simplify-kmem_cache_cpu-and-tid-setup.patch
mm-slub-move-disabling-enabling-irqs-to-___slab_alloc.patch
mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled.patch
mm-slub-move-disabling-irqs-closer-to-get_partial-in-___slab_alloc.patch
mm-slub-restore-irqs-around-calling-new_slab.patch
mm-slub-validate-slab-from-partial-list-or-page-allocator-before-making-it-cpu-slab.patch
mm-slub-check-new-pages-with-restored-irqs.patch
mm-slub-stop-disabling-irqs-around-get_partial.patch
mm-slub-move-reset-of-c-page-and-freelist-out-of-deactivate_slab.patch
mm-slub-make-locking-in-deactivate_slab-irq-safe.patch
mm-slub-call-deactivate_slab-without-disabling-irqs.patch
mm-slub-move-irq-control-into-unfreeze_partials.patch
mm-slub-discard-slabs-in-unfreeze_partials-without-irqs-disabled.patch
mm-slub-detach-whole-partial-list-at-once-in-unfreeze_partials.patch
mm-slub-separate-detaching-of-partial-list-in-unfreeze_partials-from-unfreezing.patch
mm-slub-only-disable-irq-with-spin_lock-in-__unfreeze_partials.patch
mm-slub-dont-disable-irqs-in-slub_cpu_dead.patch
mm-slab-make-flush_slab-possible-to-call-with-irqs-enabled.patch
mm-slub-optionally-save-restore-irqs-in-slab_lock.patch
mm-slub-make-slab_lock-disable-irqs-with-preempt_rt.patch
mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg.patch
mm-slub-use-migrate_disable-on-preempt_rt.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch

