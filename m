Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD72AC4338F
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A47FB610FF
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhHEXhe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:37:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237996AbhHEXhd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 19:37:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A539E60E52;
        Thu,  5 Aug 2021 23:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628206638;
        bh=VXeMIpVbLQJdyj/7dXiMkYUd0xe+z6Ew0sq26S/wSSE=;
        h=Date:From:To:Subject:From;
        b=T7iOmLMVBNMDHypqiyZwY3iECS/avAXEiTpZTIIUD/ct6ATa5tBseERBu6Sjl+pgV
         x19ZIQ+uBNeYI2hIByT5AVBTLcIMJzGlroVdNaCerN2XJKzxffJ34ANil2UQ5mmc/I
         qK6Mznk7lZ5dxHfAoAdiiFvOw+EOrp44R5GiSZuM=
Date:   Thu, 05 Aug 2021 16:37:18 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        rientjes@google.com, penberg@kernel.org,
        mgorman@techsingularity.net, jannh@google.com,
        iamjoonsoo.kim@lge.com, efault@gmx.de, cl@linux.com,
        brouer@redhat.com, bigeasy@linutronix.de, vbabka@suse.cz
Subject:  +
 mm-slub-unify-cmpxchg_double_slab-and-__cmpxchg_double_slab.patch added to
 -mm tree
Message-ID: <20210805233718.t-_z1%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: unify cmpxchg_double_slab() and __cmpxchg_double_slab()
has been added to the -mm tree.  Its filename is
     mm-slub-unify-cmpxchg_double_slab-and-__cmpxchg_double_slab.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-unify-cmpxchg_double_slab-and-__cmpxchg_double_slab.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-unify-cmpxchg_double_slab-and-__cmpxchg_double_slab.patch

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
Subject: mm, slub: unify cmpxchg_double_slab() and __cmpxchg_double_slab()

These functions differ only in irq disabling in the slow path.  We can
create a common function with an extra bool parameter to control the irq
disabling.  As the functions are inline and the parameter compile-time
constant, there will be no runtime overhead due to this change.

Also change the DEBUG_VM based irqs disable assert to the more standard
lockdep_assert based one.

Link: https://lkml.kernel.org/r/20210805152000.12817-7-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
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

 mm/slub.c |   62 ++++++++++++++++++++--------------------------------
 1 file changed, 24 insertions(+), 38 deletions(-)

--- a/mm/slub.c~mm-slub-unify-cmpxchg_double_slab-and-__cmpxchg_double_slab
+++ a/mm/slub.c
@@ -371,13 +371,13 @@ static __always_inline void slab_unlock(
 	__bit_spin_unlock(PG_locked, &page->flags);
 }
 
-/* Interrupts must be disabled (for the fallback code to work right) */
-static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
+static inline bool ___cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
 		void *freelist_old, unsigned long counters_old,
 		void *freelist_new, unsigned long counters_new,
-		const char *n)
+		const char *n, bool disable_irqs)
 {
-	VM_BUG_ON(!irqs_disabled());
+	if (!disable_irqs)
+		lockdep_assert_irqs_disabled();
 #if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
     defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
 	if (s->flags & __CMPXCHG_DOUBLE) {
@@ -388,15 +388,23 @@ static inline bool __cmpxchg_double_slab
 	} else
 #endif
 	{
+		unsigned long flags;
+
+		if (disable_irqs)
+			local_irq_save(flags);
 		slab_lock(page);
 		if (page->freelist == freelist_old &&
 					page->counters == counters_old) {
 			page->freelist = freelist_new;
 			page->counters = counters_new;
 			slab_unlock(page);
+			if (disable_irqs)
+				local_irq_restore(flags);
 			return true;
 		}
 		slab_unlock(page);
+		if (disable_irqs)
+			local_irq_restore(flags);
 	}
 
 	cpu_relax();
@@ -409,45 +417,23 @@ static inline bool __cmpxchg_double_slab
 	return false;
 }
 
-static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
+/* Interrupts must be disabled (for the fallback code to work right) */
+static inline bool __cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
 		void *freelist_old, unsigned long counters_old,
 		void *freelist_new, unsigned long counters_new,
 		const char *n)
 {
-#if defined(CONFIG_HAVE_CMPXCHG_DOUBLE) && \
-    defined(CONFIG_HAVE_ALIGNED_STRUCT_PAGE)
-	if (s->flags & __CMPXCHG_DOUBLE) {
-		if (cmpxchg_double(&page->freelist, &page->counters,
-				   freelist_old, counters_old,
-				   freelist_new, counters_new))
-			return true;
-	} else
-#endif
-	{
-		unsigned long flags;
-
-		local_irq_save(flags);
-		slab_lock(page);
-		if (page->freelist == freelist_old &&
-					page->counters == counters_old) {
-			page->freelist = freelist_new;
-			page->counters = counters_new;
-			slab_unlock(page);
-			local_irq_restore(flags);
-			return true;
-		}
-		slab_unlock(page);
-		local_irq_restore(flags);
-	}
-
-	cpu_relax();
-	stat(s, CMPXCHG_DOUBLE_FAIL);
-
-#ifdef SLUB_DEBUG_CMPXCHG
-	pr_info("%s %s: cmpxchg double redo ", n, s->name);
-#endif
+	return ___cmpxchg_double_slab(s, page, freelist_old, counters_old,
+				      freelist_new, counters_new, n, false);
+}
 
-	return false;
+static inline bool cmpxchg_double_slab(struct kmem_cache *s, struct page *page,
+		void *freelist_old, unsigned long counters_old,
+		void *freelist_new, unsigned long counters_new,
+		const char *n)
+{
+	return ___cmpxchg_double_slab(s, page, freelist_old, counters_old,
+				      freelist_new, counters_new, n, true);
 }
 
 #ifdef CONFIG_SLUB_DEBUG
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

