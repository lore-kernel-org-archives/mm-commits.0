From: akpm@linux-foundation.org
Subject: +
 mm-nominate-faultaround-area-in-bytes-rather-then-page-order.patch added to -mm tree
Date: Thu, 29 May 2014 15:51:09 -0700
Message-ID: <5387b9dd.GWohTG/WhLLAnO8Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaE2WvK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 May 2014 18:51:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, riel@redhat.com, peterz@infradead.org, paulus@samba.org, mingo@kernel.org, mgorman@suse.de, maddy@linux.vnet.ibm.com, hughd@google.com, dave.hansen@intel.com, benh@kernel.crashing.org, ak@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: + mm-nominate-faultaround-area-in-bytes-rather-then-page-order.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,ak@linux.intel.com,benh@kernel.crashing.org,dave.hansen@intel.com,hughd@google.com,maddy@linux.vnet.ibm.com,mgorman@suse.de,mingo@kernel.org,paulus@samba.org,peterz@infradead.org,riel@redhat.com,rusty@rustcorp.com.au
From: akpm@linux-foundation.org
Date: Thu, 29 May 2014 15:51:09 -0700


The patch titled
     Subject: mm: nominate faultaround area in bytes rather than page order
has been added to the -mm tree.  Its filename is
     mm-nominate-faultaround-area-in-bytes-rather-then-page-order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-nominate-faultaround-area-in-bytes-rather-then-page-order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-nominate-faultaround-area-in-bytes-rather-then-page-order.patch

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
Subject: mm: nominate faultaround area in bytes rather than page order

There is evidencs that the faultaround feature is less relevant on
architectures with page size bigger then 4k.  Which makes sense since page
fault overhead per byte of mapped area should be less there.

Let's rework the feature to specify faultaround area in bytes instead of
page order.  It's 64 kilobytes for now.

The patch effectively disables faultaround on architectures with page size
>= 64k (like ppc64).

It's possible that some other size of faultaround area is relevant for a
platform.  We can expose `fault_around_bytes' variable to arch-specific
code once such platforms will be found.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Hugh Dickins <hughd@google.com>
Cc: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   62 ++++++++++++++++++--------------------------------
 1 file changed, 23 insertions(+), 39 deletions(-)

diff -puN mm/memory.c~mm-nominate-faultaround-area-in-bytes-rather-then-page-order mm/memory.c
--- a/mm/memory.c~mm-nominate-faultaround-area-in-bytes-rather-then-page-order
+++ a/mm/memory.c
@@ -2758,63 +2758,47 @@ void do_set_pte(struct vm_area_struct *v
 	update_mmu_cache(vma, address, pte);
 }
 
-#define FAULT_AROUND_ORDER 4
+static unsigned long fault_around_bytes = 65536;
 
-#ifdef CONFIG_DEBUG_FS
-static unsigned int fault_around_order = FAULT_AROUND_ORDER;
+static inline unsigned long fault_around_pages(void)
+{
+	return rounddown_pow_of_two(fault_around_bytes) / PAGE_SIZE;
+}
 
-static int fault_around_order_get(void *data, u64 *val)
+static inline unsigned long fault_around_mask(void)
 {
-	*val = fault_around_order;
+	return ~(rounddown_pow_of_two(fault_around_bytes) - 1) & PAGE_MASK;
+}
+
+
+#ifdef CONFIG_DEBUG_FS
+static int fault_around_bytes_get(void *data, u64 *val)
+{
+	*val = fault_around_bytes;
 	return 0;
 }
 
-static int fault_around_order_set(void *data, u64 val)
+static int fault_around_bytes_set(void *data, u64 val)
 {
-	BUILD_BUG_ON((1UL << FAULT_AROUND_ORDER) > PTRS_PER_PTE);
-	if (1UL << val > PTRS_PER_PTE)
+	if (val / PAGE_SIZE > PTRS_PER_PTE)
 		return -EINVAL;
-	fault_around_order = val;
+	fault_around_bytes = val;
 	return 0;
 }
-DEFINE_SIMPLE_ATTRIBUTE(fault_around_order_fops,
-		fault_around_order_get, fault_around_order_set, "%llu\n");
+DEFINE_SIMPLE_ATTRIBUTE(fault_around_bytes_fops,
+		fault_around_bytes_get, fault_around_bytes_set, "%llu\n");
 
 static int __init fault_around_debugfs(void)
 {
 	void *ret;
 
-	ret = debugfs_create_file("fault_around_order",	0644, NULL, NULL,
-			&fault_around_order_fops);
+	ret = debugfs_create_file("fault_around_bytes", 0644, NULL, NULL,
+			&fault_around_bytes_fops);
 	if (!ret)
-		pr_warn("Failed to create fault_around_order in debugfs");
+		pr_warn("Failed to create fault_around_bytes in debugfs");
 	return 0;
 }
 late_initcall(fault_around_debugfs);
-
-static inline unsigned long fault_around_pages(void)
-{
-	return 1UL << fault_around_order;
-}
-
-static inline unsigned long fault_around_mask(void)
-{
-	return ~((1UL << (PAGE_SHIFT + fault_around_order)) - 1);
-}
-#else
-static inline unsigned long fault_around_pages(void)
-{
-	unsigned long nr_pages;
-
-	nr_pages = 1UL << FAULT_AROUND_ORDER;
-	BUILD_BUG_ON(nr_pages > PTRS_PER_PTE);
-	return nr_pages;
-}
-
-static inline unsigned long fault_around_mask(void)
-{
-	return ~((1UL << (PAGE_SHIFT + FAULT_AROUND_ORDER)) - 1);
-}
 #endif
 
 static void do_fault_around(struct vm_area_struct *vma, unsigned long address,
@@ -2871,7 +2855,7 @@ static int do_read_fault(struct mm_struc
 	 * if page by the offset is not ready to be mapped (cold cache or
 	 * something).
 	 */
-	if (vma->vm_ops->map_pages) {
+	if (vma->vm_ops->map_pages && fault_around_pages() > 1) {
 		pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 		do_fault_around(vma, address, pte, pgoff, flags);
 		if (!pte_same(*pte, orig_pte))
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
thp-consolidate-assert-checks-in-__split_huge_page.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-move-get_user_pages-related-code-to-separate-file.patch
mm-extract-in_gate_area-case-from-__get_user_pages.patch
mm-cleanup-follow_page_mask.patch
mm-extract-code-to-fault-in-a-page-from-__get_user_pages.patch
mm-cleanup-__get_user_pages.patch
mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static.patch
mm-update-comment-for-default_max_map_count.patch
mm-update-comment-for-default_max_map_count-fix.patch
mm-fix-typo-in-comment-in-do_fault_around.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
mm-nominate-faultaround-area-in-bytes-rather-then-page-order.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-userc-drop-unused-field-files-from-user_struct.patch
linux-next.patch
mm-mark-remap_file_pages-syscall-as-deprecated.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

