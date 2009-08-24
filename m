From: akpm@linux-foundation.org
Subject: + memcg-show-swap-usage-in-stat-file.patch added to -mm tree
Date: Mon, 24 Aug 2009 13:04:30 -0700
Message-ID: <200908242004.n7OK4VT8016136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067AbZHXUFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 16:05:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: show swap usage in stat file
has been added to the -mm tree.  Its filename is
     memcg-show-swap-usage-in-stat-file.patch

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
@@ -2663,6 +2663,7 @@ enum {
 	MCS_MAPPED_FILE,
 	MCS_PGPGIN,
 	MCS_PGPGOUT,
+	MCS_SWAP,
 	MCS_INACTIVE_ANON,
 	MCS_ACTIVE_ANON,
 	MCS_INACTIVE_FILE,
@@ -2684,6 +2685,7 @@ struct {
 	{"mapped_file", "total_mapped_file"},
 	{"pgpgin", "total_pgpgin"},
 	{"pgpgout", "total_pgpgout"},
+	{"swap", "total_swap"},
 	{"inactive_anon", "total_inactive_anon"},
 	{"active_anon", "total_active_anon"},
 	{"inactive_file", "total_inactive_file"},
@@ -2708,6 +2710,10 @@ static int mem_cgroup_get_local_stat(str
 	s->stat[MCS_PGPGIN] += val;
 	val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_PGPGOUT_COUNT);
 	s->stat[MCS_PGPGOUT] += val;
+	if (do_swap_account) {
+		val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_SWAPOUT);
+		s->stat[MCS_SWAP] += val;
+	}
 
 	/* per zone stat */
 	val = mem_cgroup_get_local_zonestat(mem, LRU_INACTIVE_ANON);
@@ -2739,8 +2745,11 @@ static int mem_control_stat_show(struct 
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
@@ -2753,9 +2762,11 @@ static int mem_control_stat_show(struct 
 
 	memset(&mystat, 0, sizeof(mystat));
 	mem_cgroup_get_total_stat(mem_cont, &mystat);
-	for (i = 0; i < NR_MCS_STAT; i++)
+	for (i = 0; i < NR_MCS_STAT; i++) {
+		if (i == MCS_SWAP && !do_swap_account)
+			continue;
 		cb->fill(cb, memcg_stat_strings[i].total_name, mystat.stat[i]);
