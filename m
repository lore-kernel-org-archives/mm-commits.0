From: akpm@linux-foundation.org
Subject: + vmscanmemcg-reintroduce-sc-may_swap.patch added to -mm tree
Date: Mon, 20 Apr 2009 15:42:36 -0700
Message-ID: <200904202242.n3KMgaeF008539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38721 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753450AbZDTWqZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Apr 2009 18:46:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     vmscan,memcg: reintroduce sc->may_swap
has been added to the -mm tree.  Its filename is
     vmscanmemcg-reintroduce-sc-may_swap.patch

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
Subject: vmscan,memcg: reintroduce sc->may_swap
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

a6dc60f8975ad96d162915e07703a4439c80dcf0 ("vmscan: rename sc.may_swap to
may_unmap") removed the may_swap flag, but memcg had used it as a flag for
"we need to use swap?", as the name indicate.

And in the current implementation, memcg cannot reclaim mapped file caches
when mem+swap hits the limit.

re-introduce may_swap flag and handle it at get_scan_ratio().  This patch
doesn't influence any scan_control users other than memcg.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~vmscanmemcg-reintroduce-sc-may_swap mm/vmscan.c
--- a/mm/vmscan.c~vmscanmemcg-reintroduce-sc-may_swap
+++ a/mm/vmscan.c
@@ -63,6 +63,9 @@ struct scan_control {
 	/* Can mapped pages be reclaimed? */
 	int may_unmap;
 
+	/* Can pages be swapped as part of reclaim? */
+	int may_swap;
+
 	/* This context's SWAP_CLUSTER_MAX. If freeing memory for
 	 * suspend, we effectively ignore SWAP_CLUSTER_MAX.
 	 * In this context, it doesn't matter that we scan the
@@ -1380,7 +1383,7 @@ static void get_scan_ratio(struct zone *
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
 	/* If we have no swap space, do not bother scanning anon pages. */
-	if (nr_swap_pages <= 0) {
+	if (!sc->may_swap || (nr_swap_pages <= 0)) {
 		percent[0] = 0;
 		percent[1] = 100;
 		return;
@@ -1697,6 +1700,7 @@ unsigned long try_to_free_pages(struct z
 		.may_writepage = !laptop_mode,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.may_unmap = 1,
+		.may_swap = 1,
 		.swappiness = vm_swappiness,
 		.order = order,
 		.mem_cgroup = NULL,
@@ -1717,6 +1721,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
+		.may_swap = !noswap,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.swappiness = swappiness,
 		.order = 0,
@@ -1726,9 +1731,6 @@ unsigned long try_to_free_mem_cgroup_pag
 	};
 	struct zonelist *zonelist;
 
-	if (noswap)
-		sc.may_unmap = 0;
-
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 	zonelist = NODE_DATA(numa_node_id())->node_zonelists;
@@ -1767,6 +1769,7 @@ static unsigned long balance_pgdat(pg_da
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.may_unmap = 1,
+		.may_swap = 1,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.swappiness = vm_swappiness,
 		.order = order,
@@ -2298,6 +2301,7 @@ static int __zone_reclaim(struct zone *z
 	struct scan_control sc = {
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
 		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
+		.may_swap = 1,
 		.swap_cluster_max = max_t(unsigned long, nr_pages,
 					SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
memcg-use-rcu_dereference-to-access-mm-owner.patch
vmscanmemcg-reintroduce-sc-may_swap.patch
procfs-make-errno-values-consistent-when-open-pident-vs-exit2-race-occurs.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

