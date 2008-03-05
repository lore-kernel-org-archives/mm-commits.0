From: akpm@linux-foundation.org
Subject: - memcg-fix-mem_cgroup_move_lists-locking.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:39 -0800
Message-ID: <200803050745.m257jdk5021611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39064 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758052AbYCEHvJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:51:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: fix mem_cgroup_move_lists locking
has been removed from the -mm tree.  Its filename was
     memcg-fix-mem_cgroup_move_lists-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix mem_cgroup_move_lists locking
From: Hugh Dickins <hugh@veritas.com>

Ever since the VM_BUG_ON(page_get_page_cgroup(page)) (now Bad page state) went
into page freeing, I've hit it from time to time in testing on some machines,
sometimes only after many days.  Recently found a machine which could usually
produce it within a few hours, which got me there at last.

The culprit is mem_cgroup_move_lists, whose locking is inadequate; and the
arrangement of structures was such that you got page_cgroups from the lru list
neatly put on to SLUB's freelist.  Kamezawa-san identified the same hole
independently.

The main problem was that it was missing the lock_page_cgroup it needs to
safely page_get_page_cgroup; but it's tricky to go beyond that too, and I
couldn't do it with SLAB_DESTROY_BY_RCU as I'd expected.  See the code for
comments on the constraints.

This patch immediately gets replaced by a simpler one from Hirokazu-san; but
is it just foolish pride that tells me to put this one on record, in case we
need to come back to it later?

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   49 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-mem_cgroup_move_lists-locking mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-mem_cgroup_move_lists-locking
+++ a/mm/memcontrol.c
@@ -277,6 +277,11 @@ static void lock_page_cgroup(struct page
 	bit_spin_lock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
 }
 
+static int try_lock_page_cgroup(struct page *page)
+{
+	return bit_spin_trylock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
+}
+
 static void unlock_page_cgroup(struct page *page)
 {
 	bit_spin_unlock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
@@ -348,17 +353,49 @@ int task_in_mem_cgroup(struct task_struc
 void mem_cgroup_move_lists(struct page *page, bool active)
 {
 	struct page_cgroup *pc;
+	struct mem_cgroup *mem;
 	struct mem_cgroup_per_zone *mz;
 	unsigned long flags;
 
-	pc = page_get_page_cgroup(page);
-	if (!pc)
+	/*
+	 * We cannot lock_page_cgroup while holding zone's lru_lock,
+	 * because other holders of lock_page_cgroup can be interrupted
+	 * with an attempt to rotate_reclaimable_page.  But we cannot
+	 * safely get to page_cgroup without it, so just try_lock it:
+	 * mem_cgroup_isolate_pages allows for page left on wrong list.
+	 */
+	if (!try_lock_page_cgroup(page))
 		return;
 
-	mz = page_cgroup_zoneinfo(pc);
-	spin_lock_irqsave(&mz->lru_lock, flags);
-	__mem_cgroup_move_lists(pc, active);
-	spin_unlock_irqrestore(&mz->lru_lock, flags);
+	/*
+	 * Now page_cgroup is stable, but we cannot acquire mz->lru_lock
+	 * while holding it, because mem_cgroup_force_empty_list does the
+	 * reverse.  Get a hold on the mem_cgroup before unlocking, so that
+	 * the zoneinfo remains stable, then take mz->lru_lock; then check
+	 * that page still points to pc and pc (even if freed and reassigned
+	 * to that same page meanwhile) still points to the same mem_cgroup.
+	 * Then we know mz still points to the right spinlock, so it's safe
+	 * to move_lists (page->page_cgroup might be reset while we do so, but
+	 * that doesn't matter: pc->page is stable till we drop mz->lru_lock).
+	 * We're being a little naughty not to try_lock_page_cgroup again
+	 * inside there, but we are safe, aren't we?  Aren't we?  Whistle...
+	 */
+	pc = page_get_page_cgroup(page);
+	if (pc) {
+		mem = pc->mem_cgroup;
+		mz = page_cgroup_zoneinfo(pc);
+		css_get(&mem->css);
+
+		unlock_page_cgroup(page);
+
+		spin_lock_irqsave(&mz->lru_lock, flags);
+		if (page_get_page_cgroup(page) == pc && pc->mem_cgroup == mem)
+			__mem_cgroup_move_lists(pc, active);
+		spin_unlock_irqrestore(&mz->lru_lock, flags);
+
+		css_put(&mem->css);
+	} else
+		unlock_page_cgroup(page);
 }
 
 /*
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

