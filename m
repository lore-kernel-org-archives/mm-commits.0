From: akpm@linux-foundation.org
Subject: + mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch
 added to -mm tree
Date: Wed, 14 May 2014 13:31:01 -0700
Message-ID: <5373d285.dH0JGPpXf+e5xPy5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaENUbC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 May 2014 16:31:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nasa4836@gmail.com, hughd@google.com, akpm@linux-foundation.org

Subject: + mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,hughd@google.com,nasa4836@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 14 May 2014 13:31:01 -0700


The patch titled
     Subject: mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch

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
Subject: mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes

also fix spellos

WARNING: line over 80 characters
#54: FILE: mm/rmap.c:988:
+		 * pte lock(a spinlock) is held, which implies preemtion disabled.

total: 0 errors, 1 warnings, 45 lines checked

./patches/mm-add-comment-for-__mod_zone_page_stat.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Hugh Dickins <hughd@google.com>
Cc: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    6 +++---
 mm/rmap.c     |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/internal.h~mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes mm/internal.h
--- a/mm/internal.h~mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes
+++ a/mm/internal.h
@@ -202,9 +202,9 @@ static inline int mlocked_vma_newpage(st
 
 	if (!TestSetPageMlocked(page)) {
 		/*
-		 * We use the irq-unsafe __mod_zone_page_stat because
-		 * this counter is not modified from interrupt context, and the
-		 * pte lock is held(spinlock), which implies preemtion disabled.
+		 * We use the irq-unsafe __mod_zone_page_stat because this
+		 * counter is not modified from interrupt context, and the pte
+		 * lock is held(spinlock), which implies preemption disabled.
 		 */
 		__mod_zone_page_state(page_zone(page), NR_MLOCK,
 				    hpage_nr_pages(page));
diff -puN mm/rmap.c~mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes mm/rmap.c
--- a/mm/rmap.c~mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes
+++ a/mm/rmap.c
@@ -985,7 +985,8 @@ void do_page_add_anon_rmap(struct page *
 		/*
 		 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
 		 * these counters are not modified in interrupt context, and
-		 * pte lock(a spinlock) is held, which implies preemtion disabled.
+		 * pte lock(a spinlock) is held, which implies preemption
+		 * disabled.
 		 */
 		if (PageTransHuge(page))
 			__inc_zone_page_state(page,
@@ -1082,7 +1083,7 @@ void page_remove_rmap(struct page *page)
 	 * We use the irq-unsafe __{inc|mod}_zone_page_stat because
 	 * these counters are not modified in interrupt context, and
 	 * these counters are not modified in interrupt context, and
-	 * pte lock(a spinlock) is held, which implies preemtion disabled.
+	 * pte lock(a spinlock) is held, which implies preemption disabled.
 	 */
 	if (unlikely(PageHuge(page)))
 		goto out;
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
mm-add-comment-for-__mod_zone_page_stat.patch
mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch
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
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
lib-test_bpfc-dont-use-gcc-union-shortcut.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

