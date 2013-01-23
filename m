From: akpm@linux-foundation.org
Subject: + memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch added to -mm tree
Date: Tue, 22 Jan 2013 16:30:59 -0800
Message-ID: <20130123003100.534CD5A4486@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:46800 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3AWAbB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jan 2013 19:31:01 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so379678ghb.0
        for <mm-commits@vger.kernel.org>; Tue, 22 Jan 2013 16:31:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, caiqian@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, rientjes@google.com, tj@kernel.org, zliu@redhat.com


The patch titled
     Subject: memcg: do not create memsw files if swap accounting is disabled
has been added to the -mm tree.  Its filename is
     memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch

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
Subject: memcg: do not create memsw files if swap accounting is disabled

Zhouping Liu has reported that memsw files are exported even though swap
accounting is runtime disabled if CONFIG_MEMCG_SWAP is enabled.  This
behavior has been introduced by af36f906 (memcg: always create memsw files
if CONFIG_CGROUP_MEM_RES_CTLR_SWAP) and it causes any attempt to open the
file to return EOPNOTSUPP.  Although EOPNOTSUPP should say be clear that
memsw operations are not supported in the given configuration it is fair
to say that this behavior could be quite confusing.

Let's tear memsw files out of default cgroup files and add them only if
the swap accounting is really enabled (either by CONFIG_MEMCG_SWAP_ENABLED
or swapaccount=1 boot parameter).  We can hook into mem_cgroup_init which
is called when the memcg subsystem is initialized and which happens after
boot command line is processed.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Zhouping Liu <zliu@redhat.com>
Tested-by: Zhouping Liu <zliu@redhat.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: CAI Qian <caiqian@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   94 ++++++++++++++++++++++++++--------------------
 1 file changed, 54 insertions(+), 40 deletions(-)

diff -puN mm/memcontrol.c~memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled
+++ a/mm/memcontrol.c
@@ -5821,33 +5821,6 @@ static struct cftype mem_cgroup_files[] 
 		.read_seq_string = memcg_numa_stat_show,
 	},
 #endif
-#ifdef CONFIG_MEMCG_SWAP
-	{
-		.name = "memsw.usage_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_USAGE),
-		.read = mem_cgroup_read,
-		.register_event = mem_cgroup_usage_register_event,
-		.unregister_event = mem_cgroup_usage_unregister_event,
-	},
-	{
-		.name = "memsw.max_usage_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_MAX_USAGE),
-		.trigger = mem_cgroup_reset,
-		.read = mem_cgroup_read,
-	},
-	{
-		.name = "memsw.limit_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_LIMIT),
-		.write_string = mem_cgroup_write,
-		.read = mem_cgroup_read,
-	},
-	{
-		.name = "memsw.failcnt",
-		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_FAILCNT),
-		.trigger = mem_cgroup_reset,
-		.read = mem_cgroup_read,
-	},
-#endif
 #ifdef CONFIG_MEMCG_KMEM
 	{
 		.name = "kmem.limit_in_bytes",
@@ -5882,6 +5855,36 @@ static struct cftype mem_cgroup_files[] 
 	{ },	/* terminate */
 };
 
+#ifdef CONFIG_MEMCG_SWAP
+static struct cftype memsw_cgroup_files[] = {
+	{
+		.name = "memsw.usage_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_USAGE),
+		.read = mem_cgroup_read,
+		.register_event = mem_cgroup_usage_register_event,
+		.unregister_event = mem_cgroup_usage_unregister_event,
+	},
+	{
+		.name = "memsw.max_usage_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_MAX_USAGE),
+		.trigger = mem_cgroup_reset,
+		.read = mem_cgroup_read,
+	},
+	{
+		.name = "memsw.limit_in_bytes",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_LIMIT),
+		.write_string = mem_cgroup_write,
+		.read = mem_cgroup_read,
+	},
+	{
+		.name = "memsw.failcnt",
+		.private = MEMFILE_PRIVATE(_MEMSWAP, RES_FAILCNT),
+		.trigger = mem_cgroup_reset,
+		.read = mem_cgroup_read,
+	},
+	{ },	/* terminate */
+};
+#endif
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn;
@@ -6781,19 +6784,6 @@ struct cgroup_subsys mem_cgroup_subsys =
 	.use_id = 1,
 };
 
-/*
- * The rest of init is performed during ->css_alloc() for root css which
- * happens before initcalls.  hotcpu_notifier() can't be done together as
- * it would introduce circular locking by adding cgroup_lock -> cpu hotplug
- * dependency.  Do it from a subsys_initcall().
- */
-static int __init mem_cgroup_init(void)
-{
-	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
-	return 0;
-}
-subsys_initcall(mem_cgroup_init);
-
 #ifdef CONFIG_MEMCG_SWAP
 static int __init enable_swap_account(char *s)
 {
@@ -6806,4 +6796,28 @@ static int __init enable_swap_account(ch
 }
 __setup("swapaccount=", enable_swap_account);
 
+static void __init memsw_file_init(void)
+{
+	if (really_do_swap_account)
+		WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys,
+					memsw_cgroup_files));
+}
+#else
+static void __init memsw_file_init(void)
+{
+}
 #endif
+
+/*
+ * The rest of init is performed during ->css_alloc() for root css which
+ * happens before initcalls.  hotcpu_notifier() can't be done together as
+ * it would introduce circular locking by adding cgroup_lock -> cpu hotplug
+ * dependency.  Do it from a subsys_initcall().
+ */
+static int __init mem_cgroup_init(void)
+{
+	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
+	memsw_file_init();
+	return 0;
+}
+subsys_initcall(mem_cgroup_init);
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
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

