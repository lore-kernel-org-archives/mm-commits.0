Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54A8DC4338F
	for <mm-commits@archiver.kernel.org>; Tue, 24 Aug 2021 20:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CC3261357
	for <mm-commits@archiver.kernel.org>; Tue, 24 Aug 2021 20:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbhHXUk3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Aug 2021 16:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235378AbhHXUk2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 24 Aug 2021 16:40:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B62B161181;
        Tue, 24 Aug 2021 20:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629837582;
        bh=Cg1ZM+hzG6fGURptNXVEl+zdyPnhNa3uwik/KaqoyYM=;
        h=Date:From:To:Subject:From;
        b=oI4gJip0y0z1hpbvDHuDcRCvoylQWiwse0bIyYrhFjcSEz16/2BheB2T1ZF2U9y9l
         l4QGP2pZJygUMfX6TvVCjioAAPDCdO3axonXHkDI7GZNyxuzJgQ6YQskXZ9ojNvbjt
         w59GZhVdHB6Zb6NztDKYnOH9JXpN6pAGU1rUlixo=
Date:   Tue, 24 Aug 2021 13:39:40 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz
Subject:  + mm-vmscan-guarantee-drop_slab_node-termination-fix.patch
 added to -mm tree
Message-ID: <20210824203940.RCeMf%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: guarantee drop_slab_node() termination-fix
has been added to the -mm tree.  Its filename is
     mm-vmscan-guarantee-drop_slab_node-termination-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-guarantee-drop_slab_node-termination-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-guarantee-drop_slab_node-termination-fix.patch

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
Subject: mm, vmscan: guarantee drop_slab_node() termination-fix

Matthew reports [1] that if we free enough objects, we can eventually
right-shift by BITS_PER_LONG, which is undefined behavior.  Raise the
threshold from 0 to 1 which means we will shift only up to
BITS_PER_LONG-1.

[1] https://lore.kernel.org/linux-mm/YSTDnqKgQLvziyQI@casper.infradead.org/

Link: https://lkml.kernel.org/r/2f034e6f-a753-550a-f374-e4e23899d3d5@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-guarantee-drop_slab_node-termination-fix
+++ a/mm/vmscan.c
@@ -952,7 +952,7 @@ void drop_slab_node(int nid)
 		do {
 			freed += shrink_slab(GFP_KERNEL, nid, memcg, 0);
 		} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
-	} while ((freed >> shift++) > 0);
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
mm-vmscan-guarantee-drop_slab_node-termination-fix.patch

