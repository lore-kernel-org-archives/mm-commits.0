From: akpm@linux-foundation.org
Subject: - memcg-remove-redundant-function-calls.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:09 -0700
Message-ID: <200804300543.m3U5h9di029296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760625AbYD3GMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: remove redundant function calls
has been removed from the -mm tree.  Its filename was
     memcg-remove-redundant-function-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove redundant function calls
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

remove_list/add_list uses page_cgroup_zoneinfo() in it.

So, it's called twice before and after lock.

	mz = page_cgroup_zoneinfo();
	lock();
	mz = page_cgroup_zoneinfo();
	....
	unlock();

And address of mz never changes.

This is not good. This patch fixes this behavior.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-redundant-function-calls mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-redundant-function-calls
+++ a/mm/memcontrol.c
@@ -275,10 +275,10 @@ static void unlock_page_cgroup(struct pa
 	bit_spin_unlock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
 }
 
-static void __mem_cgroup_remove_list(struct page_cgroup *pc)
+static void __mem_cgroup_remove_list(struct mem_cgroup_per_zone *mz,
+			struct page_cgroup *pc)
 {
 	int from = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
-	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
 
 	if (from)
 		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_ACTIVE) -= 1;
@@ -289,10 +289,10 @@ static void __mem_cgroup_remove_list(str
 	list_del_init(&pc->lru);
 }
 
-static void __mem_cgroup_add_list(struct page_cgroup *pc)
+static void __mem_cgroup_add_list(struct mem_cgroup_per_zone *mz,
+				struct page_cgroup *pc)
 {
 	int to = pc->flags & PAGE_CGROUP_FLAG_ACTIVE;
-	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
 
 	if (!to) {
 		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) += 1;
@@ -618,7 +618,7 @@ retry:
 
 	mz = page_cgroup_zoneinfo(pc);
 	spin_lock_irqsave(&mz->lru_lock, flags);
-	__mem_cgroup_add_list(pc);
+	__mem_cgroup_add_list(mz, pc);
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
 
 	unlock_page_cgroup(page);
@@ -674,7 +674,7 @@ void mem_cgroup_uncharge_page(struct pag
 	if (--(pc->ref_cnt) == 0) {
 		mz = page_cgroup_zoneinfo(pc);
 		spin_lock_irqsave(&mz->lru_lock, flags);
-		__mem_cgroup_remove_list(pc);
+		__mem_cgroup_remove_list(mz, pc);
 		spin_unlock_irqrestore(&mz->lru_lock, flags);
 
 		page_assign_page_cgroup(page, NULL);
@@ -736,7 +736,7 @@ void mem_cgroup_page_migration(struct pa
 
 	mz = page_cgroup_zoneinfo(pc);
 	spin_lock_irqsave(&mz->lru_lock, flags);
-	__mem_cgroup_remove_list(pc);
+	__mem_cgroup_remove_list(mz, pc);
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
 
 	page_assign_page_cgroup(page, NULL);
@@ -748,7 +748,7 @@ void mem_cgroup_page_migration(struct pa
 
 	mz = page_cgroup_zoneinfo(pc);
 	spin_lock_irqsave(&mz->lru_lock, flags);
-	__mem_cgroup_add_list(pc);
+	__mem_cgroup_add_list(mz, pc);
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
 
 	unlock_page_cgroup(newpage);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
disable-the-memory-controller-by-default-v3.patch
proc-pagetypeinfo-fix-output-for-memoryless-nodes.patch

