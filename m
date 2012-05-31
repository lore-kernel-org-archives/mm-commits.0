From: akpm@linux-foundation.org
Subject: [merged] mm-remove-swap-token-code.patch removed from -mm tree
Date: Thu, 31 May 2012 12:13:48 -0700
Message-ID: <20120531191348.8D723A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:65415 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932663Ab2EaTNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2012 15:13:51 -0400
Received: by lagr15 with SMTP id r15so75614lag.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:13:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, bpicco@meloft.net, hannes@cmpxchg.org, hughd@google.com, khlebnikov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove swap token code
has been removed from the -mm tree.  Its filename was
     mm-remove-swap-token-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: remove swap token code

The swap token code no longer fits in with the current VM model.  It does
not play well with cgroups or the better NUMA placement code in
development, since we have only one swap token globally.

It also has the potential to mess with scalability of the system, by
increasing the number of non-reclaimable pages on the active and inactive
anon LRU lists.

Last but not least, the swap token code has been broken for a year without
complaints, as reported by Konstantin Khlebnikov.  This suggests we no
longer have much use for it.

The days of sub-1G memory systems with heavy use of swap are over.  If we
ever need thrashing reducing code in the future, we will have to implement
something that does scale.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hughd@google.com>
Acked-by: Bob Picco <bpicco@meloft.net>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h      |   11 --
 include/linux/swap.h          |   35 -------
 include/trace/events/vmscan.h |   82 ----------------
 kernel/fork.c                 |    9 -
 mm/Makefile                   |    2 
 mm/memcontrol.c               |    1 
 mm/memory.c                   |    2 
 mm/rmap.c                     |    6 -
 mm/thrash.c                   |  155 --------------------------------
 mm/vmscan.c                   |    6 -
 10 files changed, 2 insertions(+), 307 deletions(-)

