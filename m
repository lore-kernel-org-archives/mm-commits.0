From: akpm@linux-foundation.org
Subject: - memcg-explain-details-and-test-document-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:18:06 -0800
Message-ID: <200901072318.n07NI7B1002409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763408AbZAGXSg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:18:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: update document for memcg details.
has been removed from the -mm tree.  Its filename was
     memcg-explain-details-and-test-document-fix.patch

This patch was dropped because it was folded into memcg-explain-details-and-test-document.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: update document for memcg details.
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Update/Fix document about implementation details of memcg.

Changelog:
  - Fixed typo and bad texts.
  - removed changes to memcontrol.c

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memcg_test.txt |  240 +++++++++++++++++----
 1 file changed, 203 insertions(+), 37 deletions(-)

diff -puN Documentation/controllers/memcg_test.txt~memcg-explain-details-and-test-document-fix Documentation/controllers/memcg_test.txt
--- a/Documentation/controllers/memcg_test.txt~memcg-explain-details-and-test-document-fix
+++ a/Documentation/controllers/memcg_test.txt
@@ -1,59 +1,76 @@
 Memory Resource Controller(Memcg)  Implementation Memo.
-Last Updated: 2009/12/03
+Last Updated: 2008/12/10
+Base Kernel Version: based on 2.6.28-rc7-mm.
 
 Because VM is getting complex (one of reasons is memcg...), memcg's behavior
-is complex. This is a document for memcg's internal behavior and some test
-patterns tend to be racy.
+is complex. This is a document for memcg's internal behavior.
+Please note that implementation details can be changed.
 
-1. charges
+(*) Topics on API should be in Documentation/controllers/memory.txt)
+
+0. How to record usage ?
+   2 objects are used.
+
+   page_cgroup ....an object per page.
+	Allocated at boot or memory hotplug. Freed at memory hot removal.
+
+   swap_cgroup ... an entry per swp_entry.
+	Allocated at swapon(). Freed at swapoff().
+
+   The page_cgroup has USED bit and double count against a page_cgroup never
+   occurs. swap_cgroup is used only when a charged page is swapped-out.
+
+1. Charge
 
    a page/swp_entry may be charged (usage += PAGE_SIZE) at
 
-	mem_cgroup_newpage_newpage()
-	  called at new page fault and COW.
+	mem_cgroup_newpage_charge()
+	  Called at new page fault and Copy-On-Write.
 
 	mem_cgroup_try_charge_swapin()
-	  called at do_swap_page() and swapoff.
-	  followed by charge-commit-cancel protocol.
-	  (With swap accounting) at commit, charges recorded in swap is removed.
+	  Called at do_swap_page() (page fault on swap entry) and swapoff.
+	  Followed by charge-commit-cancel protocol. (With swap accounting)
+	  At commit, a charge recorded in swap_cgroup is removed.
 
 	mem_cgroup_cache_charge()
-	  called at add_to_page_cache()
+	  Called at add_to_page_cache()
 
-	mem_cgroup_cache_charge_swapin)()
-	  called by shmem's swapin processing.
+	mem_cgroup_cache_charge_swapin()
+	  Called at shmem's swapin.
 
 	mem_cgroup_prepare_migration()
-	  called before migration. "extra" charge is done
-	  followed by charge-commit-cancel protocol.
+	  Called before migration. "extra" charge is done and followed by
+	  charge-commit-cancel protocol.
 	  At commit, charge against oldpage or newpage will be committed.
 
-2. uncharge
+2. Uncharge
   a page/swp_entry may be uncharged (usage -= PAGE_SIZE) by
 
 	mem_cgroup_uncharge_page()
-	  called when an anonymous page is unmapped. If the page is SwapCache
-	  uncharge is delayed until mem_cgroup_uncharge_swapcache().
+	  Called when an anonymous page is fully unmapped. I.e., mapcount goes
+	  to 0. If the page is SwapCache, uncharge is delayed until
+	  mem_cgroup_uncharge_swapcache().
 
 	mem_cgroup_uncharge_cache_page()
