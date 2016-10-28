From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-do-not-recurse-in-direct-reclaim.patch
 removed from -mm tree
Date: Fri, 28 Oct 2016 11:30:48 -0700
Message-ID: <58139958.RQC+X6twk6kC+qZW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45786 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030339AbcJ1Sat (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 14:30:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: do not recurse in direct reclaim
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-do-not-recurse-in-direct-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: do not recurse in direct reclaim

On 4.0, we saw a stack corruption from a page fault entering direct memory
cgroup reclaim, calling into btrfs_releasepage(), which then tried to
allocate an extent and recursed back into a kmem charge ad nauseam:

[...]
[<ffffffff8136590c>] btrfs_releasepage+0x2c/0x30
[<ffffffff811559a2>] try_to_release_page+0x32/0x50
[<ffffffff81168cea>] shrink_page_list+0x6da/0x7a0
[<ffffffff811693b5>] shrink_inactive_list+0x1e5/0x510
[<ffffffff8116a0a5>] shrink_lruvec+0x605/0x7f0
[<ffffffff8116a37e>] shrink_zone+0xee/0x320
[<ffffffff8116a934>] do_try_to_free_pages+0x174/0x440
[<ffffffff8116adf7>] try_to_free_mem_cgroup_pages+0xa7/0x130
[<ffffffff811b738b>] try_charge+0x17b/0x830
[<ffffffff811bb5b0>] memcg_charge_kmem+0x40/0x80
[<ffffffff811a96a9>] new_slab+0x2d9/0x5a0
[<ffffffff817b2547>] __slab_alloc+0x2fd/0x44f
[<ffffffff811a9b03>] kmem_cache_alloc+0x193/0x1e0
[<ffffffff813801e1>] alloc_extent_state+0x21/0xc0
[<ffffffff813820c5>] __clear_extent_bit+0x2b5/0x400
[<ffffffff81386d03>] try_release_extent_mapping+0x1a3/0x220
[<ffffffff813658a1>] __btrfs_releasepage+0x31/0x70
[<ffffffff8136590c>] btrfs_releasepage+0x2c/0x30
[<ffffffff811559a2>] try_to_release_page+0x32/0x50
[<ffffffff81168cea>] shrink_page_list+0x6da/0x7a0
[<ffffffff811693b5>] shrink_inactive_list+0x1e5/0x510
[<ffffffff8116a0a5>] shrink_lruvec+0x605/0x7f0
[<ffffffff8116a37e>] shrink_zone+0xee/0x320
[<ffffffff8116a934>] do_try_to_free_pages+0x174/0x440
[<ffffffff8116adf7>] try_to_free_mem_cgroup_pages+0xa7/0x130
[<ffffffff811b738b>] try_charge+0x17b/0x830
[<ffffffff811bbfd5>] mem_cgroup_try_charge+0x65/0x1c0
[<ffffffff8118338f>] handle_mm_fault+0x117f/0x1510
[<ffffffff81041cf7>] __do_page_fault+0x177/0x420
[<ffffffff81041fac>] do_page_fault+0xc/0x10
[<ffffffff817c0182>] page_fault+0x22/0x30

On later kernels, kmem charging is opt-in rather than opt-out, and that
particular kmem allocation in btrfs_releasepage() is no longer being
charged and won't recurse and overrun the stack anymore.  But it's not
impossible for an accounted allocation to happen from the memcg direct
reclaim context, and we needed to reproduce this crash many times before
we even got a useful stack trace out of it.

Like other direct reclaimers, mark tasks in memcg reclaim PF_MEMALLOC to
avoid recursing into any other form of direct reclaim.  Then let recursive
charges from PF_MEMALLOC contexts bypass the cgroup limit.

Link: http://lkml.kernel.org/r/20161025141050.GA13019@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++++
 mm/vmscan.c     |    2 ++
 2 files changed, 11 insertions(+)

diff -puN mm/memcontrol.c~mm-memcontrol-do-not-recurse-in-direct-reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-do-not-recurse-in-direct-reclaim
+++ a/mm/memcontrol.c
@@ -1917,6 +1917,15 @@ retry:
 		     current->flags & PF_EXITING))
 		goto force;
 
+	/*
+	 * Prevent unbounded recursion when reclaim operations need to
+	 * allocate memory. This might exceed the limits temporarily,
+	 * but we prefer facilitating memory reclaim and getting back
+	 * under the limit over triggering OOM kills in these cases.
+	 */
+	if (unlikely(current->flags & PF_MEMALLOC))
+		goto force;
+
 	if (unlikely(task_in_memcg_oom(current)))
 		goto nomem;
 
diff -puN mm/vmscan.c~mm-memcontrol-do-not-recurse-in-direct-reclaim mm/vmscan.c
--- a/mm/vmscan.c~mm-memcontrol-do-not-recurse-in-direct-reclaim
+++ a/mm/vmscan.c
@@ -3043,7 +3043,9 @@ unsigned long try_to_free_mem_cgroup_pag
 					    sc.gfp_mask,
 					    sc.reclaim_idx);
 
+	current->flags |= PF_MEMALLOC;
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
+	current->flags &= ~PF_MEMALLOC;
 
 	trace_mm_vmscan_memcg_reclaim_end(nr_reclaimed);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


