From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Wed, 14 Dec 2016 11:22:27 -0800
Message-ID: <58519bf3.p4KJWlOD5bdMIlI9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756469AbcLNTW2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:22:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c        |   21 +++++++++++++++++----
 mm/filemap.c    |    5 ++---
 mm/memcontrol.c |   11 ++++++-----
 3 files changed, 25 insertions(+), 12 deletions(-)

diff -puN fs/dax.c~linux-next-rejects fs/dax.c
--- a/fs/dax.c~linux-next-rejects
+++ a/fs/dax.c
@@ -560,22 +560,35 @@ static void *dax_insert_mapping_entry(st
 		error = radix_tree_preload(vmf->gfp_mask & ~__GFP_HIGHMEM);
 		if (error)
 			return ERR_PTR(error);
+	} else if (dax_is_zero_entry(entry) && !(flags & RADIX_DAX_HZP)) {
+		/* replacing huge zero page with PMD block mapping */
+		unmap_mapping_range(mapping,
+			(vmf->pgoff << PAGE_SHIFT) & PMD_MASK, PMD_SIZE, 0);
 	}
 
 	spin_lock_irq(&mapping->tree_lock);
-	new_entry = (void *)((unsigned long)RADIX_DAX_ENTRY(sector, false) |
-		       RADIX_DAX_ENTRY_LOCK);
+	new_entry = dax_radix_locked_entry(sector, flags);
+
 	if (hole_fill) {
 		__delete_from_page_cache(entry, NULL);
 		/* Drop pagecache reference */
 		put_page(entry);
-		error = radix_tree_insert(page_tree, index, new_entry);
+		error = __radix_tree_insert(page_tree, index,
+				dax_radix_order(new_entry), new_entry);
 		if (error) {
 			new_entry = ERR_PTR(error);
 			goto unlock;
 		}
 		mapping->nrexceptional++;
-	} else {
+	} else if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
+		/*
+		 * Only swap our new entry into the radix tree if the current
+		 * entry is a zero page or an empty entry.  If a normal PTE or
+		 * PMD entry is already in the tree, we leave it alone.  This
+		 * means that if we are trying to insert a PTE and the
+		 * existing entry is a PMD, we will just leave the PMD in the
+		 * tree and dirty it if necessary.
+		 */
 		struct radix_tree_node *node;
 		void **slot;
 		void *ret;
diff -puN mm/filemap.c~linux-next-rejects mm/filemap.c
--- a/mm/filemap.c~linux-next-rejects
+++ a/mm/filemap.c
@@ -135,10 +135,9 @@ static int page_cache_tree_insert(struct
 		} else {
 			/* DAX can replace empty locked entry with a hole */
 			WARN_ON_ONCE(p !=
-				(void *)(RADIX_TREE_EXCEPTIONAL_ENTRY |
-					 RADIX_DAX_ENTRY_LOCK));
+				dax_radix_locked_entry(0, RADIX_DAX_EMPTY));
 			/* Wakeup waiters for exceptional entry lock */
-			dax_wake_mapping_entry_waiter(mapping, page->index,
+			dax_wake_mapping_entry_waiter(mapping, page->index, p,
 						      false);
 		}
 	}
diff -puN mm/memcontrol.c~linux-next-rejects mm/memcontrol.c
--- a/mm/memcontrol.c~linux-next-rejects
+++ a/mm/memcontrol.c
@@ -5767,10 +5767,10 @@ __setup("cgroup.memory=", cgroup_memory)
 /*
  * subsys_initcall() for memory controller.
  *
- * Some parts like hotcpu_notifier() have to be initialized from this context
- * because of lock dependencies (cgroup_lock -> cpu hotplug) but basically
- * everything that doesn't depend on a specific mem_cgroup structure should
- * be initialized from here.
+ * Some parts like memcg_hotplug_cpu_dead() have to be initialized from this
+ * context because of lock dependencies (cgroup_lock -> cpu hotplug) but
+ * basically everything that doesn't depend on a specific mem_cgroup structure
+ * should be initialized from here.
  */
 static int __init mem_cgroup_init(void)
 {
@@ -5787,7 +5787,8 @@ static int __init mem_cgroup_init(void)
 	BUG_ON(!memcg_kmem_cache_create_wq);
 #endif
 
-	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
+	cpuhp_setup_state_nocalls(CPUHP_MM_MEMCQ_DEAD, "mm/memctrl:dead", NULL,
+				  memcg_hotplug_cpu_dead);
 
 	for_each_possible_cpu(cpu)
 		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

