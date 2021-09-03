Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2171CC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:46:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F021A60EBA
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbhICVrv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230425AbhICVrv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:47:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D95A560FD7;
        Fri,  3 Sep 2021 21:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630705611;
        bh=XnkSNB3CubUrQd92eqAJqQLnb5oqNXMBk6CIMrF/LsI=;
        h=Date:From:To:Subject:From;
        b=uNkVjwQQWEJMGpInvsQgd2cv19MA6orv7ARg+cx23AehQ4SNtODGrOjCFQrLmf3xo
         nL5YACL+ZrejHPc29zUOC8X14LWk3mImYo2tjnGSPka/+poM3Z1yq00bZWA7xtxo61
         Xt2b0n8BaBYpM9m2pPyt/3x11vcQIetNAASJhpzQ=
Date:   Fri, 03 Sep 2021 14:46:50 -0700
From:   akpm@linux-foundation.org
To:     efault@gmx.de, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  +
 mm-slub-remove-conditional-locking-parameter-from-flush_slab.patch added to
 -mm tree
Message-ID: <20210903214650.U0QvwXFWN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: remove conditional locking parameter from flush_slab()
has been added to the -mm tree.  Its filename is
     mm-slub-remove-conditional-locking-parameter-from-flush_slab.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-remove-conditional-locking-parameter-from-flush_slab.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-remove-conditional-locking-parameter-from-flush_slab.patch

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
Subject: mm, slub: remove conditional locking parameter from flush_slab()

flush_slab() is called either as part of work scheduled on given live cpu,
or called as a cleanup for another cpu that went offline.  In the first
case it needs to hold the cpu_slab->lock local lock when updating the
protected kmem_cache_cpu fields.  This is now achieved by a "bool lock"
parameter.

To avoid the conditional locking, we can instead lock unconditionally in
flush_slab() for live cpus, and opencode the variant without locking in
__flush_cpu_slab() for the dead cpus.

Link: https://lkml.kernel.org/r/1ae902f7-c500-f9e8-1b4f-077beade0f42@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/mm/slub.c~mm-slub-remove-conditional-locking-parameter-from-flush_slab
+++ a/mm/slub.c
@@ -2566,15 +2566,13 @@ static inline void unfreeze_partials_cpu
 
 #endif	/* CONFIG_SLUB_CPU_PARTIAL */
 
-static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c,
-			      bool lock)
+static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
 	unsigned long flags;
 	void *freelist;
 	struct page *page;
 
-	if (lock)
-		local_lock_irqsave(&s->cpu_slab->lock, flags);
+	local_lock_irqsave(&s->cpu_slab->lock, flags);
 
 	freelist = c->freelist;
 	page = c->page;
@@ -2583,8 +2581,7 @@ static inline void flush_slab(struct kme
 	c->freelist = NULL;
 	c->tid = next_tid(c->tid);
 
-	if (lock)
-		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
+	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 
 	if (page)
 		deactivate_slab(s, page, freelist);
@@ -2595,9 +2592,17 @@ static inline void flush_slab(struct kme
 static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
 {
 	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
+	struct page *page = c->page;
+	void *freelist = c->freelist;
 
-	if (c->page)
-		flush_slab(s, c, false);
+	c->page = NULL;
+	c->freelist = NULL;
+	c->tid = next_tid(c->tid);
+
+	if (page) {
+		deactivate_slab(s, page, freelist);
+		stat(s, CPUSLAB_FLUSH);
+	}
 
 	unfreeze_partials_cpu(s, c);
 }
@@ -2625,7 +2630,7 @@ static void flush_cpu_slab(struct work_s
 	c = this_cpu_ptr(s->cpu_slab);
 
 	if (c->page)
-		flush_slab(s, c, true);
+		flush_slab(s, c);
 
 	unfreeze_partials(s);
 }
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
mm-slub-remove-conditional-locking-parameter-from-flush_slab.patch

