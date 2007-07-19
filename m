From: akpm@linux-foundation.org
Subject: + mm-fault-feedback-more-fixes.patch added to -mm tree
Date: Wed, 18 Jul 2007 21:41:31 -0700
Message-ID: <200707190441.l6J4fVVL013991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51784 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbXGSEll (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 00:41:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm: fault feedback more fixes
has been added to the -mm tree.  Its filename is
     mm-fault-feedback-more-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: fault feedback more fixes
From: Nick Piggin <npiggin@suse.de>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm26/mm/fault.c |    8 +++-----
 arch/ppc/mm/fault.c   |    4 ++--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff -puN arch/arm26/mm/fault.c~mm-fault-feedback-more-fixes arch/arm26/mm/fault.c
--- a/arch/arm26/mm/fault.c~mm-fault-feedback-more-fixes
+++ a/arch/arm26/mm/fault.c
@@ -225,13 +225,11 @@ int do_page_fault(unsigned long addr, un
 	/*
 	 * Handle the "normal" case first
 	 */
-	if (unlikely(fault & VM_FAULT_SIGBUS))
-	case VM_FAULT_MINOR:
-	case VM_FAULT_MAJOR:
+	if (likely(!(fault & VM_FAULT_ERROR)))
 		return 0;
-	case VM_FAULT_SIGBUS:
+	if (fault & VM_FAULT_SIGBUS)
 		goto do_sigbus;
-	}
+	/* else VM_FAULT_OOM */
 
 	/*
 	 * If we are in kernel mode at this point, we
diff -puN arch/ppc/mm/fault.c~mm-fault-feedback-more-fixes arch/ppc/mm/fault.c
--- a/arch/ppc/mm/fault.c~mm-fault-feedback-more-fixes
+++ a/arch/ppc/mm/fault.c
@@ -259,9 +259,9 @@ good_area:
 		BUG();
 	}
 	if (fault & VM_FAULT_MAJOR)
-		tsk->maj_flt++;
+		current->maj_flt++;
 	else
-		tsk->min_flt++;
+		current->min_flt++;
 
 	up_read(&mm->mmap_sem);
 	/*
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-1.patch
mm-fault-feedback-2.patch
mm-fault-feedback-2-fix.patch
mm-fault-feedback-2-fix-2.patch
mm-fault-feedback-more-fixes.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
introduce-write_begin-write_end-aops-important-fix.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-convert-to-new-aops-fix.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
hostfs-convert-to-new-aops-fix.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
udf-convert-to-new-aops-fix.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
affs-convert-to-new-aops-fix.patch
ocfs2-convert-to-new-aops.patch
fs-remove-some-aop_truncated_page.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
