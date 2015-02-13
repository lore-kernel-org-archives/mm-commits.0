From: akpm@linux-foundation.org
Subject: [merged] mm-do-not-use-mm-nr_pmds-on-mmu-configurations.patch
 removed from -mm tree
Date: Fri, 13 Feb 2015 12:20:46 -0800
Message-ID: <54de5c9e.lrntbyHq060PHZ0I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbbBMUUr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:20:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not use mm->nr_pmds on !MMU configurations
has been removed from the -mm tree.  Its filename was
     mm-do-not-use-mm-nr_pmds-on-mmu-configurations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: do not use mm->nr_pmds on !MMU configurations

mm->nr_pmds doesn't make sense on !MMU configurations

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    9 ++++++++-
 kernel/fork.c      |    4 +---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~mm-do-not-use-mm-nr_pmds-on-mmu-configurations include/linux/mm.h
--- a/include/linux/mm.h~mm-do-not-use-mm-nr_pmds-on-mmu-configurations
+++ a/include/linux/mm.h
@@ -1447,13 +1447,15 @@ static inline int __pud_alloc(struct mm_
 int __pud_alloc(struct mm_struct *mm, pgd_t *pgd, unsigned long address);
 #endif
 
-#ifdef __PAGETABLE_PMD_FOLDED
+#if defined(__PAGETABLE_PMD_FOLDED) || !defined(CONFIG_MMU)
 static inline int __pmd_alloc(struct mm_struct *mm, pud_t *pud,
 						unsigned long address)
 {
 	return 0;
 }
 
+static inline void mm_nr_pmds_init(struct mm_struct *mm) {}
+
 static inline unsigned long mm_nr_pmds(struct mm_struct *mm)
 {
 	return 0;
@@ -1465,6 +1467,11 @@ static inline void mm_dec_nr_pmds(struct
 #else
 int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address);
 
+static inline void mm_nr_pmds_init(struct mm_struct *mm)
+{
+	atomic_long_set(&mm->nr_pmds, 0);
+}
+
 static inline unsigned long mm_nr_pmds(struct mm_struct *mm)
 {
 	return atomic_long_read(&mm->nr_pmds);
diff -puN kernel/fork.c~mm-do-not-use-mm-nr_pmds-on-mmu-configurations kernel/fork.c
--- a/kernel/fork.c~mm-do-not-use-mm-nr_pmds-on-mmu-configurations
+++ a/kernel/fork.c
@@ -555,9 +555,7 @@ static struct mm_struct *mm_init(struct
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm->core_state = NULL;
 	atomic_long_set(&mm->nr_ptes, 0);
-#ifndef __PAGETABLE_PMD_FOLDED
-	atomic_long_set(&mm->nr_pmds, 0);
-#endif
+	mm_nr_pmds_init(mm);
 	mm->map_count = 0;
 	mm->locked_vm = 0;
 	mm->pinned_vm = 0;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
dax-replace-xip-documentation-with-dax-documentation.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch

