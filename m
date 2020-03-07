From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-add-pgprot_t-to-mhp_params.patch
 added to -mm tree
Date: Sat, 07 Mar 2020 15:04:59 -0800
Message-ID: <20200307230459.l3EoH3ry5%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgCGXFC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Mar 2020 18:05:02 -0500
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@redhat.com, ebadger@gigaio.com, hch@lst.de, hpa@zytor.com, jgg@ziepe.ca, logang@deltatee.com, luto@kernel.org, mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: mm/memory_hotplug: add pgprot_t to mhp_params
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-add-pgprot_t-to-mhp_params.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-add-pgprot_t-to-mhp_params.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-add-pgprot_t-to-mhp_params.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Logan Gunthorpe <logang@deltatee.com>
Subject: mm/memory_hotplug: add pgprot_t to mhp_params

devm_memremap_pages() is currently used by the PCI P2PDMA code to create
struct page mappings for IO memory.  At present, these mappings are
created with PAGE_KERNEL which implies setting the PAT bits to be WB. 
However, on x86, an mtrr register will typically override this and force
the cache type to be UC-.  In the case firmware doesn't set this register
it is effectively WB and will typically result in a machine check
exception when it's accessed.

Other arches are not currently likely to function correctly seeing they
don't have any MTRR registers to fall back on.

To solve this, provide a way to specify the pgprot value explicitly to
arch_add_memory().

Of the arches that support MEMORY_HOTPLUG: x86_64, and arm64 need a simple
change to pass the pgprot_t down to their respective functions which set
up the page tables.  For x86_32, set the page tables explicitly using
_set_memory_prot() (seeing they are already mapped).  For ia64, s390 and
sh, reject anything but PAGE_KERNEL settings -- this should be fine, for
now, seeing these architectures don't support ZONE_DEVICE.

A check in __add_pages() is also added to ensure the pgprot parameter was
set for all arches.

Link: http://lkml.kernel.org/r/20200306170846.9333-7-logang@deltatee.com
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
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

 arch/arm64/mm/mmu.c            |    3 ++-
 arch/ia64/mm/init.c            |    3 +++
 arch/powerpc/mm/mem.c          |    3 ++-
 arch/s390/mm/init.c            |    3 +++
 arch/sh/mm/init.c              |    3 +++
 arch/x86/mm/init_32.c          |   12 ++++++++++++
 arch/x86/mm/init_64.c          |    2 +-
 include/linux/memory_hotplug.h |    3 +++
 mm/memory_hotplug.c            |    5 ++++-
 mm/memremap.c                  |    6 +++---
 10 files changed, 36 insertions(+), 7 deletions(-)

--- a/arch/arm64/mm/mmu.c~mm-memory_hotplug-add-pgprot_t-to-mhp_params
+++ a/arch/arm64/mm/mmu.c
@@ -1382,7 +1382,8 @@ int arch_add_memory(int nid, u64 start,
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	__create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
-			     size, PAGE_KERNEL, __pgd_pgtable_alloc, flags);
+			     size, params->pgprot, __pgd_pgtable_alloc,
+			     flags);
 
 	memblock_clear_nomap(start, size);
 
