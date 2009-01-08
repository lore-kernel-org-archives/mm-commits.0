From: akpm@linux-foundation.org
Subject: - memcg-memswap-controller-kconfig.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:20 -0800
Message-ID: <200901082248.n08MmK9t027701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755716AbZAHWtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:49:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: mem+swap controller Kconfig
has been removed from the -mm tree.  Its filename was
     memcg-memswap-controller-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: mem+swap controller Kconfig
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Config and control variable for mem+swap controller.

This patch adds CONFIG_CGROUP_MEM_RES_CTLR_SWAP
(memory resource controller swap extension.)

For accounting swap, it's obvious that we have to use additional memory to
remember "who uses swap".  This adds more overhead.  So, it's better to
offer "choice" to users.  This patch adds 2 choices.

This patch adds 2 parameters to enable swap extension or not.
  - CONFIG
  - boot option

Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    3 ++
 include/linux/memcontrol.h          |    3 ++
 init/Kconfig                        |   17 +++++++++++++
 mm/memcontrol.c                     |   34 ++++++++++++++++++++++++++
 4 files changed, 57 insertions(+)

diff -puN Documentation/kernel-parameters.txt~memcg-memswap-controller-kconfig Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~memcg-memswap-controller-kconfig
+++ a/Documentation/kernel-parameters.txt
@@ -1562,6 +1562,9 @@ and is between 256 and 4096 characters. 
 
 	nosoftlockup	[KNL] Disable the soft-lockup detector.
 
+	noswapaccount	[KNL] Disable accounting of swap in memory resource
+			controller. (See Documentation/controllers/memory.txt)
+
 	nosync		[HW,M68K] Disables sync negotiation for all devices.
 
 	notsc		[BUGS=X86-32] Disable Time Stamp Counter
diff -puN include/linux/memcontrol.h~memcg-memswap-controller-kconfig include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-memswap-controller-kconfig
+++ a/include/linux/memcontrol.h
@@ -77,6 +77,9 @@ extern void mem_cgroup_record_reclaim_pr
 extern long mem_cgroup_calc_reclaim(struct mem_cgroup *mem, struct zone *zone,
 					int priority, enum lru_list lru);
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+extern int do_swap_account;
+#endif
 
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
diff -puN init/Kconfig~memcg-memswap-controller-kconfig init/Kconfig
--- a/init/Kconfig~memcg-memswap-controller-kconfig
+++ a/init/Kconfig
@@ -428,6 +428,23 @@ config CGROUP_MEM_RES_CTLR
 config MM_OWNER
 	bool
 
+config CGROUP_MEM_RES_CTLR_SWAP
+	bool "Memory Resource Controller Swap Extension(EXPERIMENTAL)"
+	depends on CGROUP_MEM_RES_CTLR && SWAP && EXPERIMENTAL
+	help
+	  Add swap management feature to memory resource controller. When you
+	  enable this, you can limit mem+swap usage per cgroup. In other words,
+	  when you disable this, memory resource controller has no cares to
+	  usage of swap...a process can exhaust all of the swap. This extension
+	  is useful when you want to avoid exhaustion swap but this itself
+	  adds more overheads and consumes memory for remembering information.
+	  Especially if you use 32bit system or small memory system, please
+	  be careful about enabling this. When memory resource controller
+	  is disabled by boot option, this will be automatically disabled and
+	  there will be no overhead from this. Even when you set this config=y,
+	  if boot option "noswapaccount" is set, swap will not be accounted.
+
+
 endmenu
 
 config SYSFS_DEPRECATED
diff -puN mm/memcontrol.c~memcg-memswap-controller-kconfig mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-memswap-controller-kconfig
+++ a/mm/memcontrol.c
@@ -41,6 +41,15 @@
 struct cgroup_subsys mem_cgroup_subsys __read_mostly;
 #define MEM_CGROUP_RECLAIM_RETRIES	5
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+/* Turned on only when memory cgroup is enabled && really_do_swap_account = 0 */
+int do_swap_account __read_mostly;
+static int really_do_swap_account __initdata = 1; /* for remember boot option*/
+#else
+#define do_swap_account		(0)
+#endif
+
+
 /*
  * Statistics for memory cgroup.
  */
@@ -1404,6 +1413,18 @@ static void mem_cgroup_free(struct mem_c
 }
 
 
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+static void __init enable_swap_cgroup(void)
+{
+	if (!mem_cgroup_subsys.disabled && really_do_swap_account)
+		do_swap_account = 1;
+}
+#else
+static void __init enable_swap_cgroup(void)
+{
+}
+#endif
+
 static struct cgroup_subsys_state *
 mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
@@ -1419,6 +1440,9 @@ mem_cgroup_create(struct cgroup_subsys *
 	for_each_node_state(node, N_POSSIBLE)
 		if (alloc_mem_cgroup_per_zone_info(mem, node))
 			goto free_out;
+	/* root ? */
+	if (cont->parent == NULL)
+		enable_swap_cgroup();
 
 	return &mem->css;
 free_out:
@@ -1490,3 +1514,13 @@ struct cgroup_subsys mem_cgroup_subsys =
 	.attach = mem_cgroup_move_task,
 	.early_init = 0,
 };
+
+#ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
+
+static int __init disable_swap_account(char *s)
+{
+	really_do_swap_account = 0;
+	return 1;
+}
+__setup("noswapaccount", disable_swap_account);
+#endif
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

