From: akpm@linux-foundation.org
Subject: + cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch added to -mm tree
Date: Tue, 04 Jan 2011 14:05:48 -0800
Message-ID: <201101042205.p04M5mLl026800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854Ab1ADWGB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 17:06:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, stefani@seibold.net


The patch titled
     cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#44: FILE: fs/cramfs/inode.c:40:
+static unsigned long cramino(struct cramfs_inode * cino, unsigned int offset)

ERROR: "foo * bar" should be "foo *bar"
#68: FILE: fs/cramfs/inode.c:64:
+	struct cramfs_inode * cramfs_inode, unsigned int offset)

WARNING: line over 80 characters
#157: FILE: fs/cramfs/inode.c:293:
+	super.root.mode |= (S_IRUSR | S_IXUSR | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH);

WARNING: line over 80 characters
#187: FILE: fs/cramfs/inode.c:436:
+		de = cramfs_read(dir->i_sb, dir_off, sizeof(*de)+CRAMFS_MAXPATHLEN);

WARNING: line over 80 characters
#196: FILE: fs/cramfs/inode.c:467:
+			d_add(dentry, get_cramfs_inode(dir->i_sb, &entry, dir_off));

total: 2 errors, 3 warnings, 161 lines checked

./patches/cramfs-generate-unique-inode-number-for-better-inode-cache-usage.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/cramfs/inode.c~cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~cramfs-generate-unique-inode-number-for-better-inode-cache-usage-checkpatch-fixes
+++ a/fs/cramfs/inode.c
@@ -37,7 +37,7 @@ static DEFINE_MUTEX(read_mutex);
 /* These macros may change in future, to provide better st_ino semantics. */
 #define OFFSET(x)	((x)->i_ino)
 
-static unsigned long cramino(struct cramfs_inode * cino, unsigned int offset)
+static unsigned long cramino(struct cramfs_inode *cino, unsigned int offset)
 {
 	if (!cino->offset)
 		return offset + 1;
@@ -61,7 +61,7 @@ static unsigned long cramino(struct cram
 }
 
 static struct inode *get_cramfs_inode(struct super_block *sb,
-	struct cramfs_inode * cramfs_inode, unsigned int offset)
+	struct cramfs_inode *cramfs_inode, unsigned int offset)
 {
 	struct inode *inode;
 	static struct timespec zerotime;
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
gen_init_cpio-avoid-risk-of-file-changing-between-calls-to-stat-and-open-checkpatch-fixes.patch
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
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

