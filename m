Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA5F3C433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:53:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D5F561108
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347361AbhIHCyK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347302AbhIHCyI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:54:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82B76610C9;
        Wed,  8 Sep 2021 02:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069580;
        bh=2w4EQ5lGeI8RdJudKOIOWfeEPzEG+Z9iM94E+xOTwD0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lAZtnKjuHdmqrchf3ceR4hJZNtKDolyO5zMtyHuGcI0BJjilDRzHFS050gXPYHRbB
         /cTd3GhBd5ZGcNgtpc0nLFIeZwq36oQ1fSdDvIbREVHYUx5MkFlKwY6ZbVsvj9ikVy
         hMhb8/aKhMFUs9u+0ghVtvq8RwE6SpYULOZDqOA4=
Date:   Tue, 07 Sep 2021 19:52:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 001/147] mm, slub: don't call flush_all() from
 slab_debug_trace_open()
Message-ID: <20210908025259.BMWcjoHBL%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: don't call flush_all() from slab_debug_trace_open()

Patch series "SLUB: reduce irq disabled scope and make it RT compatible", v6.

This series was initially inspired by Mel's pcplist local_lock rewrite,
and also interest to better understand SLUB's locking and the new
primitives and RT variants and implications.  It makes SLUB compatible
with PREEMPT_RT and generally more preemption-friendly, apparently without
significant regressions, as the fast paths are not affected.

The main changes to SLUB by this series:

* irq disabling is now only done for minimum amount of time needed to protect
  the strict kmem_cache_cpu fields, and as part of spin lock, local lock and
  bit lock operations to make them irq-safe

* SLUB is fully PREEMPT_RT compatible

The series should now be sufficiently tested in both RT and !RT configs,
mainly thanks to Mike.

The RFC/v1 version also got basic performance screening by Mel that didn't
show major regressions.  Mike's testing with hackbench of v2 on !RT
reported negligible differences [6]:

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

Patches 7-9 are also preparatory code changes without functional changes,
but not so useful without the rest of the series.

Patch 10 simplifies the fast paths on systems with preemption, based on
(hopefully correct) observation that the current loops to verify tid are
unnecessary.

Patches 11-20 focus on reducing irq disabled scope in the allocation
slowpath.

Patch 11 moves disabling of irqs into ___slab_alloc() from its callers,
which are the allocation slowpath, and bulk allocation.  Instead these
callers only disable preemption to stabilize the cpu.  The following
patches then gradually reduce the scope of disabled irqs in
___slab_alloc() and the functions called from there.  As of patch 14, the
re-enabling of irqs based on gfp flags before calling the page allocator
is removed from allocate_slab().  As of patch 17, it's possible to reach
the page allocator (in case of existing slabs depleted) without disabling
and re-enabling irqs a single time.

Patches 21-26 reduce the scope of disabled irqs in functions related to
unfreezing percpu partial slab.

Patch 27 is preparatory.  Patch 28 is adopted from the RT tree and
converts the flushing of percpu slabs on all cpus from using IPI to
workqueue, so that the processing isn't happening with irqs disabled in
the IPI handler.  The flushing is not performance critical so it should be
acceptable.

Patch 29 also comes from RT tree and makes object_map_lock RT compatible.

Patch 30 make slab_lock irq-safe on RT where we cannot rely on having irq
disabled from the list_lock spin lock usage.

Patch 31 changes kmem_cache_cpu->partial handling in put_cpu_partial()
from cmpxchg loop to a short irq disabled section, which is used by all
other code modifying the field.  This addresses a theoretical race
scenario pointed out by Jann, and makes the critical section safe wrt with
RT local_lock semantics after the conversion in patch 35.

Patch 32 changes preempt disable to migrate disable, so that the nested
list_lock spinlock is safe to take on RT.  Because migrate_disable() is a
function call even on !RT, a small set of private wrappers is introduced
to keep using the cheaper preempt_disable() on !PREEMPT_RT configurations.
As of this patch, SLUB should be already compatible with RT's lock
semantics.

Finally, patch 33 changes irq disabled sections that protect
kmem_cache_cpu fields in the slow paths, with a local lock.  However on
PREEMPT_RT it means the lockless fast paths can now preempt slow paths
which don't expect that, so the local lock has to be taken also in the
fast paths and they are no longer lockless.  RT folks seem to not mind
this tradeoff.  The patch also updates the locking documentation in the
file's comment.

[1] https://lore.kernel.org/lkml/20210524233946.20352-1-vbabka@suse.cz/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git/tree/patches/0001-mm-sl-au-b-Change-list_lock-to-raw_spinlock_t.patch?h=linux-5.12.y-rt-patches
[3] https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git/tree/patches/0004-mm-slub-Move-discard_slab-invocations-out-of-IRQ-off.patch?h=linux-5.12.y-rt-patches
[4] https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-rt-devel.git/tree/patches/0005-mm-slub-Move-flush_cpu_slab-invocations-__free_slab-.patch?h=linux-5.12.y-rt-patches
[5] https://lore.kernel.org/lkml/20210609113903.1421-1-vbabka@suse.cz/
[6] https://lore.kernel.org/lkml/891dc24e38106f8542f4c72831d52dc1a1863ae8.camel@gmx.de
[7] https://lore.kernel.org/linux-rt-users/87tul5p2fa.ffs@nanos.tec.linutronix.de/
[8] https://lore.kernel.org/lkml/20210729132132.19691-1-vbabka@suse.cz/
[9] https://lore.kernel.org/lkml/20210804120522.GD6464@techsingularity.net/
[10] https://lore.kernel.org/lkml/20210805152000.12817-1-vbabka@suse.cz/
[11] https://lore.kernel.org/all/20210823145826.3857-1-vbabka@suse.cz/
[12] https://lore.kernel.org/all/20210823145826.3857-7-vbabka@suse.cz/
[13] https://lore.kernel.org/all/20210823145826.3857-32-vbabka@suse.cz/
[14] https://lore.kernel.org/linux-mm/1ae902f7-c500-f9e8-1b4f-077beade0f42@suse.cz/
[15] https://lore.kernel.org/linux-mm/CAHk-=wjRfFtnQ5p42s_5Uv8i0U5YKSBpTH++_ZMKZyyvYicYmQ@mail.gmail.com/
[16] https://lore.kernel.org/all/871r6j526m.ffs@tglx/


This patch (of 33):

slab_debug_trace_open() can only be called on caches with SLAB_STORE_USER
flag and as with all slub debugging flags, such caches avoid cpu or percpu
partial slabs altogether, so there's nothing to flush.

Link: https://lkml.kernel.org/r/20210904105003.11688-1-vbabka@suse.cz
Link: https://lkml.kernel.org/r/20210904105003.11688-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
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
