From: akpm@linux-foundation.org
Subject: + memcg-move-mem_cgroup_soft_limit_tree_init-to-mem_cgroup_init.patch added to -mm tree
Date: Tue, 05 Feb 2013 14:01:53 -0800
Message-ID: <20130205220154.4A9AF31C20C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:61400 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab3BEWB4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 17:01:56 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so33025ggi.5
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 14:01:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, hannes@cmpxchg.org, htejun@gmail.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     Subject: memcg: move mem_cgroup_soft_limit_tree_init to mem_cgroup_init
has been added to the -mm tree.  Its filename is
     memcg-move-mem_cgroup_soft_limit_tree_init-to-mem_cgroup_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: move mem_cgroup_soft_limit_tree_init to mem_cgroup_init

Per-node-zone soft limit tree is currently initialized when the root
cgroup is created which is OK but it pointlessly pollutes memcg allocation
code with something that can be called when the memcg subsystem is
initialized by mem_cgroup_init along with other controller specific parts.

While we are at it let's make mem_cgroup_soft_limit_tree_init void because
it doesn't make much sense to report memory failure because if we fail to
allocate memory that early during the boot then we are screwed anyway
(this saves some code).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff -puN mm/memcontrol.c~memcg-move-mem_cgroup_soft_limit_tree_init-to-mem_cgroup_init mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-move-mem_cgroup_soft_limit_tree_init-to-mem_cgroup_init
+++ a/mm/memcontrol.c
@@ -6051,7 +6051,7 @@ struct mem_cgroup *parent_mem_cgroup(str
 }
 EXPORT_SYMBOL(parent_mem_cgroup);
 
-static int mem_cgroup_soft_limit_tree_init(void)
+static void __init mem_cgroup_soft_limit_tree_init(void)
 {
 	struct mem_cgroup_tree_per_node *rtpn;
 	struct mem_cgroup_tree_per_zone *rtpz;
@@ -6062,8 +6062,7 @@ static int mem_cgroup_soft_limit_tree_in
 		if (!node_state(node, N_NORMAL_MEMORY))
 			tmp = -1;
 		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, tmp);
-		if (!rtpn)
-			goto err_cleanup;
+		BUG_ON(!rtpn);
 
 		soft_limit_tree.rb_tree_per_node[node] = rtpn;
 
@@ -6073,17 +6072,6 @@ static int mem_cgroup_soft_limit_tree_in
 			spin_lock_init(&rtpz->lock);
 		}
 	}
-	return 0;
-
-err_cleanup:
-	for_each_node(node) {
-		if (!soft_limit_tree.rb_tree_per_node[node])
-			break;
-		kfree(soft_limit_tree.rb_tree_per_node[node]);
-		soft_limit_tree.rb_tree_per_node[node] = NULL;
-	}
-	return 1;
-
 }
 
 static struct cgroup_subsys_state * __ref
@@ -6105,8 +6093,6 @@ mem_cgroup_css_alloc(struct cgroup *cont
 	if (cont->parent == NULL) {
 		int cpu;
 
-		if (mem_cgroup_soft_limit_tree_init())
-			goto free_out;
 		root_mem_cgroup = memcg;
 		for_each_possible_cpu(cpu) {
 			struct memcg_stock_pcp *stock =
@@ -6849,6 +6835,7 @@ static int __init mem_cgroup_init(void)
 {
 	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
 	enable_swap_cgroup();
+	mem_cgroup_soft_limit_tree_init();
 	return 0;
 }
 subsys_initcall(mem_cgroup_init);
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
linux-next.patch
memcg-oom-provide-more-precise-dump-info-while-memcg-oom-happening.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap-fix.patch
acpi-memory-hotplug-parse-srat-before-memblock-is-ready-fix.patch
mm-use-zone-present_pages-instead-of-zone-managed_pages-where-appropriate.patch
mm-set-zone-present_pages-to-number-of-existing-pages-in-the-zone.patch
mm-increase-totalram_pages-when-free-pages-allocated-by-bootmem-allocator.patch
mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation.patch
pm-runtime-introduce-pm_runtime_set_memalloc_noio.patch
block-genhdc-apply-pm_runtime_set_memalloc_noio-on-block-devices.patch
net-core-apply-pm_runtime_set_memalloc_noio-on-network-devices.patch
pm-runtime-force-memory-allocation-with-no-i-o-during-runtime-pm-callbcack.patch
usb-forbid-memory-allocation-with-i-o-during-bus-reset.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
mm-refactor-inactive_file_is_low-to-use-get_lru_size.patch
memcg-move-mem_cgroup_soft_limit_tree_init-to-mem_cgroup_init.patch
memcg-move-memcg_stock-initialization-to-mem_cgroup_init.patch
memcg-cleanup-mem_cgroup_init-comment.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

