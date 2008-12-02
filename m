From: akpm@linux-foundation.org
Subject: - memcg-memory-hotplug-fix-for-notifier-callback.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:38:17 -0800
Message-ID: <200812021838.mB2IcHKl006824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755AbYLBSij (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:38:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, pbadari@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: memory hotplug fix for notifier callback
has been removed from the -mm tree.  Its filename was
     memcg-memory-hotplug-fix-for-notifier-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: memory hotplug fix for notifier callback
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Fixes for memcg/memory hotplug.

While memory hotplug allocate/free memmap, page_cgroup doesn't free
page_cgroup at OFFLINE when page_cgroup is allocated via bootomem. 
(Because freeing bootmem requires special care.)

Then, if page_cgroup is allocated by bootmem and memmap is freed/allocated
by memory hotplug, page_cgroup->page == page is no longer true.

But current MEM_ONLINE handler doesn't check it and update
page_cgroup->page if it's not necessary to allocate page_cgroup.  (This
was not found because memmap is not freed if SPARSEMEM_VMEMMAP is y.)

And I noticed that MEM_ONLINE can be called against "part of section". 
So, freeing page_cgroup at CANCEL_ONLINE will cause trouble.  (freeing
used page_cgroup) Don't rollback at CANCEL.

One more, current memory hotplug notifier is stopped by slub because it
sets NOTIFY_STOP_MASK to return vaule.  So, page_cgroup's callback never
be called.  (low priority than slub now.)

I think this slub's behavior is not intentional(BUG). and fixes it.

Another way to be considered about page_cgroup allocation:
  - free page_cgroup at OFFLINE even if it's from bootmem
    and remove specieal handler. But it requires more changes.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=12041

Signed-off-by: KAMEZAWA Hiruyoki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Tested-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |   43 +++++++++++++++++++++++++++++--------------
 mm/slub.c        |    6 ++++--
 2 files changed, 33 insertions(+), 16 deletions(-)

diff -puN mm/page_cgroup.c~memcg-memory-hotplug-fix-for-notifier-callback mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-memory-hotplug-fix-for-notifier-callback
+++ a/mm/page_cgroup.c
@@ -107,19 +107,29 @@ int __init_refok init_section_page_cgrou
 
 	section = __pfn_to_section(pfn);
 
-	if (section->page_cgroup)
-		return 0;
-
-	nid = page_to_nid(pfn_to_page(pfn));
-
-	table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-	if (slab_is_available()) {
-		base = kmalloc_node(table_size, GFP_KERNEL, nid);
-		if (!base)
-			base = vmalloc_node(table_size, nid);
-	} else {
-		base = __alloc_bootmem_node_nopanic(NODE_DATA(nid), table_size,
+	if (!section->page_cgroup) {
+		nid = page_to_nid(pfn_to_page(pfn));
+		table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
+		if (slab_is_available()) {
+			base = kmalloc_node(table_size, GFP_KERNEL, nid);
+			if (!base)
+				base = vmalloc_node(table_size, nid);
+		} else {
+			base = __alloc_bootmem_node_nopanic(NODE_DATA(nid),
+				table_size,
 				PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+		}
+	} else {
+		/*
+ 		 * We don't have to allocate page_cgroup again, but
+		 * address of memmap may be changed. So, we have to initialize
+		 * again.
+		 */
+		base = section->page_cgroup + pfn;
+		table_size = 0;
+		/* check address of memmap is changed or not. */
+		if (base->page == pfn_to_page(pfn))
+			return 0;
 	}
 
 	if (!base) {
@@ -208,18 +218,23 @@ static int __meminit page_cgroup_callbac
 		ret = online_page_cgroup(mn->start_pfn,
 				   mn->nr_pages, mn->status_change_nid);
 		break;
-	case MEM_CANCEL_ONLINE:
 	case MEM_OFFLINE:
 		offline_page_cgroup(mn->start_pfn,
 				mn->nr_pages, mn->status_change_nid);
 		break;
+	case MEM_CANCEL_ONLINE:
 	case MEM_GOING_OFFLINE:
 		break;
 	case MEM_ONLINE:
 	case MEM_CANCEL_OFFLINE:
 		break;
 	}
-	ret = notifier_from_errno(ret);
+
+	if (ret)
+		ret = notifier_from_errno(ret);
+	else
+		ret = NOTIFY_OK;
+
 	return ret;
 }
 
diff -puN mm/slub.c~memcg-memory-hotplug-fix-for-notifier-callback mm/slub.c
--- a/mm/slub.c~memcg-memory-hotplug-fix-for-notifier-callback
+++ a/mm/slub.c
@@ -2931,8 +2931,10 @@ static int slab_memory_callback(struct n
 	case MEM_CANCEL_OFFLINE:
 		break;
 	}
-
-	ret = notifier_from_errno(ret);
+	if (ret)
+		ret = notifier_from_errno(ret);
+	else
+		ret = NOTIFY_OK;
 	return ret;
 }
 
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
cpuset-rcu_read_lock-to-protect-task_cs.patch

