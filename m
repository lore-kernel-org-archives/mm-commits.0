From: akpm@linux-foundation.org
Subject: + mm-add-debugfs-tunable-for-fault_around_order.patch added to
 -mm tree
Date: Fri, 28 Feb 2014 16:01:40 -0800
Message-ID: <53112364.CNyh3oKgyPqhSqB+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbaCAABl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 19:01:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, torvalds@linux-foundation.org, riel@redhat.com, quning@gmail.com, mgorman@suse.de, matthew.r.wilcox@intel.com, david@fromorbit.com, dave.hansen@linux.intel.com, ak@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: + mm-add-debugfs-tunable-for-fault_around_order.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,ak@linux.intel.com,dave.hansen@linux.intel.com,david@fromorbit.com,matthew.r.wilcox@intel.com,mgorman@suse.de,quning@gmail.com,riel@redhat.com,torvalds@linux-foundation.org,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 16:01:40 -0800


The patch titled
     Subject: mm: add debugfs tunable for fault_around_order
has been added to the -mm tree.  Its filename is
     mm-add-debugfs-tunable-for-fault_around_order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-debugfs-tunable-for-fault_around_order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-debugfs-tunable-for-fault_around_order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: add debugfs tunable for fault_around_order

Let's allow people to tweak faultaround at runtime.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ning Qu <quning@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   68 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 7 deletions(-)

diff -puN mm/memory.c~mm-add-debugfs-tunable-for-fault_around_order mm/memory.c
--- a/mm/memory.c~mm-add-debugfs-tunable-for-fault_around_order
+++ a/mm/memory.c
@@ -60,6 +60,7 @@
 #include <linux/migrate.h>
 #include <linux/string.h>
 #include <linux/dma-debug.h>
+#include <linux/debugfs.h>
 
 #include <asm/io.h>
 #include <asm/pgalloc.h>
@@ -3344,8 +3345,63 @@ void do_set_pte(struct vm_area_struct *v
 }
 
 #define FAULT_AROUND_ORDER 4
-#define FAULT_AROUND_PAGES (1UL << FAULT_AROUND_ORDER)
-#define FAULT_AROUND_MASK ~((1UL << (PAGE_SHIFT + FAULT_AROUND_ORDER)) - 1)
+
+#ifdef CONFIG_DEBUG_FS
+static unsigned int fault_around_order = FAULT_AROUND_ORDER;
+
+static int fault_around_order_get(void *data, u64 *val)
+{
+	*val = fault_around_order;
+	return 0;
+}
+
+static int fault_around_order_set(void *data, u64 val)
+{
+	BUILD_BUG_ON((1UL << FAULT_AROUND_ORDER) > PTRS_PER_PTE);
+	if (1UL << val > PTRS_PER_PTE)
+		return -EINVAL;
+	fault_around_order = val;
+	return 0;
+}
+DEFINE_SIMPLE_ATTRIBUTE(fault_around_order_fops,
+		fault_around_order_get, fault_around_order_set, "%llu\n");
+
+static int __init fault_around_debugfs(void)
+{
+	void *ret;
+
+	ret = debugfs_create_file("fault_around_order",	0644, NULL, NULL,
+			&fault_around_order_fops);
+	if (!ret)
+		pr_warning("Failed to create fault_around_order in debugfs");
+	return 0;
+}
+late_initcall(fault_around_debugfs);
+
+static inline unsigned long fault_around_pages(void)
+{
+	return 1UL << fault_around_order;
+}
+
+static inline unsigned long fault_around_mask(void)
+{
+	return ~((1UL << (PAGE_SHIFT + fault_around_order)) - 1);
+}
+#else
+static inline unsigned long fault_around_pages(void)
+{
+	unsigned long nr_pages;
+
+	nr_pages = 1UL << FAULT_AROUND_ORDER;
+	BUILD_BUG_ON(nr_pages > PTRS_PER_PTE);
+	return nr_pages;
+}
+
+static inline unsigned long fault_around_mask(void)
+{
+	return ~((1UL << (PAGE_SHIFT + FAULT_AROUND_ORDER)) - 1);
+}
+#endif
 
 static void do_fault_around(struct vm_area_struct *vma, unsigned long address,
 		pte_t *pte, pgoff_t pgoff, unsigned int flags)
@@ -3355,21 +3411,19 @@ static void do_fault_around(struct vm_ar
 	struct vm_fault vmf;
 	int off;
 
-	BUILD_BUG_ON(FAULT_AROUND_PAGES > PTRS_PER_PTE);
-
-	start_addr = max(address & FAULT_AROUND_MASK, vma->vm_start);
+	start_addr = max(address & fault_around_mask(), vma->vm_start);
 	off = ((address - start_addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
 	pte -= off;
 	pgoff -= off;
 
 	/*
 	 *  max_pgoff is either end of page table or end of vma
-	 *  or FAULT_AROUND_PAGES from pgoff, depending what is neast.
+	 *  or fault_around_pages() from pgoff, depending what is neast.
 	 */
 	max_pgoff = pgoff - ((start_addr >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)) +
 		PTRS_PER_PTE - 1;
 	max_pgoff = min3(max_pgoff, vma_pages(vma) + vma->vm_pgoff - 1,
-			pgoff + FAULT_AROUND_PAGES - 1);
+			pgoff + fault_around_pages() - 1);
 
 	/* Check if it makes any sense to call ->map_pages */
 	while (!pte_none(*pte)) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
mm-include-vm_mixedmap-flag-in-the-vm_special-list-to-avoid-munlocking.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch
mm-consolidate-code-to-setup-pte.patch
mm-thp-drop-do_huge_pmd_wp_zero_page_fallback.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
mm-disable-split-page-table-lock-for-mmu.patch
mm-introduce-vm_ops-map_pages.patch
mm-implement-map_pages-for-page-cache.patch
mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch
mm-add-debugfs-tunable-for-fault_around_order.patch

