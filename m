From: akpm@linux-foundation.org
Subject: + memcg-explain-details-and-test-document.patch added to -mm tree
Date: Tue, 02 Dec 2008 21:58:29 -0800
Message-ID: <200812030558.mB35wUum029662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752091AbYLCF7O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 00:59:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: explain details and test document
has been added to the -mm tree.  Its filename is
     memcg-explain-details-and-test-document.patch

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
Subject: memcg: explain details and test document
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Documentation for implementation details and how to test.

Just an example. feel free to modify, add, remove lines.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memcg_test.txt |  145 +++++++++++++++++++++
 1 file changed, 145 insertions(+)

diff -puN /dev/null Documentation/controllers/memcg_test.txt
--- /dev/null
+++ a/Documentation/controllers/memcg_test.txt
@@ -0,0 +1,145 @@
+Memory Resource Controller(Memcg)  Implementation Memo.
+Last Updated: 2009/12/03
+
+Because VM is getting complex (one of reasons is memcg...), memcg's behavior
+is complex. This is a document for memcg's internal behavior and some test
+patterns tend to be racy.
+
+1. charges
+
+   a page/swp_entry may be charged (usage += PAGE_SIZE) at
+
+	mem_cgroup_newpage_newpage()
+	  called at new page fault and COW.
+
+	mem_cgroup_try_charge_swapin()
+	  called at do_swap_page() and swapoff.
+	  followed by charge-commit-cancel protocol.
+	  (With swap accounting) at commit, charges recorded in swap is removed.
+
+	mem_cgroup_cache_charge()
+	  called at add_to_page_cache()
+
+	mem_cgroup_cache_charge_swapin)()
+	  called by shmem's swapin processing.
+
+	mem_cgroup_prepare_migration()
+	  called before migration. "extra" charge is done
+	  followed by charge-commit-cancel protocol.
+	  At commit, charge against oldpage or newpage will be committed.
+
+2. uncharge
+  a page/swp_entry may be uncharged (usage -= PAGE_SIZE) by
+
+	mem_cgroup_uncharge_page()
+	  called when an anonymous page is unmapped. If the page is SwapCache
+	  uncharge is delayed until mem_cgroup_uncharge_swapcache().
+
+	mem_cgroup_uncharge_cache_page()
+	  called when a page-cache is deleted from radix-tree. If the page is
+	  SwapCache, uncharge is delayed until mem_cgroup_uncharge_swapcache()
+
+	mem_cgroup_uncharge_swapcache()
+	  called when SwapCache is removed from radix-tree. the charge itself
+	  is moved to swap_cgroup. (If mem+swap controller is disabled, no
+	  charge to swap.)
+
+	mem_cgroup_uncharge_swap()
+	  called when swp_entry's refcnt goes down to be 0. charge against swap
+	  disappears.
+
+	mem_cgroup_end_migration(old, new)
+	at success of migration -> old is uncharged (if necessary), charge
+	to new is committed. at failure, charge to old is committed.
+
+3. charge-commit-cancel
+	In some case, we can't know this "charge" is valid or not at charge.
+	To handle such case, there are charge-commit-cancel functions.
+		mem_cgroup_try_charge_XXX
+		mem_cgroup_commit_charge_XXX
+		mem_cgroup_cancel_charge_XXX
+	these are used in swap-in and migration.
+
+	At try_charge(), there are no flags to say "this page is charged".
+	at this point, usage += PAGE_SIZE.
+
+	At commit(), the function checks the page should be charged or not
+	and set flags or avoid charging.(usage -= PAGE_SIZE)
+
+	At cancel(), simply usage -= PAGE_SIZE.
+
+4. Typical Tests.
+
+  Tests for racy cases.
+
+  4.1 small limit to memcg.
+	When you do test to do racy case, it's good test to set memcg's limit
+	to be very small rather than GB. Many races found in the test under
+	xKB or xxMB limits.
+	(Memory behavior under GB and Memory behavior under MB shows very
+	 different situation.)
+
+  4.2 shmem
+	Historically, memcg's shmem handling was poor and we saw some amount
+	of troubles here. This is because shmem is page-cache but can be
+	SwapCache. Test with shmem/tmpfs is always good test.
+
+  4.3 migration
+	For NUMA, migration is an another special. To do easy test, cpuset
+	is useful. Following is a sample script to do migration.
+
+	mount -t cgroup -o cpuset none /opt/cpuset
+
+	mkdir /opt/cpuset/01
+	echo 1 > /opt/cpuset/01/cpuset.cpus
+	echo 0 > /opt/cpuset/01/cpuset.mems
+	echo 1 > /opt/cpuset/01/cpuset.memory_migrate
+	mkdir /opt/cpuset/02
+	echo 1 > /opt/cpuset/02/cpuset.cpus
+	echo 1 > /opt/cpuset/02/cpuset.mems
+	echo 1 > /opt/cpuset/02/cpuset.memory_migrate
+
+	In above set, when you moves a task from 01 to 02, page migration to
+	node 0 to node 1 will occur. Following is a script to migrate all
+	under cpuset.
+	--
+	move_task()
+	{
+	for pid in $1
+        do
+                /bin/echo $pid >$2/tasks 2>/dev/null
+		echo -n $pid
+		echo -n " "
+        done
+	echo END
+	}
+
+	G1_TASK=`cat ${G1}/tasks`
+	G2_TASK=`cat ${G2}/tasks`
+	move_task "${G1_TASK}" ${G2} &
+	--
+  4.4 memory hotplug.
+	memory hotplug test is one of good test.
+	to offline memory, do following.
+	# echo offline > /sys/devices/system/memory/memoryXXX/state
+	(XXX is the place of memory)
+	This is an easy way to test page migration, too.
+
+ 4.5 mkdir/rmdir
+	When using hierarchy, mkdir/rmdir test should be done.
+	tests like following.
+
+	#echo 1 >/opt/cgroup/01/memory/use_hierarchy
+	#mkdir /opt/cgroup/01/child_a
+	#mkdir /opt/cgroup/01/child_b
+
+	set limit to 01.
+	add limit to 01/child_b
+	run jobs under child_a and child_b
+
+	create/delete following groups at random while jobs are running.
+	/opt/cgroup/01/child_a/child_aa
+	/opt/cgroup/01/child_b/child_bb
+	/opt/cgroup/01/child_c
+
+	running new jobs in new group is also good.
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

vmscan-evict-streaming-io-first.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
swapfile-swapon-needs-larger-size-type.patch
swapfile-remove-swp_active-mask.patch
swapfile-remove-surplus-whitespace.patch
swapfile-remove-v0-swap-space-message.patch
swapfile-rearrange-scan-and-swap_info.patch
swapfile-swapon-use-discard-trim.patch
swapfile-swap-allocation-use-discard.patch
swapfile-swapon-randomize-if-nonrot.patch
swapfile-swap-allocation-cycle-if-nonrot.patch
swapfile-change-discard-pgoff_t-to-sector_t.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
swapfile-let-others-seed-random.patch
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
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcontrol-rcu_read_lock-to-protect-mm_match_cgroup.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
memcg-fix-reclaim-result-checks.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
cpuset-rcu_read_lock-to-protect-task_cs.patch

