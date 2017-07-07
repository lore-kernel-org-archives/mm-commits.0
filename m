From: akpm@linux-foundation.org
Subject: [merged]
 mm-memory_hotplug-get-rid-of-is_zone_device_section.patch removed from -mm
 tree
Date: Fri, 07 Jul 2017 12:08:58 -0700
Message-ID: <20170707190858.Tf5R7SUhv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32874 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752452AbdGGTJF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Jul 2017 15:09:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, ak@linux.intel.com, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, imammedo@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, tobias.regnery@gmail.com, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com


The patch titled
     Subject: mm, memory_hotplug: get rid of is_zone_device_section
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-get-rid-of-is_zone_device_section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: get rid of is_zone_device_section

Device memory hotplug hooks into regular memory hotplug only half way.  It
needs memory sections to track struct pages but there is no need/desire to
associate those sections with memory blocks and export them to the
userspace via sysfs because they cannot be onlined anyway.

This is currently expressed by for_device argument to arch_add_memory
which then makes sure to associate the given memory range with
ZONE_DEVICE.  register_new_memory then relies on is_zone_device_section to
distinguish special memory hotplug from the regular one.  While this works
now, later patches in this series want to move __add_zone outside of
arch_add_memory path so we have to come up with something else.

Add want_memblock down the __add_pages path and use it to control whether
the section->memblock association should be done.  arch_add_memory then
just trivially want memblock for everything but for_device hotplug.

remove_memory_section doesn't need is_zone_device_section either.  We can
simply skip all the memblock specific cleanup if there is no memblock for
the given section.

This shouldn't introduce any functional change.

Link: http://lkml.kernel.org/r/20170515085827.16474-5-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Balbir Singh <bsingharora@gmail.com>
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

 arch/ia64/mm/init.c            |    2 +-
 arch/powerpc/mm/mem.c          |    2 +-
 arch/s390/mm/init.c            |    2 +-
 arch/sh/mm/init.c              |    2 +-
 arch/x86/mm/init_32.c          |    2 +-
 arch/x86/mm/init_64.c          |    2 +-
 drivers/base/memory.c          |   23 +++++++++--------------
 include/linux/memory_hotplug.h |    2 +-
 mm/memory_hotplug.c            |    9 ++++++---
 9 files changed, 22 insertions(+), 24 deletions(-)

