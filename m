From: akpm@linux-foundation.org
Subject: + cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch added to -mm tree
Date: Wed, 11 Mar 2009 13:45:10 -0700
Message-ID: <200903112045.n2BKjBOL002026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754536AbZCKUsm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 16:48:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     cgroups: use css id in swap cgroup for saving memory v5
has been added to the -mm tree.  Its filename is
     cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch

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
Subject: cgroups: use css id in swap cgroup for saving memory v5
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Try to use CSS ID for records in swap_cgroup.  By this, on 64bit machine,
size of swap_cgroup goes down to 2 bytes from 8bytes.

This means, when 2GB of swap is equipped, (assume the page size is 4096bytes)

	From size of swap_cgroup = 2G/4k * 8 = 4Mbytes.
	To   size of swap_cgroup = 2G/4k * 2 = 1Mbytes.

Reduction is large.  Of course, there are trade-offs.  This CSS ID will
add overhead to swap-in/swap-out/swap-free.

But in general,
  - swap is a resource which the user tend to avoid use.
  - If swap is never used, swap_cgroup area is not used.
  - Reading traditional manuals, size of swap should be proportional to
    size of memory. Memory size of machine is increasing now.

I think reducing size of swap_cgroup makes sense.

Note:
  - ID->CSS lookup routine has no locks, it's under RCU-Read-Side.
  - memcg can be obsolete at rmdir() but not freed while refcnt from
    swap_cgroup is available.

Changelog v4->v5:
 - reworked on to memcg-charge-swapcache-to-proper-memcg.patch
Changlog ->v4:
 - fixed not configured case.
 - deleted unnecessary comments.
 - fixed NULL pointer bug.
 - fixed message in dmesg.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |   13 +++---
 mm/memcontrol.c             |   64 ++++++++++++++++++++++++++++++----
 mm/page_cgroup.c            |   32 +++++++----------
 3 files changed, 78 insertions(+), 31 deletions(-)

diff -puN include/linux/page_cgroup.h~cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5 include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5
+++ a/include/linux/page_cgroup.h
@@ -91,24 +91,23 @@ static inline void page_cgroup_init(void
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 #include <linux/swap.h>
-extern struct mem_cgroup *
-swap_cgroup_record(swp_entry_t ent, struct mem_cgroup *mem);
-extern struct mem_cgroup *lookup_swap_cgroup(swp_entry_t ent);
+extern unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id);
+extern unsigned short lookup_swap_cgroup(swp_entry_t ent);
 extern int swap_cgroup_swapon(int type, unsigned long max_pages);
 extern void swap_cgroup_swapoff(int type);
 #else
 #include <linux/swap.h>
 
 static inline
-struct mem_cgroup *swap_cgroup_record(swp_entry_t ent, struct mem_cgroup *mem)
+unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
 {
-	return NULL;
+	return 0;
 }
 
 static inline
-struct mem_cgroup *lookup_swap_cgroup(swp_entry_t ent)
+unsigned short lookup_swap_cgroup(swp_entry_t ent)
 {
-	return NULL;
+	return 0;
 }
 
 static inline int
diff -puN mm/memcontrol.c~cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5 mm/memcontrol.c
--- a/mm/memcontrol.c~cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5
+++ a/mm/memcontrol.c
@@ -991,10 +991,31 @@ nomem:
 	return -ENOMEM;
 }
 
