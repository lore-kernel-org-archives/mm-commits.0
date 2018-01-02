From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix.patch removed from -mm tree
Date: Tue, 02 Jan 2018 14:09:12 -0800
Message-ID: <5a4c0308.q6td5eRhkOrumiZe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48130 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbeABWJO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jan 2018 17:09:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix.patch

This patch was dropped because it was folded into ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix

rename ocfs2_check_range_for_holes(), make it return bool

Cc: Changwei Ge <ge.changwei@h3c.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix
+++ a/fs/ocfs2/aops.c
@@ -2421,10 +2421,9 @@ static int ocfs2_dio_end_io(struct kiocb
  * Will look for holes and unwritten extents in the range starting at
  * pos for count bytes (inclusive).
  */
-static int ocfs2_check_range_for_holes(struct inode *inode, loff_t pos,
-				       size_t count)
+static bool ocfs2_range_has_holes(struct inode *inode, loff_t pos, size_t count)
 {
-	int ret = 0;
+	bool ret = false;
 	unsigned int extent_flags;
 	u32 cpos, clusters, extent_len, phys_cpos;
 	struct super_block *sb = inode->i_sb;
@@ -2441,8 +2440,8 @@ static int ocfs2_check_range_for_holes(s
 		}
 
 		if (phys_cpos == 0 || (extent_flags & OCFS2_EXT_UNWRITTEN)) {
-			ret = 1;
-			break;
+			ret = true;
+			goto out;
 		}
 
 		if (extent_len > clusters)
@@ -2472,7 +2471,7 @@ static ssize_t ocfs2_direct_IO(struct ki
 	/* Fallback to buffered I/O if we do not support append dio. */
 	if (!ocfs2_supports_append_dio(osb) &&
 			(iocb->ki_pos + iter->count > i_size_read(inode) ||
-			 ocfs2_check_range_for_holes(inode, iocb->ki_pos,
+			 ocfs2_range_has_holes(inode, iocb->ki_pos,
 						     iter->count)))
 		return 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
kernel-exitc-export-abort-to-modules.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing.patch
mm.patch
mm-terminate-shrink_slab-loop-if-signal-is-pending-fix.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-split-deferred_init_range-into-initializing-and-freeing-parts-fix.patch
mm-do-not-stall-register_shrinker-fix.patch
selftest-vm-move-128tb-mmap-boundary-test-to-generic-directory-fix.patch
list_lru-prefetch-neighboring-list-entries-before-acquiring-lock-fix.patch
mm-oom-cgroup-aware-oom-killer-fix.patch
sparc64-update-pmdp_invalidate-to-return-old-pmd-value-fix.patch
x86-mm-provide-pmdp_establish-helper-fix.patch
fs-elf-drop-map_fixed-usage-from-elf_map-checkpatch-fixes.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix.patch
mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-checkpatch-fixes.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix.patch
mm-zsmalloc-simplify-shrinker-init-destroy-fix.patch
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

