From: akpm@linux-foundation.org
Subject: [alternative-merged]
 x86-kasan-add-and-use-kasan_map_populate.patch removed from -mm tree
Date: Fri, 03 Nov 2017 12:00:11 -0700
Message-ID: <59fcbcbb.JzEO2hIcFWFVvBiU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55304 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756218AbdKCTAN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Nov 2017 15:00:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, bob.picco@oracle.com, borntraeger@de.ibm.com, catalin.marinas@arm.com, daniel.m.jordan@oracle.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, heiko.carstens@de.ibm.com, hpa@zytor.com, mark.rutland@arm.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, mingo@redhat.com, sam@ravnborg.org, steven.sistare@oracle.com, tglx@linutronix.de, will.deacon@arm.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/kasan: add and use kasan_map_populate()
has been removed from the -mm tree.  Its filename was
     x86-kasan-add-and-use-kasan_map_populate.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: x86/kasan: add and use kasan_map_populate()

During early boot, kasan uses vmemmap_populate() to establish its shadow
memory.  But, that interface is intended for struct pages use.

Because of the current project, vmemmap won't be zeroed during allocation,
but kasan expects that memory to be zeroed.  We are adding a new
kasan_map_populate() function to resolve this difference.

Therefore, we must use a new interface to allocate and map kasan shadow
memory, that also zeroes memory for us.

Link: http://lkml.kernel.org/r/20171013173214.27300-8-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Bob Picco <bob.picco@oracle.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/kasan_init_64.c |   75 ++++++++++++++++++++++++++++++++--
 1 file changed, 71 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/kasan_init_64.c~x86-kasan-add-and-use-kasan_map_populate arch/x86/mm/kasan_init_64.c
--- a/arch/x86/mm/kasan_init_64.c~x86-kasan-add-and-use-kasan_map_populate
+++ a/arch/x86/mm/kasan_init_64.c
@@ -16,6 +16,73 @@
 
 extern struct range pfn_mapped[E820_MAX_ENTRIES];
 
+/* Creates mappings for kasan during early boot. The mapped memory is zeroed */
+static int __meminit kasan_map_populate(unsigned long start, unsigned long end,
+					int node)
+{
+	unsigned long addr, pfn, next;
+	unsigned long long size;
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	int ret;
+
+	ret = vmemmap_populate(start, end, node);
+	/*
+	 * We might have partially populated memory, so check for no entries,
+	 * and zero only those that actually exist.
+	 */
+	for (addr = start; addr < end; addr = next) {
+		pgd = pgd_offset_k(addr);
+		if (pgd_none(*pgd)) {
+			next = pgd_addr_end(addr, end);
+			continue;
+		}
+
+		p4d = p4d_offset(pgd, addr);
+		if (p4d_none(*p4d)) {
+			next = p4d_addr_end(addr, end);
+			continue;
+		}
+
+		pud = pud_offset(p4d, addr);
+		if (pud_none(*pud)) {
+			next = pud_addr_end(addr, end);
+			continue;
+		}
+		if (pud_large(*pud)) {
+			/* This is PUD size page */
+			next = pud_addr_end(addr, end);
+			size = PUD_SIZE;
+			pfn = pud_pfn(*pud);
+		} else {
+			pmd = pmd_offset(pud, addr);
+			if (pmd_none(*pmd)) {
+				next = pmd_addr_end(addr, end);
+				continue;
+			}
+			if (pmd_large(*pmd)) {
+				/* This is PMD size page */
+				next = pmd_addr_end(addr, end);
+				size = PMD_SIZE;
+				pfn = pmd_pfn(*pmd);
+			} else {
+				pte = pte_offset_kernel(pmd, addr);
+				next = addr + PAGE_SIZE;
+				if (pte_none(*pte))
+					continue;
+				/* This is base size page */
+				size = PAGE_SIZE;
+				pfn = pte_pfn(*pte);
+			}
+		}
+		memset(phys_to_virt(PFN_PHYS(pfn)), 0, size);
+	}
+	return ret;
+}
+
 static int __init map_range(struct range *range)
 {
 	unsigned long start;
@@ -24,7 +91,7 @@ static int __init map_range(struct range
 	start = (unsigned long)kasan_mem_to_shadow(pfn_to_kaddr(range->start));
 	end = (unsigned long)kasan_mem_to_shadow(pfn_to_kaddr(range->end));
 
-	return vmemmap_populate(start, end, NUMA_NO_NODE);
+	return kasan_map_populate(start, end, NUMA_NO_NODE);
 }
 
 static void __init clear_pgds(unsigned long start,
@@ -137,9 +204,9 @@ void __init kasan_init(void)
 		kasan_mem_to_shadow((void *)PAGE_OFFSET + MAXMEM),
 		kasan_mem_to_shadow((void *)__START_KERNEL_map));
 
-	vmemmap_populate((unsigned long)kasan_mem_to_shadow(_stext),
-			(unsigned long)kasan_mem_to_shadow(_end),
-			NUMA_NO_NODE);
+	kasan_map_populate((unsigned long)kasan_mem_to_shadow(_stext),
+			   (unsigned long)kasan_mem_to_shadow(_end),
+			   NUMA_NO_NODE);
 
 	kasan_populate_zero_shadow(kasan_mem_to_shadow((void *)MODULES_END),
 			(void *)KASAN_SHADOW_END);
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-deferred_init_memmap-improvements.patch
mm-deferred_init_memmap-improvements-fix-3.patch
x86-mm-setting-fields-in-deferred-pages.patch
sparc64-mm-setting-fields-in-deferred-pages.patch
sparc64-simplify-vmemmap_populate.patch
mm-defining-memblock_virt_alloc_try_nid_raw.patch
mm-zero-reserved-and-unavailable-struct-pages.patch
x86-mm-kasan-dont-use-vmemmap_populate-to-initialize-shadow.patch
arm64-mm-kasan-dont-use-vmemmap_populate-to-initialize-shadow.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap.patch
sparc64-optimized-struct-page-zeroing.patch
mm-broken-deferred-calculation.patch
sparc64-ng4-memset-32-bits-overflow.patch

