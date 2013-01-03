From: akpm@linux-foundation.org
Subject: + memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch added to -mm tree
Date: Thu, 03 Jan 2013 12:24:44 -0800
Message-ID: <20130103202445.4744120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:42574 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3ACUYs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jan 2013 15:24:48 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so978219fav.0
        for <mm-commits@vger.kernel.org>; Thu, 03 Jan 2013 12:24:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, glommer@parallels.com, hannes@cmpxchg.org, htejun@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, yinghan@google.com


The patch titled
     Subject: memcg,vmscan: do not break out targeted reclaim without reclaimed pages
has been added to the -mm tree.  Its filename is
     memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg,vmscan: do not break out targeted reclaim without reclaimed pages

Targeted (hard resp.  soft) reclaim has traditionally tried to scan one
group with decreasing priority until nr_to_reclaim (SWAP_CLUSTER_MAX
pages) is reclaimed or all priorities are exhausted.  The reclaim is then
retried until the limit is met.

This approach, however, doesn't work well with deeper hierarchies where
groups higher in the hierarchy do not have any or only very few pages
(this usually happens if those groups do not have any tasks and they have
only re-parented pages after some of their children is removed).  Those
groups are reclaimed with decreasing priority pointlessly as there is
nothing to reclaim from them.

An easiest fix is to break out of the memcg iteration loop in shrink_zone
only if the whole hierarchy has been visited or sufficient pages have been
reclaimed.  This is also more natural because the reclaimer expects that
the hierarchy under the given root is reclaimed.  As a result we can
simplify the soft limit reclaim which does its own iteration.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN mm/vmscan.c~memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages mm/vmscan.c
--- a/mm/vmscan.c~memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages
+++ a/mm/vmscan.c
@@ -1973,18 +1973,17 @@ static void shrink_zone(struct zone *zon
 			shrink_lruvec(lruvec, sc);
 
 			/*
-			 * Limit reclaim has historically picked one
-			 * memcg and scanned it with decreasing
-			 * priority levels until nr_to_reclaim had
-			 * been reclaimed.  This priority cycle is
-			 * thus over after a single memcg.
-			 *
-			 * Direct reclaim and kswapd, on the other
-			 * hand, have to scan all memory cgroups to
-			 * fulfill the overall scan target for the
+			 * Direct reclaim and kswapd have to scan all memory
+			 * cgroups to fulfill the overall scan target for the
 			 * zone.
+			 *
+			 * Limit reclaim, on the other hand, only cares about
+			 * nr_to_reclaim pages to be reclaimed and it will
+			 * retry with decreasing priority if one round over the
+			 * whole hierarchy is not sufficient.
 			 */
-			if (!global_reclaim(sc)) {
+			if (!global_reclaim(sc) &&
+					sc->nr_to_reclaim >= sc->nr_reclaimed) {
 				mem_cgroup_iter_break(root, memcg);
 				break;
 			}
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-cond_resched-in-tlb_flush_mmu-to-fix-soft-lockups-on-config_preempt.patch
mm-fix-zone_watermark_ok_safe-accounting-of-isolated-pages.patch
mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt.patch
mm-limit-mmu_gather-batching-to-fix-soft-lockups-on-config_preempt-fix.patch
memcg-oom-provide-more-precise-dump-info-while-memcg-oom-happening.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

