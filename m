From: akpm@linux-foundation.org
Subject: + mm-vmscan-fix-unsequenced-modification-and-access-warning.patch added to -mm tree
Date: Wed, 10 May 2017 14:08:41 -0700
Message-ID: <59138159./fsDwpJnBBEu6jl6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34490 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753535AbdEJVIm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 May 2017 17:08:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nick.desaulniers@gmail.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan.c: fix unsequenced modification and access warning
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-unsequenced-modification-and-access-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-unsequenced-modification-and-access-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-unsequenced-modification-and-access-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nick Desaulniers <nick.desaulniers@gmail.com>
Subject: mm/vmscan.c: fix unsequenced modification and access warning

Clang and its -Wunsequenced emits a warning

mm/vmscan.c:2961:25: error: unsequenced modification and access to
'gfp_mask' [-Wunsequenced]
                .gfp_mask = (gfp_mask = current_gfp_context(gfp_mask)),
                                      ^

While it is not clear to me whether the initialization code violates the
specification (6.7.8 par 19 (ISO/IEC 9899) looks like it disagrees) the
code is quite confusing and worth cleaning up anyway. Fix this by
reusing sc.gfp_mask rather than the updated input gfp_mask parameter.

Link: http://lkml.kernel.org/r/20170510154030.10720-1-nick.desaulniers@gmail.com
Signed-off-by: Nick Desaulniers <nick.desaulniers@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-unsequenced-modification-and-access-warning mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-unsequenced-modification-and-access-warning
+++ a/mm/vmscan.c
@@ -2958,7 +2958,7 @@ unsigned long try_to_free_pages(struct z
 	unsigned long nr_reclaimed;
 	struct scan_control sc = {
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
-		.gfp_mask = (gfp_mask = current_gfp_context(gfp_mask)),
+		.gfp_mask = current_gfp_context(gfp_mask),
 		.reclaim_idx = gfp_zone(gfp_mask),
 		.order = order,
 		.nodemask = nodemask,
@@ -2973,12 +2973,12 @@ unsigned long try_to_free_pages(struct z
 	 * 1 is returned so that the page allocator does not OOM kill at this
 	 * point.
 	 */
-	if (throttle_direct_reclaim(gfp_mask, zonelist, nodemask))
+	if (throttle_direct_reclaim(sc.gfp_mask, zonelist, nodemask))
 		return 1;
 
 	trace_mm_vmscan_direct_reclaim_begin(order,
 				sc.may_writepage,
-				gfp_mask,
+				sc.gfp_mask,
 				sc.reclaim_idx);
 
 	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
@@ -3765,17 +3765,16 @@ static int __node_reclaim(struct pglist_
 	const unsigned long nr_pages = 1 << order;
 	struct task_struct *p = current;
 	struct reclaim_state reclaim_state;
-	int classzone_idx = gfp_zone(gfp_mask);
 	unsigned int noreclaim_flag;
 	struct scan_control sc = {
 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
-		.gfp_mask = (gfp_mask = current_gfp_context(gfp_mask)),
+		.gfp_mask = current_gfp_context(gfp_mask),
 		.order = order,
 		.priority = NODE_RECLAIM_PRIORITY,
 		.may_writepage = !!(node_reclaim_mode & RECLAIM_WRITE),
 		.may_unmap = !!(node_reclaim_mode & RECLAIM_UNMAP),
 		.may_swap = 1,
-		.reclaim_idx = classzone_idx,
+		.reclaim_idx = gfp_zone(gfp_mask),
 	};
 
 	cond_resched();
@@ -3786,7 +3785,7 @@ static int __node_reclaim(struct pglist_
 	 */
 	noreclaim_flag = memalloc_noreclaim_save();
 	p->flags |= PF_SWAPWRITE;
-	lockdep_set_current_reclaim_state(gfp_mask);
+	lockdep_set_current_reclaim_state(sc.gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
_

Patches currently in -mm which might be from nick.desaulniers@gmail.com are

mm-vmscan-fix-unsequenced-modification-and-access-warning.patch

