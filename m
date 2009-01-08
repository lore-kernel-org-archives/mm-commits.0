From: akpm@linux-foundation.org
Subject: - memcg-memoryswap-controller-fix-limit-check.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:56 -0800
Message-ID: <200901082248.n08MmuBp028229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51524 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760069AbZAHW6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:58:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: memory swap controller: fix limit check
has been removed from the -mm tree.  Its filename was
     memcg-memoryswap-controller-fix-limit-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: memory swap controller: fix limit check
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

There are scatterd calls of res_counter_check_under_limit(), and most of
them don't take mem+swap accounting into account.

define mem_cgroup_check_under_limit() and avoid direct use of
res_counter_check_limit().

Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff -puN mm/memcontrol.c~memcg-memoryswap-controller-fix-limit-check mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-memoryswap-controller-fix-limit-check
+++ a/mm/memcontrol.c
@@ -571,6 +571,18 @@ done:
 	return ret;
 }
 
+static bool mem_cgroup_check_under_limit(struct mem_cgroup *mem)
+{
+	if (do_swap_account) {
+		if (res_counter_check_under_limit(&mem->res) &&
+			res_counter_check_under_limit(&mem->memsw))
+			return true;
+	} else
+		if (res_counter_check_under_limit(&mem->res))
+			return true;
+	return false;
+}
+
 /*
  * Dance down the hierarchy if needed to reclaim memory. We remember the
  * last child we reclaimed from, so that we don't end up penalizing
@@ -592,7 +604,7 @@ static int mem_cgroup_hierarchical_recla
 	 * have left.
 	 */
 	ret = try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap);
-	if (res_counter_check_under_limit(&root_mem->res))
+	if (mem_cgroup_check_under_limit(root_mem))
 		return 0;
 
 	next_mem = mem_cgroup_get_first_node(root_mem);
@@ -606,7 +618,7 @@ static int mem_cgroup_hierarchical_recla
 			continue;
 		}
 		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap);
-		if (res_counter_check_under_limit(&root_mem->res))
+		if (mem_cgroup_check_under_limit(root_mem))
 			return 0;
 		cgroup_lock();
 		next_mem = mem_cgroup_get_next_node(next_mem, root_mem);
@@ -709,12 +721,8 @@ static int __mem_cgroup_try_charge(struc
 		 * current usage of the cgroup before giving up
 		 *
 		 */
-		if (do_swap_account) {
-			if (res_counter_check_under_limit(&mem_over_limit->res) &&
-			    res_counter_check_under_limit(&mem_over_limit->memsw))
-				continue;
-		} else if (res_counter_check_under_limit(&mem_over_limit->res))
-				continue;
+		if (mem_cgroup_check_under_limit(mem_over_limit))
+			continue;
 
 		if (!nr_retries--) {
 			if (oom) {
@@ -1334,7 +1342,7 @@ int mem_cgroup_shrink_usage(struct mm_st
 
 	do {
 		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask, true);
-		progress += res_counter_check_under_limit(&mem->res);
+		progress += mem_cgroup_check_under_limit(mem);
 	} while (!progress && --retry);
 
 	css_put(&mem->css);
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch

