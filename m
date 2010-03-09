From: akpm@linux-foundation.org
Subject: [merged] mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:03:26 -0800
Message-ID: <201003091903.o29J3QCj030967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755639Ab0CITDr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:03:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, a.p.zijlstra@chello.nl, minchan.kim@gmail.com, mingo@elte.hu, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm, lockdep: annotate reclaim context to zone reclaim too
has been removed from the -mm tree.  Its filename was
     mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm, lockdep: annotate reclaim context to zone reclaim too
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Commit cf40bd16fd ("lockdep: annotate reclaim context") introduced reclaim
context annotation.  But it didn't annotate zone reclaim.  This patch do
it.

The point is, commit cf40bd16fd annotate __alloc_pages_direct_reclaim but
zone-reclaim doesn't use __alloc_pages_direct_reclaim.

current call graph is

__alloc_pages_nodemask
   get_page_from_freelist
       zone_reclaim()
   __alloc_pages_slowpath
       __alloc_pages_direct_reclaim
           try_to_free_pages

Actually, if zone_reclaim_mode=1, VM never call
__alloc_pages_direct_reclaim in usual VM pressure.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/vmscan.c~mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too mm/vmscan.c
--- a/mm/vmscan.c~mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too
+++ a/mm/vmscan.c
@@ -2557,6 +2557,7 @@ static int __zone_reclaim(struct zone *z
 	 * and RECLAIM_SWAP.
 	 */
 	p->flags |= PF_MEMALLOC | PF_SWAPWRITE;
+	lockdep_set_current_reclaim_state(gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
@@ -2600,6 +2601,7 @@ static int __zone_reclaim(struct zone *z
 
 	p->reclaim_state = NULL;
 	current->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE);
+	lockdep_clear_current_reclaim_state();
 	return sc.nr_reclaimed >= nr_pages;
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
memcg-move-charges-of-anonymous-swap-fix-2.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
reiser4.patch

