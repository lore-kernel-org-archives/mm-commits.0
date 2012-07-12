From: akpm@linux-foundation.org
Subject: + mm-allow-pf_memalloc-from-softirq-context.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:27:32 -0700
Message-ID: <20120712212732.641AF100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:51016 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971Ab2GLV1d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:27:33 -0400
Received: by vbnl22 with SMTP id l22so279362vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:27:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, a.p.zijlstra@chello.nl, cl@linux.com, davem@davemloft.net, emunson@mgebm.net, eric.dumazet@gmail.com, michaelc@cs.wisc.edu, neilb@suse.de, sebastian@breakpoint.cc


The patch titled
     Subject: mm: allow PF_MEMALLOC from softirq context
has been added to the -mm tree.  Its filename is
     mm-allow-pf_memalloc-from-softirq-context.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: allow PF_MEMALLOC from softirq context

This is needed to allow network softirq packet processing to make use of
PF_MEMALLOC.

Currently softirq context cannot use PF_MEMALLOC due to it not being
associated with a task, and therefore not having task flags to fiddle with
- thus the gfp to alloc flag mapping ignores the task flags when in
interrupts (hard or soft) context.

Allowing softirqs to make use of PF_MEMALLOC therefore requires some
trickery.  This patch borrows the task flags from whatever process happens
to be preempted by the softirq.  It then modifies the gfp to alloc flags
mapping to not exclude task flags in softirq context, and modify the
softirq code to save, clear and restore the PF_MEMALLOC flag.

The save and clear, ensures the preempted task's PF_MEMALLOC flag doesn't
leak into the softirq.  The restore ensures a softirq's PF_MEMALLOC flag
cannot leak back into the preempted process.  This should be safe due to
the following reasons

Softirqs can run on multiple CPUs sure but the same task should not be
	executing the same softirq code. Neither should the softirq
	handler be preempted by any other softirq handler so the flags
	should not leak to an unrelated softirq.

Softirqs re-enable hardware interrupts in __do_softirq() so can be
	preempted by hardware interrupts so PF_MEMALLOC is inherited
	by the hard IRQ. However, this is similar to a process in
	reclaim being preempted by a hardirq. While PF_MEMALLOC is
	set, gfp_to_alloc_flags() distinguishes between hard and
	soft irqs and avoids giving a hardirq the ALLOC_NO_WATERMARKS
	flag.

If the softirq is deferred to ksoftirq then its flags may be used
        instead of a normal tasks but as the softirq cannot be preempted,
        the PF_MEMALLOC flag does not leak to other code by accident.

[davem@davemloft.net: Document why PF_MEMALLOC is safe]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: David Miller <davem@davemloft.net>
Cc: Neil Brown <neilb@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    7 +++++++
 kernel/softirq.c      |    9 +++++++++
 mm/page_alloc.c       |    6 +++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff -puN include/linux/sched.h~mm-allow-pf_memalloc-from-softirq-context include/linux/sched.h
--- a/include/linux/sched.h~mm-allow-pf_memalloc-from-softirq-context
+++ a/include/linux/sched.h
@@ -1902,6 +1902,13 @@ static inline void rcu_copy_process(stru
 
 #endif
 
+static inline void tsk_restore_flags(struct task_struct *task,
+				unsigned long orig_flags, unsigned long flags)
+{
+	task->flags &= ~flags;
+	task->flags |= orig_flags & flags;
+}
+
 #ifdef CONFIG_SMP
 extern void do_set_cpus_allowed(struct task_struct *p,
 			       const struct cpumask *new_mask);
diff -puN kernel/softirq.c~mm-allow-pf_memalloc-from-softirq-context kernel/softirq.c
--- a/kernel/softirq.c~mm-allow-pf_memalloc-from-softirq-context
+++ a/kernel/softirq.c
@@ -210,6 +210,14 @@ asmlinkage void __do_softirq(void)
 	__u32 pending;
 	int max_restart = MAX_SOFTIRQ_RESTART;
 	int cpu;
+	unsigned long old_flags = current->flags;
+
+	/*
+	 * Mask out PF_MEMALLOC s current task context is borrowed for the
+	 * softirq. A softirq handled such as network RX might set PF_MEMALLOC
+	 * again if the socket is related to swap
+	 */
+	current->flags &= ~PF_MEMALLOC;
 
 	pending = local_softirq_pending();
 	account_system_vtime(current);
@@ -265,6 +273,7 @@ restart:
 
 	account_system_vtime(current);
 	__local_bh_enable(SOFTIRQ_OFFSET);
+	tsk_restore_flags(current, old_flags, PF_MEMALLOC);
 }
 
 #ifndef __ARCH_HAS_DO_SOFTIRQ
diff -puN mm/page_alloc.c~mm-allow-pf_memalloc-from-softirq-context mm/page_alloc.c
--- a/mm/page_alloc.c~mm-allow-pf_memalloc-from-softirq-context
+++ a/mm/page_alloc.c
@@ -2295,7 +2295,11 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
 		if (gfp_mask & __GFP_MEMALLOC)
 			alloc_flags |= ALLOC_NO_WATERMARKS;
-		else if (likely(!(gfp_mask & __GFP_NOMEMALLOC)) && !in_interrupt())
+		else if (in_serving_softirq() && (current->flags & PF_MEMALLOC))
+			alloc_flags |= ALLOC_NO_WATERMARKS;
+		else if (!in_interrupt() &&
+				((current->flags & PF_MEMALLOC) ||
+				 unlikely(test_thread_flag(TIF_MEMDIE))))
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 	}
 
_
Subject: Subject: mm: allow PF_MEMALLOC from softirq context

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
memcg-prevent-oom-with-too-many-dirty-pages-fix.patch
mm-do-not-use-page_count-without-a-page-pin.patch
mm-clean-up-__count_immobile_pages.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch
mm-factor-out-memory-isolate-functions.patch
mm-bug-fix-free-page-check-in-zone_watermark_ok.patch
memory-hotplug-fix-kswapd-looping-forever-problem.patch
memory-hotplug-fix-kswapd-looping-forever-problem-fix.patch
mm-slb-add-knowledge-of-pfmemalloc-reserve-pages.patch
mm-slub-optimise-the-slub-fast-path-to-avoid-pfmemalloc-checks.patch
mm-introduce-__gfp_memalloc-to-allow-access-to-emergency-reserves.patch
mm-allow-pf_memalloc-from-softirq-context.patch
mm-only-set-page-pfmemalloc-when-alloc_no_watermarks-was-used.patch
mm-ignore-mempolicies-when-using-alloc_no_watermark.patch
net-introduce-sk_gfp_atomic-to-allow-addition-of-gfp-flags-depending-on-the-individual-socket.patch
netvm-allow-the-use-of-__gfp_memalloc-by-specific-sockets.patch
netvm-allow-skb-allocation-to-use-pfmemalloc-reserves.patch
netvm-propagate-page-pfmemalloc-to-skb.patch
netvm-propagate-page-pfmemalloc-from-skb_alloc_page-to-skb.patch
netvm-set-pf_memalloc-as-appropriate-during-skb-processing.patch
mm-micro-optimise-slab-to-avoid-a-function-call.patch
nbd-set-sock_memalloc-for-access-to-pfmemalloc-reserves.patch
mm-throttle-direct-reclaimers-if-pf_memalloc-reserves-are-low-and-swap-is-backed-by-network-storage.patch
mm-account-for-the-number-of-times-direct-reclaimers-get-throttled.patch

