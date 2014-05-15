From: akpm@linux-foundation.org
Subject: + fs-add-generic-data-flush-to-fsync-fix-fix.patch added to -mm
 tree
Date: Thu, 15 May 2014 16:36:25 -0700
Message-ID: <53754f79.4kunwjNKc99vEtfH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaEOXg0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 19:36:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be, akpm@linux-foundation.org

Subject: + fs-add-generic-data-flush-to-fsync-fix-fix.patch added to -mm tree
To: akpm@linux-foundation.org,fabf@skynet.be
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 16:36:25 -0700


The patch titled
     Subject: fs-add-generic-data-flush-to-fsync-fix-fix
has been added to the -mm tree.  Its filename is
     fs-add-generic-data-flush-to-fsync-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-add-generic-data-flush-to-fsync-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-add-generic-data-flush-to-fsync-fix-fix.patch

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
Subject: fs-add-generic-data-flush-to-fsync-fix-fix

fix warning

Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/blkdev.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/blkdev.h~fs-add-generic-data-flush-to-fsync-fix-fix include/linux/blkdev.h
--- a/include/linux/blkdev.h~fs-add-generic-data-flush-to-fsync-fix-fix
+++ a/include/linux/blkdev.h
@@ -1589,6 +1589,9 @@ struct block_device_operations {
 extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
 				 unsigned long);
 #else /* CONFIG_BLOCK */
+
+struct block_device;
+
 /*
  * stubs for when the block layer is configured out
  */
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
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
lib-test_bpfc-dont-use-gcc-union-shortcut.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
rwsem-support-optimistic-spinning-checkpatch-fixes.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

