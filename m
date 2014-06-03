From: akpm@linux-foundation.org
Subject: [folded-merged]
 rwsem-support-optimistic-spinning-checkpatch-fixes.patch removed from -mm
 tree
Date: Tue, 03 Jun 2014 15:52:51 -0700
Message-ID: <538e51c3./R3EsBSTNr6ARLlv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbaFCWww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2014 18:52:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, davidlohr@hp.com, akpm@linux-foundation.org

Subject: [folded-merged] rwsem-support-optimistic-spinning-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,davidlohr@hp.com,hpa@zytor.com,mingo@elte.hu,tglx@linutronix.de,tim.c.chen@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 03 Jun 2014 15:52:51 -0700


The patch titled
     Subject: rwsem-support-optimistic-spinning-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     rwsem-support-optimistic-spinning-checkpatch-fixes.patch

This patch was dropped because it was folded into rwsem-support-optimistic-spinning.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rwsem-support-optimistic-spinning-checkpatch-fixes

WARNING: line over 80 characters
#205: FILE: kernel/locking/rwsem-xadd.c:275:
+		old = cmpxchg(&sem->count, count, count + RWSEM_ACTIVE_WRITE_BIAS);

WARNING: line over 80 characters
#376: FILE: kernel/locking/rwsem-xadd.c:434:
+		 * If there were already threads queued before us and there are no

WARNING: line over 80 characters
#377: FILE: kernel/locking/rwsem-xadd.c:435:
+		 * active writers, the lock must be read owned; so we try to wake

total: 0 errors, 3 warnings, 417 lines checked

./patches/rwsem-support-optimistic-spinning.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/locking/rwsem-xadd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/locking/rwsem-xadd.c~rwsem-support-optimistic-spinning-checkpatch-fixes kernel/locking/rwsem-xadd.c
--- a/kernel/locking/rwsem-xadd.c~rwsem-support-optimistic-spinning-checkpatch-fixes
+++ a/kernel/locking/rwsem-xadd.c
@@ -431,9 +431,9 @@ struct rw_semaphore __sched *rwsem_down_
 		count = ACCESS_ONCE(sem->count);
 
 		/*
-		 * If there were already threads queued before us and there are no
-		 * active writers, the lock must be read owned; so we try to wake
-		 * any read locks that were queued ahead of us.
+		 * If there were already threads queued before us and there are
+		 * no active writers, the lock must be read owned; so we try to
+		 * wake any read locks that were queued ahead of us.
 		 */
 		if (count > RWSEM_WAITING_BIAS)
 			sem = __rwsem_do_wake(sem, RWSEM_WAKE_READERS);
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
fs-add-generic-data-flush-to-fsync-fix.patch
fs-add-generic-data-flush-to-fsync-fix-fix.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
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
mm-add-comment-for-__mod_zone_page_stat.patch
mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site-checkpatch-fixes.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch
mm-document-do_fault_around-feature-fix.patch
mm-memory-failurec-support-dedicated-thread-to-handle-sigbusbus_mceerr_ao-checkpatch-fixes.patch
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
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-checkpatch-fixes.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
rwsem-support-optimistic-spinning.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

