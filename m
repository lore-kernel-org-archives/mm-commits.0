From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-impossible-conditional-when-committing.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:35 -0700
Message-ID: <201103250724.p2P7OTJr025863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933773Ab1CYHYj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: remove impossible conditional when committing
has been removed from the -mm tree.  Its filename was
     memcg-remove-impossible-conditional-when-committing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove impossible conditional when committing
From: Johannes Weiner <hannes@cmpxchg.org>

No callsite ever passes a NULL pointer for a struct mem_cgroup * to the
committing function.  There is no need to check for it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-impossible-conditional-when-committing mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-impossible-conditional-when-committing
+++ a/mm/memcontrol.c
@@ -2118,10 +2118,6 @@ static void __mem_cgroup_commit_charge(s
 {
 	int nr_pages = page_size >> PAGE_SHIFT;
 
-	/* try_charge() can return NULL to *memcg, taking care of it. */
-	if (!mem)
-		return;
