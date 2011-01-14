From: akpm@linux-foundation.org
Subject: [merged] mm-page_allocc-dont-cache-current-in-a-local.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:26 -0800
Message-ID: <201101142252.p0EMqGe5005603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079Ab1ANWwX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:52:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm/page_alloc.c: don't cache `current' in a local
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-dont-cache-current-in-a-local.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page_alloc.c: don't cache `current' in a local
From: Andrew Morton <akpm@linux-foundation.org>

It's old-fashioned and unneeded.

akpm:/usr/src/25> size mm/page_alloc.o
   text    data     bss     dec     hex filename
  39884 1241317   18808 1300009  13d629 mm/page_alloc.o (before)
  39838 1241317   18808 1299963  13d5fb mm/page_alloc.o (after)

Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-dont-cache-current-in-a-local mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-dont-cache-current-in-a-local
+++ a/mm/page_alloc.c
@@ -1809,15 +1809,14 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	bool sync_migration)
 {
 	struct page *page;
-	struct task_struct *tsk = current;
 
 	if (!order || compaction_deferred(preferred_zone))
 		return NULL;
 
-	tsk->flags |= PF_MEMALLOC;
+	current->flags |= PF_MEMALLOC;
 	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
 						nodemask, sync_migration);
-	tsk->flags &= ~PF_MEMALLOC;
+	current->flags &= ~PF_MEMALLOC;
 	if (*did_some_progress != COMPACT_SKIPPED) {
 
 		/* Page migration frees to the PCP lists but we want merging */
@@ -1869,23 +1868,22 @@ __alloc_pages_direct_reclaim(gfp_t gfp_m
 {
 	struct page *page = NULL;
 	struct reclaim_state reclaim_state;
-	struct task_struct *p = current;
 	bool drained = false;
 
 	cond_resched();
 
 	/* We now go into synchronous reclaim */
 	cpuset_memory_pressure_bump();
-	p->flags |= PF_MEMALLOC;
+	current->flags |= PF_MEMALLOC;
 	lockdep_set_current_reclaim_state(gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
-	p->reclaim_state = &reclaim_state;
+	current->reclaim_state = &reclaim_state;
 
 	*did_some_progress = try_to_free_pages(zonelist, order, gfp_mask, nodemask);
 
-	p->reclaim_state = NULL;
+	current->reclaim_state = NULL;
 	lockdep_clear_current_reclaim_state();
-	p->flags &= ~PF_MEMALLOC;
+	current->flags &= ~PF_MEMALLOC;
 
 	cond_resched();
 
@@ -1950,7 +1948,6 @@ void wake_all_kswapd(unsigned int order,
 static inline int
 gfp_to_alloc_flags(gfp_t gfp_mask)
 {
-	struct task_struct *p = current;
 	int alloc_flags = ALLOC_WMARK_MIN | ALLOC_CPUSET;
 	const gfp_t wait = gfp_mask & __GFP_WAIT;
 
@@ -1977,12 +1974,12 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
 		 */
 		alloc_flags &= ~ALLOC_CPUSET;
-	} else if (unlikely(rt_task(p)) && !in_interrupt())
+	} else if (unlikely(rt_task(current)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
 	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
 		if (!in_interrupt() &&
-		    ((p->flags & PF_MEMALLOC) ||
+		    ((current->flags & PF_MEMALLOC) ||
 		     unlikely(test_thread_flag(TIF_MEMDIE))))
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 	}
@@ -2001,7 +1998,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	int alloc_flags;
 	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
-	struct task_struct *p = current;
 	bool sync_migration = false;
 
 	/*
@@ -2060,7 +2056,7 @@ rebalance:
 		goto nopage;
 
 	/* Avoid recursion of direct reclaim */
-	if (p->flags & PF_MEMALLOC)
+	if (current->flags & PF_MEMALLOC)
 		goto nopage;
 
 	/* Avoid allocations with no watermarks from looping endlessly */
@@ -2153,7 +2149,7 @@ nopage:
 	if (!(gfp_mask & __GFP_NOWARN) && printk_ratelimit()) {
 		printk(KERN_WARNING "%s: page allocation failure."
 			" order:%d, mode:0x%x\n",
-			p->comm, order, gfp_mask);
+			current->comm, order, gfp_mask);
 		dump_stack();
 		show_mem();
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-nfc-pn544c-fix-min_t-warnings.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
mm-deactivate-invalidated-pages-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

