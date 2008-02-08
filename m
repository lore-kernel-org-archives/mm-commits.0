From: akpm@linux-foundation.org
Subject: - bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:03:47 -0800
Message-ID: <200802080803.m1883Ssq014125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32877 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755078AbYBHI06 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:26:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     bugfix for memory controller: add helper function for assigning cgroup to page
has been removed from the -mm tree.  Its filename was
     bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bugfix for memory controller: add helper function for assigning cgroup to page
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch adds following functions.
   - clear_page_cgroup(page, pc)
   - page_cgroup_assign_new_page_group(page, pc)

Mainly for cleanup.

A manner "check page->cgroup again after lock_page_cgroup()" is
implemented in straight way.

A comment in mem_cgroup_uncharge() will be removed by force-empty patch

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: David Rientjes <rientjes@google.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  105 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 76 insertions(+), 29 deletions(-)

diff -puN mm/memcontrol.c~bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page mm/memcontrol.c
--- a/mm/memcontrol.c~bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page
+++ a/mm/memcontrol.c
@@ -162,6 +162,48 @@ static void __always_inline unlock_page_
 	bit_spin_unlock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
 }
 
+/*
+ * Tie new page_cgroup to struct page under lock_page_cgroup()
+ * This can fail if the page has been tied to a page_cgroup.
+ * If success, returns 0.
+ */
+static inline int
+page_cgroup_assign_new_page_cgroup(struct page *page, struct page_cgroup *pc)
+{
+	int ret = 0;
+
+	lock_page_cgroup(page);
+	if (!page_get_page_cgroup(page))
+		page_assign_page_cgroup(page, pc);
+	else /* A page is tied to other pc. */
+		ret = 1;
+	unlock_page_cgroup(page);
+	return ret;
+}
+
+/*
+ * Clear page->page_cgroup member under lock_page_cgroup().
+ * If given "pc" value is different from one page->page_cgroup,
+ * page->cgroup is not cleared.
+ * Returns a value of page->page_cgroup at lock taken.
+ * A can can detect failure of clearing by following
+ *  clear_page_cgroup(page, pc) == pc
+ */
+
+static inline struct page_cgroup *
+clear_page_cgroup(struct page *page, struct page_cgroup *pc)
+{
+	struct page_cgroup *ret;
+	/* lock and clear */
+	lock_page_cgroup(page);
+	ret = page_get_page_cgroup(page);
+	if (likely(ret == pc))
+		page_assign_page_cgroup(page, NULL);
+	unlock_page_cgroup(page);
+	return ret;
+}
+
+
 static void __mem_cgroup_move_lists(struct page_cgroup *pc, bool active)
 {
 	if (active)
@@ -270,7 +312,7 @@ int mem_cgroup_charge(struct page *page,
 				gfp_t gfp_mask)
 {
 	struct mem_cgroup *mem;
-	struct page_cgroup *pc, *race_pc;
+	struct page_cgroup *pc;
 	unsigned long flags;
 	unsigned long nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
 
@@ -293,8 +335,10 @@ retry:
 			unlock_page_cgroup(page);
 			cpu_relax();
 			goto retry;
-		} else
+		} else {
+			unlock_page_cgroup(page);
 			goto done;
+		}
 	}
 
 	unlock_page_cgroup(page);
@@ -364,31 +408,26 @@ noreclaim:
 		goto free_pc;
 	}
 
-	lock_page_cgroup(page);
-	/*
-	 * Check if somebody else beat us to allocating the page_cgroup
-	 */
-	race_pc = page_get_page_cgroup(page);
-	if (race_pc) {
-		kfree(pc);
-		pc = race_pc;
-		atomic_inc(&pc->ref_cnt);
-		res_counter_uncharge(&mem->res, PAGE_SIZE);
-		css_put(&mem->css);
-		goto done;
-	}
-
 	atomic_set(&pc->ref_cnt, 1);
 	pc->mem_cgroup = mem;
 	pc->page = page;
-	page_assign_page_cgroup(page, pc);
+	if (page_cgroup_assign_new_page_cgroup(page, pc)) {
+		/*
+		 * an another charge is added to this page already.
+		 * we do take lock_page_cgroup(page) again and read
+		 * page->cgroup, increment refcnt.... just retry is OK.
+		 */
+		res_counter_uncharge(&mem->res, PAGE_SIZE);
+		css_put(&mem->css);
+		kfree(pc);
+		goto retry;
+	}
 
 	spin_lock_irqsave(&mem->lru_lock, flags);
 	list_add(&pc->lru, &mem->active_list);
 	spin_unlock_irqrestore(&mem->lru_lock, flags);
 
 done:
-	unlock_page_cgroup(page);
 	return 0;
 free_pc:
 	kfree(pc);
@@ -432,17 +471,25 @@ void mem_cgroup_uncharge(struct page_cgr
 
 	if (atomic_dec_and_test(&pc->ref_cnt)) {
 		page = pc->page;
-		lock_page_cgroup(page);
-		mem = pc->mem_cgroup;
-		css_put(&mem->css);
-		page_assign_page_cgroup(page, NULL);
-		unlock_page_cgroup(page);
-		res_counter_uncharge(&mem->res, PAGE_SIZE);
-
- 		spin_lock_irqsave(&mem->lru_lock, flags);
- 		list_del_init(&pc->lru);
- 		spin_unlock_irqrestore(&mem->lru_lock, flags);
-		kfree(pc);
+		/*
+		 * get page->cgroup and clear it under lock.
+		 */
+		if (clear_page_cgroup(page, pc) == pc) {
+			mem = pc->mem_cgroup;
+			css_put(&mem->css);
+			res_counter_uncharge(&mem->res, PAGE_SIZE);
+			spin_lock_irqsave(&mem->lru_lock, flags);
+			list_del_init(&pc->lru);
+			spin_unlock_irqrestore(&mem->lru_lock, flags);
+			kfree(pc);
+		} else {
+			/*
+			 * Note:This will be removed when force-empty patch is
+			 * applied. just show warning here.
+			 */
+			printk(KERN_ERR "Race in mem_cgroup_uncharge() ?");
+			dump_stack();
+		}
 	}
 }
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