--- a/arch/ia64/mm/init.c~mm-memory_hotplug-add-pgprot_t-to-mhp_params
+++ a/arch/ia64/mm/init.c
@@ -676,6 +676,9 @@ int arch_add_memory(int nid, u64 start,
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
+	if (WARN_ON_ONCE(params->pgprot.pgprot != PAGE_KERNEL.pgprot))
+		return -EINVAL;
+
 	ret = __add_pages(nid, start_pfn, nr_pages, params);
 	if (ret)
 		printk("%s: Problem encountered in __add_pages() as ret=%d\n",
--- a/arch/powerpc/mm/mem.c~mm-memory_hotplug-add-pgprot_t-to-mhp_params
+++ a/arch/powerpc/mm/mem.c
@@ -132,7 +132,8 @@ int __ref arch_add_memory(int nid, u64 s
 	resize_hpt_for_hotplug(memblock_phys_mem_size());
 
 	start = (unsigned long)__va(start);
-	rc = create_section_mapping(start, start + size, nid, PAGE_KERNEL);
+	rc = create_section_mapping(start, start + size, nid,
+				    params->pgprot);
 	if (rc) {
 		pr_warn("Unable to create mapping for hot added memory 0x%llx..0x%llx: %d\n",
 			start, start + size, rc);
--- a/arch/s390/mm/init.c~mm-memory_hotplug-add-pgprot_t-to-mhp_params
+++ a/arch/s390/mm/init.c
@@ -277,6 +277,9 @@ int arch_add_memory(int nid, u64 start,
 	if (WARN_ON_ONCE(params->altmap))
 		return -EINVAL;
 
+	if (WARN_ON_ONCE(params->pgprot.pgprot != PAGE_KERNEL.pgprot))
+		return -EINVAL;
+
 	rc = vmem_add_mapping(start, size);
 	if (rc)
 		return rc;
--- a/arch/sh/mm/init.c~mm-memory_hotplug-add-pgprot_t-to-mhp_params
+++ a/arch/sh/mm/init.c
@@ -412,6 +412,9 @@ int arch_add_memory(int nid, u64 start,
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
+	if (WARN_ON_ONCE(params->pgprot.pgprot != PAGE_KERNEL.pgprot)
+		return -EINVAL;
+
 	/* We only have ZONE_NORMAL, so this is easy.. */
 	ret = __add_pages(nid, start_pfn, nr_pages, params);
 	if (unlikely(ret))
--- a/arch/x86/mm/init_32.c~mm-memory_hotplug-add-pgprot_t-to-mhp_params
+++ a/arch/x86/mm/init_32.c
@@ -858,6 +858,18 @@ int arch_add_memory(int nid, u64 start,
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
+	int ret;
+
+	/*
+	 * The page tables were already mapped at boot so if the caller
+	 * requests a different mapping type then we must change all the
+	 * pages with __set_memory_prot().
+	 */
+	if (params->pgprot.pgprot != PAGE_KERNEL.pgprot) {
+		ret = __set_memory_prot(start, nr_pages, params->pgprot);
+		if (ret)
+			return ret;
+	}
 
 	return __add_pages(nid, start_pfn, nr_pages, params);
 }
--- a/arch/x86/mm/init_64.c~mm-memory_hotplug-add-pgprot_t-to-mhp_params
+++ a/arch/x86/mm/init_64.c
@@ -868,7 +868,7 @@ int arch_add_memory(int nid, u64 start,
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	init_memory_mapping(start, start + size, PAGE_KERNEL);
+	init_memory_mapping(start, start + size, params->pgprot);
 
 	return add_pages(nid, start_pfn, nr_pages, params);
 }
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-add-pgprot_t-to-mhp_params
+++ a/include/linux/memory_hotplug.h
@@ -56,9 +56,12 @@ enum {
 /*
  * Extended parameters for memory hotplug:
  * altmap: alternative allocator for memmap array (optional)
+ * pgprot: page protection flags to apply to newly created page tables
+ *	(required)
  */
 struct mhp_params {
 	struct vmem_altmap *altmap;
+	pgprot_t pgprot;
 };
 
 /*
--- a/mm/memory_hotplug.c~mm-memory_hotplug-add-pgprot_t-to-mhp_params
+++ a/mm/memory_hotplug.c
@@ -312,6 +312,9 @@ int __ref __add_pages(int nid, unsigned
 	int err;
 	struct vmem_altmap *altmap = params->altmap;
 
+	if (WARN_ON_ONCE(!params->pgprot.pgprot))
+		return -EINVAL;
+
 	err = check_hotplug_memory_addressable(pfn, nr_pages);
 	if (err)
 		return err;
@@ -1002,7 +1005,7 @@ static int online_memory_block(struct me
  */
 int __ref add_memory_resource(int nid, struct resource *res)
 {
-	struct mhp_params params = {};
+	struct mhp_params params = { .pgprot = PAGE_KERNEL };
 	u64 start, size;
 	bool new_node = false;
 	int ret;
--- a/mm/memremap.c~mm-memory_hotplug-add-pgprot_t-to-mhp_params
+++ a/mm/memremap.c
@@ -186,8 +186,8 @@ void *memremap_pages(struct dev_pagemap
 		 * We do not want any optional features only our own memmap
 		 */
 		.altmap = pgmap_altmap(pgmap),
+		.pgprot = PAGE_KERNEL,
 	};
-	pgprot_t pgprot = PAGE_KERNEL;
 	int error, is_ram;
 	bool need_devmap_managed = true;
 
@@ -275,8 +275,8 @@ void *memremap_pages(struct dev_pagemap
 	if (nid < 0)
 		nid = numa_mem_id();
 
-	error = track_pfn_remap(NULL, &pgprot, PHYS_PFN(res->start), 0,
-			resource_size(res));
+	error = track_pfn_remap(NULL, &params.pgprot, PHYS_PFN(res->start),
+				0, resource_size(res));
 	if (error)
 		goto err_pfn_remap;
 
_

Patches currently in -mm which might be from logang@deltatee.com are

mm-memory_hotplug-drop-the-flags-field-from-struct-mhp_restrictions.patch
mm-memory_hotplug-rename-mhp_restrictions-to-mhp_params.patch
x86-mm-thread-pgprot_t-through-init_memory_mapping.patch
x86-mm-introduce-__set_memory_prot.patch
powerpc-mm-thread-pgprot_t-through-create_section_mapping.patch
mm-memory_hotplug-add-pgprot_t-to-mhp_params.patch
mm-memremap-set-caching-mode-for-pci-p2pdma-memory-to-wc.patch
