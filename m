From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch added to
 -mm tree
Date: Thu, 17 Dec 2015 13:59:53 -0800
Message-ID: <56733059.46hfwanD2hhZ8B+j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932828AbbLQV7y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Dec 2015 16:59:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: do not scan anon pages if memcg swap limit is hit
has been added to the -mm tree.  Its filename is
     mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -552,6 +552,7 @@ static inline int mem_cgroup_swappiness(
 extern void mem_cgroup_swapout(struct page *page, swp_entry_t entry);
 extern int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry);
 extern void mem_cgroup_uncharge_swap(swp_entry_t entry);
+extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
 #else
 static inline void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 {
@@ -566,6 +567,11 @@ static inline int mem_cgroup_try_charge_
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
@@ -5733,6 +5733,19 @@ void mem_cgroup_uncharge_swap(swp_entry_
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

revert-kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
revert-gfp-add-__gfp_noaccount.patch
memcg-only-account-kmem-allocations-marked-as-__gfp_account.patch
slab-add-slab_account-flag.patch
vmalloc-allow-to-account-vmalloc-to-memcg.patch
account-certain-kmem-allocations-to-memcg.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small.patch
vmscan-do-not-force-scan-file-lru-if-its-absolute-size-is-small-v2.patch
memcg-do-not-allow-to-disable-tcp-accounting-after-limit-is-set.patch
mm-add-page_check_address_transhuge-helper.patch
mm-add-page_check_address_transhuge-helper-fix.patch
mm-memcontrol-allow-to-disable-kmem-accounting-for-cgroup2.patch
net-drop-tcp_memcontrolc.patch
mm-memcontrol-charge-swap-to-cgroup2.patch
mm-vmscan-pass-memcg-to-get_scan_count.patch
mm-memcontrol-replace-mem_cgroup_lruvec_online-with-mem_cgroup_online.patch
swaph-move-memcg-related-stuff-to-the-end-of-the-file.patch
mm-vmscan-do-not-scan-anon-pages-if-memcg-swap-limit-is-hit.patch
mm-free-swap-cache-aggressively-if-memcg-swap-is-full.patch
documentation-cgroup-add-memoryswapcurrentmax-description.patch

