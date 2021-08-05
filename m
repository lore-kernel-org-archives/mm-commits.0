Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9ABBC4338F
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90C8460E53
	for <mm-commits@archiver.kernel.org>; Thu,  5 Aug 2021 23:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239266AbhHEXiQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Aug 2021 19:38:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238926AbhHEXiP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Aug 2021 19:38:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5B7661156;
        Thu,  5 Aug 2021 23:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628206680;
        bh=UczPNj6YOyW2e7iR4bU9NQm8A2Irjo13Kk4FStHrJrs=;
        h=Date:From:To:Subject:From;
        b=KHfWC1ycI9GSvlnH6Jb5uC9nNsA2OjFXRD0FY5OLECR39ghIFMhO+sib8Mm1wocV3
         GZvPZW1H8NZva7bOlYHyRwbNyEIZc3YAs3MVm4hjYNrvaL98D+/xEC8PshGJkLD3Ou
         zLQejr+fO9NnMRHW5P3WF0znMxIXPREzgxtLAAew=
Date:   Thu, 05 Aug 2021 16:38:00 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, tglx@linutronix.de,
        rientjes@google.com, penberg@kernel.org,
        mgorman@techsingularity.net, jannh@google.com,
        iamjoonsoo.kim@lge.com, efault@gmx.de, cl@linux.com,
        brouer@redhat.com, bigeasy@linutronix.de, vbabka@suse.cz
Subject:  + mm-slub-dont-disable-irqs-in-slub_cpu_dead.patch added to
 -mm tree
Message-ID: <20210805233800.Vz9i3%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: don't disable irqs in slub_cpu_dead()
has been added to the -mm tree.  Its filename is
     mm-slub-dont-disable-irqs-in-slub_cpu_dead.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-dont-disable-irqs-in-slub_cpu_dead.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-dont-disable-irqs-in-slub_cpu_dead.patch

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
Subject: mm, slub: don't disable irqs in slub_cpu_dead()

slub_cpu_dead() cleans up for an offlined cpu from another cpu and calls
only functions that are now irq safe, so we don't need to disable irqs
anymore.

Link: https://lkml.kernel.org/r/20210805152000.12817-28-vbabka@suse.cz
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

 mm/slub.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/slub.c~mm-slub-dont-disable-irqs-in-slub_cpu_dead
+++ a/mm/slub.c
@@ -2540,14 +2540,10 @@ static void flush_all(struct kmem_cache
 static int slub_cpu_dead(unsigned int cpu)
 {
 	struct kmem_cache *s;
-	unsigned long flags;
 
 	mutex_lock(&slab_mutex);
-	list_for_each_entry(s, &slab_caches, list) {
-		local_irq_save(flags);
+	list_for_each_entry(s, &slab_caches, list)
 		__flush_cpu_slab(s, cpu);
-		local_irq_restore(flags);
-	}
 	mutex_unlock(&slab_mutex);
 	return 0;
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

