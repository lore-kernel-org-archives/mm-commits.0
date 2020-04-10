From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 20/35] mm/memory_hotplug: rename mhp_restrictions
 to mhp_params
Date: Fri, 10 Apr 2020 14:33:21 -0700
Message-ID: <20200410213321.S-XgeJDgS%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgDJVdW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:33:22 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@redhat.com, ebadger@gigaio.com, hch@lst.de, hpa@zytor.com, jgg@ziepe.ca, linux-mm@kvack.org, logang@deltatee.com, luto@kernel.org, mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, torvalds@linux-foundation.org, will@kernel.org

From: Logan Gunthorpe <logang@deltatee.com>
Subject: mm/memory_hotplug: rename mhp_restrictions to mhp_params

The mhp_restrictions struct really doesn't specify anything resembling a
restriction anymore so rename it to be mhp_params as it is a list of
extended parameters.

Link: http://lkml.kernel.org/r/20200306170846.9333-3-logang@deltatee.com
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Eric Badger <ebadger@gigaio.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c            |    4 ++--
 arch/ia64/mm/init.c            |    4 ++--
 arch/powerpc/mm/mem.c          |    4 ++--
 arch/s390/mm/init.c            |    6 +++---
 arch/sh/mm/init.c              |    4 ++--
 arch/x86/mm/init_32.c          |    4 ++--
 arch/x86/mm/init_64.c          |    8 ++++----
 include/linux/memory_hotplug.h |   16 ++++++++--------
 mm/memory_hotplug.c            |    8 ++++----
 mm/memremap.c                  |    8 ++++----
 10 files changed, 33 insertions(+), 33 deletions(-)

--- a/arch/arm64/mm/mmu.c~mm-memory_hotplug-rename-mhp_restrictions-to-mhp_params
+++ a/arch/arm64/mm/mmu.c
@@ -1374,7 +1374,7 @@ static void __remove_pgd_mapping(pgd_t *
 }
 
 int arch_add_memory(int nid, u64 start, u64 size,
-			struct mhp_restrictions *restrictions)
+		    struct mhp_params *params)
 {
 	int ret, flags = 0;
 
@@ -1387,7 +1387,7 @@ int arch_add_memory(int nid, u64 start,
 	memblock_clear_nomap(start, size);
 
 	ret = __add_pages(nid, start >> PAGE_SHIFT, size >> PAGE_SHIFT,
-			   restrictions);
+			   params);
 	if (ret)
 		__remove_pgd_mapping(swapper_pg_dir,
 				     __phys_to_virt(start), size);
--- a/arch/ia64/mm/init.c~mm-memory_hotplug-rename-mhp_restrictions-to-mhp_params
+++ a/arch/ia64/mm/init.c
@@ -670,13 +670,13 @@ mem_init (void)
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 int arch_add_memory(int nid, u64 start, u64 size,
-			struct mhp_restrictions *restrictions)
+		    struct mhp_params *params)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
-	ret = __add_pages(nid, start_pfn, nr_pages, restrictions);
+	ret = __add_pages(nid, start_pfn, nr_pages, params);
 	if (ret)
 		printk("%s: Problem encountered in __add_pages() as ret=%d\n",
 		       __func__,  ret);
--- a/arch/powerpc/mm/mem.c~mm-memory_hotplug-rename-mhp_restrictions-to-mhp_params
+++ a/arch/powerpc/mm/mem.c
@@ -122,7 +122,7 @@ static void flush_dcache_range_chunked(u
 }
 
 int __ref arch_add_memory(int nid, u64 start, u64 size,
-			struct mhp_restrictions *restrictions)
+			  struct mhp_params *params)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
@@ -138,7 +138,7 @@ int __ref arch_add_memory(int nid, u64 s
 		return -EFAULT;
 	}
 
