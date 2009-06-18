From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-some-redundant-checks.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:01 -0700
Message-ID: <200906182246.n5IMk1EV005095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41198 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758465AbZFRWqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:46:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: remove some redundant checks
has been removed from the -mm tree.  Its filename was
     memcg-remove-some-redundant-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove some redundant checks
From: Li Zefan <lizf@cn.fujitsu.com>

We don't need to check do_swap_account in the case that the function which
checks do_swap_account will never get called if do_swap_account == 0.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c  |   11 ++++-------
 mm/page_cgroup.c |    8 --------
 2 files changed, 4 insertions(+), 15 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-some-redundant-checks mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-some-redundant-checks
+++ a/mm/memcontrol.c
@@ -45,7 +45,7 @@ struct cgroup_subsys mem_cgroup_subsys _
 #define MEM_CGROUP_RECLAIM_RETRIES	5
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
-/* Turned on only when memory cgroup is enabled && really_do_swap_account = 0 */
+/* Turned on only when memory cgroup is enabled && really_do_swap_account = 1 */
 int do_swap_account __read_mostly;
 static int really_do_swap_account __initdata = 1; /* for remember boot option*/
 #else
@@ -1763,16 +1763,14 @@ static int mem_cgroup_resize_limit(struc
 	return ret;
 }
 
-int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
-				unsigned long long val)
+static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
+					unsigned long long val)
 {
 	int retry_count;
 	u64 memlimit, oldusage, curusage;
 	int children = mem_cgroup_count_children(memcg);
 	int ret = -EBUSY;
 
-	if (!do_swap_account)
-		return -EINVAL;
 	/* see mem_cgroup_resize_res_limit */
  	retry_count = children * MEM_CGROUP_RECLAIM_RETRIES;
 	oldusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
@@ -2007,8 +2005,7 @@ static u64 mem_cgroup_read(struct cgroup
 		val = res_counter_read_u64(&mem->res, name);
 		break;
 	case _MEMSWAP:
-		if (do_swap_account)
-			val = res_counter_read_u64(&mem->memsw, name);
+		val = res_counter_read_u64(&mem->memsw, name);
 		break;
 	default:
 		BUG();
diff -puN mm/page_cgroup.c~memcg-remove-some-redundant-checks mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-remove-some-redundant-checks
+++ a/mm/page_cgroup.c
@@ -311,8 +311,6 @@ static int swap_cgroup_prepare(int type)
 	struct swap_cgroup_ctrl *ctrl;
 	unsigned long idx, max;
 
-	if (!do_swap_account)
-		return 0;
 	ctrl = &swap_cgroup_ctrl[type];
 
 	for (idx = 0; idx < ctrl->length; idx++) {
@@ -349,9 +347,6 @@ unsigned short swap_cgroup_record(swp_en
 	struct swap_cgroup *sc;
 	unsigned short old;
 
-	if (!do_swap_account)
-		return 0;
-
 	ctrl = &swap_cgroup_ctrl[type];
 
 	mappage = ctrl->map[idx];
@@ -380,9 +375,6 @@ unsigned short lookup_swap_cgroup(swp_en
 	struct swap_cgroup *sc;
 	unsigned short ret;
 
-	if (!do_swap_account)
-		return 0;
