From: akpm@linux-foundation.org
Subject: + remove-handle_mm_fault-export.patch added to -mm tree
Date: Thu, 19 Jul 2007 13:50:52 -0700
Message-ID: <200707192050.l6JKoqED022289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761206AbXGSUvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:51:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, nickpiggin@yahoo.com.au


The patch titled
     remove handle_mm_fault export
has been added to the -mm tree.  Its filename is
     remove-handle_mm_fault-export.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 2 deletions(-)

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

origin.patch
fix-spufs-build-after-fault-changes.patch
gdth-remove-redundant-pci-stuff.patch
gdth-remove-redundant-pci-stuff-update.patch
git-xfs.patch
remove-handle_mm_fault-export.patch
sysv-convert-to-new-aops.patch
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
