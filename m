From: akpm@linux-foundation.org
Subject: - memcg-fix-reclaim-result-checks.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:50 -0800
Message-ID: <200901082248.n08MmoVH028149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761439AbZAHW7D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:59:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, jblunck@suse.de, lizf@cn.fujitsu.com, nickpiggin@yahoo.com.au, nishimura@mxp.nes.nec.co.jp, pbadari@us.ibm.com, taka@valinux.co.jp


The patch titled
     memcg: fix reclaim result checks
has been removed from the -mm tree.  Its filename was
     memcg-fix-reclaim-result-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix reclaim result checks
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

check_under_limit logic was wrong and this check should be against
mem_over_limit rather than mem.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Jan Blunck <jblunck@suse.de>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-reclaim-result-checks mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-reclaim-result-checks
+++ a/mm/memcontrol.c
@@ -709,17 +709,17 @@ static int __mem_cgroup_try_charge(struc
 		 * current usage of the cgroup before giving up
 		 *
 		 */
-		if (!do_swap_account &&
-			res_counter_check_under_limit(&mem->res))
-			continue;
-		if (do_swap_account &&
-			res_counter_check_under_limit(&mem->memsw))
-			continue;
+		if (do_swap_account) {
+			if (res_counter_check_under_limit(&mem_over_limit->res) &&
+			    res_counter_check_under_limit(&mem_over_limit->memsw))
+				continue;
+		} else if (res_counter_check_under_limit(&mem_over_limit->res))
+				continue;
 
 		if (!nr_retries--) {
 			if (oom) {
-				mem_cgroup_out_of_memory(mem, gfp_mask);
-				mem->last_oom_jiffies = jiffies;
+				mem_cgroup_out_of_memory(mem_over_limit, gfp_mask);
+				mem_over_limit->last_oom_jiffies = jiffies;
 			}
 			goto nomem;
 		}
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

