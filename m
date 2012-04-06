From: akpm@linux-foundation.org
Subject: [merged] memcg-swap-use-mem_cgroup_uncharge_swap-fix.patch removed from -mm tree
Date: Fri, 06 Apr 2012 11:49:13 -0700
Message-ID: <20120406184913.6F7B2A0443@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:60946 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2DFStP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 14:49:15 -0400
Received: by wibhj13 with SMTP id hj13so42002wib.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 11:49:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, hannes@cmpxchg.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg swap: use mem_cgroup_uncharge_swap fix
has been removed from the -mm tree.  Its filename was
     memcg-swap-use-mem_cgroup_uncharge_swap-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg swap: use mem_cgroup_uncharge_swap fix

Although mem_cgroup_uncharge_swap has an empty placeholder for
!CONFIG_CGROUP_MEM_RES_CTLR_SWAP the definition is placed in the
CONFIG_SWAP ifdef block so we are missing the same definition for
!CONFIG_SWAP which implies !CONFIG_CGROUP_MEM_RES_CTLR_SWAP.

This was not an issue until "memcg swap: use mem_cgroup_uncharge_swap()"
because mem_cgroup_uncharge_swap was not called from !CONFIG_SWAP context
but now we are calling it from __mem_cgroup_commit_charge_swapin which is
defined also for !CONFIG_SWAP.

Let's move both the empty definition and declaration outside of the
CONFIG_SWAP block to fix the following compilation error:

mm/memcontrol.c: In function '__mem_cgroup_commit_charge_swapin':
mm/memcontrol.c:2837: error: implicit declaration of function 'mem_cgroup_uncharge_swap'

if CONFIG_SWAP is disabled.

Reported-by: David Rientjes <rientjes@google.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/swap.h~memcg-swap-use-mem_cgroup_uncharge_swap-fix include/linux/swap.h
--- a/include/linux/swap.h~memcg-swap-use-mem_cgroup_uncharge_swap-fix
+++ a/include/linux/swap.h
@@ -305,6 +305,13 @@ static inline int mem_cgroup_swappiness(
 	return vm_swappiness;
 }
 #endif
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+extern void mem_cgroup_uncharge_swap(swp_entry_t ent);
+#else
+static inline void mem_cgroup_uncharge_swap(swp_entry_t ent)
+{
+}
+#endif
 #ifdef CONFIG_SWAP
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
@@ -375,13 +382,6 @@ mem_cgroup_uncharge_swapcache(struct pag
 {
 }
 #endif
-#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
-extern void mem_cgroup_uncharge_swap(swp_entry_t ent);
-#else
-static inline void mem_cgroup_uncharge_swap(swp_entry_t ent)
-{
-}
-#endif
 
 #else /* CONFIG_SWAP */
 
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
memcg-fix-up-documentation-on-global-lru.patch
memcg-fix-broken-boolen-expression.patch
memcg-do-not-open-code-accesses-to-res_counter-members.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
memcg-mark-more-functions-variables-as-static.patch
memcg-remove-unused-variable.patch
memcg-mark-stat-field-of-mem_cgroup-struct-as-__percpu.patch
memcg-remove-redundant-parentheses.patch
memcg-make-threshold-index-in-the-right-position.patch
memcg-revise-the-position-of-threshold-index-while-unregistering-event.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch

