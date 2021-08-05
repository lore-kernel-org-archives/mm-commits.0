Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D8BFC4338F
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C9A4610CD
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237396AbhHEXiZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:38:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235436AbhHEXiY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 19:38:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0680610FF;
        Thu,  5 Aug 2021 23:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628206688;
        bh=5hklGo/93p/y+QYIFuNkC9FE3mSsloB9lxBOzFZSN5A=;
        h=Date:From:To:Subject:From;
        b=OthTFLLokr/YtOGahvlm1k0wVNOPQdBpafb1wRsgo1D2cPJGDVUBX7kK2ISnzBYqy
         3sqO2uiErzXc/S/FfQjYoxr0W6qpv/LvVYvMh6cjKs8ufWYxT+AISKz6yrppSECSIs
         ZFhtAS3PexldOkgHaScf4FKWMNuciYk5uxxjFov4=
Date:   Thu, 05 Aug 2021 16:38:08 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        rientjes@google.com, penberg@kernel.org,
        mgorman@techsingularity.net, jannh@google.com,
        iamjoonsoo.kim@lge.com, efault@gmx.de, cl@linux.com,
        brouer@redhat.com, bigeasy@linutronix.de, vbabka@suse.cz
Subject:  + mm-slub-optionally-save-restore-irqs-in-slab_lock.patch
 added to -mm tree
Message-ID: <20210805233808.i6hUC%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: optionally save/restore irqs in slab_[un]lock()/
has been added to the -mm tree.  Its filename is
     mm-slub-optionally-save-restore-irqs-in-slab_lock.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-optionally-save-restore-irqs-in-slab_lock.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-optionally-save-restore-irqs-in-slab_lock.patch

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
Subject: mm, slub: optionally save/restore irqs in slab_[un]lock()/

For PREEMPT_RT we will need to disable irqs for this bit spinlock.  As a
preparation, add a flags parameter, and an internal version that takes
additional bool parameter to control irq saving/restoring (the flags
parameter is compile-time unused if the bool is a constant false).

Convert ___cmpxchg_double_slab(), which also comes with the same bool
parameter, to use the internal version.

Link: https://lkml.kernel.org/r/20210805152000.12817-32-vbabka@suse.cz
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

 mm/slub.c |   52 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 19 deletions(-)

--- a/mm/slub.c~mm-slub-optionally-save-restore-irqs-in-slab_lock
+++ a/mm/slub.c
@@ -359,16 +359,33 @@ static inline unsigned int oo_objects(st
 /*
  * Per slab locking using the pagelock
  */
-static __always_inline void slab_lock(struct page *page)
+static __always_inline void
+__slab_lock(struct page *page, unsigned long *flags, bool disable_irqs)
 {
 	VM_BUG_ON_PAGE(PageTail(page), page);
+	if (disable_irqs)
+		local_irq_save(*flags);
 	bit_spin_lock(PG_locked, &page->flags);
 }
 
-static __always_inline void slab_unlock(struct page *page)
+static __always_inline void
+__slab_unlock(struct page *page, unsigned long *flags, bool disable_irqs)
 {
 	VM_BUG_ON_PAGE(PageTail(page), page);
 	__bit_spin_unlock(PG_locked, &page->flags);
+	if (disable_irqs)
+		local_irq_restore(*flags);
+}
+
+static __always_inline void
+slab_lock(struct page *page, unsigned long *flags)
+{
+	__slab_lock(page, flags, false);
+}
+
+static __always_inline void slab_unlock(struct page *page, unsigned long *flags)
+{
+	__slab_unlock(page, flags, false);
 }
 
 static inline bool ___cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
@@ -388,23 +405,18 @@ static inline bool ___cmpxchg_double_sla
 	} else
 #endif
 	{
-		unsigned long flags;
+		/* init to 0 to prevent spurious warnings */
+		unsigned long flags = 0;
 
-		if (disable_irqs)
-			local_irq_save(flags);
-		slab_lock(page);
+		__slab_lock(page, &flags, disable_irqs);
 		if (page->freelist == freelist_old &&
 					page->counters == counters_old) {
 			page->freelist = freelist_new;
 			page->counters = counters_new;
-			slab_unlock(page);
-			if (disable_irqs)
-				local_irq_restore(flags);
+			__slab_unlock(page, &flags, disable_irqs);
 			return true;
 		}
-		slab_unlock(page);
-		if (disable_irqs)
-			local_irq_restore(flags);
+		__slab_unlock(page, &flags, disable_irqs);
 	}
 
 	cpu_relax();
@@ -1255,11 +1267,11 @@ static noinline int free_debug_processin
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 	void *object = head;
 	int cnt = 0;
-	unsigned long flags;
+	unsigned long flags, flags2;
 	int ret = 0;
 
 	spin_lock_irqsave(&n->list_lock, flags);
-	slab_lock(page);
+	slab_lock(page, &flags2);
 
 	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
 		if (!check_slab(s, page))
@@ -1292,7 +1304,7 @@ out:
 		slab_err(s, page, "Bulk freelist count(%d) invalid(%d)\n",
 			 bulk_cnt, cnt);
 
-	slab_unlock(page);
+	slab_unlock(page, &flags2);
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	if (!ret)
 		slab_fix(s, "Object at 0x%p not freed", object);
@@ -4051,9 +4063,10 @@ static void list_slab_objects(struct kme
 	void *addr = page_address(page);
 	unsigned long *map;
 	void *p;
+	unsigned long flags;
 
 	slab_err(s, page, text, s->name);
-	slab_lock(page);
+	slab_lock(page, &flags);
 
 	map = get_map(s, page);
 	for_each_object(p, s, addr, page->objects) {
@@ -4064,7 +4077,7 @@ static void list_slab_objects(struct kme
 		}
 	}
 	put_map(map);
-	slab_unlock(page);
+	slab_unlock(page, &flags);
 #endif
 }
 
@@ -4789,8 +4802,9 @@ static void validate_slab(struct kmem_ca
 {
 	void *p;
 	void *addr = page_address(page);
+	unsigned long flags;
 
-	slab_lock(page);
+	slab_lock(page, &flags);
 
 	if (!check_slab(s, page) || !on_freelist(s, page, NULL))
 		goto unlock;
@@ -4805,7 +4819,7 @@ static void validate_slab(struct kmem_ca
 			break;
 	}
 unlock:
-	slab_unlock(page);
+	slab_unlock(page, &flags);
 }
 
 static int validate_slab_node(struct kmem_cache *s,
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

