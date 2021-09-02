Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C11C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C14FE60FC4
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347105AbhIBVJV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:09:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346910AbhIBVJS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:09:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A966561074;
        Thu,  2 Sep 2021 21:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630616899;
        bh=BKvkmMCpyhEhjEhuQq6CV/FRGgaFICpdQ0F+voXc0qs=;
        h=Date:From:To:Subject:From;
        b=rmCHyLvUtL+uyk/XLsirN1UZz/sNaOhgj4EtO+ifzepNtFp7dqerLdR0jP0s2GW42
         kxm0g+EuRBWJykU7vUSmDv4iLRA4h1p3CaeIG6qio4UMIZ5OzvXDarHMT7HM1I1rl+
         s4qlpJHTk5xvCLaEyWhcYypjMMK+Yg2fS1DDICQM=
Date:   Thu, 02 Sep 2021 14:08:19 -0700
From:   akpm@linux-foundation.org
To:     efault@gmx.de, mm-commits@vger.kernel.org, vbabka@suse.cz,
        williams@redhat.com
Subject:  [folded-merged]
 mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled-fix-fix.patch
 removed from -mm tree
Message-ID: <20210902210819.33X5i3c05%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled-fix-fix.patch

This patch was dropped because it was folded into mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled-fix-fix

fix renaming snafu

Link: https://lkml.kernel.org/r/ec98bce0-fef4-0fbc-2067-e358510e0321@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Clark Williams <williams@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled-fix-fix
+++ a/mm/slub.c
@@ -2720,7 +2720,7 @@ redo:
 	 * PFMEMALLOC but right now, we are losing the pfmemalloc
 	 * information when the page leaves the per-cpu allocator
 	 */
-	if (unlikely(!try_pfmemalloc_match(page, gfpflags)))
+	if (unlikely(!pfmemalloc_match_unsafe(page, gfpflags)))
 		goto deactivate_slab;
 
 	/* must check again c->page in case IRQ handler changed it */
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

