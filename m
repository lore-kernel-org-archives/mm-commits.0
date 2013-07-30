From: akpm@linux-foundation.org
Subject: +
 memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch added to -mm tree
Date: Tue, 30 Jul 2013 15:33:59 -0700
Message-ID: <51f83f57.7S3LOdyGI7zXvNd6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977Ab3G3WeA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jul 2013 18:34:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghan@google.com, walken@google.com, tj@kernel.org, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, hannes@cmpxchg.org, gthelen@google.com, glommer@openvz.org, bsingharora@gmail.com, mhocko@suse.cz

Subject: + memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch added to -mm tree
To: mhocko@suse.cz,bsingharora@gmail.com,glommer@openvz.org,gthelen@google.com,hannes@cmpxchg.org,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,tj@kernel.org,walken@google.com,yinghan@google.com
From: akpm@linux-foundation.org
Date: Tue, 30 Jul 2013 15:33:59 -0700


The patch titled
     Subject: memcg, vmscan: do not attempt soft limit reclaim if it would not scan anything
has been added to the -mm tree.  Its filename is
     memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch

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
Subject: memcg, vmscan: do not attempt soft limit reclaim if it would not scan anything

mem_cgroup_should_soft_reclaim controls whether soft reclaim pass is done
and it always says yes currently.  Memcg iterators are clever to skip
nodes that are not soft reclaimable quite efficiently but
mem_cgroup_should_soft_reclaim can be more clever and do not start the
soft reclaim pass at all if it knows that nothing would be scanned anyway.

In order to do that, simply reuse mem_cgroup_soft_reclaim_eligible for the
target group of the reclaim and allow the pass only if the whole subtree
wouldn't be skipped.

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

 mm/memcontrol.c |    6 +++++-
 mm/vmscan.c     |    4 +++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything
+++ a/mm/memcontrol.c
@@ -1909,7 +1909,11 @@ enum mem_cgroup_filter_t
 mem_cgroup_soft_reclaim_eligible(struct mem_cgroup *memcg,
 		struct mem_cgroup *root)
 {
-	struct mem_cgroup *parent = memcg;
+	struct mem_cgroup *parent;
+
+	if (!memcg)
+		memcg = root_mem_cgroup;
+	parent = memcg;
 
 	if (res_counter_soft_limit_excess(&memcg->res))
 		return VISIT;
diff -puN mm/vmscan.c~memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything mm/vmscan.c
--- a/mm/vmscan.c~memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything
+++ a/mm/vmscan.c
@@ -142,7 +142,9 @@ static bool global_reclaim(struct scan_c
 
 static bool mem_cgroup_should_soft_reclaim(struct scan_control *sc)
 {
-	return !mem_cgroup_disabled();
+	struct mem_cgroup *root = sc->target_mem_cgroup;
+	return !mem_cgroup_disabled() &&
+		mem_cgroup_soft_reclaim_eligible(root, root) != SKIP_TREE;
 }
 #else
 static bool global_reclaim(struct scan_control *sc)
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

