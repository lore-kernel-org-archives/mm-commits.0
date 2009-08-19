From: akpm@linux-foundation.org
Subject: + mm-dont-use-alloc_bootmem_low-where-not-strictly-needed.patch added to -mm tree
Date: Wed, 19 Aug 2009 14:35:58 -0700
Message-ID: <200908192135.n7JLZw1P025038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114AbZHSVgW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 17:36:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, hpa@zytor.com, jbeulich@novell.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     mm: don't use alloc_bootmem_low() where not strictly needed
has been added to the -mm tree.  Its filename is
     mm-dont-use-alloc_bootmem_low-where-not-strictly-needed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: don't use alloc_bootmem_low() where not strictly needed
From: "Jan Beulich" <JBeulich@novell.com>

Since alloc_bootmem() will never return inaccessible (via virtual
addressing) memory anyway, using the ..._low() variant only makes sense
when the physical address range of the allocated memory must fulfill
further constraints, espacially since on 64-bits (or more generally in all
cases where the pools the two variants allocate from are than the full
available range.

Probably the use in alloc_tce_table() could also be eliminated (based on
code inspection of pci-calgary_64.c), but that seems too risky given I
know nothing about that hardware and have no way to test it.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/e820.c    |    2 +-
 arch/x86/mm/init_32.c     |    4 ++--
 drivers/firmware/memmap.c |    2 +-
 kernel/power/snapshot.c   |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/e820.c~mm-dont-use-alloc_bootmem_low-where-not-strictly-needed arch/x86/kernel/e820.c
--- a/arch/x86/kernel/e820.c~mm-dont-use-alloc_bootmem_low-where-not-strictly-needed
+++ a/arch/x86/kernel/e820.c
@@ -1331,7 +1331,7 @@ void __init e820_reserve_resources(void)
 	struct resource *res;
 	u64 end;
 
-	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
+	res = alloc_bootmem(sizeof(struct resource) * e820.nr_map);
 	e820_res = res;
 	for (i = 0; i < e820.nr_map; i++) {
 		end = e820.map[i].addr + e820.map[i].size - 1;
diff -puN arch/x86/mm/init_32.c~mm-dont-use-alloc_bootmem_low-where-not-strictly-needed arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~mm-dont-use-alloc_bootmem_low-where-not-strictly-needed
+++ a/arch/x86/mm/init_32.c
@@ -84,7 +84,7 @@ static pmd_t * __init one_md_table_init(
 #ifdef CONFIG_X86_PAE
 	if (!(pgd_val(*pgd) & _PAGE_PRESENT)) {
 		if (after_bootmem)
-			pmd_table = (pmd_t *)alloc_bootmem_low_pages(PAGE_SIZE);
+			pmd_table = (pmd_t *)alloc_bootmem_pages(PAGE_SIZE);
 		else
 			pmd_table = (pmd_t *)alloc_low_page();
 		paravirt_alloc_pmd(&init_mm, __pa(pmd_table) >> PAGE_SHIFT);
@@ -116,7 +116,7 @@ static pte_t * __init one_page_table_ini
 #endif
 			if (!page_table)
 				page_table =
-				(pte_t *)alloc_bootmem_low_pages(PAGE_SIZE);
+				(pte_t *)alloc_bootmem_pages(PAGE_SIZE);
 		} else
 			page_table = (pte_t *)alloc_low_page();
 
diff -puN drivers/firmware/memmap.c~mm-dont-use-alloc_bootmem_low-where-not-strictly-needed drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~mm-dont-use-alloc_bootmem_low-where-not-strictly-needed
+++ a/drivers/firmware/memmap.c
@@ -164,7 +164,7 @@ int __init firmware_map_add_early(u64 st
 {
 	struct firmware_map_entry *entry;
 
-	entry = alloc_bootmem_low(sizeof(struct firmware_map_entry));
+	entry = alloc_bootmem(sizeof(struct firmware_map_entry));
 	if (WARN_ON(!entry))
 		return -ENOMEM;
 
diff -puN kernel/power/snapshot.c~mm-dont-use-alloc_bootmem_low-where-not-strictly-needed kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~mm-dont-use-alloc_bootmem_low-where-not-strictly-needed
+++ a/kernel/power/snapshot.c
@@ -619,7 +619,7 @@ __register_nosave_region(unsigned long s
 		BUG_ON(!region);
 	} else
 		/* This allocation cannot fail */
-		region = alloc_bootmem_low(sizeof(struct nosave_region));
+		region = alloc_bootmem(sizeof(struct nosave_region));
 	region->start_pfn = start_pfn;
 	region->end_pfn = end_pfn;
 	list_add_tail(&region->list, &nosave_regions);
_

Patches currently in -mm which might be from JBeulich@novell.com are

linux-next.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
mm-dont-use-alloc_bootmem_low-where-not-strictly-needed.patch

