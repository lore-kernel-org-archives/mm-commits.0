From: akpm@linux-foundation.org
Subject: - memcg-fix-vm_bug_on-from-page-migration.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:17 -0800
Message-ID: <200803050745.m257jH6B021581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757325AbYCEHwa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:52:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: fix VM_BUG_ON from page migration
has been removed from the -mm tree.  Its filename was
     memcg-fix-vm_bug_on-from-page-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix VM_BUG_ON from page migration
From: Hugh Dickins <hugh@veritas.com>

Page migration gave me free_hot_cold_page's VM_BUG_ON page->page_cgroup. 
remove_migration_pte was calling mem_cgroup_charge on the new page whenever it
found a swap pte, before it had determined it to be a migration entry.  That
left a surplus reference count on the page_cgroup, so it was still attached
when the page was later freed.

Move that mem_cgroup_charge down to where we're sure it's a migration entry. 
We were already under i_mmap_lock or anon_vma->lock, so its GFP_KERNEL was
already inappropriate: change that to GFP_ATOMIC.

It's essential that remove_migration_pte removes all the migration entries,
other crashes follow if not.  So proceed even when the charge fails: normally
it cannot, but after a mem_cgroup_force_empty it might - comment in the code.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN mm/migrate.c~memcg-fix-vm_bug_on-from-page-migration mm/migrate.c
--- a/mm/migrate.c~memcg-fix-vm_bug_on-from-page-migration
+++ a/mm/migrate.c
@@ -153,11 +153,6 @@ static void remove_migration_pte(struct 
  		return;
  	}
 
-	if (mem_cgroup_charge(new, mm, GFP_KERNEL)) {
-		pte_unmap(ptep);
-		return;
-	}
-
  	ptl = pte_lockptr(mm, pmd);
  	spin_lock(ptl);
 	pte = *ptep;
@@ -169,6 +164,20 @@ static void remove_migration_pte(struct 
 	if (!is_migration_entry(entry) || migration_entry_to_page(entry) != old)
 		goto out;
 
+	/*
+	 * Yes, ignore the return value from a GFP_ATOMIC mem_cgroup_charge.
+	 * Failure is not an option here: we're now expected to remove every
+	 * migration pte, and will cause crashes otherwise.  Normally this
+	 * is not an issue: mem_cgroup_prepare_migration bumped up the old
+	 * page_cgroup count for safety, that's now attached to the new page,
+	 * so this charge should just be another incrementation of the count,
+	 * to keep in balance with rmap.c's mem_cgroup_uncharging.  But if
+	 * there's been a force_empty, those reference counts may no longer
+	 * be reliable, and this charge can actually fail: oh well, we don't
+	 * make the situation any worse by proceeding as if it had succeeded.
+	 */
+	mem_cgroup_charge(new, mm, GFP_ATOMIC);
+
 	get_page(new);
 	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
 	if (is_write_migration_entry(entry))
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

