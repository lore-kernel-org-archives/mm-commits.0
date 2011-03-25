From: akpm@linux-foundation.org
Subject: [merged] memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:41 -0700
Message-ID: <201103250724.p2P7OZga025872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933849Ab1CYHYt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: no uncharged pages reach page_cgroup_zoneinfo
has been removed from the -mm tree.  Its filename was
     memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: no uncharged pages reach page_cgroup_zoneinfo
From: Johannes Weiner <hannes@cmpxchg.org>

This patch series removes the direct page pointer from struct page_cgroup,
which saves 20% of per-page memcg memory overhead (Fedora and Ubuntu
enable memcg per default, openSUSE apparently too).

The node id or section number is encoded in the remaining free bits of
pc->flags which allows calculating the corresponding page without the
extra pointer.

I ran, what I think is, a worst-case microbenchmark that just cats a large
sparse file to /dev/null, because it means that walking the LRU list on
behalf of per-cgroup reclaim and looking up pages from page_cgroups is
happening constantly and at a high rate.  But it made no measurable
difference.  A profile reported a 0.11% share of the new
lookup_cgroup_page() function in this benchmark.


This patch:

All callsites check PCG_USED before passing pc->mem_cgroup, so the latter
is never NULL.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo
+++ a/mm/memcontrol.c
@@ -370,9 +370,6 @@ page_cgroup_zoneinfo(struct page_cgroup 
 	int nid = page_cgroup_nid(pc);
 	int zid = page_cgroup_zid(pc);
 
-	if (!mem)
-		return NULL;
