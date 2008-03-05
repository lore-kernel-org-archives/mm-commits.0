From: akpm@linux-foundation.org
Subject: - memcg-memcontrol-uninlined-and-static.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:31 -0800
Message-ID: <200803050745.m257jV43021599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759366AbYCEHps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:45:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: memcontrol uninlined and static
has been removed from the -mm tree.  Its filename was
     memcg-memcontrol-uninlined-and-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: memcontrol uninlined and static
From: Hugh Dickins <hugh@veritas.com>

More cleanup to memcontrol.c, this time changing some of the code generated. 
Let the compiler decide what to inline (except for page_cgroup_locked which is
only used when CONFIG_DEBUG_VM): the __always_inline on lock_page_cgroup etc. 
was quite a waste since bit_spin_lock etc.  are inlines in a header file; made
mem_cgroup_force_empty and mem_cgroup_write_strategy static.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff -puN mm/memcontrol.c~memcg-memcontrol-uninlined-and-static mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-memcontrol-uninlined-and-static
+++ a/mm/memcontrol.c
@@ -168,12 +168,12 @@ struct page_cgroup {
 #define PAGE_CGROUP_FLAG_CACHE	(0x1)	/* charged as cache */
 #define PAGE_CGROUP_FLAG_ACTIVE (0x2)	/* page is active in this cgroup */
 
-static inline int page_cgroup_nid(struct page_cgroup *pc)
+static int page_cgroup_nid(struct page_cgroup *pc)
 {
 	return page_to_nid(pc->page);
 }
 
-static inline enum zone_type page_cgroup_zid(struct page_cgroup *pc)
+static enum zone_type page_cgroup_zid(struct page_cgroup *pc)
 {
 	return page_zonenum(pc->page);
 }
@@ -199,14 +199,13 @@ static void mem_cgroup_charge_statistics
 		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_RSS, val);
 }
 
-static inline struct mem_cgroup_per_zone *
+static struct mem_cgroup_per_zone *
 mem_cgroup_zoneinfo(struct mem_cgroup *mem, int nid, int zid)
 {
-	BUG_ON(!mem->info.nodeinfo[nid]);
 	return &mem->info.nodeinfo[nid]->zoneinfo[zid];
 }
 
-static inline struct mem_cgroup_per_zone *
+static struct mem_cgroup_per_zone *
 page_cgroup_zoneinfo(struct page_cgroup *pc)
 {
 	struct mem_cgroup *mem = pc->mem_cgroup;
@@ -231,16 +230,14 @@ static unsigned long mem_cgroup_get_all_
 	return total;
 }
 
-static inline
-struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
+static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
 {
 	return container_of(cgroup_subsys_state(cont,
 				mem_cgroup_subsys_id), struct mem_cgroup,
 				css);
 }
 
-static inline
-struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
+static struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 {
 	return container_of(task_subsys_state(p, mem_cgroup_subsys_id),
 				struct mem_cgroup, css);
@@ -276,13 +273,12 @@ struct page_cgroup *page_get_page_cgroup
 	return (struct page_cgroup *) (page->page_cgroup & ~PAGE_CGROUP_LOCK);
 }
 
-static void __always_inline lock_page_cgroup(struct page *page)
+static void lock_page_cgroup(struct page *page)
 {
 	bit_spin_lock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
-	VM_BUG_ON(!page_cgroup_locked(page));
 }
 
-static void __always_inline unlock_page_cgroup(struct page *page)
+static void unlock_page_cgroup(struct page *page)
 {
 	bit_spin_unlock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
 }
@@ -741,16 +737,14 @@ void mem_cgroup_end_migration(struct pag
 void mem_cgroup_page_migration(struct page *page, struct page *newpage)
 {
 	struct page_cgroup *pc;
-	struct mem_cgroup *mem;
-	unsigned long flags;
 	struct mem_cgroup_per_zone *mz;
+	unsigned long flags;
 
 retry:
 	pc = page_get_page_cgroup(page);
 	if (!pc)
 		return;
 
-	mem = pc->mem_cgroup;
 	mz = page_cgroup_zoneinfo(pc);
 	if (clear_page_cgroup(page, pc) != pc)
 		goto retry;
@@ -822,7 +816,7 @@ retry:
  * make mem_cgroup's charge to be 0 if there is no task.
  * This enables deleting this mem_cgroup.
  */
-int mem_cgroup_force_empty(struct mem_cgroup *mem)
+static int mem_cgroup_force_empty(struct mem_cgroup *mem)
 {
 	int ret = -EBUSY;
 	int node, zid;
@@ -852,7 +846,7 @@ out:
 	return ret;
 }
 
-int mem_cgroup_write_strategy(char *buf, unsigned long long *tmp)
+static int mem_cgroup_write_strategy(char *buf, unsigned long long *tmp)
 {
 	*tmp = memparse(buf, &buf);
 	if (*buf != '\0')
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-try-both-endianess-when-checking-for-endianess.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
prio_tree-debugging-patch.patch