-	  called when a page-cache is deleted from radix-tree. If the page is
-	  SwapCache, uncharge is delayed until mem_cgroup_uncharge_swapcache()
+	  Called when a page-cache is deleted from radix-tree. If the page is
+	  SwapCache, uncharge is delayed until mem_cgroup_uncharge_swapcache().
 
 	mem_cgroup_uncharge_swapcache()
-	  called when SwapCache is removed from radix-tree. the charge itself
+	  Called when SwapCache is removed from radix-tree. The charge itself
 	  is moved to swap_cgroup. (If mem+swap controller is disabled, no
-	  charge to swap.)
+	  charge to swap occurs.)
 
 	mem_cgroup_uncharge_swap()
-	  called when swp_entry's refcnt goes down to be 0. charge against swap
+	  Called when swp_entry's refcnt goes down to 0. A charge against swap
 	  disappears.
 
 	mem_cgroup_end_migration(old, new)
-	at success of migration -> old is uncharged (if necessary), charge
-	to new is committed. at failure, charge to old is committed.
+	At success of migration old is uncharged (if necessary), a charge
+	to new page is committed. At failure, charge to old page is committed.
 
 3. charge-commit-cancel
-	In some case, we can't know this "charge" is valid or not at charge.
+	In some case, we can't know this "charge" is valid or not at charging
+	(because of races).
 	To handle such case, there are charge-commit-cancel functions.
 		mem_cgroup_try_charge_XXX
 		mem_cgroup_commit_charge_XXX
@@ -68,24 +85,164 @@ patterns tend to be racy.
 
 	At cancel(), simply usage -= PAGE_SIZE.
 
-4. Typical Tests.
+Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
+
+4. Anonymous
+	Anonymous page is newly allocated at
+		  - page fault into MAP_ANONYMOUS mapping.
+		  - Copy-On-Write.
+ 	It is charged right after it's allocated before doing any page table
+	related operations. Of course, it's uncharged when another page is used
+	for the fault address.
+
+	At freeing anonymous page (by exit() or munmap()), zap_pte() is called
+	and pages for ptes are freed one by one.(see mm/memory.c). Uncharges
+	are done at page_remove_rmap() when page_mapcount() goes down to 0.
+
+	Another page freeing is by page-reclaim (vmscan.c) and anonymous
+	pages are swapped out. In this case, the page is marked as
+	PageSwapCache(). uncharge() routine doesn't uncharge the page marked
+	as SwapCache(). It's delayed until __delete_from_swap_cache().
+
+	4.1 Swap-in.
+	At swap-in, the page is taken from swap-cache. There are 2 cases.
+
+	(a) If the SwapCache is newly allocated and read, it has no charges.
+	(b) If the SwapCache has been mapped by processes, it has been
+	    charged already.
+
+	In case (a), we charge it. In case (b), we don't charge it.
+	(But racy state between (a) and (b) exists. We do check it.)
+	At charging, a charge recorded in swap_cgroup is moved to page_cgroup.
+
+	4.2 Swap-out.
+	At swap-out, typical state transition is below.
+
+	(a) add to swap cache. (marked as SwapCache)
+	    swp_entry's refcnt += 1.
+	(b) fully unmapped.
+	    swp_entry's refcnt += # of ptes.
+	(c) write back to swap.
+	(d) delete from swap cache. (remove from SwapCache)
+	    swp_entry's refcnt -= 1.
+
+
+	At (b), the page is marked as SwapCache and not uncharged.
+	At (d), the page is removed from SwapCache and a charge in page_cgroup
+	is moved to swap_cgroup.
+
+	Finally, at task exit,
+	(e) zap_pte() is called and swp_entry's refcnt -=1 -> 0.
+	Here, a charge in swap_cgroup disappears.
+
+5. Page Cache
+   	Page Cache is charged at
+	- add_to_page_cache_locked().
+
+	uncharged at
+	- __remove_from_page_cache().
+
+	The logic is very clear. (About migration, see below)
+	Note: __remove_from_page_cache() is called by remove_from_page_cache()
+	and __remove_mapping().
+
+6. Shmem(tmpfs) Page Cache
+	Memcg's charge/uncharge have special handlers of shmem. The best way
+	to understand shmem's page state transition is to read mm/shmem.c.
+	But brief explanation of the behavior of memcg around shmem will be
+	helpful to understand the logic.
+
+	Shmem's page (just leaf page, not direct/indirect block) can be on
+		- radix-tree of shmem's inode.
+		- SwapCache.
+		- Both on radix-tree and SwapCache. This happens at swap-in
+		  and swap-out,
+
+	It's charged when...
+	- A new page is added to shmem's radix-tree.
+	- A swp page is read. (move a charge from swap_cgroup to page_cgroup)
+	It's uncharged when
+	- A page is removed from radix-tree and not SwapCache.
+	- When SwapCache is removed, a charge is moved to swap_cgroup.
+	- When swp_entry's refcnt goes down to 0, a charge in swap_cgroup
+	  disappears.
 