diff -puN include/linux/mm_types.h~mm-remove-swap-token-code include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-remove-swap-token-code
+++ a/include/linux/mm_types.h
@@ -345,17 +345,6 @@ struct mm_struct {
 	/* Architecture-specific MM context */
 	mm_context_t context;
 
-	/* Swap token stuff */
-	/*
-	 * Last value of global fault stamp as seen by this process.
-	 * In other words, this value gives an indication of how long
-	 * it has been since this task got the token.
-	 * Look at mm/thrash.c
-	 */
-	unsigned int faultstamp;
-	unsigned int token_priority;
-	unsigned int last_interval;
-
 	unsigned long flags; /* Must use atomic bitops to access the bits */
 
 	struct core_state *core_state; /* coredumping support */
diff -puN include/linux/swap.h~mm-remove-swap-token-code include/linux/swap.h
--- a/include/linux/swap.h~mm-remove-swap-token-code
+++ a/include/linux/swap.h
@@ -355,23 +355,6 @@ extern int reuse_swap_page(struct page *
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 
-/* linux/mm/thrash.c */
-extern struct mm_struct *swap_token_mm;
-extern void grab_swap_token(struct mm_struct *);
-extern void __put_swap_token(struct mm_struct *);
-extern void disable_swap_token(struct mem_cgroup *memcg);
-
-static inline int has_swap_token(struct mm_struct *mm)
-{
-	return (mm == swap_token_mm);
-}
-
-static inline void put_swap_token(struct mm_struct *mm)
-{
-	if (has_swap_token(mm))
-		__put_swap_token(mm);
-}
-
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 extern void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent, bool swapout);
@@ -476,24 +459,6 @@ static inline swp_entry_t get_swap_page(
 	return entry;
 }
 
-/* linux/mm/thrash.c */
-static inline void put_swap_token(struct mm_struct *mm)
-{
-}
-
-static inline void grab_swap_token(struct mm_struct *mm)
-{
-}
-
-static inline int has_swap_token(struct mm_struct *mm)
-{
-	return 0;
-}
-
-static inline void disable_swap_token(struct mem_cgroup *memcg)
-{
-}
-
 static inline void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
 {
diff -puN include/trace/events/vmscan.h~mm-remove-swap-token-code include/trace/events/vmscan.h
--- a/include/trace/events/vmscan.h~mm-remove-swap-token-code
+++ a/include/trace/events/vmscan.h
@@ -395,88 +395,6 @@ TRACE_EVENT(mm_vmscan_lru_shrink_inactiv
 		show_reclaim_flags(__entry->reclaim_flags))
 );
 
-TRACE_EVENT(replace_swap_token,
-	TP_PROTO(struct mm_struct *old_mm,
-		 struct mm_struct *new_mm),
-
-	TP_ARGS(old_mm, new_mm),
-
-	TP_STRUCT__entry(
-		__field(struct mm_struct*,	old_mm)
-		__field(unsigned int,		old_prio)
-		__field(struct mm_struct*,	new_mm)
-		__field(unsigned int,		new_prio)
-	),
-
-	TP_fast_assign(
-		__entry->old_mm   = old_mm;
-		__entry->old_prio = old_mm ? old_mm->token_priority : 0;
-		__entry->new_mm   = new_mm;
-		__entry->new_prio = new_mm->token_priority;
-	),
-
-	TP_printk("old_token_mm=%p old_prio=%u new_token_mm=%p new_prio=%u",
-		  __entry->old_mm, __entry->old_prio,
-		  __entry->new_mm, __entry->new_prio)
-);
-
-DECLARE_EVENT_CLASS(put_swap_token_template,
-	TP_PROTO(struct mm_struct *swap_token_mm),
-
-	TP_ARGS(swap_token_mm),
-
-	TP_STRUCT__entry(
-		__field(struct mm_struct*, swap_token_mm)
-	),
-
-	TP_fast_assign(
-		__entry->swap_token_mm = swap_token_mm;
-	),
-
-	TP_printk("token_mm=%p", __entry->swap_token_mm)
-);
-
-DEFINE_EVENT(put_swap_token_template, put_swap_token,
-	TP_PROTO(struct mm_struct *swap_token_mm),
-	TP_ARGS(swap_token_mm)
-);
-
-DEFINE_EVENT_CONDITION(put_swap_token_template, disable_swap_token,
-	TP_PROTO(struct mm_struct *swap_token_mm),
-	TP_ARGS(swap_token_mm),
-	TP_CONDITION(swap_token_mm != NULL)
-);
-
-TRACE_EVENT_CONDITION(update_swap_token_priority,
-	TP_PROTO(struct mm_struct *mm,
-		 unsigned int old_prio,
-		 struct mm_struct *swap_token_mm),
-
-	TP_ARGS(mm, old_prio, swap_token_mm),
-
-	TP_CONDITION(mm->token_priority != old_prio),
-
-	TP_STRUCT__entry(
-		__field(struct mm_struct*, mm)
-		__field(unsigned int, old_prio)
-		__field(unsigned int, new_prio)
-		__field(struct mm_struct*, swap_token_mm)
-		__field(unsigned int, swap_token_prio)
-	),
-
-	TP_fast_assign(
-		__entry->mm		= mm;
-		__entry->old_prio	= old_prio;
-		__entry->new_prio	= mm->token_priority;
-		__entry->swap_token_mm	= swap_token_mm;
-		__entry->swap_token_prio = swap_token_mm ? swap_token_mm->token_priority : 0;
-	),
-
-	TP_printk("mm=%p old_prio=%u new_prio=%u swap_token_mm=%p token_prio=%u",
-		  __entry->mm, __entry->old_prio, __entry->new_prio,
-		  __entry->swap_token_mm, __entry->swap_token_prio)
-);
-
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
diff -puN kernel/fork.c~mm-remove-swap-token-code kernel/fork.c
--- a/kernel/fork.c~mm-remove-swap-token-code
+++ a/kernel/fork.c
@@ -614,7 +614,6 @@ void mmput(struct mm_struct *mm)
 			list_del(&mm->mmlist);
 			spin_unlock(&mmlist_lock);
 		}
-		put_swap_token(mm);
 		if (mm->binfmt)
 			module_put(mm->binfmt->module);
 		mmdrop(mm);
