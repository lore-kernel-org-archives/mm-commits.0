From: akpm@linux-foundation.org
Subject: + memcg-fix-wrong-check-of-noswap-with-softlimit.patch added to -mm tree
Date: Mon, 13 Jun 2011 14:23:48 -0700
Message-ID: <201106132123.p5DLNmBU022727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193Ab1FMVY0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jun 2011 17:24:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix wrong check of noswap with softlimit
has been added to the -mm tree.  Its filename is
     memcg-fix-wrong-check-of-noswap-with-softlimit.patch

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
Subject: memcg: fix wrong check of noswap with softlimit
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Hierarchical reclaim doesn't swap out if memsw and resource limits are
thye same (memsw_is_minimum == true) because we would hit mem+swap limit
anyway (during hard limit reclaim).

If it comes to the soft limit we shouldn't consider memsw_is_minimum at
all because it doesn't make much sense.  Either the soft limit is bellow
the hard limit and then we cannot hit mem+swap limit or the direct reclaim
takes a precedence.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-fix-wrong-check-of-noswap-with-softlimit mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-wrong-check-of-noswap-with-softlimit
+++ a/mm/memcontrol.c
@@ -1663,7 +1663,7 @@ static int mem_cgroup_hierarchical_recla
 	excess = res_counter_soft_limit_excess(&root_mem->res) >> PAGE_SHIFT;
 
 	/* If memsw_is_minimum==1, swap-out is of-no-use. */
-	if (root_mem->memsw_is_minimum)
+	if (!check_soft && root_mem->memsw_is_minimum)
 		noswap = true;
 
 	while (1) {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

vmscanmemcg-memcg-aware-swap-token.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-fix-wrong-kunmap_atomic-pointer.patch
mm-memory_hotplugc-fix-building-of-node-hotplug-zonelist.patch
mm-memorynuma_stat-fix-file-permission.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem-fix.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves-fix.patch
memcg-fix-wrong-check-of-noswap-with-softlimit.patch
memcg-fix-percpu-cached-charge-draining-frequency.patch
memcg-fix-percpu-cached-charge-draining-frequency-fix.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

