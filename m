From: akpm@linux-foundation.org
Subject: + memcg-memcontrol-uninlined-and-static.patch added to -mm tree
Date: Wed, 27 Feb 2008 19:52:48 -0800
Message-ID: <200802280352.m1S3qmPj014229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758764AbYB1D6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 22:58:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp


The patch titled
     memcg: memcontrol uninlined and static
has been added to the -mm tree.  Its filename is
     memcg-memcontrol-uninlined-and-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
memcg-mm_match_cgroup-not-vm_match_cgroup.patch
memcg-move_lists-on-page-not-page_cgroup.patch
memcg-page_cache_release-not-__free_page.patch
memcg-when-do_swaps-do_wp_page-fails.patch
memcg-fix-vm_bug_on-from-page-migration.patch
memcg-bad-page-if-page_cgroup-when-free.patch
memcg-mem_cgroup_charge-never-null.patch
memcg-remove-mem_cgroup_uncharge.patch
memcg-memcontrol-whitespace-cleanups.patch
memcg-memcontrol-uninlined-and-static.patch
memcg-remove-clear_page_cgroup-and-atomics.patch
memcg-css_put-after-remove_list.patch
memcg-fix-mem_cgroup_move_lists-locking.patch
memcg-simplify-force_empty-and-move_lists.patch
memcg-fix-oops-on-null-lru-list.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-try-both-endianess-when-checking-for-endianess.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
prio_tree-debugging-patch.patch
