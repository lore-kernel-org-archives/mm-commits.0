From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-split-up-register_one_node.patch added to -mm tree
Date: Mon, 15 May 2017 14:26:50 -0700
Message-ID: <591a1d1a.Y61Yss/R5Iw2xc05%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48362 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758837AbdEOV0w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 17:26:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, imammedo@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, tobias.regnery@gmail.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: split up register_one_node()
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-split-up-register_one_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-split-up-register_one_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-split-up-register_one_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: split up register_one_node()

Memory hotplug (add_memory_resource) has to reinitialize node
infrastructure if the node is offline (one which went through the complete
add_memory(); remove_memory() cycle).  That involves node registration to
the kobj infrastructure (register_node), the proper association with cpus
(register_cpu_under_node) and finally creation of node<->memblock symlinks
(link_mem_sections).

The last part requires to know node_start_pfn and node_spanned_pages which
we currently have but a leter patch will postpone this initialization to
the onlining phase which happens later.  In fact we do not need to rely on
the early pgdat initialization even now because the currently hot added
pfn range is currently known.

Split register_one_node into core which does all the common work for the
boot time NUMA initialization and the hotplug (__register_one_node). 
register_one_node keeps the full initialization while hotplug calls
__register_one_node and manually calls link_mem_sections for the proper
range.

This shouldn't introduce any functional change.

Link: http://lkml.kernel.org/r/20170515085827.16474-6-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Reza Arbab <arbab@linux.vnet.ibm.com>
Cc: Tobias Regnery <tobias.regnery@gmail.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c  |   55 ++++++++++++++++-------------------------
 include/linux/node.h |   35 +++++++++++++++++++++++++-
 mm/memory_hotplug.c  |   17 +++++++++++-
 3 files changed, 72 insertions(+), 35 deletions(-)

diff -puN drivers/base/node.c~mm-memory_hotplug-split-up-register_one_node drivers/base/node.c
--- a/drivers/base/node.c~mm-memory_hotplug-split-up-register_one_node
+++ a/drivers/base/node.c
@@ -461,10 +461,9 @@ int unregister_mem_sect_under_nodes(stru
 	return 0;
 }
 
