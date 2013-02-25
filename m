From: akpm@linux-foundation.org
Subject: [merged] memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:08 -0800
Message-ID: <20130225205308.D3B7231C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:55875 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab3BYUxK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:10 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so362525qaj.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, caiqian@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, rientjes@google.com, tj@kernel.org, zliu@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: do not create memsw files if swap accounting is disabled
has been removed from the -mm tree.  Its filename was
     memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -5823,33 +5823,6 @@ static struct cftype mem_cgroup_files[] 
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
@@ -5884,6 +5857,36 @@ static struct cftype mem_cgroup_files[] 
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
@@ -6783,19 +6786,6 @@ struct cgroup_subsys mem_cgroup_subsys =
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
@@ -6808,4 +6798,28 @@ static int __init enable_swap_account(ch
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

origin.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

