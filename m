From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-rip-out-zonelist_order_zone-fix.patch removed from -mm tree
Date: Wed, 06 Sep 2017 15:59:54 -0700
Message-ID: <59b07dea.xurEZiSYkq4fkRGD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46676 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752422AbdIFW74 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 18:59:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, abdhalee@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-rip-out-zonelist_order_zone-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-rip-out-zonelist_order_zone-fix.patch

This patch was dropped because it was folded into mm-page_alloc-rip-out-zonelist_order_zone.patch

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm-page_alloc-rip-out-zonelist_order_zone-fix

Abdul has noticed that reading sysctl vm.numa_zonelist_order read will
never terminate.  This is because of
http://lkml.kernel.org/r/20170714080006.7250-2-mhocko@kernel.org where the
reading side doesn't update ppos and so the reader will never get 0. 
Return back to proc_dostring which does all the necessary stuff.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 kernel/sysctl.c        |    2 ++
 mm/page_alloc.c        |   10 ++++------
 3 files changed, 8 insertions(+), 6 deletions(-)

diff -puN include/linux/mmzone.h~mm-page_alloc-rip-out-zonelist_order_zone-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-page_alloc-rip-out-zonelist_order_zone-fix
+++ a/include/linux/mmzone.h
@@ -895,6 +895,8 @@ int sysctl_min_slab_ratio_sysctl_handler
 
 extern int numa_zonelist_order_handler(struct ctl_table *, int,
 			void __user *, size_t *, loff_t *);
+extern char numa_zonelist_order[];
+#define NUMA_ZONELIST_ORDER_LEN	16
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 
diff -puN kernel/sysctl.c~mm-page_alloc-rip-out-zonelist_order_zone-fix kernel/sysctl.c
--- a/kernel/sysctl.c~mm-page_alloc-rip-out-zonelist_order_zone-fix
+++ a/kernel/sysctl.c
@@ -1574,6 +1574,8 @@ static struct ctl_table vm_table[] = {
 #ifdef CONFIG_NUMA
 	{
 		.procname	= "numa_zonelist_order",
+		.data		= &numa_zonelist_order,
+		.maxlen		= NUMA_ZONELIST_ORDER_LEN,
 		.mode		= 0644,
 		.proc_handler	= numa_zonelist_order_handler,
 	},
diff -puN mm/page_alloc.c~mm-page_alloc-rip-out-zonelist_order_zone-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-rip-out-zonelist_order_zone-fix
+++ a/mm/page_alloc.c
@@ -4880,6 +4880,8 @@ static __init int setup_numa_zonelist_or
 }
 early_param("numa_zonelist_order", setup_numa_zonelist_order);
 
+char numa_zonelist_order[] = "Node";
+
 /*
  * sysctl handler for numa_zonelist_order
  */
@@ -4890,12 +4892,8 @@ int numa_zonelist_order_handler(struct c
 	char *str;
 	int ret;
 
-	if (!write) {
-		int len = sizeof("Node");
-		if (copy_to_user(buffer, "Node", len))
-			return -EFAULT;
-		return len;
-	}
+	if (!write)
+		return proc_dostring(table, write, buffer, length, ppos);
 	str = memdup_user_nul(buffer, 16);
 	if (IS_ERR(str))
 		return PTR_ERR(str);
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-display-allowed-zones-in-the-preferred-ordering.patch
mm-memory_hotplug-remove-zone-restrictions.patch
mm-page_alloc-rip-out-zonelist_order_zone.patch
mm-page_alloc-remove-boot-pageset-initialization-from-memory-hotplug.patch
mm-page_alloc-do-not-set_cpu_numa_mem-on-empty-nodes-initialization.patch
mm-memory_hotplug-drop-zone-from-build_all_zonelists.patch
mm-memory_hotplug-remove-explicit-build_all_zonelists-from-try_online_node.patch
mm-page_alloc-simplify-zonelist-initialization.patch
mm-page_alloc-remove-stop_machine-from-build_all_zonelists.patch
mm-memory_hotplug-get-rid-of-zonelists_mutex.patch
mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations.patch
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever.patch
mm-vmscan-do-not-loop-on-too_many_isolated-for-ever-fix.patch
mm-rename-global_page_state-to-global_zone_page_state.patch
mm-hugetlb-do-not-allocate-non-migrateable-gigantic-pages-from-movable-zones.patch
mm-oom-do-not-rely-on-tif_memdie-for-memory-reserves-access.patch
mm-replace-tif_memdie-checks-by-tsk_is_oom_victim.patch

