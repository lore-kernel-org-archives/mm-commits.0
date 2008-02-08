From: akpm@linux-foundation.org
Subject: - memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:04:14 -0800
Message-ID: <200802080803.m1883tQs014157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762015AbYBHIUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Memory controller use rcu_read_lock() in mem_cgroup_cache_charge()
has been removed from the -mm tree.  Its filename was
     memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Memory controller use rcu_read_lock() in mem_cgroup_cache_charge()
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Hugh Dickins noticed that we were using rcu_dereference() without
rcu_read_lock() in the cache charging routine. The patch below fixes
this problem

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge
+++ a/mm/memcontrol.c
@@ -456,16 +456,20 @@ int mem_cgroup_charge(struct page *page,
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
+	int ret = 0;
 	struct mem_cgroup *mem;
 	if (!mm)
 		mm = &init_mm;
 
+	rcu_read_lock();
 	mem = rcu_dereference(mm->mem_cgroup);
+	css_get(&mem->css);
+	rcu_read_unlock();
 	if (mem->control_type == MEM_CGROUP_TYPE_ALL)
-		return mem_cgroup_charge_common(page, mm, gfp_mask,
+		ret = mem_cgroup_charge_common(page, mm, gfp_mask,
 				MEM_CGROUP_CHARGE_TYPE_CACHE);
-	else
-		return 0;
+	css_put(&mem->css);
+	return ret;
 }
 
 /*
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
getdelays-fix-gcc-warnings.patch