diff -puN arch/ia64/mm/init.c~mm-memory_hotplug-get-rid-of-is_zone_device_section arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-memory_hotplug-get-rid-of-is_zone_device_section
+++ a/arch/ia64/mm/init.c
@@ -658,7 +658,7 @@ int arch_add_memory(int nid, u64 start,
 
 	zone = pgdat->node_zones +
 		zone_for_memory(nid, start, size, ZONE_NORMAL, for_device);
-	ret = __add_pages(nid, zone, start_pfn, nr_pages);
+	ret = __add_pages(nid, zone, start_pfn, nr_pages, !for_device);
 
 	if (ret)
 		printk("%s: Problem encountered in __add_pages() as ret=%d\n",
diff -puN arch/powerpc/mm/mem.c~mm-memory_hotplug-get-rid-of-is_zone_device_section arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~mm-memory_hotplug-get-rid-of-is_zone_device_section
+++ a/arch/powerpc/mm/mem.c
@@ -151,7 +151,7 @@ int arch_add_memory(int nid, u64 start,
 	zone = pgdata->node_zones +
 		zone_for_memory(nid, start, size, 0, for_device);
 
-	return __add_pages(nid, zone, start_pfn, nr_pages);
+	return __add_pages(nid, zone, start_pfn, nr_pages, !for_device);
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
diff -puN arch/s390/mm/init.c~mm-memory_hotplug-get-rid-of-is_zone_device_section arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~mm-memory_hotplug-get-rid-of-is_zone_device_section
+++ a/arch/s390/mm/init.c
@@ -195,7 +195,7 @@ int arch_add_memory(int nid, u64 start,
 			continue;
 		nr_pages = (start_pfn + size_pages > zone_end_pfn) ?
 			   zone_end_pfn - start_pfn : size_pages;
-		rc = __add_pages(nid, zone, start_pfn, nr_pages);
+		rc = __add_pages(nid, zone, start_pfn, nr_pages, !for_device);
 		if (rc)
 			break;
 		start_pfn += nr_pages;
diff -puN arch/sh/mm/init.c~mm-memory_hotplug-get-rid-of-is_zone_device_section arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~mm-memory_hotplug-get-rid-of-is_zone_device_section
+++ a/arch/sh/mm/init.c
@@ -498,7 +498,7 @@ int arch_add_memory(int nid, u64 start,
 	ret = __add_pages(nid, pgdat->node_zones +
 			zone_for_memory(nid, start, size, ZONE_NORMAL,
 			for_device),
-			start_pfn, nr_pages);
+			start_pfn, nr_pages, !for_device);
 	if (unlikely(ret))
 		printk("%s: Failed, __add_pages() == %d\n", __func__, ret);
 
diff -puN arch/x86/mm/init_32.c~mm-memory_hotplug-get-rid-of-is_zone_device_section arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~mm-memory_hotplug-get-rid-of-is_zone_device_section
+++ a/arch/x86/mm/init_32.c
@@ -831,7 +831,7 @@ int arch_add_memory(int nid, u64 start,
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	return __add_pages(nid, zone, start_pfn, nr_pages);
+	return __add_pages(nid, zone, start_pfn, nr_pages, !for_device);
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
diff -puN arch/x86/mm/init_64.c~mm-memory_hotplug-get-rid-of-is_zone_device_section arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-memory_hotplug-get-rid-of-is_zone_device_section
+++ a/arch/x86/mm/init_64.c
@@ -787,7 +787,7 @@ int arch_add_memory(int nid, u64 start,
 
 	init_memory_mapping(start, start + size);
 
-	ret = __add_pages(nid, zone, start_pfn, nr_pages);
+	ret = __add_pages(nid, zone, start_pfn, nr_pages, !for_device);
 	WARN_ON_ONCE(ret);
 
 	/* update max_pfn, max_low_pfn and high_memory */
diff -puN drivers/base/memory.c~mm-memory_hotplug-get-rid-of-is_zone_device_section drivers/base/memory.c
--- a/drivers/base/memory.c~mm-memory_hotplug-get-rid-of-is_zone_device_section
+++ a/drivers/base/memory.c
@@ -685,14 +685,6 @@ static int add_memory_block(int base_sec
 	return 0;
 }
 
-static bool is_zone_device_section(struct mem_section *ms)
-{
-	struct page *page;
-
-	page = sparse_decode_mem_map(ms->section_mem_map, __section_nr(ms));
-	return is_zone_device_page(page);
-}
-
 /*
  * need an interface for the VM to add new memory regions,
  * but without onlining it.
@@ -702,9 +694,6 @@ int register_new_memory(int nid, struct
 	int ret = 0;
 	struct memory_block *mem;
 
-	if (is_zone_device_section(section))
-		return 0;
-
 	mutex_lock(&mem_sysfs_mutex);
 
 	mem = find_memory_block(section);
@@ -741,11 +730,16 @@ static int remove_memory_section(unsigne
 {
 	struct memory_block *mem;
 
-	if (is_zone_device_section(section))
-		return 0;
-
 	mutex_lock(&mem_sysfs_mutex);
+
+	/*
+	 * Some users of the memory hotplug do not want/need memblock to
+	 * track all sections. Skip over those.
+	 */
 	mem = find_memory_block(section);
+	if (!mem)
+		goto out_unlock;
+
 	unregister_mem_sect_under_nodes(mem, __section_nr(section));
 
 	mem->section_count--;
@@ -754,6 +748,7 @@ static int remove_memory_section(unsigne
 	else
 		put_device(&mem->dev);
 
+out_unlock:
 	mutex_unlock(&mem_sysfs_mutex);
 	return 0;
 }
diff -puN include/linux/memory_hotplug.h~mm-memory_hotplug-get-rid-of-is_zone_device_section include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-get-rid-of-is_zone_device_section
+++ a/include/linux/memory_hotplug.h
@@ -111,7 +111,7 @@ extern int __remove_pages(struct zone *z
 
 /* reasonably generic interface to expand the physical pages in a zone  */
 extern int __add_pages(int nid, struct zone *zone, unsigned long start_pfn,
-	unsigned long nr_pages);
+	unsigned long nr_pages, bool want_memblock);
 
 #ifdef CONFIG_NUMA
 extern int memory_add_physaddr_to_nid(u64 start);
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-get-rid-of-is_zone_device_section mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-get-rid-of-is_zone_device_section
+++ a/mm/memory_hotplug.c
@@ -494,7 +494,7 @@ static int __meminit __add_zone(struct z
 }
 
 static int __meminit __add_section(int nid, struct zone *zone,
-					unsigned long phys_start_pfn)
+		unsigned long phys_start_pfn, bool want_memblock)
 {
 	int ret;
 
@@ -511,6 +511,9 @@ static int __meminit __add_section(int n
 	if (ret < 0)
 		return ret;
 
+	if (!want_memblock)
+		return 0;
+
 	return register_new_memory(nid, __pfn_to_section(phys_start_pfn));
 }
 
@@ -521,7 +524,7 @@ static int __meminit __add_section(int n
  * add the new pages.
  */
 int __ref __add_pages(int nid, struct zone *zone, unsigned long phys_start_pfn,
-			unsigned long nr_pages)
+			unsigned long nr_pages, bool want_memblock)
 {
 	unsigned long i;
 	int err = 0;
@@ -549,7 +552,7 @@ int __ref __add_pages(int nid, struct zo
 	}
 
 	for (i = start_sec; i <= end_sec; i++) {
-		err = __add_section(nid, zone, section_nr_to_pfn(i));
+		err = __add_section(nid, zone, section_nr_to_pfn(i), want_memblock);
 
 		/*
 		 * EEXIST is finally dealt with by ioresource collision
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

