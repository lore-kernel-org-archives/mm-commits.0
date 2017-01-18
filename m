From: akpm@linux-foundation.org
Subject: +
 mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically.patch added
 to -mm tree
Date: Wed, 18 Jan 2017 13:52:06 -0800
Message-ID: <587fe386.DpYx6gScFC3Szl5m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753545AbdARVwN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 16:52:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, nholland@tisys.org, penguin-kernel@I-love.SAKURA.ne.jp, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: do not enfore OOM killer for __GFP_NOFAIL automatically
has been added to the -mm tree.  Its filename is
     mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: do not enfore OOM killer for __GFP_NOFAIL automatically

__alloc_pages_may_oom makes sure to skip the OOM killer depending on the
allocation request.  This includes lowmem requests, costly high order
requests and others.  For a long time __GFP_NOFAIL acted as an override
for all those rules.  This is not documented and it can be quite
surprising as well.  E.g.  GFP_NOFS requests are not invoking the OOM
killer but GFP_NOFS|__GFP_NOFAIL does so if we try to convert some of the
existing open coded loops around allocator to nofail request (and we have
done that in the past) then such a change would have a non trivial side
effect which is far from obvious.  Note that the primary motivation for
skipping the OOM killer is to prevent from pre-mature invocation.

The exception has been added by 82553a937f12 ("oom: invoke oom killer for
__GFP_NOFAIL").  The changelog points out that the oom killer has to be
invoked otherwise the request would be looping for ever.  But this
argument is rather weak because the OOM killer doesn't really guarantee a
forward progress for those exceptional cases:

	- it will hardly help to form costly order which in turn can
	  result in the system panic because of no oom killable task in
	  the end - I believe we certainly do not want to put the system
	  down just because there is a nasty driver asking for order-9
	  page with GFP_NOFAIL not realizing all the consequences. It is
	  much better this request would loop for ever than the massive
	  system disruption
	- lowmem is also highly unlikely to be freed during OOM killer
	- GFP_NOFS request could trigger while there is still a lot of
	  memory pinned by filesystems.

The pre-mature OOM killer is a real issue as reported by Nils Holland
	kworker/u4:5 invoked oom-killer: gfp_mask=0x2400840(GFP_NOFS|__GFP_NOFAIL), nodemask=0, order=0, oom_score_adj=0
	kworker/u4:5 cpuset=/ mems_allowed=0
	CPU: 1 PID: 2603 Comm: kworker/u4:5 Not tainted 4.9.0-gentoo #2
	Hardware name: Hewlett-Packard Compaq 15 Notebook PC/21F7, BIOS F.22 08/06/2014
	Workqueue: writeback wb_workfn (flush-btrfs-1)
	 eff0b604 c142bcce eff0b734 00000000 eff0b634 c1163332 00000000 00000292
	 eff0b634 c1431876 eff0b638 e7fb0b00 e7fa2900 e7fa2900 c1b58785 eff0b734
	 eff0b678 c110795f c1043895 eff0b664 c11075c7 00000007 00000000 00000000
	Call Trace:
	 [<c142bcce>] dump_stack+0x47/0x69
	 [<c1163332>] dump_header+0x60/0x178
	 [<c1431876>] ? ___ratelimit+0x86/0xe0
	 [<c110795f>] oom_kill_process+0x20f/0x3d0
	 [<c1043895>] ? has_capability_noaudit+0x15/0x20
	 [<c11075c7>] ? oom_badness.part.13+0xb7/0x130
	 [<c1107df9>] out_of_memory+0xd9/0x260
	 [<c110ba0b>] __alloc_pages_nodemask+0xbfb/0xc80
	 [<c110414d>] pagecache_get_page+0xad/0x270
	 [<c13664a6>] alloc_extent_buffer+0x116/0x3e0
	 [<c1334a2e>] btrfs_find_create_tree_block+0xe/0x10
	[...]
	Normal free:41332kB min:41368kB low:51708kB high:62048kB active_anon:0kB inactive_anon:0kB active_file:532748kB inactive_file:44kB unevictable:0kB writepending:24kB present:897016kB managed:836248kB mlocked:0kB slab_reclaimable:159448kB slab_unreclaimable:69608kB kernel_stack:1112kB pagetables:1404kB bounce:0kB free_pcp:528kB local_pcp:340kB free_cma:0kB
	lowmem_reserve[]: 0 0 21292 21292
	HighMem free:781660kB min:512kB low:34356kB high:68200kB active_anon:234740kB inactive_anon:360kB active_file:557232kB inactive_file:1127804kB unevictable:0kB writepending:2592kB present:2725384kB managed:2725384kB mlocked:0kB slab_reclaimable:0kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB bounce:0kB free_pcp:800kB local_pcp:608kB free_cma:0kB

This is a GFP_NOFS|__GFP_NOFAIL request which invokes the OOM killer
because there is clearly nothing reclaimable in the zone Normal while
there is a lot of page cache which is most probably pinned by the fs but
GFP_NOFS cannot reclaim it.

This patch simply removes the __GFP_NOFAIL special case in order to have a
more clear semantic without surprising side effects.

Link: http://lkml.kernel.org/r/20161220134904.21023-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Nils Holland <nholland@tisys.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c   |    2 -
 mm/page_alloc.c |   49 ++++++++++++++++++++++------------------------
 2 files changed, 25 insertions(+), 26 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically
+++ a/mm/oom_kill.c
@@ -1013,7 +1013,7 @@ bool out_of_memory(struct oom_control *o
 	 * make sure exclude 0 mask - all other users should have at least
 	 * ___GFP_DIRECT_RECLAIM to get here.
 	 */
-	if (oc->gfp_mask && !(oc->gfp_mask & (__GFP_FS|__GFP_NOFAIL)))
+	if (oc->gfp_mask && !(oc->gfp_mask & __GFP_FS))
 		return true;
 
 	/*
diff -puN mm/page_alloc.c~mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically
+++ a/mm/page_alloc.c
@@ -3093,32 +3093,31 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	if (page)
 		goto out;
 
-	if (!(gfp_mask & __GFP_NOFAIL)) {
-		/* Coredumps can quickly deplete all memory reserves */
-		if (current->flags & PF_DUMPCORE)
-			goto out;
-		/* The OOM killer will not help higher order allocs */
-		if (order > PAGE_ALLOC_COSTLY_ORDER)
-			goto out;
-		/* The OOM killer does not needlessly kill tasks for lowmem */
-		if (ac->high_zoneidx < ZONE_NORMAL)
-			goto out;
-		if (pm_suspended_storage())
-			goto out;
-		/*
-		 * XXX: GFP_NOFS allocations should rather fail than rely on
-		 * other request to make a forward progress.
-		 * We are in an unfortunate situation where out_of_memory cannot
-		 * do much for this context but let's try it to at least get
-		 * access to memory reserved if the current task is killed (see
-		 * out_of_memory). Once filesystems are ready to handle allocation
-		 * failures more gracefully we should just bail out here.
-		 */
+	/* Coredumps can quickly deplete all memory reserves */
+	if (current->flags & PF_DUMPCORE)
+		goto out;
+	/* The OOM killer will not help higher order allocs */
+	if (order > PAGE_ALLOC_COSTLY_ORDER)
+		goto out;
+	/* The OOM killer does not needlessly kill tasks for lowmem */
+	if (ac->high_zoneidx < ZONE_NORMAL)
+		goto out;
+	if (pm_suspended_storage())
+		goto out;
+	/*
+	 * XXX: GFP_NOFS allocations should rather fail than rely on
+	 * other request to make a forward progress.
+	 * We are in an unfortunate situation where out_of_memory cannot
+	 * do much for this context but let's try it to at least get
+	 * access to memory reserved if the current task is killed (see
+	 * out_of_memory). Once filesystems are ready to handle allocation
+	 * failures more gracefully we should just bail out here.
+	 */
+
+	/* The OOM killer may not free memory on a specific node */
+	if (gfp_mask & __GFP_THISNODE)
+		goto out;
 
-		/* The OOM killer may not free memory on a specific node */
-		if (gfp_mask & __GFP_THISNODE)
-			goto out;
-	}
 	/* Exhausted what can be done so it's blamo time */
 	if (out_of_memory(&oc) || WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL)) {
 		*did_some_progress = 1;
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-throttle-show_mem-from-warn_alloc.patch
mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
oom-trace-add-oom-detection-tracepoints.patch
oom-trace-add-compaction-retry-tracepoint.patch
mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch
mm-vmscan-add-active-list-aging-tracepoint.patch
mm-vmscan-add-active-list-aging-tracepoint-update.patch
mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate.patch
mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint.patch
mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch
mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch
mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint.patch
trace-vmscan-postprocess-sync-with-tracepoints-updates.patch
mm-vmscan-do-not-count-freed-pages-as-pgdeactivate.patch
mm-vmscan-cleanup-lru-size-claculations.patch
mm-vmscan-consider-eligible-zones-in-get_scan_count.patch
revert-mm-bail-out-in-shrink_inactive_list.patch
mm-page_alloc-do-not-report-all-nodes-in-show_mem.patch
mm-page_alloc-warn_alloc-print-nodemask.patch
arch-mm-remove-arch-specific-show_mem.patch
lib-show_memc-teach-show_mem-to-work-with-the-given-nodemask.patch
mm-consolidate-gfp_nofail-checks-in-the-allocator-slowpath.patch
mm-oom-do-not-enfore-oom-killer-for-__gfp_nofail-automatically.patch
mm-help-__gfp_nofail-allocations-which-do-not-trigger-oom-killer.patch

