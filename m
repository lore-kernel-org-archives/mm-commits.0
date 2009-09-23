From: akpm@linux-foundation.org
Subject: [folded] memcg-show-swap-usage-in-stat-file-fix.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:33:14 -0700
Message-ID: <200909232233.n8NMXEHH024671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751945AbZIWWdS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:33:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg-show-swap-usage-in-stat-file-fix
has been removed from the -mm tree.  Its filename was
     memcg-show-swap-usage-in-stat-file-fix.patch

This patch was dropped because it was folded into memcg-show-swap-usage-in-stat-file.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-show-swap-usage-in-stat-file-fix
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

The usage of swap should be showed in bytes.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-show-swap-usage-in-stat-file-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-show-swap-usage-in-stat-file-fix
+++ a/mm/memcontrol.c
@@ -2712,7 +2712,7 @@ static int mem_cgroup_get_local_stat(str
 	s->stat[MCS_PGPGOUT] += val;
 	if (do_swap_account) {
 		val = mem_cgroup_read_stat(&mem->stat, MEM_CGROUP_STAT_SWAPOUT);
-		s->stat[MCS_SWAP] += val;
+		s->stat[MCS_SWAP] += val * PAGE_SIZE;
 	}
 
 	/* per zone stat */
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-add-comments-explaining-memory-barriers.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memcg-improve-resource-counter-scalability.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch

