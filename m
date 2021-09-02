Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73752C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D66060BD3
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbhIBVL4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232087AbhIBVLz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:11:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09797604AC;
        Thu,  2 Sep 2021 21:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630617057;
        bh=eaPtpQKWwWEdfG3Wl9ZOJTxXYVnjk5OSiclKdrFGlt8=;
        h=Date:From:To:Subject:From;
        b=LNQvZfMA6/PJMdd3KRaXrNjBr9Y3lEoom4H5GNOl49HlJc3X1/xyWoFGkRl9CWVNW
         guT6a5B4hxj5VFy0I8yfJ4KsPuFbhWasZ/rvcLJi36jHLSRW2EJV8WPrlv981P0xJn
         vssZ+5jAdrp6pSCPVwax4ig8FexXvbGc8egGctyc=
Date:   Thu, 02 Sep 2021 14:10:56 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [folded-merged]
 mm-slub-convert-kmem_cpu_slab-protection-to-local_lock-fix.patch removed
 from -mm tree
Message-ID: <20210902211056.PwGRAX_9_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slab: simplify lockdep_assert_held in lockdep_assert_held()
has been removed from the -mm tree.  Its filename was
     mm-slub-convert-kmem_cpu_slab-protection-to-local_lock-fix.patch

This patch was dropped because it was folded into mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slab: simplify lockdep_assert_held in lockdep_assert_held()

Sebastian reports [1] that the special version of lockdep_assert_held() for a
local lock with PREEMPT_RT is no longer necessary, and we can simplify.

[1] https://lore.kernel.org/linux-mm/20210817153937.hxnuh7mqp6vuiyws@linutronix.de/

This is a fixup for mmotm patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch

Link: https://lkml.kernel.org/r/7e9ccf34-57d1-786b-2dfd-3b9ba78e1b32@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/slub.c~mm-slub-convert-kmem_cpu_slab-protection-to-local_lock-fix
+++ a/mm/slub.c
@@ -2913,11 +2913,7 @@ redo:
 
 load_freelist:
 
-#ifdef CONFIG_PREEMPT_RT
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_slab->lock.lock));
-#else
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_slab->lock));
-#endif
 
 	/*
 	 * freelist is pointing to the list of objects to be used.
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
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock-fix-2.patch
mm-vmscan-guarantee-drop_slab_node-termination.patch
mm-vmscan-guarantee-drop_slab_node-termination-fix.patch

