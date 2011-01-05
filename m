From: akpm@linux-foundation.org
Subject: [folded] vfs-add-super-operation-writeback_inodes-fix.patch removed from -mm tree
Date: Tue, 04 Jan 2011 16:36:33 -0800
Message-ID: <201101050036.p050aY78000819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342Ab1AEAgg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 19:36:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vfs-add-super-operation-writeback_inodes-fix
has been removed from the -mm tree.  Its filename was
     vfs-add-super-operation-writeback_inodes-fix.patch

This patch was dropped because it was folded into vfs-add-super-operation-writeback_inodes.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs-add-super-operation-writeback_inodes-fix
From: Andrew Morton <akpm@linux-foundation.org>

writeback_inodes_wbc() got removed.

Cc: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c  |    2 +-
 include/linux/fs.h |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~vfs-add-super-operation-writeback_inodes-fix fs/fs-writeback.c
--- a/fs/fs-writeback.c~vfs-add-super-operation-writeback_inodes-fix
+++ a/fs/fs-writeback.c
@@ -623,6 +623,7 @@ void writeback_inodes_wb(struct bdi_writ
 	spin_unlock(&inode_lock);
 	/* Leave any unwritten inodes on b_io */
 }
+EXPORT_SYMBOL(writeback_inodes_wb);
 
 static void __writeback_inodes_sb(struct super_block *sb,
 		struct bdi_writeback *wb, struct writeback_control *wbc)
@@ -635,7 +636,6 @@ static void __writeback_inodes_sb(struct
 	do_writeback_sb_inodes(sb, wb, wbc, true);
 	spin_unlock(&inode_lock);
 }
-EXPORT_SYMBOL(writeback_inodes_wbc);
 
 /*
  * The maximum number of pages to writeout in a single bdi flush/kupdate
diff -puN include/linux/fs.h~vfs-add-super-operation-writeback_inodes-fix include/linux/fs.h
--- a/include/linux/fs.h~vfs-add-super-operation-writeback_inodes-fix
+++ a/include/linux/fs.h
@@ -2158,7 +2158,8 @@ extern int invalidate_inode_pages2_range
 extern int write_inode_now(struct inode *, int);
 extern void writeback_skip_sb_inodes(struct super_block *sb,
 				     struct bdi_writeback *wb);
-extern void writeback_inodes_wbc(struct writeback_control *wbc);
+extern void writeback_inodes_wb(struct bdi_writeback *wb,
+				struct writeback_control *wbc);
 extern int generic_writeback_sb_inodes(struct super_block *sb,
 				       struct bdi_writeback *wb,
 				       struct writeback_control *wbc,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code-checkpatch-fixes.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-deactivate-invalidated-pages-fix.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix2.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call-fix.patch
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration-fix.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common-fix.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk-fix.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-checkpatch-fixes.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists-fix.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit.patch
include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit-fix.patch
include-linux-unaligned-packed_structh-use-__packed.patch
ihex-fix-unused-return-value-compiler-warning-fix.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users-fix.patch
kptr_restrict-for-hiding-kernel-pointers-v7-fix.patch
fs-select-fix-information-leak-to-userspace-fix.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
drivers-telephony-ixjc-fix-warning.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
fs-proc-basec-kernel-latencytopc-convert-sprintf_symbol-to-%ps-checkpatch-fixes.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
sysctl-remove-obsolete-comments-fix.patch
user_ns-improve-the-user_ns-on-the-slab-packaging-fix.patch
pps-add-parallel-port-pps-signal-generator-fix.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-fix.patch
cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch
ramoops-fix-types-remove-typecasts.patch
vfs-add-super-operation-writeback_inodes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

