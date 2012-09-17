From: akpm@linux-foundation.org
Subject: [folded-merged] memory-hotplug-fix-a-double-register-section-info-bug-fix.patch removed from -mm tree
Date: Mon, 17 Sep 2012 14:05:34 -0700
Message-ID: <20120917210534.DAD731E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:64905 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab2IQVFg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Sep 2012 17:05:36 -0400
Received: by qafl39 with SMTP id l39so293547qaf.1
        for <mm-commits@vger.kernel.org>; Mon, 17 Sep 2012 14:05:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, mgorman@suse.de, qiuxishi@gmail.com, qiuxishi@huawei.com, stable@vger.kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug-fix-a-double-register-section-info-bug-fix
has been removed from the -mm tree.  Its filename was
     memory-hotplug-fix-a-double-register-section-info-bug-fix.patch

This patch was dropped because it was folded into memory-hotplug-fix-a-double-register-section-info-bug.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memory-hotplug-fix-a-double-register-section-info-bug-fix

Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: qiuxishi <qiuxishi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN mm/memory_hotplug.c~memory-hotplug-fix-a-double-register-section-info-bug-fix mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-fix-a-double-register-section-info-bug-fix
+++ a/mm/memory_hotplug.c
@@ -185,6 +185,12 @@ void register_page_bootmem_info_node(str
 
 	/* register_section info */
 	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		/*
+		 * Some platforms can assign the same pfn to multiple nodes - on
+		 * node0 as well as nodeN.  To avoid registering a pfn against
+		 * multiple nodes we check that this pfn does not already
+		 * reside in some other node.
+		 */
 		if (pfn_valid(pfn) && (pfn_to_nid(pfn) == node))
 			register_page_bootmem_info_section(pfn);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memory-hotplug-fix-a-double-register-section-info-bug.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
slab-fix-debug==0-warning.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes.patch
sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

