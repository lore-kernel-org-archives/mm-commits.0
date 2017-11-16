From: akpm@linux-foundation.org
Subject: [patch 087/131] x86/mm/kasan: don't use vmemmap_populate()
 to initialize shadow
Date: Wed, 15 Nov 2017 17:36:35 -0800
Message-ID: <20171116013635.0PDciisip%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40002 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933233AbdKPBgi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:36:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, bob.picco@oracle.com, borntraeger@de.ibm.com, catalin.marinas@arm.com, daniel.m.jordan@oracle.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, heiko.carstens@de.ibm.com, hpa@zytor.com, mark.rutland@arm.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org, pasha.tatashin@oracle.com, sam@ravnborg.org, steven.sistare@oracle.com, tglx@linutronix.de, torvalds@linux-foundation.org, will.deacon@arm.com, willy@infradead.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: x86/mm/kasan: don't use vmemmap_populate() to initialize shadow

The kasan shadow is currently mapped using vmemmap_populate() since that
provides a semi-convenient way to map pages into init_top_pgt.  However,
since that no longer zeroes the mapped pages, it is not suitable for
kasan, which requires zeroed shadow memory.

Add kasan_populate_shadow() interface and use it instead of
vmemmap_populate().  Besides, this allows us to take advantage of gigantic
pages and use them to populate the shadow, which should save us some
memory wasted on page tables and reduce TLB pressure.

Link: http://lkml.kernel.org/r/20171103185147.2688-2-pasha.tatashin@oracle.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Bob Picco <bob.picco@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig            |    2 
 arch/x86/mm/kasan_init_64.c |  143 ++++++++++++++++++++++++++++++++--
 2 files changed, 137 insertions(+), 8 deletions(-)

diff -puN arch/x86/Kconfig~x86-mm-kasan-dont-use-vmemmap_populate-to-initialize-shadow arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86-mm-kasan-dont-use-vmemmap_populate-to-initialize-shadow
+++ a/arch/x86/Kconfig
@@ -110,7 +110,7 @@ config X86
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_HUGE_VMAP		if X86_64 || X86_PAE
 	select HAVE_ARCH_JUMP_LABEL
-	select HAVE_ARCH_KASAN			if X86_64 && SPARSEMEM_VMEMMAP
+	select HAVE_ARCH_KASAN			if X86_64
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_MMAP_RND_BITS		if MMU
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS	if MMU && COMPAT
diff -puN arch/x86/mm/kasan_init_64.c~x86-mm-kasan-dont-use-vmemmap_populate-to-initialize-shadow arch/x86/mm/kasan_init_64.c
--- a/arch/x86/mm/kasan_init_64.c~x86-mm-kasan-dont-use-vmemmap_populate-to-initialize-shadow
+++ a/arch/x86/mm/kasan_init_64.c
@@ -4,12 +4,14 @@
 #include <linux/bootmem.h>
 #include <linux/kasan.h>
 #include <linux/kdebug.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/sched/task.h>
 #include <linux/vmalloc.h>
 
 #include <asm/e820/types.h>
+#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
 #include <asm/pgtable.h>
@@ -18,7 +20,134 @@ extern struct range pfn_mapped[E820_MAX_
 
 static p4d_t tmp_p4d_table[PTRS_PER_P4D] __initdata __aligned(PAGE_SIZE);
 
-static int __init map_range(struct range *range)
+static __init void *early_alloc(size_t size, int nid)
+{
+	return memblock_virt_alloc_try_nid_nopanic(size, size,
+		__pa(MAX_DMA_ADDRESS), BOOTMEM_ALLOC_ACCESSIBLE, nid);
+}
+
+static void __init kasan_populate_pmd(pmd_t *pmd, unsigned long addr,
+				      unsigned long end, int nid)
+{
+	pte_t *pte;
+
+	if (pmd_none(*pmd)) {
+		void *p;
+
+		if (boot_cpu_has(X86_FEATURE_PSE) &&
+		    ((end - addr) == PMD_SIZE) &&
+		    IS_ALIGNED(addr, PMD_SIZE)) {
+			p = early_alloc(PMD_SIZE, nid);
+			if (p && pmd_set_huge(pmd, __pa(p), PAGE_KERNEL))
+				return;
+			else if (p)
+				memblock_free(__pa(p), PMD_SIZE);
+		}
+
+		p = early_alloc(PAGE_SIZE, nid);
+		pmd_populate_kernel(&init_mm, pmd, p);
+	}
+
+	pte = pte_offset_kernel(pmd, addr);
+	do {
+		pte_t entry;
+		void *p;
+
+		if (!pte_none(*pte))
+			continue;
+
+		p = early_alloc(PAGE_SIZE, nid);
+		entry = pfn_pte(PFN_DOWN(__pa(p)), PAGE_KERNEL);
+		set_pte_at(&init_mm, addr, pte, entry);
+	} while (pte++, addr += PAGE_SIZE, addr != end);
+}
+
+static void __init kasan_populate_pud(pud_t *pud, unsigned long addr,
+				      unsigned long end, int nid)
+{
+	pmd_t *pmd;
+	unsigned long next;
+
+	if (pud_none(*pud)) {
+		void *p;
+
+		if (boot_cpu_has(X86_FEATURE_GBPAGES) &&
+		    ((end - addr) == PUD_SIZE) &&
+		    IS_ALIGNED(addr, PUD_SIZE)) {
+			p = early_alloc(PUD_SIZE, nid);
+			if (p && pud_set_huge(pud, __pa(p), PAGE_KERNEL))
+				return;
+			else if (p)
+				memblock_free(__pa(p), PUD_SIZE);
+		}
+
+		p = early_alloc(PAGE_SIZE, nid);
+		pud_populate(&init_mm, pud, p);
+	}
+
+	pmd = pmd_offset(pud, addr);
+	do {
+		next = pmd_addr_end(addr, end);
+		if (!pmd_large(*pmd))
+			kasan_populate_pmd(pmd, addr, next, nid);
+	} while (pmd++, addr = next, addr != end);
+}
+
+static void __init kasan_populate_p4d(p4d_t *p4d, unsigned long addr,
+				      unsigned long end, int nid)
+{
+	pud_t *pud;
+	unsigned long next;
+
+	if (p4d_none(*p4d)) {
+		void *p = early_alloc(PAGE_SIZE, nid);
+
+		p4d_populate(&init_mm, p4d, p);
+	}
+
+	pud = pud_offset(p4d, addr);
+	do {
+		next = pud_addr_end(addr, end);
+		if (!pud_large(*pud))
+			kasan_populate_pud(pud, addr, next, nid);
+	} while (pud++, addr = next, addr != end);
+}
+
+static void __init kasan_populate_pgd(pgd_t *pgd, unsigned long addr,
+				      unsigned long end, int nid)
+{
+	void *p;
+	p4d_t *p4d;
+	unsigned long next;
+
+	if (pgd_none(*pgd)) {
+		p = early_alloc(PAGE_SIZE, nid);
+		pgd_populate(&init_mm, pgd, p);
+	}
+
+	p4d = p4d_offset(pgd, addr);
+	do {
+		next = p4d_addr_end(addr, end);
+		kasan_populate_p4d(p4d, addr, next, nid);
+	} while (p4d++, addr = next, addr != end);
+}
+
+static void __init kasan_populate_shadow(unsigned long addr, unsigned long end,
+					 int nid)
+{
+	pgd_t *pgd;
+	unsigned long next;
+
+	addr = addr & PAGE_MASK;
+	end = round_up(end, PAGE_SIZE);
+	pgd = pgd_offset_k(addr);
+	do {
+		next = pgd_addr_end(addr, end);
+		kasan_populate_pgd(pgd, addr, next, nid);
+	} while (pgd++, addr = next, addr != end);
+}
+
+static void __init map_range(struct range *range)
 {
 	unsigned long start;
 	unsigned long end;
@@ -26,7 +155,7 @@ static int __init map_range(struct range
 	start = (unsigned long)kasan_mem_to_shadow(pfn_to_kaddr(range->start));
 	end = (unsigned long)kasan_mem_to_shadow(pfn_to_kaddr(range->end));
 
-	return vmemmap_populate(start, end, NUMA_NO_NODE);
+	kasan_populate_shadow(start, end, early_pfn_to_nid(range->start));
 }
 
 static void __init clear_pgds(unsigned long start,
@@ -189,16 +318,16 @@ void __init kasan_init(void)
 		if (pfn_mapped[i].end == 0)
 			break;
 
-		if (map_range(&pfn_mapped[i]))
-			panic("kasan: unable to allocate shadow!");
+		map_range(&pfn_mapped[i]);
 	}
+
 	kasan_populate_zero_shadow(
 		kasan_mem_to_shadow((void *)PAGE_OFFSET + MAXMEM),
 		kasan_mem_to_shadow((void *)__START_KERNEL_map));
 
-	vmemmap_populate((unsigned long)kasan_mem_to_shadow(_stext),
-			(unsigned long)kasan_mem_to_shadow(_end),
-			NUMA_NO_NODE);
+	kasan_populate_shadow((unsigned long)kasan_mem_to_shadow(_stext),
+			      (unsigned long)kasan_mem_to_shadow(_end),
+			      early_pfn_to_nid(__pa(_stext)));
 
 	kasan_populate_zero_shadow(kasan_mem_to_shadow((void *)MODULES_END),
 			(void *)KASAN_SHADOW_END);
_