-	return __add_pages(nid, start_pfn, nr_pages, restrictions);
+	return __add_pages(nid, start_pfn, nr_pages, params);
 }
 
 void __ref arch_remove_memory(int nid, u64 start, u64 size,
--- a/arch/s390/mm/init.c~mm-memory_hotplug-rename-mhp_restrictions-to-mhp_params
+++ a/arch/s390/mm/init.c
@@ -268,20 +268,20 @@ device_initcall(s390_cma_mem_init);
 #endif /* CONFIG_CMA */
 
 int arch_add_memory(int nid, u64 start, u64 size,
-		struct mhp_restrictions *restrictions)
+		    struct mhp_params *params)
 {
 	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long size_pages = PFN_DOWN(size);
 	int rc;
 
-	if (WARN_ON_ONCE(restrictions->altmap))
+	if (WARN_ON_ONCE(params->altmap))
 		return -EINVAL;
 
 	rc = vmem_add_mapping(start, size);
 	if (rc)
 		return rc;
 
-	rc = __add_pages(nid, start_pfn, size_pages, restrictions);
+	rc = __add_pages(nid, start_pfn, size_pages, params);
 	if (rc)
 		vmem_remove_mapping(start, size);
 	return rc;
--- a/arch/sh/mm/init.c~mm-memory_hotplug-rename-mhp_restrictions-to-mhp_params
+++ a/arch/sh/mm/init.c
@@ -406,14 +406,14 @@ void __init mem_init(void)
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 int arch_add_memory(int nid, u64 start, u64 size,
-			struct mhp_restrictions *restrictions)
+		    struct mhp_params *params)
 {
 	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
 	/* We only have ZONE_NORMAL, so this is easy.. */
-	ret = __add_pages(nid, start_pfn, nr_pages, restrictions);
+	ret = __add_pages(nid, start_pfn, nr_pages, params);
 	if (unlikely(ret))
 		printk("%s: Failed, __add_pages() == %d\n", __func__, ret);
 
--- a/arch/x86/mm/init_32.c~mm-memory_hotplug-rename-mhp_restrictions-to-mhp_params
+++ a/arch/x86/mm/init_32.c
@@ -819,12 +819,12 @@ void __init mem_init(void)
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 int arch_add_memory(int nid, u64 start, u64 size,
-			struct mhp_restrictions *restrictions)
+		    struct mhp_params *params)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	return __add_pages(nid, start_pfn, nr_pages, restrictions);
+	return __add_pages(nid, start_pfn, nr_pages, params);
 }
 
 void arch_remove_memory(int nid, u64 start, u64 size,
--- a/arch/x86/mm/init_64.c~mm-memory_hotplug-rename-mhp_restrictions-to-mhp_params
+++ a/arch/x86/mm/init_64.c
@@ -843,11 +843,11 @@ static void update_end_of_memory_vars(u6
 }
 
 int add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
-				struct mhp_restrictions *restrictions)
+	      struct mhp_params *params)
 {
 	int ret;
 
-	ret = __add_pages(nid, start_pfn, nr_pages, restrictions);
+	ret = __add_pages(nid, start_pfn, nr_pages, params);
 	WARN_ON_ONCE(ret);
 
 	/* update max_pfn, max_low_pfn and high_memory */
@@ -858,14 +858,14 @@ int add_pages(int nid, unsigned long sta
 }
 
 int arch_add_memory(int nid, u64 start, u64 size,
-			struct mhp_restrictions *restrictions)
+		    struct mhp_params *params)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
 	init_memory_mapping(start, start + size);
 
-	return add_pages(nid, start_pfn, nr_pages, restrictions);
+	return add_pages(nid, start_pfn, nr_pages, params);
 }
 
 #define PAGE_INUSE 0xFD
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-rename-mhp_restrictions-to-mhp_params
+++ a/include/linux/memory_hotplug.h
@@ -58,10 +58,10 @@ enum {
 };
 
 /*
- * Restrictions for the memory hotplug:
- * altmap: alternative allocator for memmap array
+ * Extended parameters for memory hotplug:
+ * altmap: alternative allocator for memmap array (optional)
  */
