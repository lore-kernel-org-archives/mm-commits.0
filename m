From: akpm@linux-foundation.org
Subject: [merged] memcg-show-swap-usage-in-stat-file.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:34:59 -0700
Message-ID: <200909241934.n8OJYxVI031911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891AbZIXTnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:43:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: show swap usage in stat file
has been removed from the -mm tree.  Its filename was
     memcg-show-swap-usage-in-stat-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: show swap usage in stat file
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

We now count MEM_CGROUP_STAT_SWAPOUT, so we can show swap usage.  It would
be useful for users to show swap usage in memory.stat file, because they
don't need calculate memsw.usage - res.usage to know swap usage.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-show-swap-usage-in-stat-file mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-show-swap-usage-in-stat-file
+++ a/mm/memcontrol.c
@@ -2676,6 +2676,7 @@ enum {
 	MCS_MAPPED_FILE,
 	MCS_PGPGIN,
 	MCS_PGPGOUT,
+	MCS_SWAP,
 	MCS_INACTIVE_ANON,
 	MCS_ACTIVE_ANON,
 	MCS_INACTIVE_FILE,
@@ -2697,6 +2698,7 @@ struct {
 	{"mapped_file", "total_mapped_file"},
 	{"pgpgin", "total_pgpgin"},
 	{"pgpgout", "total_pgpgout"},
+	{"swap", "total_swap"},
 	{"inactive_anon", "total_inactive_anon"},
 	{"active_anon", "total_active_anon"},
 	{"inactive_file", "total_inactive_file"},
@@ -2721,6 +2723,10 @@ static int mem_cgroup_get_local_stat(str
 	s->stat[MCS_PGPGIN] += val;
 	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGOUT_COUNT);
 	s->stat[MCS_PGPGOUT] += val;
+	if (do_swap_account) {
+		val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_SWAPOUT);
+		s->stat[MCS_SWAP] += val * PAGE_SIZE;
+	}
 
 	/* per zone stat */
 	val = mem_cgroup_get_local_zonestat(mem, LRU_INACTIVE_ANON);
@@ -2752,8 +2758,11 @@ static int mem_control_stat_show(struct 
 	memset(&mystat, 0, sizeof(mystat));
 	mem_cgroup_get_local_stat(mem_cont, &mystat);
 
-	for (i = 0; i < NR_MCS_STAT; i++)
+	for (i = 0; i < NR_MCS_STAT; i++) {
+		if (i == MCS_SWAP && !do_swap_account)
+			continue;
 		cb->fill(cb, memcg_stat_strings[i].local_name, mystat.stat[i]);
+	}
 
 	/* Hierarchical information */
 	{
@@ -2766,9 +2775,11 @@ static int mem_control_stat_show(struct 
 
 	memset(&mystat, 0, sizeof(mystat));
 	mem_cgroup_get_total_stat(mem_cont, &mystat);
-	for (i = 0; i < NR_MCS_STAT; i++)
+	for (i = 0; i < NR_MCS_STAT; i++) {
+		if (i == MCS_SWAP && !do_swap_account)
+			continue;
 		cb->fill(cb, memcg_stat_strings[i].total_name, mystat.stat[i]);
