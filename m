From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
Date: Wed, 09 Apr 2014 10:53:56 -0700
Message-ID: <53458934.h6lu9tUDD7hCRiQ8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323AbaDIRx5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2014 13:53:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: [obsolete] linux-next-rejects.patch removed from -mm tree
To: akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 09 Apr 2014 10:53:56 -0700


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/head.S |    3 ---
 arch/arm64/mm/mmu.c      |   30 ------------------------------
 2 files changed, 33 deletions(-)

diff -puN arch/arm64/kernel/head.S~linux-next-rejects arch/arm64/kernel/head.S
--- a/arch/arm64/kernel/head.S~linux-next-rejects
+++ a/arch/arm64/kernel/head.S
@@ -482,8 +482,6 @@ __create_page_tables:
 	ldr	x5, =FIXADDR_TOP		// Fixed mapping virtual address
 	add	x0, x26, #2 * PAGE_SIZE		// section table address
 	create_pgd_entry x26, x0, x5, x6, x7
-<<<<<<< HEAD
-=======
 #endif
 
 	/*
@@ -496,7 +494,6 @@ __create_page_tables:
 	bl	__inval_cache_range
 
 	mov	lr, x27
->>>>>>> linux-next/akpm-base
 	ret
 ENDPROC(__create_page_tables)
 	.ltorg
diff -puN arch/arm64/mm/mmu.c~linux-next-rejects arch/arm64/mm/mmu.c
--- a/arch/arm64/mm/mmu.c~linux-next-rejects
+++ a/arch/arm64/mm/mmu.c
@@ -117,36 +117,6 @@ static int __init early_cachepolicy(char
 }
 early_param("cachepolicy", early_cachepolicy);
 
-<<<<<<< HEAD
-/*
- * Adjust the PMD section entries according to the CPU in use.
- */
-void __init init_mem_pgprot(void)
-{
-	pteval_t default_pgprot;
-	int i;
-
-	default_pgprot = PTE_ATTRINDX(MT_NORMAL);
-	prot_sect_kernel = PMD_TYPE_SECT | PMD_SECT_AF | PMD_ATTRINDX(MT_NORMAL);
-
-#ifdef CONFIG_SMP
-	/*
-	 * Mark memory with the "shared" attribute for SMP systems
-	 */
-	default_pgprot |= PTE_SHARED;
-	prot_sect_kernel |= PMD_SECT_S;
-#endif
-
-	for (i = 0; i < 16; i++) {
-		unsigned long v = pgprot_val(protection_map[i]);
-		protection_map[i] = __pgprot(v | default_pgprot);
-	}
-
-	pgprot_default = __pgprot(PTE_TYPE_PAGE | PTE_AF | default_pgprot);
-}
-
-=======
->>>>>>> linux-next/akpm-base
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 			      unsigned long size, pgprot_t vma_prot)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

