From: akpm@linux-foundation.org
Subject: [folded-merged] mm-document-do_fault_around-feature-fix.patch
 removed from -mm tree
Date: Wed, 04 Jun 2014 15:49:42 -0700
Message-ID: <538fa286.dQ/uoyGSZmk0/ubt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaFDWtn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:49:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-document-do_fault_around-feature-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:49:42 -0700


The patch titled
     Subject: mm-document-do_fault_around-feature-fix
has been removed from the -mm tree.  Its filename was
     mm-document-do_fault_around-feature-fix.patch

This patch was dropped because it was folded into mm-document-do_fault_around-feature.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-document-do_fault_around-feature-fix

tweak comment text

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/memory.c~mm-document-do_fault_around-feature-fix mm/memory.c
--- a/mm/memory.c~mm-document-do_fault_around-feature-fix
+++ a/mm/memory.c
@@ -2807,7 +2807,7 @@ late_initcall(fault_around_debugfs);
 
 /*
  * do_fault_around() tries to map few pages around the fault address. The hope
- * is that the pages will be needed soon and this would lower the number of
+ * is that the pages will be needed soon and this will lower the number of
  * faults to handle.
  *
  * It uses vm_ops->map_pages() to map the pages, which skips the page if it's
@@ -2815,18 +2815,18 @@ late_initcall(fault_around_debugfs);
  *
  * This function is called with the page table lock taken. In the split ptlock
  * case the page table lock only protects only those entries which belong to
- * page table corresponding to the fault address.
+ * the page table corresponding to the fault address.
  *
- * This function don't cross the VMA boundaries in order to call map_pages()
+ * This function doesn't cross the VMA boundaries, in order to call map_pages()
  * only once.
  *
  * fault_around_pages() defines how many pages we'll try to map.
- * do_fault_around() expects it to be power of two and less or equal to
+ * do_fault_around() expects it to return a power of two less than or equal to
  * PTRS_PER_PTE.
  *
  * The virtual address of the area that we map is naturally aligned to the
- * fault_around_pages() (and therefore to page order). This way it's easier to
- * guarantee that we don't cross the page table boundaries.
+ * fault_around_pages() value (and therefore to page order).  This way it's
+ * easier to guarantee that we don't cross page table boundaries.
  */
 static void do_fault_around(struct vm_area_struct *vma, unsigned long address,
 		pte_t *pte, pgoff_t pgoff, unsigned int flags)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted.patch
fs-add-generic-data-flush-to-fsync.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
swap-use-bdev_read_page-bdev_write_page.patch
mm-update-comment-for-default_max_map_count.patch
memcg-fold-mem_cgroup_stolen.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
mm-document-do_fault_around-feature.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch

