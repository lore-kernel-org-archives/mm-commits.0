From: akpm@linux-foundation.org
Subject: [patch 056/108] mm, memory_hotplug: replace for_device by
 want_memblock in arch_add_memory
Date: Thu, 06 Jul 2017 15:38:21 -0700
Message-ID: <20170706223821.bDaqGM9uj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36034 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752784AbdGFWiZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, ak@linux.intel.com, akpm@linux-foundation.org, arbab@linux.vnet.ibm.com, bsingharora@gmail.com, dan.j.williams@intel.com, daniel.kiper@oracle.com, heiko.carstens@de.ibm.com, imammedo@redhat.com, isimatu.yasuaki@jp.fujitsu.com, jglisse@redhat.com, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, qiuxishi@huawei.com, rientjes@google.com, schwidefsky@de.ibm.com, tobias.regnery@gmail.com, torvalds@linux-foundation.org, toshi.kani@hpe.com, vbabka@suse.cz, vkuznets@redhat.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, memory_hotplug: replace for_device by want_memblock in arch_add_memory

arch_add_memory gets for_device argument which then controls whether we
want to create memblocks for created memory sections.  Simplify the logic
by telling whether we want memblocks directly rather than going through
pointless negation.  This also makes the api easier to understand because
it is clear what we want rather than nothing telling for_device which can
mean anything.

This shouldn't introduce any functional change.

Link: http://lkml.kernel.org/r/20170515085827.16474-13-mhocko@kernel.org
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

 arch/ia64/mm/init.c            |    4 ++--
 arch/powerpc/mm/mem.c          |    4 ++--
 arch/s390/mm/init.c            |    4 ++--
 arch/sh/mm/init.c              |    4 ++--
 arch/x86/mm/init_32.c          |    4 ++--
 arch/x86/mm/init_64.c          |    4 ++--
 include/linux/memory_hotplug.h |    2 +-
 kernel/memremap.c              |    2 +-
 mm/memory_hotplug.c            |    2 +-
 9 files changed, 15 insertions(+), 15 deletions(-)

diff -puN arch/ia64/mm/init.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory
+++ a/arch/ia64/mm/init.c
@@ -646,13 +646,13 @@ mem_init (void)
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
+int arch_add_memory(int nid, u64 start, u64 size, bool want_memblock)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
-	ret = __add_pages(nid, start_pfn, nr_pages, !for_device);
+	ret = __add_pages(nid, start_pfn, nr_pages, want_memblock);
 	if (ret)
 		printk("%s: Problem encountered in __add_pages() as ret=%d\n",
 		       __func__,  ret);
diff -puN arch/powerpc/mm/mem.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory
+++ a/arch/powerpc/mm/mem.c
@@ -126,7 +126,7 @@ int __weak remove_section_mapping(unsign
 	return -ENODEV;
 }
 
-int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
+int arch_add_memory(int nid, u64 start, u64 size, bool want_memblock)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
@@ -143,7 +143,7 @@ int arch_add_memory(int nid, u64 start,
 		return -EFAULT;
 	}
 
-	return __add_pages(nid, start_pfn, nr_pages, !for_device);
+	return __add_pages(nid, start_pfn, nr_pages, want_memblock);
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
diff -puN arch/s390/mm/init.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory
+++ a/arch/s390/mm/init.c
@@ -166,7 +166,7 @@ unsigned long memory_block_size_bytes(vo
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
+int arch_add_memory(int nid, u64 start, u64 size, bool want_memblock)
 {
 	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long size_pages = PFN_DOWN(size);
@@ -176,7 +176,7 @@ int arch_add_memory(int nid, u64 start,
 	if (rc)
 		return rc;
 
-	rc = __add_pages(nid, start_pfn, size_pages, !for_device);
+	rc = __add_pages(nid, start_pfn, size_pages, want_memblock);
 	if (rc)
 		vmem_remove_mapping(start, size);
 	return rc;
diff -puN arch/sh/mm/init.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory
+++ a/arch/sh/mm/init.c
@@ -485,14 +485,14 @@ void free_initrd_mem(unsigned long start
 #endif
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
+int arch_add_memory(int nid, u64 start, u64 size, bool want_memblock)
 {
 	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
 	/* We only have ZONE_NORMAL, so this is easy.. */
-	ret = __add_pages(nid, start_pfn, nr_pages, !for_device);
+	ret = __add_pages(nid, start_pfn, nr_pages, want_memblock);
 	if (unlikely(ret))
 		printk("%s: Failed, __add_pages() == %d\n", __func__, ret);
 
diff -puN arch/x86/mm/init_32.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory
+++ a/arch/x86/mm/init_32.c
@@ -823,12 +823,12 @@ void __init mem_init(void)
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
+int arch_add_memory(int nid, u64 start, u64 size, bool want_memblock)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	return __add_pages(nid, start_pfn, nr_pages, !for_device);
+	return __add_pages(nid, start_pfn, nr_pages, want_memblock);
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
diff -puN arch/x86/mm/init_64.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory
+++ a/arch/x86/mm/init_64.c
@@ -772,7 +772,7 @@ static void  update_end_of_memory_vars(u
 	}
 }
 
-int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
+int arch_add_memory(int nid, u64 start, u64 size, bool want_memblock)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
@@ -780,7 +780,7 @@ int arch_add_memory(int nid, u64 start,
 
 	init_memory_mapping(start, start + size);
 
-	ret = __add_pages(nid, start_pfn, nr_pages, !for_device);
+	ret = __add_pages(nid, start_pfn, nr_pages, want_memblock);
 	WARN_ON_ONCE(ret);
 
 	/* update max_pfn, max_low_pfn and high_memory */
diff -puN include/linux/memory_hotplug.h~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory
+++ a/include/linux/memory_hotplug.h
@@ -298,7 +298,7 @@ extern int add_memory(int nid, u64 start
 extern int add_memory_resource(int nid, struct resource *resource, bool online);
 extern int zone_for_memory(int nid, u64 start, u64 size, int zone_default,
 		bool for_device);
-extern int arch_add_memory(int nid, u64 start, u64 size, bool for_device);
+extern int arch_add_memory(int nid, u64 start, u64 size, bool want_memblock);
 extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 		unsigned long nr_pages);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
diff -puN kernel/memremap.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory kernel/memremap.c
--- a/kernel/memremap.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory
+++ a/kernel/memremap.c
@@ -358,7 +358,7 @@ void *devm_memremap_pages(struct device
 		goto err_pfn_remap;
 
 	mem_hotplug_begin();
-	error = arch_add_memory(nid, align_start, align_size, true);
+	error = arch_add_memory(nid, align_start, align_size, false);
 	if (!error)
 		move_pfn_range_to_zone(&NODE_DATA(nid)->node_zones[ZONE_DEVICE],
 					align_start >> PAGE_SHIFT,
diff -puN mm/memory_hotplug.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-replace-for_device-by-want_memblock-in-arch_add_memory
+++ a/mm/memory_hotplug.c
@@ -1448,7 +1448,7 @@ int __ref add_memory_resource(int nid, s
 	}
 
 	/* call arch's memory hotadd */
-	ret = arch_add_memory(nid, start, size, false);
+	ret = arch_add_memory(nid, start, size, true);
 
 	if (ret < 0)
 		goto error;
_