+
+/*
+ * A helper function to get mem_cgroup from ID. must be called under
+ * rcu_read_lock(). The caller must check css_is_removed() or some if
+ * it's concern. (dropping refcnt from swap can be called against removed
+ * memcg.)
+ */
+static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
+{
+	struct cgroup_subsys_state *css;
+
+	/* ID 0 is unused ID */
+	if (!id)
+		return NULL;
+	css = css_lookup(&mem_cgroup_subsys, id);
+	if (!css)
+		return NULL;
+	return container_of(css, struct mem_cgroup, css);
+}
+
 static struct mem_cgroup *try_get_mem_cgroup_from_swapcache(struct page *page)
 {
 	struct mem_cgroup *mem;
 	struct page_cgroup *pc;
+	unsigned short id;
 	swp_entry_t ent;
 
 	VM_BUG_ON(!PageLocked(page));
@@ -1010,7 +1031,12 @@ static struct mem_cgroup *try_get_mem_cg
 		mem = pc->mem_cgroup;
 	else {
 		ent.val = page_private(page);
-		mem = lookup_swap_cgroup(ent);
+		id = lookup_swap_cgroup(ent);
+		rcu_read_lock();
+		mem = mem_cgroup_lookup(id);
+		if (mem && !css_tryget(&mem->css))
+			mem = NULL;
+		rcu_read_unlock();
 	}
 	if (!mem)
 		return NULL;
@@ -1276,12 +1302,22 @@ int mem_cgroup_cache_charge(struct page 
 
 	if (do_swap_account && !ret && PageSwapCache(page)) {
 		swp_entry_t ent = {.val = page_private(page)};
+		unsigned short id;
 		/* avoid double counting */
-		mem = swap_cgroup_record(ent, NULL);
+		id = swap_cgroup_record(ent, 0);
+		rcu_read_lock();
+		mem = mem_cgroup_lookup(id);
 		if (mem) {
+			/*
+			 * We did swap-in. Then, this entry is doubly counted
+			 * both in mem and memsw. We uncharge it, here.
+			 * Recorded ID can be obsolete. We avoid calling
+			 * css_tryget()
+			 */
 			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
 			mem_cgroup_put(mem);
 		}
+		rcu_read_unlock();
 	}
 	return ret;
 }
@@ -1346,13 +1382,21 @@ void mem_cgroup_commit_charge_swapin(str
 	 */
 	if (do_swap_account && PageSwapCache(page)) {
 		swp_entry_t ent = {.val = page_private(page)};
+		unsigned short id;
 		struct mem_cgroup *memcg;
-		memcg = swap_cgroup_record(ent, NULL);
+
+		id = swap_cgroup_record(ent, 0);
+		rcu_read_lock();
+		memcg = mem_cgroup_lookup(id);
 		if (memcg) {
+			/*
+			 * This recorded memcg can be obsolete one. So, avoid
+			 * calling css_tryget
+			 */
 			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
 			mem_cgroup_put(memcg);
 		}
-
+		rcu_read_unlock();
 	}
 	/* add this page(page_cgroup) to the LRU we want. */
 
@@ -1473,7 +1517,7 @@ void mem_cgroup_uncharge_swapcache(struc
 					MEM_CGROUP_CHARGE_TYPE_SWAPOUT);
 	/* record memcg information */
 	if (do_swap_account && memcg) {
-		swap_cgroup_record(ent, memcg);
+		swap_cgroup_record(ent, css_id(&memcg->css));
 		mem_cgroup_get(memcg);
 	}
 	if (memcg)
@@ -1488,15 +1532,23 @@ void mem_cgroup_uncharge_swapcache(struc
 void mem_cgroup_uncharge_swap(swp_entry_t ent)
 {
 	struct mem_cgroup *memcg;
+	unsigned short id;
 
 	if (!do_swap_account)
 		return;
 
-	memcg = swap_cgroup_record(ent, NULL);
+	id = swap_cgroup_record(ent, 0);
+	rcu_read_lock();
+	memcg = mem_cgroup_lookup(id);
 	if (memcg) {
+		/*
+		 * We uncharge this because swap is freed.
+		 * This memcg can be obsolete one. We avoid calling css_tryget
+		 */
 		res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
 		mem_cgroup_put(memcg);
 	}
+	rcu_read_unlock();
 }
 #endif
 
diff -puN mm/page_cgroup.c~cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5 mm/page_cgroup.c
--- a/mm/page_cgroup.c~cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5
+++ a/mm/page_cgroup.c
@@ -285,12 +285,8 @@ struct swap_cgroup_ctrl {
 
 struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
 
-/*
- * This 8bytes seems big..maybe we can reduce this when we can use "id" for
- * cgroup rather than pointer.
- */
 struct swap_cgroup {
-	struct mem_cgroup	*val;
+	unsigned short		id;
 };
 #define SC_PER_PAGE	(PAGE_SIZE/sizeof(struct swap_cgroup))
 #define SC_POS_MASK	(SC_PER_PAGE - 1)
@@ -342,10 +338,10 @@ not_enough_page:
  * @ent: swap entry to be recorded into
  * @mem: mem_cgroup to be recorded
  *
- * Returns old value at success, NULL at failure.
- * (Of course, old value can be NULL.)
+ * Returns old value at success, 0 at failure.
+ * (Of course, old value can be 0.)
  */
-struct mem_cgroup *swap_cgroup_record(swp_entry_t ent, struct mem_cgroup *mem)
+unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
 {
 	int type = swp_type(ent);
 	unsigned long offset = swp_offset(ent);
@@ -354,18 +350,18 @@ struct mem_cgroup *swap_cgroup_record(sw
 	struct swap_cgroup_ctrl *ctrl;
 	struct page *mappage;
 	struct swap_cgroup *sc;
-	struct mem_cgroup *old;
+	unsigned short old;
 
 	if (!do_swap_account)
-		return NULL;
+		return 0;
 
 	ctrl = &swap_cgroup_ctrl[type];
 
 	mappage = ctrl->map[idx];
 	sc = page_address(mappage);
 	sc += pos;
-	old = sc->val;
-	sc->val = mem;
+	old = sc->id;
+	sc->id = id;
 
 	return old;
 }
@@ -374,9 +370,9 @@ struct mem_cgroup *swap_cgroup_record(sw
  * lookup_swap_cgroup - lookup mem_cgroup tied to swap entry
  * @ent: swap entry to be looked up.
  *
- * Returns pointer to mem_cgroup at success. NULL at failure.
+ * Returns CSS ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
  */
-struct mem_cgroup *lookup_swap_cgroup(swp_entry_t ent)
+unsigned short lookup_swap_cgroup(swp_entry_t ent)
 {
 	int type = swp_type(ent);
 	unsigned long offset = swp_offset(ent);
@@ -385,16 +381,16 @@ struct mem_cgroup *lookup_swap_cgroup(sw
 	struct swap_cgroup_ctrl *ctrl;
 	struct page *mappage;
 	struct swap_cgroup *sc;
-	struct mem_cgroup *ret;
+	unsigned short ret;
 
 	if (!do_swap_account)
-		return NULL;
+		return 0;
 
 	ctrl = &swap_cgroup_ctrl[type];
 	mappage = ctrl->map[idx];
 	sc = page_address(mappage);
 	sc += pos;
-	ret = sc->val;
+	ret = sc->id;
 	return ret;
 }
 
@@ -432,7 +428,7 @@ int swap_cgroup_swapon(int type, unsigne
 
 	printk(KERN_INFO
 		"swap_cgroup: uses %ld bytes of vmalloc for pointer array space"
-		" and %ld bytes to hold mem_cgroup pointers on swap\n",
+		" and %ld bytes to hold mem_cgroup information per swap ents\n",
 		array_size, length * PAGE_SIZE);
 	printk(KERN_INFO
 	"swap_cgroup can be disabled by noswapaccount boot option.\n");
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
vmscan-respect-higher-order-in-zone_reclaim.patch
cgroup-css-id-support.patch
cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
cgroups-more-documentation-for-remount-and-release_agent.patch
cgroups-show-correct-file-mode.patch
cgroups-show-correct-file-mode-fix.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
memcg-charge-swapcache-to-proper-memcg.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch
use-css-id-in-swap_cgroup-for-saving-memory-v4.patch
cgroups-add-data-field-to-struct-cgroup_scanner.patch
cpuset-rewrite-update_tasks_nodemask.patch
cpuset-avoid-changing-cpusets-mems-when-errno-returned.patch
cpuset-remove-struct-cpuset_hotplug_scanner.patch

