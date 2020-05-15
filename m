From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-32-implement-arch_sync_kernel_mappings.patch
 added to -mm tree
Date: Fri, 15 May 2020 13:06:26 -0700
Message-ID: <20200515200626.3be-WYluv%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgEOUG2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 15 May 2020 16:06:28 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, dave.hansen@linux.intel.com, hch@lst.de, hpa@zytor.com, jroedel@suse.de, luto@kernel.org, mhocko@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org, peterz@infradead.org, rjw@rjwysocki.net, rostedt@goodmis.org, tglx@linutronix.de, vbabka@suse.cz, willy@infradead.org


The patch titled
     Subject: x86/mm/32: implement arch_sync_kernel_mappings()
has been added to the -mm tree.  Its filename is
     x86-mm-32-implement-arch_sync_kernel_mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-32-implement-arch_sync_kernel_mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-32-implement-arch_sync_kernel_mappings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joerg Roedel <jroedel@suse.de>
Subject: x86/mm/32: implement arch_sync_kernel_mappings()

Implement the function to sync changes in vmalloc and ioremap ranges to
all page-tables.

Link: http://lkml.kernel.org/r/20200515140023.25469-6-joro@8bytes.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Acked-by: Andy Lutomirski <luto@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-2level_types.h |    2 +
 arch/x86/include/asm/pgtable-3level_types.h |    2 +
 arch/x86/mm/fault.c                         |   25 +++++++++++-------
 3 files changed, 20 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/pgtable-2level_types.h~x86-mm-32-implement-arch_sync_kernel_mappings
+++ a/arch/x86/include/asm/pgtable-2level_types.h
@@ -20,6 +20,8 @@ typedef union {
 
 #define SHARED_KERNEL_PMD	0
 
+#define ARCH_PAGE_TABLE_SYNC_MASK	PGTBL_PMD_MODIFIED
+
 /*
  * traditional i386 two-level paging structure:
  */
--- a/arch/x86/include/asm/pgtable-3level_types.h~x86-mm-32-implement-arch_sync_kernel_mappings
+++ a/arch/x86/include/asm/pgtable-3level_types.h
@@ -27,6 +27,8 @@ typedef union {
 #define SHARED_KERNEL_PMD	(!static_cpu_has(X86_FEATURE_PTI))
 #endif
 
+#define ARCH_PAGE_TABLE_SYNC_MASK	(SHARED_KERNEL_PMD ? 0 : PGTBL_PMD_MODIFIED)
+
 /*
  * PGDIR_SHIFT determines what a top-level page table entry can map
  */
--- a/arch/x86/mm/fault.c~x86-mm-32-implement-arch_sync_kernel_mappings
+++ a/arch/x86/mm/fault.c
@@ -190,16 +190,13 @@ static inline pmd_t *vmalloc_sync_one(pg
 	return pmd_k;
 }
 
-static void vmalloc_sync(void)
+void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
 {
-	unsigned long address;
+	unsigned long addr;
 
-	if (SHARED_KERNEL_PMD)
-		return;
-
-	for (address = VMALLOC_START & PMD_MASK;
-	     address >= TASK_SIZE_MAX && address < VMALLOC_END;
-	     address += PMD_SIZE) {
+	for (addr = start & PMD_MASK;
+	     addr >= TASK_SIZE_MAX && addr < VMALLOC_END;
+	     addr += PMD_SIZE) {
 		struct page *page;
 
 		spin_lock(&pgd_lock);
@@ -210,13 +207,23 @@ static void vmalloc_sync(void)
 			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
 
 			spin_lock(pgt_lock);
-			vmalloc_sync_one(page_address(page), address);
+			vmalloc_sync_one(page_address(page), addr);
 			spin_unlock(pgt_lock);
 		}
 		spin_unlock(&pgd_lock);
 	}
 }
 
+static void vmalloc_sync(void)
+{
+	unsigned long address;
+
+	if (SHARED_KERNEL_PMD)
+		return;
+
+	arch_sync_kernel_mappings(VMALLOC_START, VMALLOC_END);
+}
+
 void vmalloc_sync_mappings(void)
 {
 	vmalloc_sync();
_

Patches currently in -mm which might be from jroedel@suse.de are

mm-add-functions-to-track-page-directory-modifications.patch
mm-vmalloc-track-which-page-table-levels-were-modified.patch
mm-ioremap-track-which-page-table-levels-were-modified.patch
x86-mm-64-implement-arch_sync_kernel_mappings.patch
x86-mm-32-implement-arch_sync_kernel_mappings.patch
mm-remove-vmalloc_sync_unmappings.patch
x86-mm-remove-vmalloc-faulting.patch