-struct mhp_restrictions {
+struct mhp_params {
 	struct vmem_altmap *altmap;
 };
 
@@ -112,7 +112,7 @@ extern int restore_online_page_callback(
 extern int try_online_node(int nid);
 
 extern int arch_add_memory(int nid, u64 start, u64 size,
-			struct mhp_restrictions *restrictions);
+			   struct mhp_params *params);
 extern u64 max_mem_size;
 
 extern int memhp_online_type_from_str(const char *str);
@@ -133,17 +133,17 @@ extern void __remove_pages(unsigned long
 
 /* reasonably generic interface to expand the physical pages */
 extern int __add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
-		       struct mhp_restrictions *restrictions);
+		       struct mhp_params *params);
 
 #ifndef CONFIG_ARCH_HAS_ADD_PAGES
 static inline int add_pages(int nid, unsigned long start_pfn,
-		unsigned long nr_pages, struct mhp_restrictions *restrictions)
+		unsigned long nr_pages, struct mhp_params *params)
 {
-	return __add_pages(nid, start_pfn, nr_pages, restrictions);
+	return __add_pages(nid, start_pfn, nr_pages, params);
 }
 #else /* ARCH_HAS_ADD_PAGES */
 int add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
-	      struct mhp_restrictions *restrictions);
+	      struct mhp_params *params);
 #endif /* ARCH_HAS_ADD_PAGES */
 
 #ifdef CONFIG_NUMA
--- a/mm/memory_hotplug.c~mm-memory_hotplug-rename-mhp_restrictions-to-mhp_params
+++ a/mm/memory_hotplug.c
@@ -304,12 +304,12 @@ static int check_hotplug_memory_addressa
  * add the new pages.
  */
 int __ref __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
-		struct mhp_restrictions *restrictions)
+		struct mhp_params *params)
 {
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
 	int err;
-	struct vmem_altmap *altmap = restrictions->altmap;
+	struct vmem_altmap *altmap = params->altmap;
 
 	err = check_hotplug_memory_addressable(pfn, nr_pages);
 	if (err)
@@ -1002,7 +1002,7 @@ static int online_memory_block(struct me
  */
 int __ref add_memory_resource(int nid, struct resource *res)
 {
-	struct mhp_restrictions restrictions = {};
+	struct mhp_params params = {};
 	u64 start, size;
 	bool new_node = false;
 	int ret;
@@ -1030,7 +1030,7 @@ int __ref add_memory_resource(int nid, s
 	new_node = ret;
 
 	/* call arch's memory hotadd */
-	ret = arch_add_memory(nid, start, size, &restrictions);
+	ret = arch_add_memory(nid, start, size, &params);
 	if (ret < 0)
 		goto error;
 
--- a/mm/memremap.c~mm-memory_hotplug-rename-mhp_restrictions-to-mhp_params
+++ a/mm/memremap.c
@@ -184,7 +184,7 @@ void *memremap_pages(struct dev_pagemap
 {
 	struct resource *res = &pgmap->res;
 	struct dev_pagemap *conflict_pgmap;
-	struct mhp_restrictions restrictions = {
+	struct mhp_params params = {
 		/*
 		 * We do not want any optional features only our own memmap
 		 */
@@ -302,7 +302,7 @@ void *memremap_pages(struct dev_pagemap
 	 */
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
 		error = add_pages(nid, PHYS_PFN(res->start),
-				PHYS_PFN(resource_size(res)), &restrictions);
+				PHYS_PFN(resource_size(res)), &params);
 	} else {
 		error = kasan_add_zero_shadow(__va(res->start), resource_size(res));
 		if (error) {
@@ -311,7 +311,7 @@ void *memremap_pages(struct dev_pagemap
 		}
 
 		error = arch_add_memory(nid, res->start, resource_size(res),
-					&restrictions);
+					&params);
 	}
 
 	if (!error) {
@@ -319,7 +319,7 @@ void *memremap_pages(struct dev_pagemap
 
 		zone = &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
 		move_pfn_range_to_zone(zone, PHYS_PFN(res->start),
-				PHYS_PFN(resource_size(res)), restrictions.altmap);
+				PHYS_PFN(resource_size(res)), params.altmap);
 	}
 
 	mem_hotplug_done();
_
