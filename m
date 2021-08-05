Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60AC2C4338F
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FC1D61157
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239314AbhHEXiS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:38:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238926AbhHEXiS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 19:38:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2E1E61132;
        Thu,  5 Aug 2021 23:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628206682;
        bh=jkyaMM++ADTfkhQ4mZkI0xC/LkFTAkijelpqmRxEfnk=;
        h=Date:From:To:Subject:From;
        b=aW5Xyde99Fof03dJFNwFeC+kKyPCJawmqdTEd352O9f7F5qXtiGSG3ulS7WbjIKkF
         KEFDKLieSXHQS+3NLKYjsIZjPVdigMbez0933WSq+J+tBA+SRDx9htJHRTkg5pWKao
         WNxGRZVzQyyAdzHTCYIOBxV3HL2RnUBKwTMst+cI=
Date:   Thu, 05 Aug 2021 16:38:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        rientjes@google.com, penberg@kernel.org,
        mgorman@techsingularity.net, jannh@google.com,
        iamjoonsoo.kim@lge.com, efault@gmx.de, cl@linux.com,
        brouer@redhat.com, bigeasy@linutronix.de, vbabka@suse.cz
Subject:  +
 mm-slab-make-flush_slab-possible-to-call-with-irqs-enabled.patch added to -mm
 tree
Message-ID: <20210805233802.a3yW_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slab: make flush_slab() possible to call with irqs enabled
has been added to the -mm tree.  Its filename is
     mm-slab-make-flush_slab-possible-to-call-with-irqs-enabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slab-make-flush_slab-possible-to-call-with-irqs-enabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-make-flush_slab-possible-to-call-with-irqs-enabled.patch

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
Subject: mm, slab: make flush_slab() possible to call with irqs enabled

Currently flush_slab() is always called with disabled IRQs if it's needed,
but the following patches will change that, so add a parameter to control
IRQ disabling within the function, which only protects the kmem_cache_cpu
manipulation and not the call to deactivate_slab() which doesn't need it.

Link: https://lkml.kernel.org/r/20210805152000.12817-29-vbabka@suse.cz
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

 mm/slub.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/mm/slub.c~mm-slab-make-flush_slab-possible-to-call-with-irqs-enabled
+++ a/mm/slub.c
@@ -2480,16 +2480,28 @@ static void put_cpu_partial(struct kmem_
 #endif	/* CONFIG_SLUB_CPU_PARTIAL */
 }
 
-static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
+static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c,
+			      bool lock)
 {
-	void *freelist = c->freelist;
-	struct page *page = c->page;
+	unsigned long flags;
+	void *freelist;
+	struct page *page;
+
+	if (lock)
+		local_irq_save(flags);
+
+	freelist = c->freelist;
+	page = c->page;
 
 	c->page = NULL;
 	c->freelist = NULL;
 	c->tid = next_tid(c->tid);
 
-	deactivate_slab(s, page, freelist);
+	if (lock)
+		local_irq_restore(flags);
+
+	if (page)
+		deactivate_slab(s, page, freelist);
 
 	stat(s, CPUSLAB_FLUSH);
 }
@@ -2499,7 +2511,7 @@ static inline void __flush_cpu_slab(stru
 	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
 
 	if (c->page)
-		flush_slab(s, c);
+		flush_slab(s, c, false);
 
 	unfreeze_partials_cpu(s, c);
 }
@@ -2515,7 +2527,7 @@ static void flush_cpu_slab(void *d)
 	struct kmem_cache_cpu *c = this_cpu_ptr(s->cpu_slab);
 
 	if (c->page)
-		flush_slab(s, c);
+		flush_slab(s, c, false);
 
 	unfreeze_partials(s);
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

