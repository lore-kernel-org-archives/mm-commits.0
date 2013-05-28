From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcg-remove-incorrect-vm_bug_on-for-swap-cache-pages-in-uncharge.patch
 removed from -mm tree
Date: Tue, 28 May 2013 12:36:47 -0700
Message-ID: <51a5074f.wWEf4n8SLSRo7WJw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab3E1Tgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:36:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, mhocko@suse.cz, lxiang@redhat.com, hughd@google.com, heiko.carstens@de.ibm.com, hannes@cmpxchg.org

Subject: [merged] mm-memcg-remove-incorrect-vm_bug_on-for-swap-cache-pages-in-uncharge.patch removed from -mm tree
To: hannes@cmpxchg.org,heiko.carstens@de.ibm.com,hughd@google.com,lxiang@redhat.com,mhocko@suse.cz,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:36:47 -0700


The patch titled
     Subject: mm: memcg: remove incorrect VM_BUG_ON for swap cache pages in uncharge
has been removed from the -mm tree.  Its filename was
     mm-memcg-remove-incorrect-vm_bug_on-for-swap-cache-pages-in-uncharge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: remove incorrect VM_BUG_ON for swap cache pages in uncharge

0c59b89 ("mm: memcg: push down PageSwapCache check into uncharge entry
functions") added a VM_BUG_ON() on PageSwapCache in the uncharge path
after checking that page flag once, assuming that the state is stable in
all paths, but this is not the case and the condition triggers in user
environments.  An uncharge after the last page table reference to the page
goes away can race with reclaim adding the page to swap cache.

Swap cache pages are usually uncharged when they are freed after swapout,
from a path that also handles swap usage accounting and memcg lifetime
management.  However, since the last page table reference is gone and thus
no references to the swap slot left, the swap slot will be freed shortly
when reclaim attempts to write the page to disk.  The whole swap
accounting is not even necessary.

So while the race condition for which this VM_BUG_ON was added is real and
actually existed all along, there are no negative effects.  Remove the
VM_BUG_ON again.

Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reported-by: Lingzhu Xiang <lxiang@redhat.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: <stable@vger.kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-remove-incorrect-vm_bug_on-for-swap-cache-pages-in-uncharge mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-remove-incorrect-vm_bug_on-for-swap-cache-pages-in-uncharge
+++ a/mm/memcontrol.c
@@ -4108,8 +4108,6 @@ __mem_cgroup_uncharge_common(struct page
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	VM_BUG_ON(PageSwapCache(page));
-
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
 		VM_BUG_ON(!PageTransHuge(page));
@@ -4205,6 +4203,18 @@ void mem_cgroup_uncharge_page(struct pag
 	if (page_mapped(page))
 		return;
 	VM_BUG_ON(page->mapping && !PageAnon(page));
+	/*
+	 * If the page is in swap cache, uncharge should be deferred
+	 * to the swap path, which also properly accounts swap usage
+	 * and handles memcg lifetime.
+	 *
+	 * Note that this check is not stable and reclaim may add the
+	 * page to swap cache at any time after this.  However, if the
+	 * page is not in swap cache by the time page->mapcount hits
+	 * 0, there won't be any page table references to the swap
+	 * slot, and reclaim will free it and not actually write the
+	 * page to disk.
+	 */
 	if (PageSwapCache(page))
 		return;
 	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_ANON, false);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcg-dont-take-task_lock-in-task_in_mem_cgroup.patch
mm-vmscan-limit-the-number-of-pages-kswapd-reclaims-at-each-priority.patch
mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch
mm-vmscan-flatten-kswapd-priority-loop.patch
mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch
mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch
mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
memcg-update-todo-list-in-documentation.patch
mm-memmap_init_zone-performance-improvement.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch

