From: akpm@linux-foundation.org
Subject: - memcg-clean-up-checking-of-the-disabled-flag.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:58 -0700
Message-ID: <200807252258.m6PMwwVf003332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753995AbYGYW7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:59:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: clean up checking of  the disabled flag
has been removed from the -mm tree.  Its filename was
     memcg-clean-up-checking-of-the-disabled-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: clean up checking of  the disabled flag
From: Li Zefan <lizf@cn.fujitsu.com>

Those checks are unnecessary, because when the subsystem is disabled
it can't be mounted, so those functions won't get called.

The check is needed in functions which will be called in other places
except cgroup.

[hugh@veritas.com: further checking of disabled flag]
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff -puN mm/memcontrol.c~memcg-clean-up-checking-of-the-disabled-flag mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clean-up-checking-of-the-disabled-flag
+++ a/mm/memcontrol.c
@@ -354,6 +354,9 @@ void mem_cgroup_move_lists(struct page *
 	struct mem_cgroup_per_zone *mz;
 	unsigned long flags;
 
+	if (mem_cgroup_subsys.disabled)
+		return;
+
 	/*
 	 * We cannot lock_page_cgroup while holding zone's lru_lock,
 	 * because other holders of lock_page_cgroup can be interrupted
@@ -533,9 +536,6 @@ static int mem_cgroup_charge_common(stru
 	unsigned long nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 	struct mem_cgroup_per_zone *mz;
 
-	if (mem_cgroup_subsys.disabled)
-		return 0;
-
 	pc = kmem_cache_alloc(page_cgroup_cache, gfp_mask);
 	if (unlikely(pc == NULL))
 		goto err;
@@ -620,6 +620,9 @@ err:
 
 int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 {
+	if (mem_cgroup_subsys.disabled)
+		return 0;
+
 	/*
 	 * If already mapped, we don't have to account.
 	 * If page cache, page->mapping has address_space.
@@ -638,6 +641,9 @@ int mem_cgroup_charge(struct page *page,
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
+	if (mem_cgroup_subsys.disabled)
+		return 0;
+
 	/*
 	 * Corner case handling. This is called from add_to_page_cache()
 	 * in usual. But some FS (shmem) precharges this page before calling it
@@ -788,6 +794,9 @@ int mem_cgroup_shrink_usage(struct mm_st
 	int progress = 0;
 	int retry = MEM_CGROUP_RECLAIM_RETRIES;
 
+	if (mem_cgroup_subsys.disabled)
+		return 0;
+
 	rcu_read_lock();
 	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
 	css_get(&mem->css);
@@ -857,9 +866,6 @@ static int mem_cgroup_force_empty(struct
 	int ret = -EBUSY;
 	int node, zid;
 
-	if (mem_cgroup_subsys.disabled)
-		return 0;
-
 	css_get(&mem->css);
 	/*
 	 * page reclaim code (kswapd etc..) will move pages between
@@ -1103,8 +1109,6 @@ static void mem_cgroup_destroy(struct cg
 static int mem_cgroup_populate(struct cgroup_subsys *ss,
 				struct cgroup *cont)
 {
-	if (mem_cgroup_subsys.disabled)
-		return 0;
 	return cgroup_add_files(cont, ss, mem_cgroup_files,
 					ARRAY_SIZE(mem_cgroup_files));
 }
@@ -1117,9 +1121,6 @@ static void mem_cgroup_move_task(struct 
 	struct mm_struct *mm;
 	struct mem_cgroup *mem, *old_mem;
 
-	if (mem_cgroup_subsys.disabled)
-		return;
