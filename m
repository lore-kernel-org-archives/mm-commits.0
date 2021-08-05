Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EAAC432BE
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B35AE61104
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238061AbhHEXhe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:37:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231173AbhHEXhc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 19:37:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9F06610FF;
        Thu,  5 Aug 2021 23:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628206636;
        bh=5IUfa+mQpCUrCUrrcG7pe6yfk5HeU4e8BIyL5EdK5F0=;
        h=Date:From:To:Subject:From;
        b=iJi8me5ZSI7GrKH8PrbBKFwV3JdkNeCZu82Y3kzU6Q2rzAGvaUNbY2O/7VBctENSE
         DT8JT+saTSeAvp/0BjF1spH+UDuToQVubVn4hp8fW0l8dymIJfbkJn6FBxybyfqQjQ
         4rzhWaFIil7OYBUG8fs14lMcb4ajhEOepuT7e8Ys=
Date:   Thu, 05 Aug 2021 16:37:16 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        rientjes@google.com, penberg@kernel.org,
        mgorman@techsingularity.net, jannh@google.com,
        iamjoonsoo.kim@lge.com, efault@gmx.de, cl@linux.com,
        brouer@redhat.com, bigeasy@linutronix.de, vbabka@suse.cz
Subject:  +
 mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial.patch added
 to -mm tree
Message-ID: <20210805233716.Fehph%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: remove redundant unfreeze_partials() from put_cpu_partial()
has been added to the -mm tree.  Its filename is
     mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial.patch

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
Subject: mm, slub: remove redundant unfreeze_partials() from put_cpu_partial()

Commit d6e0b7fa1186 ("slub: make dead caches discard free slabs
immediately") introduced cpu partial flushing for kmemcg caches, based on
setting the target cpu_partial to 0 and adding a flushing check in
put_cpu_partial().  This code that sets cpu_partial to 0 was later moved
by c9fc586403e7 ("slab: introduce __kmemcg_cache_deactivate()") and
ultimately removed by 9855609bde03 ("mm: memcg/slab: use a single set of
kmem_caches for all accounted allocations").  However the check and flush
in put_cpu_partial() was never removed, although it's effectively a dead
code.  So this patch removes it.

Note that d6e0b7fa1186 also added preempt_disable()/enable() to
unfreeze_partials() which could be thus also considered unnecessary.  But
further patches will rely on it, so keep it.

Link: https://lkml.kernel.org/r/20210805152000.12817-6-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/slub.c~mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial
+++ a/mm/slub.c
@@ -2466,13 +2466,6 @@ static void put_cpu_partial(struct kmem_
 
 	} while (this_cpu_cmpxchg(s->cpu_slab->partial, oldpage, page)
 								!= oldpage);
-	if (unlikely(!slub_cpu_partial(s))) {
-		unsigned long flags;
-
-		local_irq_save(flags);
-		unfreeze_partials(s, this_cpu_ptr(s->cpu_slab));
-		local_irq_restore(flags);
-	}
 	preempt_enable();
 #endif	/* CONFIG_SLUB_CPU_PARTIAL */
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-fix-slub_debug-disablement-for-list-of-slabs.patch
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

