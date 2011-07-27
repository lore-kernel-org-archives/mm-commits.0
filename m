From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-behavior-of-mem_cgroup_resize_limit.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:28:12 -0700
Message-ID: <201107271926.p6RJQwk7003160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754595Ab1G0T1J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:27:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, stable@kernel.org, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix behavior of mem_cgroup_resize_limit()
has been removed from the -mm tree.  Its filename was
     memcg-fix-behavior-of-mem_cgroup_resize_limit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix behavior of mem_cgroup_resize_limit()
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

22a668d7 ("memcg: fix behavior under memory.limit equals to memsw.limit")
introduced "memsw_is_minimum" flag, which becomes true when mem_limit ==
memsw_limit.  The flag is checked at the beginning of reclaim, and
"noswap" is set if the flag is true, because using swap is meaningless in
this case.

This works well in most cases, but when we try to shrink mem_limit, which
is the same as memsw_limit now, we might fail to shrink mem_limit because
swap doesn't used.

This patch fixes this behavior by:
- check MEM_CGROUP_RECLAIM_SHRINK at the begining of reclaim
- If it is set, don't set "noswap" flag even if memsw_is_minimum is true.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <bsingharora@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-behavior-of-mem_cgroup_resize_limit mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-behavior-of-mem_cgroup_resize_limit
+++ a/mm/memcontrol.c
@@ -1653,7 +1653,7 @@ static int mem_cgroup_hierarchical_recla
 	excess = res_counter_soft_limit_excess(&root_mem->res) >> PAGE_SHIFT;
 
 	/* If memsw_is_minimum==1, swap-out is of-no-use. */
-	if (!check_soft && root_mem->memsw_is_minimum)
+	if (!check_soft && !shrink && root_mem->memsw_is_minimum)
 		noswap = true;
 
 	while (1) {
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch

