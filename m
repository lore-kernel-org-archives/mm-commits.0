From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-account-leak-at-failure-of-memsw-acconting.patch removed from -mm tree
Date: Wed, 26 Jan 2011 12:32:46 -0800
Message-ID: <201101262032.p0QKWkTE003219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754105Ab1AZUc5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Jan 2011 15:32:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hannes@cmpxchg.org, nishimura@mxp.nes.nec.co.jp, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     memcg: fix account leak at failure of memsw acconting
has been removed from the -mm tree.  Its filename was
     memcg-fix-account-leak-at-failure-of-memsw-acconting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix account leak at failure of memsw acconting
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

4b53433468 ("memcg: clean up try_charge main loop") removes a cancel of
charge at case: memory charge-> success.  mem+swap charge-> failure.

This leaks usage of memory. Fix it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: <stable@kernel.org>	[2.6.36+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/memcontrol.c~memcg-fix-account-leak-at-failure-of-memsw-acconting mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-account-leak-at-failure-of-memsw-acconting
+++ a/mm/memcontrol.c
@@ -1832,6 +1832,7 @@ static int __mem_cgroup_do_charge(struct
 		if (likely(!ret))
 			return CHARGE_OK;
 
+		res_counter_uncharge(&mem->res, csize);
 		mem_over_limit = mem_cgroup_from_res_counter(fail_res, memsw);
 		flags |= MEM_CGROUP_RECLAIM_NOSWAP;
 	} else
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
mm-add-replace_page_cache_page-function.patch

