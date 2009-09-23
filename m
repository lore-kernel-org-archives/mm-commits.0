From: akpm@linux-foundation.org
Subject: [folded] memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:29:24 -0700
Message-ID: <200909232229.n8NMTOC3017028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194AbZIWW3d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:29:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2
has been removed from the -mm tree.  Its filename was
     memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch

This patch was dropped because it was folded into memcg-remove-the-overhead-associated-with-the-root-cgroup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Fix an incorrect condition in memcg lru manipulation

The PageAcctLRU bit itself does not mean a lot without checking
if the mem cgroup is the same as the root cgroup. This patch
fixes a left over from the previous versions.

Reported-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2
+++ a/mm/memcontrol.c
@@ -414,7 +414,7 @@ void mem_cgroup_rotate_lru_list(struct p
 	 */
 	smp_rmb();
 	/* unused or root page is not rotated. */
-	if (!PageCgroupUsed(pc) || PageCgroupAcctLRU(pc))
+	if (!PageCgroupUsed(pc) || mem_cgroup_is_root(pc->mem_cgroup))
 		return;
 	mz = page_cgroup_zoneinfo(pc);
 	list_move(&pc->lru, &mz->lists[lru]);
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
cgroups-make-unlock-sequence-in-cgroup_get_sb-consistent.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-checkpatch-fixes.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch

