From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:00 -0700
Message-ID: <201105271956.p4RJu5so017517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757127Ab1E0T4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 15:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: remove pointless next_mz nullification in mem_cgroup_soft_limit_reclaim()
has been removed from the -mm tree.  Its filename was
     memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove pointless next_mz nullification in mem_cgroup_soft_limit_reclaim()
From: Michal Hocko <mhocko@suse.cz>

next_mz is assigned to NULL if __mem_cgroup_largest_soft_limit_node
selects the same mz.  This doesn't make much sense as we assign to the
variable right in the next loop.

Compiler will probably optimize this out but it is little bit confusing
for the code reading.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim
+++ a/mm/memcontrol.c
@@ -3348,10 +3348,9 @@ unsigned long mem_cgroup_soft_limit_recl
 				 */
 				next_mz =
 				__mem_cgroup_largest_soft_limit_node(mctz);
-				if (next_mz == mz) {
+				if (next_mz == mz)
 					css_put(&next_mz->mem->css);
-					next_mz = NULL;
-				} else /* next_mz == NULL or other memcg */
+				else /* next_mz == NULL or other memcg */
 					break;
 			} while (1);
 		}
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

