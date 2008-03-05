From: akpm@linux-foundation.org
Subject: - memcg-fix-oops-on-null-lru-list.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:45 -0800
Message-ID: <200803050745.m257jjrR021617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765041AbYCEHpx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:45:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix oops on NULL lru list
has been removed from the -mm tree.  Its filename was
     memcg-fix-oops-on-null-lru-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix oops on NULL lru list
From: Hugh Dickins <hugh@veritas.com>

While testing force_empty, during an exit_mmap, __mem_cgroup_remove_list
called from mem_cgroup_uncharge_page oopsed on a NULL pointer in the lru list.
 I couldn't see what racing tasks on other cpus were doing, but surmise that
another must have been in mem_cgroup_charge_common on the same page, between
its unlock_page_cgroup and spin_lock_irqsave near done (thanks to that kzalloc
which I'd almost changed to a kmalloc).

Normally such a race cannot happen, the ref_cnt prevents it, the final
uncharge cannot race with the initial charge.  But force_empty buggers the
ref_cnt, that's what it's all about; and thereafter forced pages are
vulnerable to races such as this (just think of a shared page also mapped into
an mm of another mem_cgroup than that just emptied).  And remain vulnerable
until they're freed indefinitely later.

This patch just fixes the oops by moving the unlock_page_cgroups down below
adding to and removing from the list (only possible given the previous patch);
and while we're at it, we might as well make it an invariant that
page->page_cgroup is always set while pc is on lru.

But this behaviour of force_empty seems highly unsatisfactory to me: why have
a ref_cnt if we always have to cope with it being violated (as in the earlier
page migration patch).  We may prefer force_empty to move pages to an orphan
mem_cgroup (could be the root, but better not), from which other cgroups could
recover them; we might need to reverse the locking again; but no time now for
such concerns.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-oops-on-null-lru-list mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-oops-on-null-lru-list
+++ a/mm/memcontrol.c
@@ -623,13 +623,13 @@ retry:
 		goto retry;
 	}
 	page_assign_page_cgroup(page, pc);
-	unlock_page_cgroup(page);
 
 	mz = page_cgroup_zoneinfo(pc);
 	spin_lock_irqsave(&mz->lru_lock, flags);
 	__mem_cgroup_add_list(pc);
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
 
+	unlock_page_cgroup(page);
 done:
 	return 0;
 out:
@@ -677,14 +677,14 @@ void mem_cgroup_uncharge_page(struct pag
 	VM_BUG_ON(pc->ref_cnt <= 0);
 
 	if (--(pc->ref_cnt) == 0) {
-		page_assign_page_cgroup(page, NULL);
-		unlock_page_cgroup(page);
-
 		mz = page_cgroup_zoneinfo(pc);
 		spin_lock_irqsave(&mz->lru_lock, flags);
 		__mem_cgroup_remove_list(pc);
 		spin_unlock_irqrestore(&mz->lru_lock, flags);
 
+		page_assign_page_cgroup(page, NULL);
+		unlock_page_cgroup(page);
+
 		mem = pc->mem_cgroup;
 		res_counter_uncharge(&mem->res, PAGE_SIZE);
 		css_put(&mem->css);
@@ -736,23 +736,24 @@ void mem_cgroup_page_migration(struct pa
 		return;
 	}
 
-	page_assign_page_cgroup(page, NULL);
-	unlock_page_cgroup(page);
-
 	mz = page_cgroup_zoneinfo(pc);
 	spin_lock_irqsave(&mz->lru_lock, flags);
 	__mem_cgroup_remove_list(pc);
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
 
+	page_assign_page_cgroup(page, NULL);
+	unlock_page_cgroup(page);
+
 	pc->page = newpage;
 	lock_page_cgroup(newpage);
 	page_assign_page_cgroup(newpage, pc);
-	unlock_page_cgroup(newpage);
 
 	mz = page_cgroup_zoneinfo(pc);
 	spin_lock_irqsave(&mz->lru_lock, flags);
 	__mem_cgroup_add_list(pc);
 	spin_unlock_irqrestore(&mz->lru_lock, flags);
+
+	unlock_page_cgroup(newpage);
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

