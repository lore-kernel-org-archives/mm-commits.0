From: akpm@linux-foundation.org
Subject: [merged] memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch removed from -mm tree
Date: Thu, 31 May 2012 12:16:43 -0700
Message-ID: <20120531191643.75BCFA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:53963 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955Ab2EaTQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:16:44 -0400
Received: by yenl3 with SMTP id l3so138044yen.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:16:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg swap: mem_cgroup_move_swap_account never needs fixup
has been removed from the -mm tree.  Its filename was
     memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg swap: mem_cgroup_move_swap_account never needs fixup

The need_fixup arg to mem_cgroup_move_swap_account() is always false,
so just remove it.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff -puN mm/memcontrol.c~memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup
+++ a/mm/memcontrol.c
@@ -3165,7 +3165,6 @@ void mem_cgroup_uncharge_swap(swp_entry_
  * @entry: swap entry to be moved
  * @from:  mem_cgroup which the entry is moved from
  * @to:  mem_cgroup which the entry is moved to
- * @need_fixup: whether we should fixup res_counters and refcounts.
  *
  * It succeeds only when the swap_cgroup's record for this entry is the same
  * as the mem_cgroup's id of @from.
@@ -3176,7 +3175,7 @@ void mem_cgroup_uncharge_swap(swp_entry_
  * both res and memsw, and called css_get().
  */
 static int mem_cgroup_move_swap_account(swp_entry_t entry,
-		struct mem_cgroup *from, struct mem_cgroup *to, bool need_fixup)
+				struct mem_cgroup *from, struct mem_cgroup *to)
 {
 	unsigned short old_id, new_id;
 
@@ -3195,24 +3194,13 @@ static int mem_cgroup_move_swap_account(
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
@@ -5546,8 +5534,7 @@ put:			/* get_mctgt_type() gets the page
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

