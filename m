Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F0BEC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  7 Sep 2021 21:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AB7261102
	for <mm-commits@archiver.kernel.org>; Tue,  7 Sep 2021 21:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347062AbhIGVTs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 17:19:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243883AbhIGVTr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 17:19:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0A5660F70;
        Tue,  7 Sep 2021 21:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631049521;
        bh=LSfkLssbZ+rSkuK3HqBBrQ6ZUjVDEd0f6Kad0GmTqT4=;
        h=Date:From:To:Subject:From;
        b=hsb1XnTCzSHcUBAfn/Sq/4nPlgDE5II40QWaT+E9ACEKHFnU7X6Jglz+SmkAYqO99
         VW54Hb7J8T1MRU7gPW2e+jag2/9Q+rr1VwMiNpJvEz1O1i7H0TbmO40VOMfzziWQqb
         CiJVuOjLil5+FbRHy5un5eKq43mkzBIvX66ceUCg=
Date:   Tue, 07 Sep 2021 14:18:40 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        vbabka@suse.cz
Subject:  [to-be-updated]
 mm-slub-dont-call-flush_all-from-slab_debug_trace_open.patch removed from
 -mm tree
Message-ID: <20210907211840.tb-z8UshM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: don't call flush_all() from slab_debug_trace_open()
has been removed from the -mm tree.  Its filename was
     mm-slub-dont-call-flush_all-from-slab_debug_trace_open.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: don't call flush_all() from slab_debug_trace_open()

Patch series "SLUB: reduce irq disabled scope and make it RT compatible", v4.

This series was initially inspired by Mel's pcplist local_lock rewrite,
and also interest to better understand SLUB's locking and the new
primitives and RT variants and implications.  It should make SLUB more
preemption-friendly, especially for RT, hopefully without noticeable
regressions, as the fast paths are not affected.

The RFC/v1 version got basic performance screening by Mel that didn't show
major regressions.  Mike's testing with hackbench of v2 on !RT reported
negligible differences [6]:

virgin(ish) tip
5.13.0.g60ab3ed-tip
          7,320.67 msec task-clock                #    7.792 CPUs utilized            ( +-  0.31% )
           221,215      context-switches          #    0.030 M/sec                    ( +-  3.97% )
            16,234      cpu-migrations            #    0.002 M/sec                    ( +-  4.07% )
            13,233      page-faults               #    0.002 M/sec                    ( +-  0.91% )
    27,592,205,252      cycles                    #    3.769 GHz                      ( +-  0.32% )
     8,309,495,040      instructions              #    0.30  insn per cycle           ( +-  0.37% )
     1,555,210,607      branches                  #  212.441 M/sec                    ( +-  0.42% )
         5,484,209      branch-misses             #    0.35% of all branches          ( +-  2.13% )

           0.93949 +- 0.00423 seconds time elapsed  ( +-  0.45% )
           0.94608 +- 0.00384 seconds time elapsed  ( +-  0.41% ) (repeat)
           0.94422 +- 0.00410 seconds time elapsed  ( +-  0.43% )

5.13.0.g60ab3ed-tip +slub-local-lock-v2r3
          7,343.57 msec task-clock                #    7.776 CPUs utilized            ( +-  0.44% )
           223,044      context-switches          #    0.030 M/sec                    ( +-  3.02% )
            16,057      cpu-migrations            #    0.002 M/sec                    ( +-  4.03% )
            13,164      page-faults               #    0.002 M/sec                    ( +-  0.97% )
    27,684,906,017      cycles                    #    3.770 GHz                      ( +-  0.45% )
     8,323,273,871      instructions              #    0.30  insn per cycle           ( +-  0.28% )
     1,556,106,680      branches                  #  211.901 M/sec                    ( +-  0.31% )
         5,463,468      branch-misses             #    0.35% of all branches          ( +-  1.33% )

           0.94440 +- 0.00352 seconds time elapsed  ( +-  0.37% )
           0.94830 +- 0.00228 seconds time elapsed  ( +-  0.24% ) (repeat)
           0.93813 +- 0.00440 seconds time elapsed  ( +-  0.47% ) (repeat)

RT configs showed some throughput regressions, but that's expected
tradeoff for the preemption improvements through the RT mutex.  It didn't
prevent the v2 to be incorporated to the 5.13 RT tree [7], leading to
testing exposure and bugfixes.

Before the series, SLUB is lockless in both allocation and free fast
paths, but elsewhere, it's disabling irqs for considerable periods of time
- especially in allocation slowpath and the bulk allocation, where IRQs
are re-enabled only when a new page from the page allocator is needed, and
the context allows blocking.  The irq disabled sections can then include
deactivate_slab() which walks a full freelist and frees the slab back to
page allocator or unfreeze_partials() going through a list of percpu
partial slabs.  The RT tree currently has some patches mitigating these,
but we can do much better in mainline too.

Patches 1-6 are straightforward improvements or cleanups that could exist
outside of this series too, but are prerequsities.

Patches 7-10 are also preparatory code changes without functional changes,
but not so useful without the rest of the series.

Patch 11 simplifies the fast paths on systems with preemption, based on
(hopefully correct) observation that the current loops to verify tid are
unnecessary.

Patches 12-21 focus on reducing irq disabled scope in the allocation
slowpath.

Patch 12 moves disabling of irqs into ___slab_alloc() from its callers,
which are the allocation slowpath, and bulk allocation.  Instead these
callers only disable preemption to stabilize the cpu.  The following
patches then gradually reduce the scope of disabled irqs in
___slab_alloc() and the functions called from there.  As of patch 15, the
re-enabling of irqs based on gfp flags before calling the page allocator
is removed from allocate_slab().  As of patch 18, it's possible to reach
the page allocator (in case of existing slabs depleted) without disabling
and re-enabling irqs a single time.

