From: akpm@linux-foundation.org
Subject: [merged]
 vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work.patch
 removed from -mm tree
Date: Mon, 05 Aug 2013 12:06:06 -0700
Message-ID: <51fff79e.NcykUI31ox7Psu9k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3HETGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 15:06:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, anton.vorontsov@linaro.org, mhocko@suse.cz

Subject: [merged] vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work.patch removed from -mm tree
To: mhocko@suse.cz,anton.vorontsov@linaro.org,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,lizefan@huawei.com,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 12:06:06 -0700


The patch titled
     Subject: vmpressure: do not check for pending work to prevent from new work
has been removed from the -mm tree.  Its filename was
     vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: vmpressure: do not check for pending work to prevent from new work

because it is racy and it doesn't give us much anyway as schedule_work
handles this case already.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Tejun Heo <tj@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizefan@huawei.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmpressure.c~vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work mm/vmpressure.c
--- a/mm/vmpressure.c~vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work
+++ a/mm/vmpressure.c
@@ -246,7 +246,7 @@ void vmpressure(gfp_t gfp, struct mem_cg
 	scanned = vmpr->scanned;
 	spin_unlock(&vmpr->sr_lock);
 
-	if (scanned < vmpressure_win || work_pending(&vmpr->work))
+	if (scanned < vmpressure_win)
 		return;
 	schedule_work(&vmpr->work);
 }
_

Patches currently in -mm which might be from mhocko@suse.cz are

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

