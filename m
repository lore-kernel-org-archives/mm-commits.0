From: akpm@linux-foundation.org
Subject: [merged] memcg-swap-use-mem_cgroup_uncharge_swap.patch removed from -mm tree
Date: Thu, 31 May 2012 12:16:46 -0700
Message-ID: <20120531191646.5C486A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41498 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955Ab2EaTQr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:16:47 -0400
Received: by qabg24 with SMTP id g24so154350qab.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:16:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg swap: use mem_cgroup_uncharge_swap()
has been removed from the -mm tree.  Its filename was
     memcg-swap-use-mem_cgroup_uncharge_swap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg swap: use mem_cgroup_uncharge_swap()

That stuff __mem_cgroup_commit_charge_swapin() does with a swap entry, it
has a name and even a declaration: just use mem_cgroup_uncharge_swap().

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff -puN mm/memcontrol.c~memcg-swap-use-mem_cgroup_uncharge_swap mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-swap-use-mem_cgroup_uncharge_swap
+++ a/mm/memcontrol.c
@@ -2855,24 +2855,7 @@ __mem_cgroup_commit_charge_swapin(struct
 	 */
 	if (do_swap_account && PageSwapCache(page)) {
 		swp_entry_t ent = {.val = page_private(page)};
-		struct mem_cgroup *swap_memcg;
-		unsigned short id;
-
-		id = swap_cgroup_record(ent, 0);
-		rcu_read_lock();
-		swap_memcg = mem_cgroup_lookup(id);
-		if (swap_memcg) {
-			/*
-			 * This recorded memcg can be obsolete one. So, avoid
-			 * calling css_tryget
-			 */
-			if (!mem_cgroup_is_root(swap_memcg))
-				res_counter_uncharge(&swap_memcg->memsw,
-						     PAGE_SIZE);
-			mem_cgroup_swap_statistics(swap_memcg, false);
-			mem_cgroup_put(swap_memcg);
-		}
-		rcu_read_unlock();
+		mem_cgroup_uncharge_swap(ent);
 	}
 	/*
 	 * At swapin, we may charge account against cgroup which has no tasks.
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
prio_tree-debugging-patch.patch

