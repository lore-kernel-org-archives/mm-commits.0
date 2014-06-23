From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes.patch
 removed from -mm tree
Date: Mon, 23 Jun 2014 13:11:55 -0700
Message-ID: <53a88a0b.qdyrulTeV1XqKvag%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936AbaFWUL4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 16:11:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, akpm@linux-foundation.org


The patch titled
     Subject: mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes

WARNING: Missing a blank line after declarations
#46: FILE: mm/huge_memory.c:954:
+		struct page *endpage = page + HPAGE_PMD_NR;
+		atomic_add(HPAGE_PMD_NR, &page->_count);

WARNING: Missing a blank line after declarations
#57: FILE: mm/huge_memory.c:965:
+		struct page *endpage = page + HPAGE_PMD_NR;
+		while (page < endpage)

total: 0 errors, 2 warnings, 65 lines checked

./patches/mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes
+++ a/mm/huge_memory.c
@@ -951,21 +951,25 @@ static void get_user_huge_page(struct pa
 {
 	if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC)) {
 		struct page *endpage = page + HPAGE_PMD_NR;
+
 		atomic_add(HPAGE_PMD_NR, &page->_count);
 		while (++page < endpage)
 			get_huge_page_tail(page);
-	} else
+	} else {
 		get_page(page);
+	}
 }
 
 static void put_user_huge_page(struct page *page)
 {
 	if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC)) {
 		struct page *endpage = page + HPAGE_PMD_NR;
+
 		while (page < endpage)
 			put_page(page++);
-	} else
+	} else {
 		put_page(page);
+	}
 }
 
 static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep.patch
shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

