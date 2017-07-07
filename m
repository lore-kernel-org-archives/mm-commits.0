From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-move-movable_node-to-the-hotplug-proper.patch removed
 from -mm tree
Date: Fri, 07 Jul 2017 12:11:47 -0700
Message-ID: <20170707191147.I7HmREvSV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34848 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdGGTLx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:11:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, daniel.kiper@oracle.com, imammedo@redhat.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, qiuxishi@huawei.com, rientjes@google.com, slaoub@gmail.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com, yasu.isimatu@gmail.com


The patch titled
     Subject: mm, memory_hotplug: move movable_node to the hotplug proper
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-move-movable_node-to-the-hotplug-proper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: move movable_node to the hotplug proper

movable_node_is_enabled is defined in memblock proper while it is
initialized from the memory hotplug proper.  This is quite messy and it
makes a dependency between the two so move movable_node along with the
helper functions to memory_hotplug.

To make it more entertaining the kernel parameter is ignored unless
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y because we do not have the node
information for each memblock otherwise.  So let's warn when the option is
disabled.

Link: http://lkml.kernel.org/r/20170529114141.536-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Reza Arbab <arbab@linux.vnet.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Yasuaki Ishimatsu <yasu.isimatu@gmail.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Kani Toshimitsu <toshi.kani@hpe.com>
Cc: Chen Yucong <slaoub@gmail.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h       |    7 -------
 include/linux/memory_hotplug.h |   10 ++++++++++
 mm/memblock.c                  |    1 -
 mm/memory_hotplug.c            |    6 ++++++
 4 files changed, 16 insertions(+), 8 deletions(-)

diff -puN include/linux/memblock.h~mm-memory_hotplug-move-movable_node-to-the-hotplug-proper include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memory_hotplug-move-movable_node-to-the-hotplug-proper
+++ a/include/linux/memblock.h
@@ -57,8 +57,6 @@ struct memblock {
 
 extern struct memblock memblock;
 extern int memblock_debug;
-/* If movable_node boot option specified */
-extern bool movable_node_enabled;
 
 #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
 #define __init_memblock __meminit
@@ -172,11 +170,6 @@ static inline bool memblock_is_hotplugga
 	return m->flags & MEMBLOCK_HOTPLUG;
 }
 
-static inline bool __init_memblock movable_node_is_enabled(void)
-{
-	return movable_node_enabled;
-}
-
 static inline bool memblock_is_mirror(struct memblock_region *m)
 {
 	return m->flags & MEMBLOCK_MIRROR;
diff -puN include/linux/memory_hotplug.h~mm-memory_hotplug-move-movable_node-to-the-hotplug-proper include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-move-movable_node-to-the-hotplug-proper
+++ a/include/linux/memory_hotplug.h
@@ -115,6 +115,12 @@ extern void __online_page_free(struct pa
 extern int try_online_node(int nid);
 
 extern bool memhp_auto_online;
+/* If movable_node boot option specified */
+extern bool movable_node_enabled;
+static inline bool movable_node_is_enabled(void)
+{
+	return movable_node_enabled;
+}
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 extern bool is_pageblock_removable_nolock(struct page *page);
@@ -266,6 +272,10 @@ static inline void put_online_mems(void)
 static inline void mem_hotplug_begin(void) {}
 static inline void mem_hotplug_done(void) {}
 
+static inline bool movable_node_is_enabled(void)
+{
+	return false;
+}
 #endif /* ! CONFIG_MEMORY_HOTPLUG */
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
diff -puN mm/memblock.c~mm-memory_hotplug-move-movable_node-to-the-hotplug-proper mm/memblock.c
--- a/mm/memblock.c~mm-memory_hotplug-move-movable_node-to-the-hotplug-proper
+++ a/mm/memblock.c
@@ -54,7 +54,6 @@ struct memblock memblock __initdata_memb
 };
 
 int memblock_debug __initdata_memblock;
-bool movable_node_enabled __initdata_memblock = false;
 static bool system_has_some_mirror __initdata_memblock = false;
 static int memblock_can_resize __initdata_memblock;
 static int memblock_memory_in_slab __initdata_memblock = 0;
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-move-movable_node-to-the-hotplug-proper mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-move-movable_node-to-the-hotplug-proper
+++ a/mm/memory_hotplug.c
@@ -79,6 +79,8 @@ static struct {
 #define memhp_lock_acquire()      lock_map_acquire(&mem_hotplug.dep_map)
 #define memhp_lock_release()      lock_map_release(&mem_hotplug.dep_map)
 
+bool movable_node_enabled = false;
+
 #ifndef CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE
 bool memhp_auto_online;
 #else
@@ -1572,7 +1574,11 @@ check_pages_isolated(unsigned long start
 
 static int __init cmdline_parse_movable_node(char *p)
 {
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	movable_node_enabled = true;
+#else
+	pr_warn("movable_node parameter depends on CONFIG_HAVE_MEMBLOCK_NODE_MAP to work properly\n");
+#endif
 	return 0;
 }
 early_param("movable_node", cmdline_parse_movable_node);
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-make-pr_set_thp_disable-immediately-active.patch
mm-memory_hotplug-simplify-empty-node-mask-handling-in-new_node_page.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration.patch
mm-unify-new_node_page-and-alloc_migrate_target.patch
mm-memcg-fix-potential-undefined-behavior-in-mem_cgroup_event_ratelimit.patch
mm-hugetlb-unclutter-hugetlb-allocation-layers.patch
hugetlb-add-support-for-preferred-node-to-alloc_huge_page_nodemask.patch
mm-hugetlb-soft_offline-use-new_page_nodemask-for-soft-offline-migration.patch
mm-document-highmem_is_dirtyable-sysctl.patch
mm-mm-mmap-do-not-blow-on-prot_none-map_fixed-holes-in-the-stack.patch
mm-disallow-early_pfn_to_nid-on-configurations-which-do-not-implement-it.patch
lib-rhashtablec-use-kvzalloc-in-bucket_table_alloc-when-possible.patch
netfilter-use-kvmalloc-xt_alloc_table_info.patch
mips-do-not-use-__gfp_repeat-for-order-0-request.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix-2.patch
xfs-map-km_mayfail-to-__gfp_retry_mayfail.patch
mm-kvmalloc-support-__gfp_retry_mayfail-for-all-sizes.patch
drm-i915-use-__gfp_retry_mayfail.patch
mm-migration-do-not-trigger-oom-killer-when-migrating-memory.patch

