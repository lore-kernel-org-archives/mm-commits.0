From: akpm@linux-foundation.org
Subject: [merged] cpu-mem-hotplug-add-try_online_node-for-cpu_up.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:09 -0800
Message-ID: <5283e331.zoyMT9PFKyfkxpKZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3KMUiJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com, toshi.kani@hp.com

Subject: [merged] cpu-mem-hotplug-add-try_online_node-for-cpu_up.patch removed from -mm tree
To: toshi.kani@hp.com,isimatu.yasuaki@jp.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:09 -0800


The patch titled
     Subject: cpu/mem hotplug: add try_online_node() for cpu_up()
has been removed from the -mm tree.  Its filename was
     cpu-mem-hotplug-add-try_online_node-for-cpu_up.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: cpu/mem hotplug: add try_online_node() for cpu_up()

cpu_up() has #ifdef CONFIG_MEMORY_HOTPLUG code blocks, which call
mem_online_node() to put its node online if offlined and then call
build_all_zonelists() to initialize the zone list.  These steps are
specific to memory hotplug, and should be managed in mm/memory_hotplug.c. 
lock_memory_hotplug() should also be held for the whole steps.

For this reason, this patch replaces mem_online_node() with
try_online_node(), which performs the whole steps with
lock_memory_hotplug() held.  try_online_node() is named after
try_offline_node() as they have similar purpose.

There is no functional change in this patch.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    8 +++++++-
 kernel/cpu.c                   |   29 +++--------------------------
 mm/memory_hotplug.c            |   16 ++++++++++++++--
 3 files changed, 24 insertions(+), 29 deletions(-)

diff -puN include/linux/memory_hotplug.h~cpu-mem-hotplug-add-try_online_node-for-cpu_up include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~cpu-mem-hotplug-add-try_online_node-for-cpu_up
+++ a/include/linux/memory_hotplug.h
@@ -94,6 +94,8 @@ extern void __online_page_set_limits(str
 extern void __online_page_increment_counters(struct page *page);
 extern void __online_page_free(struct page *page);
 
+extern int try_online_node(int nid);
+
 #ifdef CONFIG_MEMORY_HOTREMOVE
 extern bool is_pageblock_removable_nolock(struct page *page);
 extern int arch_remove_memory(u64 start, u64 size);
@@ -225,6 +227,11 @@ static inline void register_page_bootmem
 {
 }
 
+static inline int try_online_node(int nid)
+{
+	return 0;
+}
+
 static inline void lock_memory_hotplug(void) {}
 static inline void unlock_memory_hotplug(void) {}
 
@@ -256,7 +263,6 @@ static inline void remove_memory(int nid
 
 extern int walk_memory_range(unsigned long start_pfn, unsigned long end_pfn,
 		void *arg, int (*func)(struct memory_block *, void *));
-extern int mem_online_node(int nid);
 extern int add_memory(int nid, u64 start, u64 size);
 extern int arch_add_memory(int nid, u64 start, u64 size);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
diff -puN kernel/cpu.c~cpu-mem-hotplug-add-try_online_node-for-cpu_up kernel/cpu.c
--- a/kernel/cpu.c~cpu-mem-hotplug-add-try_online_node-for-cpu_up
+++ a/kernel/cpu.c
@@ -437,11 +437,6 @@ int cpu_up(unsigned int cpu)
 {
 	int err = 0;
 
-#ifdef	CONFIG_MEMORY_HOTPLUG
-	int nid;
-	pg_data_t	*pgdat;
-#endif
-
 	if (!cpu_possible(cpu)) {
 		printk(KERN_ERR "can't online cpu %d because it is not "
 			"configured as may-hotadd at boot time\n", cpu);
@@ -452,27 +447,9 @@ int cpu_up(unsigned int cpu)
 		return -EINVAL;
 	}
 
-#ifdef	CONFIG_MEMORY_HOTPLUG
-	nid = cpu_to_node(cpu);
-	if (!node_online(nid)) {
-		err = mem_online_node(nid);
-		if (err)
-			return err;
-	}
-
-	pgdat = NODE_DATA(nid);
-	if (!pgdat) {
-		printk(KERN_ERR
-			"Can't online cpu %d due to NULL pgdat\n", cpu);
-		return -ENOMEM;
-	}
-
-	if (pgdat->node_zonelists->_zonerefs->zone == NULL) {
-		mutex_lock(&zonelists_mutex);
-		build_all_zonelists(NULL, NULL);
-		mutex_unlock(&zonelists_mutex);
-	}
-#endif
+	err = try_online_node(cpu_to_node(cpu));
+	if (err)
+		return err;
 
 	cpu_maps_update_begin();
 
diff -puN mm/memory_hotplug.c~cpu-mem-hotplug-add-try_online_node-for-cpu_up mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~cpu-mem-hotplug-add-try_online_node-for-cpu_up
+++ a/mm/memory_hotplug.c
@@ -1043,17 +1043,23 @@ static void rollback_node_hotadd(int nid
 }
 
 
-/*
+/**
+ * try_online_node - online a node if offlined
+ *
  * called by cpu_up() to online a node without onlined memory.
  */
-int mem_online_node(int nid)
+int try_online_node(int nid)
 {
 	pg_data_t	*pgdat;
 	int	ret;
 
+	if (node_online(nid))
+		return 0;
+
 	lock_memory_hotplug();
 	pgdat = hotadd_new_pgdat(nid, 0);
 	if (!pgdat) {
+		pr_err("Cannot online node %d due to NULL pgdat\n", nid);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -1061,6 +1067,12 @@ int mem_online_node(int nid)
 	ret = register_one_node(nid);
 	BUG_ON(ret);
 
+	if (pgdat->node_zonelists->_zonerefs->zone == NULL) {
+		mutex_lock(&zonelists_mutex);
+		build_all_zonelists(NULL, NULL);
+		mutex_unlock(&zonelists_mutex);
+	}
+
 out:
 	unlock_memory_hotplug();
 	return ret;
_

Patches currently in -mm which might be from toshi.kani@hp.com are

origin.patch
linux-next.patch

