From: akpm@linux-foundation.org
Subject: + fs-block_devc-set_blocksize-use-mapping_mapped.patch added to -mm tree
Date: Mon, 01 Oct 2012 12:56:22 -0700
Message-ID: <20121001195623.2355E5C007A@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:55004 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab2JAT40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:56:26 -0400
Received: by bkwq16 with SMTP id q16so385152bkw.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:56:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mpatocka@redhat.com, sfr@canb.auug.org.au


The patch titled
     Subject: fs/block_dev.c:set_blocksize(): use mapping_mapped()
has been added to the -mm tree.  Its filename is
     fs-block_devc-set_blocksize-use-mapping_mapped.patch

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
Subject: fs/block_dev.c:set_blocksize(): use mapping_mapped()

... instead of open-coding it.

Suggested-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/block_dev.c~fs-block_devc-set_blocksize-use-mapping_mapped fs/block_dev.c
--- a/fs/block_dev.c~fs-block_devc-set_blocksize-use-mapping_mapped
+++ a/fs/block_dev.c
@@ -27,7 +27,6 @@
 #include <linux/namei.h>
 #include <linux/log2.h>
 #include <linux/cleancache.h>
-#include <linux/rbtree.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -133,8 +132,7 @@ int set_blocksize(struct block_device *b
 	/* Check that the block device is not memory mapped */
 	mapping = bdev->bd_inode->i_mapping;
 	mutex_lock(&mapping->i_mmap_mutex);
-	if (!RB_EMPTY_ROOT(&mapping->i_mmap) ||
-	    !list_empty(&mapping->i_mmap_nonlinear)) {
+	if (mapping_mapped(mapping)) {
 		mutex_unlock(&mapping->i_mmap_mutex);
 		percpu_up_write(&bdev->bd_block_size_semaphore);
 		return -EBUSY;
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
fs-block_devc-set_blocksize-use-mapping_mapped.patch
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

