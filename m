From: akpm@linux-foundation.org
Subject: + memcg-clean-up-swap-accounting-initialization-code.patch added to -mm tree
Date: Tue, 22 Jan 2013 16:31:44 -0800
Message-ID: <20130123003144.B2E2F5A4485@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:36321 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3AWAbq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 19:31:46 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so708246vcd.5
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 16:31:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, caiqian@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, rientjes@google.com, tj@kernel.org, zliu@redhat.com


The patch titled
     Subject: memcg: clean up swap accounting initialization code
has been added to the -mm tree.  Its filename is
     memcg-clean-up-swap-accounting-initialization-code.patch

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
Subject: memcg: clean up swap accounting initialization code

Memcg swap accounting is currently enabled by enable_swap_cgroup when the
root cgroup is created.  mem_cgroup_init acts as a memcg subsystem
initializer which sounds like a much better place for enable_swap_cgroup
as well.  We already register memsw files from there so it makes a lot of
sense to merge those two into a single enable_swap_cgroup function.

This patch doesn't introduce any semantic changes.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: Zhouping Liu <zliu@redhat.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: CAI Qian <caiqian@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff -puN mm/memcontrol.c~memcg-clean-up-swap-accounting-initialization-code mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clean-up-swap-accounting-initialization-code
+++ a/mm/memcontrol.c
@@ -6044,18 +6044,6 @@ struct mem_cgroup *parent_mem_cgroup(str
 }
 EXPORT_SYMBOL(parent_mem_cgroup);
 
-#ifdef CONFIG_MEMCG_SWAP
-static void __init enable_swap_cgroup(void)
-{
-	if (!mem_cgroup_disabled() && really_do_swap_account)
-		do_swap_account = 1;
-}
-#else
-static void __init enable_swap_cgroup(void)
-{
-}
-#endif
-
 static int mem_cgroup_soft_limit_tree_init(void)
 {
 	struct mem_cgroup_tree_per_node *rtpn;
@@ -6109,7 +6097,6 @@ mem_cgroup_css_alloc(struct cgroup *cont
 	/* root ? */
 	if (cont->parent == NULL) {
 		int cpu;
-		enable_swap_cgroup();
 		parent = NULL;
 		if (mem_cgroup_soft_limit_tree_init())
 			goto free_out;
@@ -6798,12 +6785,19 @@ __setup("swapaccount=", enable_swap_acco
 
 static void __init memsw_file_init(void)
 {
-	if (really_do_swap_account)
-		WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys,
-					memsw_cgroup_files));
+	WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys, memsw_cgroup_files));
+}
+
+static void __init enable_swap_cgroup(void)
+{
+	if (!mem_cgroup_disabled() && really_do_swap_account) {
+		do_swap_account = 1;
+		memsw_file_init();
+	}
 }
+
 #else
-static void __init memsw_file_init(void)
+static void __init enable_swap_cgroup(void)
 {
 }
 #endif
@@ -6817,7 +6811,7 @@ static void __init memsw_file_init(void)
 static int __init mem_cgroup_init(void)
 {
 	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
-	memsw_file_init();
+	enable_swap_cgroup();
 	return 0;
 }
 subsys_initcall(mem_cgroup_init);
_

Patches currently in -mm which might be from mhocko@suse.cz are

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
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix.patch
memory-hotplug-implement-register_page_bootmem_info_section-of-sparse-vmemmap-fix-fix-fix-fix.patch
memory-hotplug-remove-memmap-of-sparse-vmemmap-fix.patch
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
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

