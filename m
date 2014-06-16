From: akpm@linux-foundation.org
Subject: [withdrawn]
 vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch removed
 from -mm tree
Date: Mon, 16 Jun 2014 15:35:11 -0700
Message-ID: <539f711f.arr+8MfQrUt6pCya%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910AbaFPWfM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 18:35:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz


The patch titled
     Subject: vmscan: memcg: check whether the low limit should be ignored
has been removed from the -mm tree.  Its filename was
     vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: vmscan: memcg: check whether the low limit should be ignored

Low-limit (aka guarantee) is ignored when there is no group scanned during
the first round of __shink_zone.  This approach doesn't work when multiple
reclaimers race and reclaim the same hierarchy (e.g.  kswapd vs.  direct
reclaim or multiple tasks hitting the hard limit) because memcg iterator
makes sure that multiple reclaimers are interleaved in the hierarchy. 
This means that some reclaimers can see 0 scanned groups although there
are groups which are above the low-limit and they were reclaimed on behalf
of other reclaimers.  This leads to a premature low-limit break.

This patch adds mem_cgroup_all_within_guarantee() which will check whether
all the groups in the reclaimed hierarchy are within their low limit and
shrink_zone will allow the fallback reclaim only when that is true.  This
alone is still not sufficient however because it would lead to another
problem.  If a reclaimer constantly fails to scan anything because it sees
only groups within their guarantees while others do the reclaim then the
reclaim priority would drop down very quickly.  shrink_zone has to be
careful to preserve scan at least one group semantic so __shrink_zone has
to be retried until at least one group is scanned.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <klamm@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++++
 mm/memcontrol.c            |   13 +++++++++++++
 mm/vmscan.c                |   17 ++++++++++++-----
 3 files changed, 30 insertions(+), 5 deletions(-)

diff -puN include/linux/memcontrol.h~vmscan-memcg-check-whether-the-low-limit-should-be-ignored include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~vmscan-memcg-check-whether-the-low-limit-should-be-ignored
+++ a/include/linux/memcontrol.h
@@ -94,6 +94,7 @@ bool task_in_mem_cgroup(struct task_stru
 
 extern bool mem_cgroup_within_guarantee(struct mem_cgroup *memcg,
 		struct mem_cgroup *root);
+extern bool mem_cgroup_all_within_guarantee(struct mem_cgroup *root);
 
 extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
@@ -296,6 +297,10 @@ static inline bool mem_cgroup_within_gua
 {
 	return false;
 }
+static inline bool mem_cgroup_all_within_guarantee(struct mem_cgroup *root)
+{
+	return false;
+}
 
 static inline struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 {
diff -puN mm/memcontrol.c~vmscan-memcg-check-whether-the-low-limit-should-be-ignored mm/memcontrol.c
--- a/mm/memcontrol.c~vmscan-memcg-check-whether-the-low-limit-should-be-ignored
+++ a/mm/memcontrol.c
@@ -2807,6 +2807,19 @@ bool mem_cgroup_within_guarantee(struct
 	return false;
 }
 
+bool mem_cgroup_all_within_guarantee(struct mem_cgroup *root)
+{
+	struct mem_cgroup *iter;
+
+	for_each_mem_cgroup_tree(iter, root)
+		if (!mem_cgroup_within_guarantee(iter, root)) {
+			mem_cgroup_iter_break(root, iter);
+			return false;
+		}
+
+	return true;
+}
+
 struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
 {
 	struct mem_cgroup *memcg = NULL;
diff -puN mm/vmscan.c~vmscan-memcg-check-whether-the-low-limit-should-be-ignored mm/vmscan.c
--- a/mm/vmscan.c~vmscan-memcg-check-whether-the-low-limit-should-be-ignored
+++ a/mm/vmscan.c
@@ -2310,13 +2310,20 @@ static unsigned __shrink_zone(struct zon
 
 static void shrink_zone(struct zone *zone, struct scan_control *sc)
 {
-	if (!__shrink_zone(zone, sc, true)) {
+	bool honor_guarantee = true;
+
+	while (!__shrink_zone(zone, sc, honor_guarantee)) {
 		/*
-		 * First round of reclaim didn't find anything to reclaim
-		 * because of the memory guantees for all memcgs in the
-		 * reclaim target so try again and ignore guarantees this time.
+		 * The previous round of reclaim didn't find anything to scan
+		 * because
+		 * a) the whole reclaimed hierarchy is within guarantee so
+		 *    we fallback to ignore the guarantee because other option
+		 *    would be the OOM
+		 * b) multiple reclaimers are racing and so the first round
+		 *    should be retried
 		 */
-		__shrink_zone(zone, sc, false);
+		if (mem_cgroup_all_within_guarantee(sc->target_mem_cgroup))
+			honor_guarantee = false;
 	}
 }
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-vmscanc-avoid-recording-the-original-scan-targets-in-shrink_lruvec.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch
madvise-cleanup-swapin_walk_pmd_entry.patch
memcg-separate-mem_cgroup_move_charge_pte_range.patch
arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
mincore-apply-page-table-walker-on-do_mincore.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch

