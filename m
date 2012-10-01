From: akpm@linux-foundation.org
Subject: [alternative-merged] mm-memoryc-squash-unused-variable-warning.patch removed from -mm tree
Date: Mon, 01 Oct 2012 12:13:35 -0700
Message-ID: <20121001191336.1BFEA5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:42482 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2JATNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:13:38 -0400
Received: by weyx43 with SMTP id x43so335102wey.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:13:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: squash unused variable warning
has been removed from the -mm tree.  Its filename was
     mm-memoryc-squash-unused-variable-warning.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memory.c: squash unused variable warning

CONFIG_NUMA=n:

mm/memory.c: In function 'do_prot_none':
mm/memory.c:3447: warning: unused variable 'node'

Fix this by eliminiating a rather gratuitous goto, and nuke a second
gratuitous goto while we're there.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   50 +++++++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff -puN mm/memory.c~mm-memoryc-squash-unused-variable-warning mm/memory.c
--- a/mm/memory.c~mm-memoryc-squash-unused-variable-warning
+++ a/mm/memory.c
@@ -3444,7 +3444,6 @@ static int do_prot_none(struct mm_struct
 {
 	struct page *page = NULL;
 	spinlock_t *ptl;
-	int node;
 
 	ptl = pte_lockptr(mm, pmd);
 	spin_lock(ptl);
@@ -3457,35 +3456,32 @@ static int do_prot_none(struct mm_struct
 	 * lazy page migration, see MPOL_MF_LAZY and related.
 	 */
 	page = vm_normal_page(vma, address, entry);
-	if (!page)
-		goto do_fixup_locked;
+	if (page) {
+		int node;
 
-	get_page(page);
-	pte_unmap_unlock(ptep, ptl);
-
-	node = mpol_misplaced(page, vma, address);
-	if (node == -1)
-		goto do_fixup;
+		get_page(page);
+		pte_unmap_unlock(ptep, ptl);
 
-	/*
-	 * Page migration will install a new pte with vma->vm_page_prot,
-	 * otherwise fall-through to the fixup. Next time,.. perhaps.
-	 */
-	if (!migrate_misplaced_page(mm, page, node)) {
-		put_page(page);
-		return 0;
+		node = mpol_misplaced(page, vma, address);
+		if (node != -1) {
+			/*
+			 * Page migration will install a new pte with
+			 * vma->vm_page_prot, otherwise fall-through to the
+			 * fixup. Next time,.. perhaps.
+			 */
+			if (!migrate_misplaced_page(mm, page, node)) {
+				put_page(page);
+				return 0;
+			}
+		}
+		/*
+		 * OK, nothing to do,.. change the protection back to what it
+		 * ought to be.
+		 */
+		ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
+		if (unlikely(!pte_same(*ptep, entry)))
+			goto unlock;
 	}
-
-do_fixup:
-	/*
-	 * OK, nothing to do,.. change the protection back to what it
-	 * ought to be.
-	 */
-	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
-	if (unlikely(!pte_same(*ptep, entry)))
-		goto unlock;
-
-do_fixup_locked:
 #endif /* CONFIG_NUMA */
 
 	flush_cache_page(vma, address, pte_pfn(entry));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
audith-replace-defines-with-c-stubs.patch
audith-replace-defines-with-c-stubs-fix.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-count-free-cma-pages-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes.patch
sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe-fix.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

