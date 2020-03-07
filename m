From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 powerpc-mm-thread-pgprot_t-through-create_section_mapping.patch added to
 -mm tree
Date: Sat, 07 Mar 2020 15:04:55 -0800
Message-ID: <20200307230455.0ZZNEKVUZ%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgCGXE5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 7 Mar 2020 18:04:57 -0500
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, bp@alien8.de, catalin.marinas@arm.com, dan.j.williams@intel.com, dave.hansen@linux.intel.com, david@redhat.com, ebadger@gigaio.com, hch@lst.de, hpa@zytor.com, jgg@ziepe.ca, logang@deltatee.com, luto@kernel.org, mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, peterz@infradead.org, tglx@linutronix.de, will@kernel.org


The patch titled
     Subject: powerpc/mm: thread pgprot_t through create_section_mapping()
has been added to the -mm tree.  Its filename is
     powerpc-mm-thread-pgprot_t-through-create_section_mapping.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-mm-thread-pgprot_t-through-create_section_mapping.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-mm-thread-pgprot_t-through-create_section_mapping.patch

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
Subject: powerpc/mm: thread pgprot_t through create_section_mapping()

In prepartion to support a pgprot_t argument for arch_add_memory().

Link: http://lkml.kernel.org/r/20200306170846.9333-6-logang@deltatee.com
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Badger <ebadger@gigaio.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/64/hash.h  |    3 ++-
 arch/powerpc/include/asm/book3s/64/radix.h |    3 ++-
 arch/powerpc/include/asm/sparsemem.h       |    3 ++-
 arch/powerpc/mm/book3s64/hash_utils.c      |    5 +++--
 arch/powerpc/mm/book3s64/pgtable.c         |    7 ++++---
 arch/powerpc/mm/book3s64/radix_pgtable.c   |   18 +++++++++++-------
 arch/powerpc/mm/mem.c                      |    5 +++--
 7 files changed, 27 insertions(+), 17 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/hash.h~powerpc-mm-thread-pgprot_t-through-create_section_mapping
+++ a/arch/powerpc/include/asm/book3s/64/hash.h
@@ -251,7 +251,8 @@ extern int __meminit hash__vmemmap_creat
 extern void hash__vmemmap_remove_mapping(unsigned long start,
 				     unsigned long page_size);
 
-int hash__create_section_mapping(unsigned long start, unsigned long end, int nid);
+int hash__create_section_mapping(unsigned long start, unsigned long end,
+				 int nid, pgprot_t prot);
 int hash__remove_section_mapping(unsigned long start, unsigned long end);
 
 #endif /* !__ASSEMBLY__ */
--- a/arch/powerpc/include/asm/book3s/64/radix.h~powerpc-mm-thread-pgprot_t-through-create_section_mapping
+++ a/arch/powerpc/include/asm/book3s/64/radix.h
@@ -289,7 +289,8 @@ static inline unsigned long radix__get_t
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-int radix__create_section_mapping(unsigned long start, unsigned long end, int nid);
+int radix__create_section_mapping(unsigned long start, unsigned long end,
+				  int nid, pgprot_t prot);
 int radix__remove_section_mapping(unsigned long start, unsigned long end);
 #endif /* CONFIG_MEMORY_HOTPLUG */
 #endif /* __ASSEMBLY__ */
--- a/arch/powerpc/include/asm/sparsemem.h~powerpc-mm-thread-pgprot_t-through-create_section_mapping
+++ a/arch/powerpc/include/asm/sparsemem.h
@@ -13,7 +13,8 @@
 #endif /* CONFIG_SPARSEMEM */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-extern int create_section_mapping(unsigned long start, unsigned long end, int nid);
+extern int create_section_mapping(unsigned long start, unsigned long end,
+				  int nid, pgprot_t prot);
 extern int remove_section_mapping(unsigned long start, unsigned long end);
 
 #ifdef CONFIG_PPC_BOOK3S_64
--- a/arch/powerpc/mm/book3s64/hash_utils.c~powerpc-mm-thread-pgprot_t-through-create_section_mapping
+++ a/arch/powerpc/mm/book3s64/hash_utils.c
@@ -809,7 +809,8 @@ int resize_hpt_for_hotplug(unsigned long
 	return 0;
 }
 
