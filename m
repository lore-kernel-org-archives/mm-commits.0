From: akpm@linux-foundation.org
Subject: [merged] memcg-mark-more-functions-variables-as-static.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:03 -0700
Message-ID: <20120531191703.47786A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:45514 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab2EaTRG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:06 -0400
Received: by faaa25 with SMTP id a25so75299faa.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: mark more functions/variables as static
has been removed from the -mm tree.  Its filename was
     memcg-mark-more-functions-variables-as-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: memcg: mark more functions/variables as static

Based on sparse output.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-mark-more-functions-variables-as-static mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-mark-more-functions-variables-as-static
+++ a/mm/memcontrol.c
@@ -59,7 +59,7 @@
 
 struct cgroup_subsys mem_cgroup_subsys __read_mostly;
 #define MEM_CGROUP_RECLAIM_RETRIES	5
-struct mem_cgroup *root_mem_cgroup __read_mostly;
+static struct mem_cgroup *root_mem_cgroup __read_mostly;
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 /* Turned on only when memory cgroup is enabled && really_do_swap_account = 1 */
@@ -1628,7 +1628,7 @@ int mem_cgroup_select_victim_node(struct
  * unused nodes. But scan_nodes is lazily updated and may not cotain
  * enough new information. We need to do double check.
  */
-bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
+static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
 {
 	int nid;
 
@@ -1663,7 +1663,7 @@ int mem_cgroup_select_victim_node(struct
 	return 0;
 }
 
-bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
+static bool mem_cgroup_reclaimable(struct mem_cgroup *memcg, bool noswap)
 {
 	return test_mem_cgroup_node_reclaimable(memcg, 0, noswap);
 }
@@ -1837,7 +1837,8 @@ static void memcg_oom_recover(struct mem
 /*
  * try to call OOM killer. returns false if we should exit memory-reclaim loop.
  */
-bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask, int order)
+static bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask,
+				  int order)
 {
 	struct oom_wait_info owait;
 	bool locked, need_to_kill;
@@ -3767,7 +3768,7 @@ try_to_free:
 	goto move_account;
 }
 
-int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
+static int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
 {
 	return mem_cgroup_force_empty(mem_cgroup_from_cont(cont), true);
 }
@@ -4048,7 +4049,7 @@ struct mcs_total_stat {
 	s64 stat[NR_MCS_STAT];
 };
 
-struct {
+static struct {
 	char *local_name;
 	char *total_name;
 } memcg_stat_strings[NR_MCS_STAT] = {
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch

