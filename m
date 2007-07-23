From: akpm@linux-foundation.org
Subject: - remove-handle_mm_fault-export.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:17 -0700
Message-ID: <200707230934.l6N9YH2a016370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758439AbXGWJpY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     remove handle_mm_fault export
has been removed from the -mm tree.  Its filename was
     remove-handle_mm_fault-export.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove handle_mm_fault export
From: Christoph Hellwig <hch@lst.de>

Now that arch/powerpc/platforms/cell/spufs/fault.c is always built in
the kernel there is no need to export handle_mm_fault anymore.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memory.c~remove-handle_mm_fault-export mm/memory.c
--- a/mm/memory.c~remove-handle_mm_fault-export
+++ a/mm/memory.c
@@ -2659,8 +2659,6 @@ int handle_mm_fault(struct mm_struct *mm
 	return handle_pte_fault(mm, vma, address, pte, pmd, write_access);
 }
 
-EXPORT_SYMBOL_GPL(handle_mm_fault);
-
 #ifndef __PAGETABLE_PUD_FOLDED
 /*
  * Allocate page upper directory.
_

Patches currently in -mm which might be from hch@lst.de are

git-xfs.patch
sysv-convert-to-new-aops.patch
kill-declare_mutex_locked.patch
remove-unneded-lock_kernel-in-driver-block-loopc.patch
loop-use-unlocked_ioctl.patch
rename-setleast-to-generic_setlease.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
