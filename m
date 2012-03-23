From: akpm@linux-foundation.org
Subject: + memcg-swap-use-mem_cgroup_uncharge_swap.patch added to -mm tree
Date: Fri, 23 Mar 2012 14:09:39 -0700
Message-ID: <20120323210939.D30CAA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:55246 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2CWVJl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:09:41 -0400
Received: by vbnl22 with SMTP id l22so299686vbn.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:09:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp


The patch titled
     Subject: memcg swap: use mem_cgroup_uncharge_swap()
has been added to the -mm tree.  Its filename is
     memcg-swap-use-mem_cgroup_uncharge_swap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg swap: use mem_cgroup_uncharge_swap()

That stuff __mem_cgroup_commit_charge_swapin() does with a swap entry, it
has a name and even a declaration: just use mem_cgroup_uncharge_swap().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff -puN mm/memcontrol.c~memcg-swap-use-mem_cgroup_uncharge_swap mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-swap-use-mem_cgroup_uncharge_swap
+++ a/mm/memcontrol.c
@@ -2850,24 +2850,7 @@ __mem_cgroup_commit_charge_swapin(struct
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
Subject: Subject: memcg swap: use mem_cgroup_uncharge_swap()

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
linux-next.patch
mm-for-fs-add-truncate_pagecache_range.patch
mm-for-fs-add-truncate_pagecache_range-fix.patch
memcg-change-behavior-of-moving-charges-at-task-move.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
radix-tree-introduce-bit-optimized-iterator.patch
radix-tree-introduce-bit-optimized-iterator-v3.patch
radix-tree-introduce-bit-optimized-iterator-v3-fix.patch
radix-tree-rewrite-gang-lookup-with-using-iterator.patch
radix-tree-use-iterators-in-find_get_pages-functions.patch
prio_tree-debugging-patch.patch

