From: akpm@linux-foundation.org
Subject: + mm-page_alloc-rip-out-zonelist_order_zone-fix.patch added to
 -mm tree
Date: Mon, 21 Aug 2017 13:31:50 -0700
Message-ID: <599b4336.7LKd65/5aIah79qq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43872 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753041AbdHUUbv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2017 16:31:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, abdhalee@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-rip-out-zonelist_order_zone-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-rip-out-zonelist_order_zone-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-rip-out-zonelist_order_zone-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-rip-out-zonelist_order_zone-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------

Author: Michal Hocko <mhocko@suse.com>
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
@@ -4832,6 +4832,8 @@ static __init int setup_numa_zonelist_or
 }
 early_param("numa_zonelist_order", setup_numa_zonelist_order);
 
+char numa_zonelist_order[] = "Node";
+
 /*
  * sysctl handler for numa_zonelist_order
  */
@@ -4842,12 +4844,8 @@ int numa_zonelist_order_handler(struct c
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
mm-memory_hotplug-introduce-add_pages.patch
fs-proc-remove-priv-argument-from-is_stack.patch
treewide-remove-gfp_temporary-allocation-flag.patch