Pathces 22-27 reduce the scope of disabled irqs in functions related to
unfreezing percpu partial slab.

Patch 28 is preparatory.  Patch 29 is adopted from the RT tree and
converts the flushing of percpu slabs on all cpus from using IPI to
workqueue, so that the processing isn't happening with irqs disabled in
the IPI handler.  The flushing is not performance critical so it should be
acceptable.

Patch 30 also comes from RT tree and makes object_map_lock RT compatible.

Patches 31-32 make slab_lock irq-safe on RT where we cannot rely on having
irq disabled from the list_lock spin lock usage.

Patch 33 changes kmem_cache_cpu->partial handling in put_cpu_partial()
from cmpxchg loop to a short irq disabled section, which is used by all
other code modifying the field.  This addresses a theoretical race
scenario pointed out by Jann, and makes the critical section safe wrt with
RT local_lock semantics after the conversion in patch 35.

Patch 34 changes preempt disable to migrate disable, so that the nested
list_lock spinlock is safe to take on RT.  Because migrate_disable() is a
function call even on !RT, a small set of private wrappers is introduced
to keep using the cheaper preempt_disable() on !PREEMPT_RT configurations.

As of this patch, SLUB should be compatible with RT's lock semantics, to
the best of my knowledge.

Finally, patch 35 changes irq disabled sections that protect
kmem_cache_cpu fields in the slow paths, with a local lock.  However on
PREEMPT_RT it means the lockless fast paths can now preempt slow paths
which don't expect that, so the local lock has to be taken also in the
fast paths and they are no longer lockless.  It's up to RT folks to decide
if this is a good tradeoff.  The patch also updates the locking
documentation in the file's comment.

The main results of this series:

* irq disabling is only done for minimum amount of time needed to
  protect the kmem_cache_cpu data and as part of spin lock, local lock and
  bit lock operations to make them irq-safe

* SLUB should be fully PREEMPT_RT compatible

This should have obvious implications for better preemptibility,
especially on RT.

Some details are different than how the previous SLUB RT tree patches were
implemented:

  mm: sl[au]b: Change list_lock to raw_spinlock_t [2] - the SLAB part
  can be dropped as a different patch restricts RT to SLUB anyway.  And
  after this series the list_lock in SLUB is never used with irqs disabled
  before taking the lock so it doesn't have to be converted to
  raw_spinlock_t.

  mm: slub: Move discard_slab() invocations out of IRQ-off sections [3]
  should be unnecessary as this series does move these invocations outside
  irq disabled sections in a different way.

The remaining patches to upstream from the RT tree are small ones related
to KConfig.  The patch that restricts PREEMPT_RT to SLUB (not SLAB or
SLOB) makes sense.  The patch that disables CONFIG_SLUB_CPU_PARTIAL with
PREEMPT_RT could perhaps be re-evaluated as the series addresses some
latency issues with it.

[1] https://lore.kernel.org/lkml/20210524233946.20352-1-vbabka@suse.cz/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git/tree/patches/0001-mm-sl-au-b-Change-list_lock-to-raw_spinlock_t.patch?h=linux-5.12.y-rt-patches
[3] https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git/tree/patches/0004-mm-slub-Move-discard_slab-invocations-out-of-IRQ-off.patch?h=linux-5.12.y-rt-patches
[4] https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git/tree/patches/0005-mm-slub-Move-flush_cpu_slab-invocations-__free_slab-.patch?h=linux-5.12.y-rt-patches
[5] https://lore.kernel.org/lkml/20210609113903.1421-1-vbabka@suse.cz/
[6] https://lore.kernel.org/lkml/891dc24e38106f8542f4c72831d52dc1a1863ae8.camel@gmx.de
[7] https://lore.kernel.org/linux-rt-users/87tul5p2fa.ffs@nanos.tec.linutronix.de/
[8] https://lore.kernel.org/lkml/20210729132132.19691-1-vbabka@suse.cz/
[9] https://lore.kernel.org/lkml/20210804120522.GD6464@techsingularity.net/


This patch (of 35:

slab_debug_trace_open() can only be called on caches with SLAB_STORE_USER
flag and as with all slub debugging flags, such caches avoid cpu or percpu
partial slabs altogether, so there's nothing to flush.

Link: https://lkml.kernel.org/r/20210805152000.12817-1-vbabka@suse.cz
Link: https://lkml.kernel.org/r/20210805152000.12817-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/slub.c~mm-slub-dont-call-flush_all-from-slab_debug_trace_open
+++ a/mm/slub.c
@@ -5825,9 +5825,6 @@ static int slab_debug_trace_open(struct
 	if (!alloc_loc_track(t, PAGE_SIZE / sizeof(struct location), GFP_KERNEL))
 		return -ENOMEM;
 
-	/* Push back cpu slabs */
-	flush_all(s);
-
 	for_each_kmem_cache_node(s, node, n) {
 		unsigned long flags;
 		struct page *page;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-allocate-private-object-map-for-debugfs-listings.patch
mm-slub-allocate-private-object-map-for-validate_slab_cache.patch
mm-slub-dont-disable-irq-for-debug_check_no_locks_freed.patch
mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial.patch
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
mm-slub-optionally-save-restore-irqs-in-slab_lock.patch
mm-slub-make-slab_lock-disable-irqs-with-preempt_rt.patch
mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg.patch
mm-slub-use-migrate_disable-on-preempt_rt.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch
mm-slub-remove-conditional-locking-parameter-from-flush_slab.patch

