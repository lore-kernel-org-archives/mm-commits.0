From: akpm@linux-foundation.org
Subject: +
 memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch added to
 -mm tree
Date: Tue, 30 Jul 2013 15:34:02 -0700
Message-ID: <51f83f5a.DkYqan1bIX9EtEcJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab3G3WeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 18:34:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghan@google.com, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, glommer@openvz.org, bsingharora@gmail.com, mhocko@suse.cz

Subject: + memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch added to -mm tree
To: mhocko@suse.cz,bsingharora@gmail.com,glommer@openvz.org,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com,yinghan@google.com
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 15:34:02 -0700


The patch titled
     Subject: memcg, vmscan: do not fall into reclaim-all pass too quickly
has been added to the -mm tree.  Its filename is
     memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch

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
Subject: memcg, vmscan: do not fall into reclaim-all pass too quickly

shrink_zone starts with soft reclaim pass first and then falls back to
regular reclaim if nothing has been scanned.  This behavior is natural but
there is a catch.  Memcg iterators, when used with the reclaim cookie, are
designed to help to prevent from over reclaim by interleaving reclaimers
(per node-zone-priority) so the tree walk might miss many (even all) nodes
in the hierarchy e.g.  when there are direct reclaimers racing with each
other or with kswapd in the global case or multiple allocators reaching
the limit for the target reclaim case.  To make it even more complicated,
targeted reclaim doesn't do the whole tree walk because it stops
reclaiming once it reclaims sufficient pages.  As a result groups over the
limit might be missed, thus nothing is scanned, and reclaim would fall
back to the reclaim all mode.

This patch checks for the incomplete tree walk in shrink_zone.  If no
group has been visited and the hierarchy is soft reclaimable then we must
have missed some groups, in which case the __shrink_zone is called again. 
This doesn't guarantee there will be some progress of course because the
current reclaimer might be still racing with others but it would at least
give a chance to start the walk without a big risk of reclaim latencies.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Glauber Costa <glommer@openvz.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN mm/vmscan.c~memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly mm/vmscan.c
--- a/mm/vmscan.c~memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly
+++ a/mm/vmscan.c
@@ -2123,10 +2123,11 @@ static inline bool should_continue_recla
 	}
 }
 
-static void
+static int
 __shrink_zone(struct zone *zone, struct scan_control *sc, bool soft_reclaim)
 {
 	unsigned long nr_reclaimed, nr_scanned;
+	int groups_scanned = 0;
 
 	do {
 		struct mem_cgroup *root = sc->target_mem_cgroup;
@@ -2144,6 +2145,7 @@ __shrink_zone(struct zone *zone, struct
 		while ((memcg = mem_cgroup_iter_cond(root, memcg, &reclaim, filter))) {
 			struct lruvec *lruvec;
 
+			groups_scanned++;
 			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 
 			shrink_lruvec(lruvec, sc);
@@ -2171,6 +2173,8 @@ __shrink_zone(struct zone *zone, struct
 
 	} while (should_continue_reclaim(zone, sc->nr_reclaimed - nr_reclaimed,
 					 sc->nr_scanned - nr_scanned, sc));
+
+	return groups_scanned;
 }
 
 
@@ -2178,8 +2182,19 @@ static void shrink_zone(struct zone *zon
 {
 	bool do_soft_reclaim = mem_cgroup_should_soft_reclaim(sc);
 	unsigned long nr_scanned = sc->nr_scanned;
+	int scanned_groups;
 
-	__shrink_zone(zone, sc, do_soft_reclaim);
+	scanned_groups = __shrink_zone(zone, sc, do_soft_reclaim);
+	/*
+         * memcg iterator might race with other reclaimer or start from
+         * a incomplete tree walk so the tree walk in __shrink_zone
+         * might have missed groups that are above the soft limit. Try
+         * another loop to catch up with others. Do it just once to
+         * prevent from reclaim latencies when other reclaimers always
+         * preempt this one.
+	 */
+	if (do_soft_reclaim && !scanned_groups)
+		__shrink_zone(zone, sc, do_soft_reclaim);
 
 	/*
 	 * No group is over the soft limit or those that are do not have
_

Patches currently in -mm which might be from mhocko@suse.cz are

vmpressure-change-vmpressure-sr_lock-to-spinlock.patch
vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined-checkpatch-fixes.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
watchdog-update-watchdog-attributes-atomically.patch
watchdog-update-watchdog_tresh-properly.patch
mm-fix-potential-null-pointer-dereference.patch
mm-hugetlb-move-up-the-code-which-check-availability-of-free-huge-page.patch
mm-hugetlb-trivial-commenting-fix.patch
mm-hugetlb-clean-up-alloc_huge_page.patch
mm-hugetlb-fix-and-clean-up-node-iteration-code-to-alloc-or-free.patch
mm-hugetlb-remove-redundant-list_empty-check-in-gather_surplus_pages.patch
mm-hugetlb-do-not-use-a-page-in-page-cache-for-cow-optimization.patch
mm-hugetlb-add-vm_noreserve-check-in-vma_has_reserves.patch
mm-hugetlb-remove-decrement_hugepage_resv_vma.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
memcg-remove-redundant-code-in-mem_cgroup_force_empty_write.patch
memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
memcg-get-rid-of-soft-limit-tree-infrastructure.patch
vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
memcg-enhance-memcg-iterator-to-support-predicates.patch
memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
memcg-track-all-children-over-limit-in-the-root.patch
memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
memcg-trivial-cleanups.patch
linux-next.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch

