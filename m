Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE6FC432BE
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE6836113C
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238901AbhHEXiE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238891AbhHEXiE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 19:38:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5971610CD;
        Thu,  5 Aug 2021 23:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628206668;
        bh=zUMli8TzdFHvCFM/9PcYe0I1xBs/Kp4ZbpOCSW5OQe4=;
        h=Date:From:To:Subject:From;
        b=fmM5rI1RvCM1BqDQ03Y6EpBI/dFV50f1++xhQOBmKP97ilbIJjH5Gu/VzBExKr2pK
         3u090c/FeRgBjJw/RLyMIb5iuFWP9Byj6tM71Jd0lj9911IGaUCMAdm2PYQqNBmPPl
         JC24S5LLJHkMitB2gP8JhfakOjAjRuuPqQZBwEwA=
Date:   Thu, 05 Aug 2021 16:37:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        rientjes@google.com, penberg@kernel.org,
        mgorman@techsingularity.net, jannh@google.com,
        iamjoonsoo.kim@lge.com, efault@gmx.de, cl@linux.com,
        brouer@redhat.com, bigeasy@linutronix.de, vbabka@suse.cz
Subject:  + mm-slub-call-deactivate_slab-without-disabling-irqs.patch
 added to -mm tree
Message-ID: <20210805233748.Ee5_j%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: call deactivate_slab() without disabling irqs
has been added to the -mm tree.  Its filename is
     mm-slub-call-deactivate_slab-without-disabling-irqs.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-call-deactivate_slab-without-disabling-irqs.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-call-deactivate_slab-without-disabling-irqs.patch

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
Subject: mm, slub: call deactivate_slab() without disabling irqs

The function is now safe to be called with irqs enabled, so move the calls
outside of irq disabled sections.

When called from ___slab_alloc() -> flush_slab() we have irqs disabled, so
to reenable them before deactivate_slab() we need to open-code
flush_slab() in ___slab_alloc() and reenable irqs after modifying the
kmem_cache_cpu fields.  But that means a IRQ handler meanwhile might have
assigned a new page to kmem_cache_cpu.page so we have to retry the whole
check.

The remaining callers of flush_slab() are the IPI handler which has
disabled irqs anyway, and slub_cpu_dead() which will be dealt with in the
following patch.

Link: https://lkml.kernel.org/r/20210805152000.12817-22-vbabka@suse.cz
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

 mm/slub.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/mm/slub.c~mm-slub-call-deactivate_slab-without-disabling-irqs
+++ a/mm/slub.c
@@ -2752,8 +2752,8 @@ deactivate_slab:
 	freelist = c->freelist;
 	c->page = NULL;
 	c->freelist = NULL;
-	deactivate_slab(s, page, freelist);
 	local_irq_restore(flags);
+	deactivate_slab(s, page, freelist);
 
 new_slab:
 
@@ -2821,18 +2821,32 @@ check_new_page:
 		 */
 		goto return_single;
 
+retry_load_page:
+
 	local_irq_save(flags);
-	if (unlikely(c->page))
-		flush_slab(s, c);
+	if (unlikely(c->page)) {
+		void *flush_freelist = c->freelist;
+		struct page *flush_page = c->page;
+
+		c->page = NULL;
+		c->freelist = NULL;
+		c->tid = next_tid(c->tid);
+
+		local_irq_restore(flags);
+
+		deactivate_slab(s, flush_page, flush_freelist);
+
+		stat(s, CPUSLAB_FLUSH);
+
+		goto retry_load_page;
+	}
 	c->page = page;
 
 	goto load_freelist;
 
 return_single:
 
-	local_irq_save(flags);
 	deactivate_slab(s, page, get_freepointer(s, freelist));
-	local_irq_restore(flags);
 	return freelist;
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

