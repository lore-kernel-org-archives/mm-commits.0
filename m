From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch removed
 from -mm tree
Date: Thu, 21 Jan 2016 15:29:59 -0800
Message-ID: <56a169f7.50+RtbF5j5b9dDQ8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcAUXaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jan 2016 18:30:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: do not scan anon pages if memcg swap limit is hit
has been removed from the -mm tree.  Its filename was
     mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: vmscan: do not scan anon pages if memcg swap limit is hit

We don't scan anonymous memory if we ran out of swap, neither should we do
it in case memcg swap limit is hit, because swap out is impossible anyway.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    6 ++++++
 mm/memcontrol.c      |   13 +++++++++++++
 mm/vmscan.c          |    2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff -puN include/linux/swap.h~mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit include/linux/swap.h
--- a/include/linux/swap.h~mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit
+++ a/include/linux/swap.h
@@ -551,6 +551,7 @@ static inline int mem_cgroup_swappiness(
 extern void mem_cgroup_swapout(struct page *page, swp_entry_t entry);
 extern int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry);
 extern void mem_cgroup_uncharge_swap(swp_entry_t entry);
+extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 #else
 static inline void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 {
@@ -565,6 +566,11 @@ static inline int mem_cgroup_try_charge_
 static inline void mem_cgroup_uncharge_swap(swp_entry_t entry)
 {
 }
+
+static inline long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
+{
+	return get_nr_swap_pages();
+}
 #endif
 
 #endif /* __KERNEL__*/
diff -puN mm/memcontrol.c~mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit mm/memcontrol.c
--- a/mm/memcontrol.c~mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit
+++ a/mm/memcontrol.c
@@ -5748,6 +5748,19 @@ void mem_cgroup_uncharge_swap(swp_entry_
 	rcu_read_unlock();
 }
 
+long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
+{
+	long nr_swap_pages = get_nr_swap_pages();
+
+	if (!do_swap_account || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return nr_swap_pages;
+	for (; memcg != root_mem_cgroup; memcg = parent_mem_cgroup(memcg))
+		nr_swap_pages = min_t(long, nr_swap_pages,
+				      READ_ONCE(memcg->swap.limit) -
+				      page_counter_read(&memcg->swap));
+	return nr_swap_pages;
+}
+
 /* for remember boot option*/
 #ifdef CONFIG_MEMCG_SWAP_ENABLED
 static int really_do_swap_account __initdata = 1;
diff -puN mm/vmscan.c~mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit
+++ a/mm/vmscan.c
@@ -2004,7 +2004,7 @@ static void get_scan_count(struct lruvec
 		force_scan = true;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
-	if (!sc->may_swap || (get_nr_swap_pages() <= 0)) {
+	if (!sc->may_swap || mem_cgroup_get_nr_swap_pages(memcg) <= 0) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are


