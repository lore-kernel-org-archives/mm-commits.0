From: akpm@linux-foundation.org
Subject: [merged] memcg-clean-up-swap-accounting-initialization-code.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:11 -0800
Message-ID: <20130225205311.C4DE031C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:34825 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab3BYUxN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:13 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so347377vcd.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, caiqian@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, rientjes@google.com, tj@kernel.org, zliu@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: clean up swap accounting initialization code
has been removed from the -mm tree.  Its filename was
     memcg-clean-up-swap-accounting-initialization-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -6046,18 +6046,6 @@ struct mem_cgroup *parent_mem_cgroup(str
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
@@ -6111,7 +6099,6 @@ mem_cgroup_css_alloc(struct cgroup *cont
 	/* root ? */
 	if (cont->parent == NULL) {
 		int cpu;
-		enable_swap_cgroup();
 		parent = NULL;
 		if (mem_cgroup_soft_limit_tree_init())
 			goto free_out;
@@ -6800,12 +6787,19 @@ __setup("swapaccount=", enable_swap_acco
 
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
@@ -6819,7 +6813,7 @@ static void __init memsw_file_init(void)
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

origin.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch

