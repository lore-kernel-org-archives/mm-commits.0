From: akpm@linux-foundation.org
Subject: [folded] memcg-improve-performance-in-moving-swap-charge-fix.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:55:38 -0800
Message-ID: <201003102255.o2AMtd7n008773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757394Ab0CJW4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:56:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     memcg-improve-performance-in-moving-swap-charge-fix
has been removed from the -mm tree.  Its filename was
     memcg-improve-performance-in-moving-swap-charge-fix.patch

This patch was dropped because it was folded into memcg-improve-performance-in-moving-swap-charge.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-improve-performance-in-moving-swap-charge-fix
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

build fix in !CONFIG_CGROUP_MEM_RES_CTLR_SWAP case.

  CC      mm/memcontrol.o
mm/memcontrol.c: In function 'mem_cgroup_move_charge_pte_range':
mm/memcontrol.c:3899: error: too many arguments to function 'mem_cgroup_move_swap_account'
mm/memcontrol.c:3899: error: too many arguments to function 'mem_cgroup_move_swap_account'
mm/memcontrol.c:3899: error: too many arguments to function 'mem_cgroup_move_swap_account'
make[1]: *** [mm/memcontrol.o] Error 1
make: *** [mm] Error 2

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-improve-performance-in-moving-swap-charge-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-improve-performance-in-moving-swap-charge-fix
+++ a/mm/memcontrol.c
@@ -2327,7 +2327,7 @@ static int mem_cgroup_move_swap_account(
 }
 #else
 static inline int mem_cgroup_move_swap_account(swp_entry_t entry,
-				struct mem_cgroup *from, struct mem_cgroup *to)
+		struct mem_cgroup *from, struct mem_cgroup *to, bool need_fixup)
 {
 	return -EINVAL;
 }
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-use-generic-percpu-instead-of-private-implementation.patch
memcg-update-threshold-and-softlimit-at-commit-v2.patch
memcg-share-event-counter-rather-than-duplicate-v2.patch
memcg-update-memcg_testtxt.patch
memcg-handle-panic_on_oom=always-case-v2.patch
cgroups-fix-race-between-userspace-and-kernelspace.patch
cgroups-remove-events-before-destroying-subsystem-state-objects.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch
cgroups-add-simple-listener-of-cgroup-events-to-documentation-fix.patch
memcg-update-memcg_testtxt-to-describe-memory-thresholds.patch
memcg-fix-oom-kill-behavior-v3.patch
memcg-fix-oom-kill-behavior-v4.patch
memcg-update-maintainer-list.patch

