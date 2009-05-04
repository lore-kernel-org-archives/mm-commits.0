From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-try_get_mem_cgroup_from_swapcache.patch removed from -mm tree
Date: Mon, 04 May 2009 13:12:31 -0700
Message-ID: <200905042012.n44KCVd0021957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778AbZEDUPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 16:15:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix try_get_mem_cgroup_from_swapcache()
has been removed from the -mm tree.  Its filename was
     memcg-fix-try_get_mem_cgroup_from_swapcache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix try_get_mem_cgroup_from_swapcache()
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

This is a bugfix for commit 3c776e64660028236313f0e54f3a9945764422df
("memcg: charge swapcache to proper memcg").

Used bit of swapcache is solid under page lock, but considering
move_account, pc->mem_cgroup is not.

We need lock_page_cgroup() anyway.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-try_get_mem_cgroup_from_swapcache mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-try_get_mem_cgroup_from_swapcache
+++ a/mm/memcontrol.c
@@ -1024,9 +1024,7 @@ static struct mem_cgroup *try_get_mem_cg
 		return NULL;
 
 	pc = lookup_page_cgroup(page);
-	/*
-	 * Used bit of swapcache is solid under page lock.
-	 */
+	lock_page_cgroup(pc);
 	if (PageCgroupUsed(pc)) {
 		mem = pc->mem_cgroup;
 		if (mem && !css_tryget(&mem->css))
@@ -1040,6 +1038,7 @@ static struct mem_cgroup *try_get_mem_cg
 			mem = NULL;
 		rcu_read_unlock();
 	}
+	unlock_page_cgroup(pc);
 	return mem;
 }
 
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
memcg-remove-mem_cgroup_cache_charge_swapin.patch

