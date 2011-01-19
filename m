From: akpm@linux-foundation.org
Subject: + memcg-correctly-order-reading-pcg_used-and-pc-mem_cgroup.patch added to -mm tree
Date: Wed, 19 Jan 2011 12:05:21 -0800
Message-ID: <201101192005.p0JK5LEd032581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671Ab1ASUGN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 15:06:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: correctly order reading PCG_USED and pc->mem_cgroup
has been added to the -mm tree.  Its filename is
     memcg-correctly-order-reading-pcg_used-and-pc-mem_cgroup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: correctly order reading PCG_USED and pc->mem_cgroup
From: Johannes Weiner <hannes@cmpxchg.org>

The placement of the read-side barrier is confused: the writer first
sets pc->mem_cgroup, then PCG_USED.  The read-side barrier has to be
between testing PCG_USED and reading pc->mem_cgroup.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff -puN mm/memcontrol.c~memcg-correctly-order-reading-pcg_used-and-pc-mem_cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-correctly-order-reading-pcg_used-and-pc-mem_cgroup
+++ a/mm/memcontrol.c
@@ -836,13 +836,12 @@ void mem_cgroup_rotate_lru_list(struct p
 		return;
 
 	pc = lookup_page_cgroup(page);
-	/*
-	 * Used bit is set without atomic ops but after smp_wmb().
-	 * For making pc->mem_cgroup visible, insert smp_rmb() here.
-	 */
-	smp_rmb();
 	/* unused or root page is not rotated. */
-	if (!PageCgroupUsed(pc) || mem_cgroup_is_root(pc->mem_cgroup))
+	if (!PageCgroupUsed(pc))
+		return;
+	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
+	smp_rmb();
+	if (mem_cgroup_is_root(pc->mem_cgroup))
 		return;
 	mz = page_cgroup_zoneinfo(pc);
 	list_move(&pc->lru, &mz->lists[lru]);
@@ -857,14 +856,10 @@ void mem_cgroup_add_lru_list(struct page
 		return;
 	pc = lookup_page_cgroup(page);
 	VM_BUG_ON(PageCgroupAcctLRU(pc));
-	/*
-	 * Used bit is set without atomic ops but after smp_wmb().
-	 * For making pc->mem_cgroup visible, insert smp_rmb() here.
-	 */
-	smp_rmb();
 	if (!PageCgroupUsed(pc))
 		return;
-
+	/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
+	smp_rmb();
 	mz = page_cgroup_zoneinfo(pc);
 	MEM_CGROUP_ZSTAT(mz, lru) += 1;
 	SetPageCgroupAcctLRU(pc);
@@ -1030,14 +1025,10 @@ mem_cgroup_get_reclaim_stat_from_page(st
 		return NULL;
 
 	pc = lookup_page_cgroup(page);
-	/*
-	 * Used bit is set without atomic ops but after smp_wmb().
-	 * For making pc->mem_cgroup visible, insert smp_rmb() here.
-	 */
-	smp_rmb();
 	if (!PageCgroupUsed(pc))
 		return NULL;