-int hash__create_section_mapping(unsigned long start, unsigned long end, int nid)
+int hash__create_section_mapping(unsigned long start, unsigned long end,
+				 int nid, pgprot_t prot)
 {
 	int rc;
 
@@ -819,7 +820,7 @@ int hash__create_section_mapping(unsigne
 	}
 
 	rc = htab_bolt_mapping(start, end, __pa(start),
-			       pgprot_val(PAGE_KERNEL), mmu_linear_psize,
+			       pgprot_val(prot), mmu_linear_psize,
 			       mmu_kernel_ssize);
 
 	if (rc < 0) {
--- a/arch/powerpc/mm/book3s64/pgtable.c~powerpc-mm-thread-pgprot_t-through-create_section_mapping
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -171,12 +171,13 @@ void mmu_cleanup_all(void)
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-int __meminit create_section_mapping(unsigned long start, unsigned long end, int nid)
+int __meminit create_section_mapping(unsigned long start, unsigned long end,
+				     int nid, pgprot_t prot)
 {
 	if (radix_enabled())
-		return radix__create_section_mapping(start, end, nid);
+		return radix__create_section_mapping(start, end, nid, prot);
 
-	return hash__create_section_mapping(start, end, nid);
+	return hash__create_section_mapping(start, end, nid, prot);
 }
 
 int __meminit remove_section_mapping(unsigned long start, unsigned long end)
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-mm-thread-pgprot_t-through-create_section_mapping
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -253,7 +253,7 @@ static unsigned long next_boundary(unsig
 
 static int __meminit create_physical_mapping(unsigned long start,
 					     unsigned long end,
-					     int nid)
+					     int nid, pgprot_t _prot)
 {
 	unsigned long vaddr, addr, mapping_size = 0;
 	bool prev_exec, exec = false;
@@ -289,7 +289,7 @@ static int __meminit create_physical_map
 			prot = PAGE_KERNEL_X;
 			exec = true;
 		} else {
-			prot = PAGE_KERNEL;
+			prot = _prot;
 			exec = false;
 		}
 
@@ -333,7 +333,7 @@ static void __init radix_init_pgtable(vo
 
 		WARN_ON(create_physical_mapping(reg->base,
 						reg->base + reg->size,
-						-1));
+						-1, PAGE_KERNEL));
 	}
 
 	/* Find out how many PID bits are supported */
@@ -712,8 +712,10 @@ static int __meminit stop_machine_change
 
 	spin_unlock(&init_mm.page_table_lock);
 	pte_clear(&init_mm, params->aligned_start, params->pte);
-	create_physical_mapping(__pa(params->aligned_start), __pa(params->start), -1);
-	create_physical_mapping(__pa(params->end), __pa(params->aligned_end), -1);
+	create_physical_mapping(__pa(params->aligned_start),
+				__pa(params->start), -1, PAGE_KERNEL);
+	create_physical_mapping(__pa(params->end), __pa(params->aligned_end),
+				-1, PAGE_KERNEL);
 	spin_lock(&init_mm.page_table_lock);
 	return 0;
 }
@@ -870,14 +872,16 @@ static void __meminit remove_pagetable(u
 	radix__flush_tlb_kernel_range(start, end);
 }
 
-int __meminit radix__create_section_mapping(unsigned long start, unsigned long end, int nid)
+int __meminit radix__create_section_mapping(unsigned long start,
+					    unsigned long end, int nid,
+					    pgprot_t prot)
 {
 	if (end >= RADIX_VMALLOC_START) {
 		pr_warn("Outside the supported range\n");
 		return -1;
 	}
 
-	return create_physical_mapping(__pa(start), __pa(end), nid);
+	return create_physical_mapping(__pa(start), __pa(end), nid, prot);
 }
 
 int __meminit radix__remove_section_mapping(unsigned long start, unsigned long end)
--- a/arch/powerpc/mm/mem.c~powerpc-mm-thread-pgprot_t-through-create_section_mapping
+++ a/arch/powerpc/mm/mem.c
@@ -90,7 +90,8 @@ int memory_add_physaddr_to_nid(u64 start
 }
 #endif
 
-int __weak create_section_mapping(unsigned long start, unsigned long end, int nid)
+int __weak create_section_mapping(unsigned long start, unsigned long end,
+				  int nid, pgprot_t prot)
 {
 	return -ENODEV;
 }
@@ -131,7 +132,7 @@ int __ref arch_add_memory(int nid, u64 s
 	resize_hpt_for_hotplug(memblock_phys_mem_size());
 
 	start = (unsigned long)__va(start);
-	rc = create_section_mapping(start, start + size, nid);
+	rc = create_section_mapping(start, start + size, nid, PAGE_KERNEL);
 	if (rc) {
 		pr_warn("Unable to create mapping for hot added memory 0x%llx..0x%llx: %d\n",
 			start, start + size, rc);
_

Patches currently in -mm which might be from logang@deltatee.com are

mm-memory_hotplug-drop-the-flags-field-from-struct-mhp_restrictions.patch
mm-memory_hotplug-rename-mhp_restrictions-to-mhp_params.patch
x86-mm-thread-pgprot_t-through-init_memory_mapping.patch
x86-mm-introduce-__set_memory_prot.patch
powerpc-mm-thread-pgprot_t-through-create_section_mapping.patch
mm-memory_hotplug-add-pgprot_t-to-mhp_params.patch
mm-memremap-set-caching-mode-for-pci-p2pdma-memory-to-wc.patch
