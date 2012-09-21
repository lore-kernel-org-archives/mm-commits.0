From: akpm@linux-foundation.org
Subject: [folded-dropped] coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 21 Sep 2012 12:23:40 -0700
Message-ID: <20120921192340.93A2E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:42983 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701Ab2IUTXl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Sep 2012 15:23:41 -0400
Received: by mail-yx0-f202.google.com with SMTP id r11so105131yen.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Sep 2012 12:23:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vda.linux@googlemail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files-checkpatch-fixes.patch

This patch was dropped because it was folded into coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files-checkpatch-fixes

ERROR: "(foo*)" should be "(foo *)"
#79: FILE: fs/binfmt_elf.c:1424:
+	name_base = name_curpos = ((char*)data) + names_ofs;

WARNING: line over 80 characters
#122: FILE: fs/binfmt_elf.c:1467:
+		memmove(name_base - shift_bytes, name_base, name_curpos - name_base);

ERROR: "(foo*)" should be "(foo *)"
#126: FILE: fs/binfmt_elf.c:1471:
+	size = name_curpos - (char*)data;

total: 2 errors, 1 warnings, 177 lines checked

./patches/coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Denys Vlasenko <vda.linux@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/binfmt_elf.c~coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files-checkpatch-fixes fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files-checkpatch-fixes
+++ a/fs/binfmt_elf.c
@@ -1421,7 +1421,7 @@ static void fill_files_note(struct memel
 		goto err;
 
 	start_end_ofs = data + 2;
-	name_base = name_curpos = ((char*)data) + names_ofs;
+	name_base = name_curpos = ((char *)data) + names_ofs;
 	remaining = size - names_ofs;
 	count = 0;
 	for (vma = current->mm->mmap; vma != NULL; vma = vma->vm_next) {
@@ -1464,11 +1464,12 @@ static void fill_files_note(struct memel
 	n = current->mm->map_count - count;
 	if (n != 0) {
 		unsigned shift_bytes = n * 3 * sizeof(data[0]);
-		memmove(name_base - shift_bytes, name_base, name_curpos - name_base);
+		memmove(name_base - shift_bytes, name_base,
+			name_curpos - name_base);
 		name_curpos -= shift_bytes;
 	}
 
-	size = name_curpos - (char*)data;
+	size = name_curpos - (char *)data;
 	fill_note(note, "CORE", NT_FILE, size, data);
  err: ;
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
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
audith-replace-defines-with-c-stubs.patch
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
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes.patch
sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code-fix-fix.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init-fix.patch
drivers-misc-lis3lv02d-lis3lv02d_i2cc-add-lis3lv02d-device-tree-init-fix.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
compat-fs-generic-compat_sys_sendfile-implementation.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