-static int link_mem_sections(int nid)
+int link_mem_sections(int nid, unsigned long start_pfn, unsigned long nr_pages)
 {
-	unsigned long start_pfn = NODE_DATA(nid)->node_start_pfn;
-	unsigned long end_pfn = start_pfn + NODE_DATA(nid)->node_spanned_pages;
+	unsigned long end_pfn = start_pfn + nr_pages;
 	unsigned long pfn;
 	struct memory_block *mem_blk = NULL;
 	int err = 0;
@@ -552,10 +551,7 @@ static int node_memory_callback(struct n
 	return NOTIFY_OK;
 }
 #endif	/* CONFIG_HUGETLBFS */
-#else	/* !CONFIG_MEMORY_HOTPLUG_SPARSE */
-
-static int link_mem_sections(int nid) { return 0; }
-#endif	/* CONFIG_MEMORY_HOTPLUG_SPARSE */
+#endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
 #if !defined(CONFIG_MEMORY_HOTPLUG_SPARSE) || \
     !defined(CONFIG_HUGETLBFS)
@@ -569,39 +565,32 @@ static void init_node_hugetlb_work(int n
 
 #endif
 
-int register_one_node(int nid)
+int __register_one_node(int nid)
 {
-	int error = 0;
+	int p_node = parent_node(nid);
+	struct node *parent = NULL;
+	int error;
 	int cpu;
 
-	if (node_online(nid)) {
-		int p_node = parent_node(nid);
-		struct node *parent = NULL;
-
-		if (p_node != nid)
-			parent = node_devices[p_node];
-
-		node_devices[nid] = kzalloc(sizeof(struct node), GFP_KERNEL);
-		if (!node_devices[nid])
-			return -ENOMEM;
-
-		error = register_node(node_devices[nid], nid, parent);
-
-		/* link cpu under this node */
-		for_each_present_cpu(cpu) {
-			if (cpu_to_node(cpu) == nid)
-				register_cpu_under_node(cpu, nid);
-		}
-
-		/* link memory sections under this node */
-		error = link_mem_sections(nid);
+	if (p_node != nid)
+		parent = node_devices[p_node];
 
-		/* initialize work queue for memory hot plug */
-		init_node_hugetlb_work(nid);
+	node_devices[nid] = kzalloc(sizeof(struct node), GFP_KERNEL);
+	if (!node_devices[nid])
+		return -ENOMEM;
+
+	error = register_node(node_devices[nid], nid, parent);
+
+	/* link cpu under this node */
+	for_each_present_cpu(cpu) {
+		if (cpu_to_node(cpu) == nid)
+			register_cpu_under_node(cpu, nid);
 	}
 
-	return error;
+	/* initialize work queue for memory hot plug */
+	init_node_hugetlb_work(nid);
 
+	return error;
 }
 
 void unregister_one_node(int nid)
diff -puN include/linux/node.h~mm-memory_hotplug-split-up-register_one_node include/linux/node.h
--- a/include/linux/node.h~mm-memory_hotplug-split-up-register_one_node
+++ a/include/linux/node.h
@@ -30,9 +30,38 @@ struct memory_block;
 extern struct node *node_devices[];
 typedef  void (*node_registration_func_t)(struct node *);
 
+#if defined(CONFIG_MEMORY_HOTPLUG_SPARSE) && defined(CONFIG_NUMA)
+extern int link_mem_sections(int nid, unsigned long start_pfn, unsigned long nr_pages);
+#else
+static inline int link_mem_sections(int nid, unsigned long start_pfn, unsigned long nr_pages)
+{
+	return 0;
+}
+#endif
+
 extern void unregister_node(struct node *node);
 #ifdef CONFIG_NUMA
-extern int register_one_node(int nid);
+/* Core of the node registration - only memory hotplug should use this */
+extern int __register_one_node(int nid);
+
+/* Registers an online node */
+static inline int register_one_node(int nid)
+{
+	int error = 0;
+
+	if (node_online(nid)) {
+		struct pglist_data *pgdat = NODE_DATA(nid);
+
+		error = __register_one_node(nid);
+		if (error)
+			return error;
+		/* link memory sections under this node */
+		error = link_mem_sections(nid, pgdat->node_start_pfn, pgdat->node_spanned_pages);
+	}
+
+	return error;
+}
+
 extern void unregister_one_node(int nid);
 extern int register_cpu_under_node(unsigned int cpu, unsigned int nid);
 extern int unregister_cpu_under_node(unsigned int cpu, unsigned int nid);
@@ -46,6 +75,10 @@ extern void register_hugetlbfs_with_node
 					 node_registration_func_t unregister);
 #endif
 #else
+static inline int __register_one_node(int nid)
+{
+	return 0;
+}
 static inline int register_one_node(int nid)
 {
 	return 0;
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-split-up-register_one_node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-split-up-register_one_node
+++ a/mm/memory_hotplug.c
@@ -1392,7 +1392,22 @@ int __ref add_memory_resource(int nid, s
 	node_set_online(nid);
 
 	if (new_node) {
-		ret = register_one_node(nid);
+		unsigned long start_pfn = start >> PAGE_SHIFT;
+		unsigned long nr_pages = size >> PAGE_SHIFT;
+
+		ret = __register_one_node(nid);
+		if (ret)
+			goto register_fail;
+
+		/*
+		 * link memory sections under this node. This is already
+		 * done when creatig memory section in register_new_memory
+		 * but that depends to have the node registered so offline
+		 * nodes have to go through register_node.
+		 * TODO clean up this mess.
+		 */
+		ret = link_mem_sections(nid, start_pfn, nr_pages);
+register_fail:
 		/*
 		 * If sysfs file of new node can't create, cpu on the node
 		 * can't be hot-added. There is no rollback way now.
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-remove-return-value-from-init_currently_empty_zone.patch
mm-memory_hotplug-use-node-instead-of-zone-in-can_online_high_movable.patch
mm-drop-page_initialized-check-from-get_nid_for_pfn.patch
mm-memory_hotplug-get-rid-of-is_zone_device_section.patch
mm-memory_hotplug-split-up-register_one_node.patch
mm-memory_hotplug-consider-offline-memblocks-removable.patch
mm-consider-zone-which-is-not-fully-populated-to-have-holes.patch
mm-compaction-skip-over-holes-in-__reset_isolation_suitable.patch
mm-__first_valid_page-skip-over-offline-pages.patch
mm-vmstat-skip-reporting-offline-pages-in-pagetypeinfo.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch
mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory.patch
mm-memory_hotplug-fix-the-section-mismatch-warning.patch
mm-memory_hotplug-remove-unused-cruft-after-memory-hotplug-rework.patch

