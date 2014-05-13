From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix-2.patch added to -mm tree
Date: Tue, 13 May 2014 15:51:34 -0700
Message-ID: <5372a1f6.OSp+r3P8sr1c6kLf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaEMWvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 18:51:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, sasha.levin@oracle.com, akpm@linux-foundation.org

Subject: + mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix-2.patch added to -mm tree
To: akpm@linux-foundation.org,sasha.levin@oracle.com,vbabka@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 15:51:34 -0700


The patch titled
     Subject: mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix-2
has been added to the -mm tree.  Its filename is
     mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix-2

fix x86_64 allnoconfig build

In file included from include/linux/suspend.h:8,
                 from arch/x86/kernel/asm-offsets.c:12:
include/linux/mm.h: In function 'check_freepage_migratetype':
include/linux/mm.h:296: error: implicit declaration of function 'page_to_section'
In file included from include/linux/suspend.h:8,
                 from arch/x86/kernel/asm-offsets.c:12:
include/linux/mm.h: At top level:
include/linux/mm.h:892: error: conflicting types for 'page_to_section'
include/linux/mm.h:296: note: previous implicit declaration of 'page_to_section' was here

Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   19 -------------------
 mm/page_alloc.c    |   19 +++++++++++++++++++
 2 files changed, 19 insertions(+), 19 deletions(-)

diff -puN include/linux/mm.h~mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix-2 include/linux/mm.h
--- a/include/linux/mm.h~mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix-2
+++ a/include/linux/mm.h
@@ -288,25 +288,6 @@ static inline int get_freepage_migratety
 }
 
 /*
- * Check that a freepage cannot end up on a wrong free_list for "sensitive"
- * migratetypes. Return false if it could. Useful for VM_BUG_ON checks.
- */
-static inline bool check_freepage_migratetype(struct page *page)
-{
-	int pageblock_mt = get_pageblock_migratetype(page);
-	int freepage_mt = get_freepage_migratetype(page);
-
-	/*
-	 * For RESERVE and CMA pageblocks, the freepage_migratetype must
-	 * match their migratetype. For other pageblocks, we don't care.
-	 */
-	if (pageblock_mt != MIGRATE_RESERVE && !is_migrate_cma(pageblock_mt))
-		return true;
-
-	return (freepage_mt == pageblock_mt);
-}
-
-/*
  * FIXME: take this include out, include page-flags.h in
  * files which need it (119 of them)
  */
diff -puN mm/page_alloc.c~mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix-2
+++ a/mm/page_alloc.c
@@ -663,6 +663,25 @@ static inline int free_pages_check(struc
 }
 
 /*
+ * Check that a freepage cannot end up on a wrong free_list for "sensitive"
+ * migratetypes. Return false if it could. Useful for VM_BUG_ON checks.
+ */
+static bool check_freepage_migratetype(struct page *page)
+{
+	int pageblock_mt = get_pageblock_migratetype(page);
+	int freepage_mt = get_freepage_migratetype(page);
+
+	/*
+	 * For RESERVE and CMA pageblocks, the freepage_migratetype must
+	 * match their migratetype. For other pageblocks, we don't care.
+	 */
+	if (pageblock_mt != MIGRATE_RESERVE && !is_migrate_cma(pageblock_mt))
+		return true;
+
+	return (freepage_mt == pageblock_mt);
+}
+
+/*
  * Frees a number of pages from the PCP lists
  * Assumes all pages on list are in same zone, and of same order.
  * count is the number of pages to free.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
mm-update-comment-for-default_max_map_count-fix.patch
memcg-fold-mem_cgroup_stolen-fix.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage.patch
mm-use-the-light-version-__mod_zone_page_state-in-mlocked_vma_newpage-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site-checkpatch-fixes.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix-2.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
rtc-da9063-rtc-driver-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

