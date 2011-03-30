From: akpm@linux-foundation.org
Subject: + memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim.patch added to -mm tree
Date: Wed, 30 Mar 2011 16:41:35 -0700
Message-ID: <201103302341.p2UNfZMJ021263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756376Ab1C3XmM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 19:42:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: remove pointless next_mz nullification in mem_cgroup_soft_limit_reclaim()
has been added to the -mm tree.  Its filename is
     memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim.patch

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
@@ -3404,10 +3404,9 @@ unsigned long mem_cgroup_soft_limit_recl
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

memsw-remove-noswapaccount-kernel-parameter.patch
memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim.patch

