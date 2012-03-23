From: akpm@linux-foundation.org
Subject: + memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch added to -mm tree
Date: Fri, 23 Mar 2012 14:09:37 -0700
Message-ID: <20120323210938.54511A00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:39019 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2CWVJl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:09:41 -0400
Received: by bkcjm19 with SMTP id jm19so187795bkc.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:09:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp


The patch titled
     Subject: memcg swap: mem_cgroup_move_swap_account never needs fixup
has been added to the -mm tree.  Its filename is
     memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch

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
Subject: memcg swap: mem_cgroup_move_swap_account never needs fixup

The need_fixup arg to mem_cgroup_move_swap_account() is always false,
so just remove it.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff -puN mm/memcontrol.c~memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup
+++ a/mm/memcontrol.c
@@ -3160,7 +3160,6 @@ void mem_cgroup_uncharge_swap(swp_entry_
  * @entry: swap entry to be moved
  * @from:  mem_cgroup which the entry is moved from
  * @to:  mem_cgroup which the entry is moved to
- * @need_fixup: whether we should fixup res_counters and refcounts.
  *
  * It succeeds only when the swap_cgroup's record for this entry is the same
  * as the mem_cgroup's id of @from.
@@ -3171,7 +3170,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
  * both res and memsw, and called css_get().
  */
 static int mem_cgroup_move_swap_account(swp_entry_t entry,
-		struct mem_cgroup *from, struct mem_cgroup *to, bool need_fixup)
+				struct mem_cgroup *from, struct mem_cgroup *to)
 {
 	unsigned short old_id, new_id;
 
@@ -3190,24 +3189,13 @@ static int mem_cgroup_move_swap_account(
 		 * swap-in, the refcount of @to might be decreased to 0.
 		 */
 		mem_cgroup_get(to);
-		if (need_fixup) {
-			if (!mem_cgroup_is_root(from))
-				res_counter_uncharge(&from->memsw, PAGE_SIZE);
-			mem_cgroup_put(from);
-			/*
-			 * we charged both to->res and to->memsw, so we should
-			 * uncharge to->res.
-			 */
-			if (!mem_cgroup_is_root(to))
-				res_counter_uncharge(&to->res, PAGE_SIZE);
-		}
 		return 0;
 	}
 	return -EINVAL;
 }
 #else
 static inline int mem_cgroup_move_swap_account(swp_entry_t entry,
-		struct mem_cgroup *from, struct mem_cgroup *to, bool need_fixup)
+				struct mem_cgroup *from, struct mem_cgroup *to)
 {
 	return -EINVAL;
 }
@@ -5529,8 +5517,7 @@ put:			/* get_mctgt_type() gets the page
 			break;
 		case MC_TARGET_SWAP:
 			ent = target.ent;
-			if (!mem_cgroup_move_swap_account(ent,
-						mc.from, mc.to, false)) {
+			if (!mem_cgroup_move_swap_account(ent, mc.from, mc.to)) {
 				mc.precharge--;
 				/* we fixup refcnts and charges later. */
 				mc.moved_swap++;
_
Subject: Subject: memcg swap: mem_cgroup_move_swap_account never needs fixup

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