-  Tests for racy cases.
+7. Page Migration
+   	One of the most complicated functions is page-migration-handler.
+	Memcg has 2 routines. Assume that we are migrating a page's contents
+	from OLDPAGE to NEWPAGE.
+
+	Usual migration logic is..
+	(a) remove the page from LRU.
+	(b) allocate NEWPAGE (migration target)
+	(c) lock by lock_page().
+	(d) unmap all mappings.
+	(e-1) If necessary, replace entry in radix-tree.
+	(e-2) move contents of a page.
+	(f) map all mappings again.
+	(g) pushback the page to LRU.
+	(-) OLDPAGE will be freed.
+
+	Before (g), memcg should complete all necessary charge/uncharge to
+	NEWPAGE/OLDPAGE.
+
+	The point is....
+	- If OLDPAGE is anonymous, all charges will be dropped at (d) because
+          try_to_unmap() drops all mapcount and the page will not be
+	  SwapCache.
+
+	- If OLDPAGE is SwapCache, charges will be kept at (g) because
+	  __delete_from_swap_cache() isn't called at (e-1)
+
+	- If OLDPAGE is page-cache, charges will be kept at (g) because
+	  remove_from_swap_cache() isn't called at (e-1)
+
+	memcg provides following hooks.
+
+	- mem_cgroup_prepare_migration(OLDPAGE)
+	  Called after (b) to account a charge (usage += PAGE_SIZE) against
+	  memcg which OLDPAGE belongs to.
+
+        - mem_cgroup_end_migration(OLDPAGE, NEWPAGE)
+	  Called after (f) before (g).
+	  If OLDPAGE is used, commit OLDPAGE again. If OLDPAGE is already
+	  charged, a charge by prepare_migration() is automatically canceled.
+	  If NEWPAGE is used, commit NEWPAGE and uncharge OLDPAGE.
+
+	  But zap_pte() (by exit or munmap) can be called while migration,
+	  we have to check if OLDPAGE/NEWPAGE is a valid page after commit().
+
+8. LRU
+        Each memcg has its own private LRU. Now, it's handling is under global
+	VM's control (means that it's handled under global zone->lru_lock).
+	Almost all routines around memcg's LRU is called by global LRU's
+	list management functions under zone->lru_lock().
+
+	A special function is mem_cgroup_isolate_pages(). This scans
+	memcg's private LRU and call __isolate_lru_page() to extract a page
+	from LRU.
+	(By __isolate_lru_page(), the page is removed from both of global and
+	 private LRU.)
 
