From: akpm@linux-foundation.org
Subject: + mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch added to -mm tree
Date: Wed, 13 Jan 2010 16:49:02 -0800
Message-ID: <201001140049.o0E0n2wi006456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976Ab0ANAtY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jan 2010 19:49:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, a.p.zijlstra@chello.nl, minchan.kim@gmail.com, mingo@elte.hu, npiggin@suse.de


The patch titled
     mm, lockdep: annotate reclaim context to zone reclaim too
has been added to the -mm tree.  Its filename is
     mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2552,6 +2552,7 @@ static int __zone_reclaim(struct zone *z
 	 * and RECLAIM_SWAP.
 	 */
 	p->flags |= PF_MEMALLOC | PF_SWAPWRITE;
+	lockdep_set_current_reclaim_state(gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
@@ -2595,6 +2596,7 @@ static int __zone_reclaim(struct zone *z
 
 	p->reclaim_state = NULL;
 	current->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE);
+	lockdep_clear_current_reclaim_state();
 	return sc.nr_reclaimed >= nr_pages;
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
page-allocator-fix-update-nr_free_pages-only-as-necessary.patch
mm-page_alloc-fix-the-range-check-for-backward-merging.patch
vmscan-kswapd-dont-retry-balance_pgdat-if-all-zones-are-unreclaimable.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
mlock_vma_pages_range-never-return-negative-value.patch
mlock_vma_pages_range-only-return-success-or-failure.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-lockdep-annotate-reclaim-context-to-zone-reclaim-too.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

