Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B99C4338F
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 19:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B582610E6
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 19:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhHRTDV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Aug 2021 15:03:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233158AbhHRTDP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Aug 2021 15:03:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF98C610E6;
        Wed, 18 Aug 2021 19:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629313360;
        bh=tROr8FGsHNfnzBAT4FJvmqn0zdt67n8uvGb53qpVmws=;
        h=Date:From:To:Subject:From;
        b=DXempbPPVdiqQsPC5+kuxgmUYJEBp7e0iugeIVczjoZ3yR9ztY+UyaGTkQa1Ksohn
         FPMgST8pjfsl4DgsNXXYw04V2O2OBo9Z4SUJ5sbzAtVgHOS5z3wbm74/fjXUWQH0jw
         TdjT0ZbDiFkdGXnAR0lsOPEIU3126nGvdD72EKtU=
Date:   Wed, 18 Aug 2021 12:02:38 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zangchunxin@bytedance.com,
        willy@infradead.org, songmuchun@bytedance.com, mhocko@kernel.org,
        chris@chrisdown.name, vbabka@suse.cz
Subject:  + mm-vmscan-guarantee-drop_slab_node-termination.patch
 added to -mm tree
Message-ID: <20210818190238.YeZnr%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: guarantee drop_slab_node() termination
has been added to the -mm tree.  Its filename is
     mm-vmscan-guarantee-drop_slab_node-termination.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-guarantee-drop_slab_node-termination.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-guarantee-drop_slab_node-termination.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/20210818152239.25502-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Chunxin Zang <zangchunxin@bytedance.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
+	} while ((freed >> shift++) > 0);
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
mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled-fix.patch
mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled-fix-fix.patch
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
mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context-fix.patch
mm-slub-move-flush_cpu_slab-invocations-__free_slab-invocations-out-of-irq-context-fix-2.patch
mm-slub-optionally-save-restore-irqs-in-slab_lock.patch
mm-slub-make-slab_lock-disable-irqs-with-preempt_rt.patch
mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg.patch
mm-slub-use-migrate_disable-on-preempt_rt.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock-fix.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock-fix-2.patch
mm-vmscan-guarantee-drop_slab_node-termination.patch

