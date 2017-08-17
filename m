From: akpm@linux-foundation.org
Subject: + mm-memory_hotplug-introduce-add_pages.patch added to -mm tree
Date: Thu, 17 Aug 2017 14:41:45 -0700
Message-ID: <59960d99.bU5kRsZMWKtSzyER%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40478 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753680AbdHQVlr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 17:41:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, SCheung@nvidia.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dan.j.williams@intel.com, dnellans@nvidia.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mhairgrove@nvidia.com, paulmck@linux.vnet.ibm.com, ross.zwisler@linux.intel.com, sgutti@nvidia.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: introduce add_pages
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-introduce-add_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-introduce-add_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-introduce-add_pages.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig               |    4 ++++
 arch/x86/mm/init_64.c          |   22 +++++++++++++++-------
 include/linux/memory_hotplug.h |   11 +++++++++++
 3 files changed, 30 insertions(+), 7 deletions(-)

diff -puN arch/x86/Kconfig~mm-memory_hotplug-introduce-add_pages arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-memory_hotplug-introduce-add_pages
+++ a/arch/x86/Kconfig
@@ -2273,6 +2273,10 @@ source "kernel/livepatch/Kconfig"
 
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

mm-fix-double-mmap_sem-unlock-on-mmf_unstable-enforced-sigbus.patch
mm-oom-fix-potential-data-corruption-when-oom_reaper-races-with-writer.patch
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
treewide-remove-gfp_temporary-allocation-flag.patch
mm-rename-global_page_state-to-global_zone_page_state.patch
mm-hugetlb-do-not-allocate-non-migrateable-gigantic-pages-from-movable-zones.patch
mm-oom-do-not-rely-on-tif_memdie-for-memory-reserves-access.patch
mm-replace-tif_memdie-checks-by-tsk_is_oom_victim.patch
mm-memory_hotplug-introduce-add_pages.patch
fs-proc-remove-priv-argument-from-is_stack.patch