-  4.1 small limit to memcg.
+
+9. Typical Tests.
+
+ Tests for racy cases.
+
+ 9.1 Small limit to memcg.
 	When you do test to do racy case, it's good test to set memcg's limit
 	to be very small rather than GB. Many races found in the test under
 	xKB or xxMB limits.
 	(Memory behavior under GB and Memory behavior under MB shows very
 	 different situation.)
 
-  4.2 shmem
+ 9.2 Shmem
 	Historically, memcg's shmem handling was poor and we saw some amount
 	of troubles here. This is because shmem is page-cache but can be
 	SwapCache. Test with shmem/tmpfs is always good test.
 
-  4.3 migration
-	For NUMA, migration is an another special. To do easy test, cpuset
+ 9.3 Migration
+	For NUMA, migration is an another special case. To do easy test, cpuset
 	is useful. Following is a sample script to do migration.
 
 	mount -t cgroup -o cpuset none /opt/cpuset
@@ -118,20 +275,20 @@ patterns tend to be racy.
 	G2_TASK=`cat ${G2}/tasks`
 	move_task "${G1_TASK}" ${G2} &
 	--
-  4.4 memory hotplug.
+ 9.4 Memory hotplug.
 	memory hotplug test is one of good test.
 	to offline memory, do following.
 	# echo offline > /sys/devices/system/memory/memoryXXX/state
 	(XXX is the place of memory)
 	This is an easy way to test page migration, too.
 
- 4.5 mkdir/rmdir
+ 9.5 mkdir/rmdir
 	When using hierarchy, mkdir/rmdir test should be done.
-	tests like following.
+	Use tests like the following.
 
-	#echo 1 >/opt/cgroup/01/memory/use_hierarchy
-	#mkdir /opt/cgroup/01/child_a
-	#mkdir /opt/cgroup/01/child_b
+	echo 1 >/opt/cgroup/01/memory/use_hierarchy
+	mkdir /opt/cgroup/01/child_a
+	mkdir /opt/cgroup/01/child_b
 
 	set limit to 01.
 	add limit to 01/child_b
@@ -143,3 +300,12 @@ patterns tend to be racy.
 	/opt/cgroup/01/child_c
 
 	running new jobs in new group is also good.
+
+ 9.6 Mount with other subsystems.
+	Mounting with other subsystems is a good test because there is a
+	race and lock dependency with other cgroup subsystems.
+
+	example)
+	# mount -t cgroup none /cgroup -t cpuset,memory,cpu,devices
+
+	and do task move, mkdir, rmdir etc...under this.
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroups-make-cgroup-config-a-submenu.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-add-lock-for-child-cgroups-in-cgroup_post_fork.patch
cgroups-fix-cgroup_iter_next-bug.patch
cgroups-dont-put-struct-cgroupfs_root-protected-by-rcu.patch
cgroups-use-task_lock-for-access-tsk-cgroups-safe-in-cgroup_clone.patch
cgroups-call-find_css_set-safely-in-cgroup_attach_task.patch
cgroups-remove-rcu_read_lock-in-cgroupstats_build.patch
cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
devcgroup-use-list_for_each_entry_rcu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-fix-reclaim-result-checks.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
memcg-explain-details-and-test-document-fix.patch
memcg-dont-trigger-oom-at-page-migration.patch
memcg-remove-mem_cgroup_try_charge.patch
memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach.patch
memcg-change-try_to_free_pages-to-hierarchical_reclaim.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-double-free-and-make-refcnt-sane.patch
memcg-use-css_tryget-in-memcg.patch
memcg-use-css_tryget-in-memcg-fix.patch
memcg-fix-lru-accounting-for-swapcache-v2.patch
memcg-fix-shmems-swap-accounting.patch
cgroups-add-a-per-subsystem-hierarchy_mutex.patch
cgroups-use-hierarchy_mutex-in-memory-controller.patch
cgroups-add-css_tryget.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch

