From: akpm@linux-foundation.org
Subject: + memcg-fix-behavior-of-mem_cgroup_resize_limit.patch added to -mm tree
Date: Fri, 22 Jul 2011 15:32:48 -0700
Message-ID: <201107222232.p6MMWmaC019003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030Ab1GVWdD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Jul 2011 18:33:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, stable@kernel.org, yinghan@google.com


The patch titled
     memcg: fix behavior of mem_cgroup_resize_limit()
has been added to the -mm tree.  Its filename is
     memcg-fix-behavior-of-mem_cgroup_resize_limit.patch

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
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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
@@ -1652,7 +1652,7 @@ static int mem_cgroup_hierarchical_recla
 	excess = res_counter_soft_limit_excess(&root_mem->res) >> PAGE_SHIFT;
 
 	/* If memsw_is_minimum==1, swap-out is of-no-use. */
-	if (!check_soft && root_mem->memsw_is_minimum)
+	if (!check_soft && !shrink && root_mem->memsw_is_minimum)
 		noswap = true;
 
 	while (1) {
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

mm-preallocate-page-before-lock_page-at-filemap-cow.patch
memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
memcg-fix-vmscan-count-in-small-memcgs.patch
memcg-fix-behavior-of-mem_cgroup_resize_limit.patch
memcg-add-memoryvmscan_stat.patch

