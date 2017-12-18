From: akpm@linux-foundation.org
Subject: +
 ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix.patch added to -mm tree
Date: Mon, 18 Dec 2017 13:54:56 -0800
Message-ID: <5a383930.KPVCTnH/mYxMMYG6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47720 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935229AbdLRVy5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Dec 2017 16:54:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix
has been added to the -mm tree.  Its filename is
     ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix.patch

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
@@ -2469,10 +2469,9 @@ static int ocfs2_dio_end_io(struct kiocb
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
@@ -2489,8 +2488,8 @@ static int ocfs2_check_range_for_holes(s
 		}
 
 		if (phys_cpos == 0 || (extent_flags & OCFS2_EXT_UNWRITTEN)) {
-			ret = 1;
-			break;
+			ret = true;
+			goto out;
 		}
 
 		if (extent_len > clusters)
@@ -2520,7 +2519,7 @@ static ssize_t ocfs2_direct_IO(struct ki
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
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-fall-back-to-buffer-io-when-append-dio-is-disabled-with-file-hole-existing-fix.patch
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
lib-ubsanc-s-missaligned-misaligned.patch
linux-next-rejects.patch
tools-objtool-makefile-dont-assume-sync-checksh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

