From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch removed from -mm tree
Date: Tue, 18 Sep 2012 12:47:26 -0700
Message-ID: <20120918194726.E2455100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:58227 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab2IRTr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 15:47:29 -0400
Received: by vcbfy27 with SMTP id fy27so32327vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 12:47:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, andrea@qumranet.com, avi@redhat.com, cl@linux-foundation.org, haggaie@mellanox.com, hughd@google.com, liranl@mellanox.com, ogerlitz@mellanox.com, raindel@mellanox.com, sagig@mellanox.com, xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix
has been removed from the -mm tree.  Its filename was
     mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch

This patch was dropped because it was folded into mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix

possible speed tweak in hugetlb_cow(), cleanups

Cc: Andrea Arcangeli <andrea@qumranet.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Haggai Eran <haggaie@mellanox.com>
Cc: Liran Liss <liranl@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Shachar Raindel <raindel@mellanox.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 mm/memory.c  |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix
+++ a/mm/hugetlb.c
@@ -2616,7 +2616,7 @@ retry_avoidcopy:
 	__SetPageUptodate(new_page);
 
 	mmun_start = address & huge_page_mask(h);
-	mmun_end   = (address & huge_page_mask(h)) + huge_page_size(h);
+	mmun_end = mmun_start + huge_page_size(h);
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	/*
 	 * Retake the page_table_lock to check for racing updates
diff -puN mm/memory.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix mm/memory.c
--- a/mm/memory.c~mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix
+++ a/mm/memory.c
@@ -1096,8 +1096,7 @@ int copy_page_range(struct mm_struct *ds
 	} while (dst_pgd++, src_pgd++, addr = next, addr != end);
 
 	if (is_cow_mapping(vma->vm_flags))
-		mmu_notifier_invalidate_range_end(src_mm, mmun_start,
-						  mmun_end);
+		mmu_notifier_invalidate_range_end(src_mm, mmun_start, mmun_end);
 	return ret;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
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
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-isolate_lru_page-dont-enable-local-interrupts.patch
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

