From: akpm@linux-foundation.org
Subject: [merged] mm-memory_hotplug-introduce-add_pages.patch
 removed from -mm tree
Date: Mon, 11 Sep 2017 12:38:57 -0700
Message-ID: <20170911193857.eNmkHGHCS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48798 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbdIKTi7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:38:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dan.j.williams@intel.com, dnellans@nvidia.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, liubo95@huawei.com, mhairgrove@nvidia.com, mhocko@suse.com, mm-commits@vger.kernel.org, paulmck@linux.vnet.ibm.com, ross.zwisler@linux.intel.com, SCheung@nvidia.com, sgutti@nvidia.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm/memory_hotplug: introduce add_pages
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-introduce-add_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm/memory_hotplug: introduce add_pages

There are new users of memory hotplug emerging.  Some of them require
different subset of arch_add_memory.  There are some which only require
allocation of struct pages without mapping those pages to the kernel
address space.  We currently have __add_pages for that purpose.  But this
is rather lowlevel and not very suitable for the code outside of the
memory hotplug.  E.g.  x86_64 wants to update max_pfn which should be done
by the caller.  Introduce add_pages() which should care about those
details if they are needed.  Each architecture should define its
implementation and select CONFIG_ARCH_HAS_ADD_PAGES.  All others use the
currently existing __add_pages.

Link: http://lkml.kernel.org/r/20170817000548.32038-7-jglisse@redhat.com
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Evgeny Baskakov <ebaskakov@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mark Hairgrove <mhairgrove@nvidia.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Sherry Cheung <SCheung@nvidia.com>
Cc: Subhash Gutti <sgutti@nvidia.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Bob Liu <liubo95@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig               |    4 ++++
 arch/x86/mm/init_64.c          |   22 +++++++++++++++-------
 include/linux/memory_hotplug.h |   11 +++++++++++
 3 files changed, 30 insertions(+), 7 deletions(-)

diff -puN arch/x86/Kconfig~mm-memory_hotplug-introduce-add_pages arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-memory_hotplug-introduce-add_pages
+++ a/arch/x86/Kconfig
@@ -2323,6 +2323,10 @@ source "kernel/livepatch/Kconfig"
 
 endmenu
 
+config ARCH_HAS_ADD_PAGES
+	def_bool y
+	depends on X86_64 && ARCH_ENABLE_MEMORY_HOTPLUG
+
 config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
 	depends on X86_64 || (X86_32 && HIGHMEM)
diff -puN arch/x86/mm/init_64.c~mm-memory_hotplug-introduce-add_pages arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-memory_hotplug-introduce-add_pages
+++ a/arch/x86/mm/init_64.c
@@ -761,7 +761,7 @@ void __init paging_init(void)
  * After memory hotplug the variables max_pfn, max_low_pfn and high_memory need
  * updating.
  */
-static void  update_end_of_memory_vars(u64 start, u64 size)
+static void update_end_of_memory_vars(u64 start, u64 size)
 {
 	unsigned long end_pfn = PFN_UP(start + size);
 
@@ -772,22 +772,30 @@ static void  update_end_of_memory_vars(u
 	}
 }
 
-int arch_add_memory(int nid, u64 start, u64 size, bool want_memblock)
+int add_pages(int nid, unsigned long start_pfn,
+	      unsigned long nr_pages, bool want_memblock)
 {
-	unsigned long start_pfn = start >> PAGE_SHIFT;
-	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
-	init_memory_mapping(start, start + size);
-
 	ret = __add_pages(nid, start_pfn, nr_pages, want_memblock);
 	WARN_ON_ONCE(ret);
 
 	/* update max_pfn, max_low_pfn and high_memory */
-	update_end_of_memory_vars(start, size);
+	update_end_of_memory_vars(start_pfn << PAGE_SHIFT,
+				  nr_pages << PAGE_SHIFT);
 
 	return ret;
 }
+
+int arch_add_memory(int nid, u64 start, u64 size, bool want_memblock)
+{
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+
+	init_memory_mapping(start, start + size);
+
+	return add_pages(nid, start_pfn, nr_pages, want_memblock);
+}
 EXPORT_SYMBOL_GPL(arch_add_memory);
 
 #define PAGE_INUSE 0xFD
diff -puN include/linux/memory_hotplug.h~mm-memory_hotplug-introduce-add_pages include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-introduce-add_pages
+++ a/include/linux/memory_hotplug.h
@@ -133,6 +133,17 @@ extern int __remove_pages(struct zone *z
 extern int __add_pages(int nid, unsigned long start_pfn,
 	unsigned long nr_pages, bool want_memblock);
 
+#ifndef CONFIG_ARCH_HAS_ADD_PAGES
+static inline int add_pages(int nid, unsigned long start_pfn,
+			    unsigned long nr_pages, bool want_memblock)
+{
+	return __add_pages(nid, start_pfn, nr_pages, want_memblock);
+}
+#else /* ARCH_HAS_ADD_PAGES */
+int add_pages(int nid, unsigned long start_pfn,
+	      unsigned long nr_pages, bool want_memblock);
+#endif /* ARCH_HAS_ADD_PAGES */
+
 #ifdef CONFIG_NUMA
 extern int memory_add_physaddr_to_nid(u64 start);
 #else
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
treewide-remove-gfp_temporary-allocation-flag.patch