@@ -831,10 +830,6 @@ struct mm_struct *dup_mm(struct task_str
 	memcpy(mm, oldmm, sizeof(*mm));
 	mm_init_cpumask(mm);
 
-	/* Initializing for Swap token stuff */
-	mm->token_priority = 0;
-	mm->last_interval = 0;
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	mm->pmd_huge_pte = NULL;
 #endif
@@ -913,10 +908,6 @@ static int copy_mm(unsigned long clone_f
 		goto fail_nomem;
 
 good_mm:
-	/* Initializing for Swap token stuff */
-	mm->token_priority = 0;
-	mm->last_interval = 0;
-
 	tsk->mm = mm;
 	tsk->active_mm = mm;
 	return 0;
diff -puN mm/Makefile~mm-remove-swap-token-code mm/Makefile
--- a/mm/Makefile~mm-remove-swap-token-code
+++ a/mm/Makefile
@@ -25,7 +25,7 @@ endif
 obj-$(CONFIG_HAVE_MEMBLOCK) += memblock.o
 
 obj-$(CONFIG_BOUNCE)	+= bounce.o
-obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
+obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o
 obj-$(CONFIG_HAS_DMA)	+= dmapool.o
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
 obj-$(CONFIG_NUMA) 	+= mempolicy.o
diff -puN mm/memcontrol.c~mm-remove-swap-token-code mm/memcontrol.c
--- a/mm/memcontrol.c~mm-remove-swap-token-code
+++ a/mm/memcontrol.c
@@ -5598,7 +5598,6 @@ static void mem_cgroup_move_task(struct 
 	if (mm) {
 		if (mc.to)
 			mem_cgroup_move_charge(mm);
-		put_swap_token(mm);
 		mmput(mm);
 	}
 	if (mc.to)
diff -puN mm/memory.c~mm-remove-swap-token-code mm/memory.c
--- a/mm/memory.c~mm-remove-swap-token-code
+++ a/mm/memory.c
@@ -2908,7 +2908,6 @@ static int do_swap_page(struct mm_struct
 	delayacct_set_flag(DELAYACCT_PF_SWAPIN);
 	page = lookup_swap_cache(entry);
 	if (!page) {
-		grab_swap_token(mm); /* Contend for token _before_ read-in */
 		page = swapin_readahead(entry,
 					GFP_HIGHUSER_MOVABLE, vma, address);
 		if (!page) {
@@ -2938,6 +2937,7 @@ static int do_swap_page(struct mm_struct
 	}
 
 	locked = lock_page_or_retry(page, mm, flags);
+
 	delayacct_clear_flag(DELAYACCT_PF_SWAPIN);
 	if (!locked) {
 		ret |= VM_FAULT_RETRY;
diff -puN mm/rmap.c~mm-remove-swap-token-code mm/rmap.c
--- a/mm/rmap.c~mm-remove-swap-token-code
+++ a/mm/rmap.c
@@ -755,12 +755,6 @@ int page_referenced_one(struct page *pag
 		pte_unmap_unlock(pte, ptl);
 	}
 
-	/* Pretend the page is referenced if the task has the
-	   swap token and is in the middle of a page fault. */
-	if (mm != current->mm && has_swap_token(mm) &&
-			rwsem_is_locked(&mm->mmap_sem))
-		referenced++;
-
 	(*mapcount)--;
 
 	if (referenced)
diff -puN mm/thrash.c~mm-remove-swap-token-code /dev/null
--- a/mm/thrash.c
+++ /dev/null
@@ -1,155 +0,0 @@
-/*
- * mm/thrash.c
- *
- * Copyright (C) 2004, Red Hat, Inc.
- * Copyright (C) 2004, Rik van Riel <riel@redhat.com>
- * Released under the GPL, see the file COPYING for details.
- *
- * Simple token based thrashing protection, using the algorithm
- * described in: http://www.cse.ohio-state.edu/hpcs/WWW/HTML/publications/abs05-1.html
- *
- * Sep 2006, Ashwin Chaugule <ashwin.chaugule@celunite.com>
- * Improved algorithm to pass token:
- * Each task has a priority which is incremented if it contended
- * for the token in an interval less than its previous attempt.
- * If the token is acquired, that task's priority is boosted to prevent
- * the token from bouncing around too often and to let the task make
- * some progress in its execution.
- */
-
-#include <linux/jiffies.h>
-#include <linux/mm.h>
-#include <linux/sched.h>
-#include <linux/swap.h>
-#include <linux/memcontrol.h>
-
-#include <trace/events/vmscan.h>
-
-#define TOKEN_AGING_INTERVAL	(0xFF)
-
-static DEFINE_SPINLOCK(swap_token_lock);
-struct mm_struct *swap_token_mm;
-static struct mem_cgroup *swap_token_memcg;
-
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR
-static struct mem_cgroup *swap_token_memcg_from_mm(struct mm_struct *mm)
-{
-	struct mem_cgroup *memcg;
-
-	memcg = try_get_mem_cgroup_from_mm(mm);
-	if (memcg)
-		css_put(mem_cgroup_css(memcg));
-
-	return memcg;
-}
-#else
-static struct mem_cgroup *swap_token_memcg_from_mm(struct mm_struct *mm)
-{
-	return NULL;
-}
-#endif
-
-void grab_swap_token(struct mm_struct *mm)
-{
-	int current_interval;
-	unsigned int old_prio = mm->token_priority;
-	static unsigned int global_faults;
-	static unsigned int last_aging;
-
-	global_faults++;
-
-	current_interval = global_faults - mm->faultstamp;
-
-	if (!spin_trylock(&swap_token_lock))
-		return;
-
-	/* First come first served */
-	if (!swap_token_mm)
-		goto replace_token;
-
-	/*
-	 * Usually, we don't need priority aging because long interval faults
-	 * makes priority decrease quickly. But there is one exception. If the
-	 * token owner task is sleeping, it never make long interval faults.
-	 * Thus, we need a priority aging mechanism instead. The requirements
-	 * of priority aging are
-	 *  1) An aging interval is reasonable enough long. Too short aging
-	 *     interval makes quick swap token lost and decrease performance.
-	 *  2) The swap token owner task have to get priority aging even if
-	 *     it's under sleep.
-	 */
-	if ((global_faults - last_aging) > TOKEN_AGING_INTERVAL) {
-		swap_token_mm->token_priority /= 2;
-		last_aging = global_faults;
-	}
-
-	if (mm == swap_token_mm) {
-		mm->token_priority += 2;
-		goto update_priority;
-	}
-
-	if (current_interval < mm->last_interval)
-		mm->token_priority++;
-	else {
-		if (likely(mm->token_priority > 0))
-			mm->token_priority--;
-	}
-
-	/* Check if we deserve the token */
-	if (mm->token_priority > swap_token_mm->token_priority)
-		goto replace_token;
-
-update_priority:
-	trace_update_swap_token_priority(mm, old_prio, swap_token_mm);
-
-out:
-	mm->faultstamp = global_faults;
-	mm->last_interval = current_interval;
-	spin_unlock(&swap_token_lock);
-	return;
-
-replace_token:
-	mm->token_priority += 2;
-	trace_replace_swap_token(swap_token_mm, mm);
-	swap_token_mm = mm;
-	swap_token_memcg = swap_token_memcg_from_mm(mm);
-	last_aging = global_faults;
-	goto out;
-}
-
-/* Called on process exit. */
-void __put_swap_token(struct mm_struct *mm)
-{
-	spin_lock(&swap_token_lock);
-	if (likely(mm == swap_token_mm)) {
-		trace_put_swap_token(swap_token_mm);
-		swap_token_mm = NULL;
-		swap_token_memcg = NULL;
-	}
-	spin_unlock(&swap_token_lock);
-}
-
-static bool match_memcg(struct mem_cgroup *a, struct mem_cgroup *b)
-{
-	if (!a)
-		return true;
-	if (!b)
-		return true;
-	if (a == b)
-		return true;
-	return false;
-}
-
-void disable_swap_token(struct mem_cgroup *memcg)
-{
-	/* memcg reclaim don't disable unrelated mm token. */
-	if (match_memcg(memcg, swap_token_memcg)) {
-		spin_lock(&swap_token_lock);
-		if (match_memcg(memcg, swap_token_memcg)) {
-			trace_disable_swap_token(swap_token_mm);
-			swap_token_mm = NULL;
-			swap_token_memcg = NULL;
-		}
-		spin_unlock(&swap_token_lock);
-	}
-}
diff -puN mm/vmscan.c~mm-remove-swap-token-code mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-swap-token-code
+++ a/mm/vmscan.c
@@ -2352,8 +2352,6 @@ static unsigned long do_try_to_free_page
 
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
 		sc->nr_scanned = 0;
-		if (!priority)
-			disable_swap_token(sc->target_mem_cgroup);
 		aborted_reclaim = shrink_zones(priority, zonelist, sc);
 
 		/*
@@ -2704,10 +2702,6 @@ loop_again:
 		unsigned long lru_pages = 0;
 		int has_under_min_watermark_zone = 0;
 
-		/* The swap token gets in the way of swapout... */
-		if (!priority)
-			disable_swap_token(NULL);
