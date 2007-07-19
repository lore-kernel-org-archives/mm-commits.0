From: akpm@linux-foundation.org
Subject: + fix-spufs-build-after-fault-changes.patch added to -mm tree
Date: Thu, 19 Jul 2007 11:02:19 -0700
Message-ID: <200707191802.l6JI2K7v014657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33259 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937590AbXGSSCj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 14:02:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, arnd@arndb.de


The patch titled
     fix spufs build after ->fault changes
has been added to the -mm tree.  Its filename is
     fix-spufs-build-after-fault-changes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix spufs build after ->fault changes
From: Christoph Hellwig <hch@lst.de>

83c54070ee1a2d05c89793884bea1a03f2851ed4 broke spufs by incorrectly
updating the code, this patch gets it to compile again.

It's probably still broken due to the scheduler changes, but this
at least makes sure cell kernels can still be built.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/fault.c |   22 ++++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/fault.c~fix-spufs-build-after-fault-changes arch/powerpc/platforms/cell/spufs/fault.c
--- a/arch/powerpc/platforms/cell/spufs/fault.c~fix-spufs-build-after-fault-changes
+++ a/arch/powerpc/platforms/cell/spufs/fault.c
@@ -74,18 +74,18 @@ good_area:
 			goto bad_area;
 	}
 	ret = 0;
-	fault = handle_mm_fault(mm, vma, ea, is_write);
-	if (unlikely(fault & VM_FAULT_ERROR)) {
-		if (fault & VM_FAULT_OOM) {
+	*flt = handle_mm_fault(mm, vma, ea, is_write);
+	if (unlikely(*flt & VM_FAULT_ERROR)) {
+		if (*flt & VM_FAULT_OOM) {
 			ret = -ENOMEM;
 			goto bad_area;
-		} else if (fault & VM_FAULT_SIGBUS) {
+		} else if (*flt & VM_FAULT_SIGBUS) {
 			ret = -EFAULT;
 			goto bad_area;
 		}
 		BUG();
 	}
-	if (fault & VM_FAULT_MAJOR)
+	if (*flt & VM_FAULT_MAJOR)
 		current->maj_flt++;
 	else
 		current->min_flt++;
@@ -210,15 +210,15 @@ int spufs_handle_class1(struct spu_conte
 	 * In case of unhandled error report the problem to user space.
 	 */
 	if (!ret) {
-		if (flt == VM_FAULT_MINOR)
-			ctx->stats.min_flt++;
-		else
+		if (flt & VM_FAULT_MAJOR)
 			ctx->stats.maj_flt++;
+		else
+			ctx->stats.min_flt++;
 		if (ctx->state == SPU_STATE_RUNNABLE) {
-			if (flt == VM_FAULT_MINOR)
-				ctx->spu->stats.min_flt++;
-			else
+			if (flt & VM_FAULT_MAJOR)
 				ctx->spu->stats.maj_flt++;
+			else
+				ctx->spu->stats.min_flt++;
 		}
 
 		if (ctx->spu)
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
fix-spufs-build-after-fault-changes.patch
fs-introduce-vfs_path_lookup.patch
sunrpc-use-vfs_path_lookup.patch
nfsctl-use-vfs_path_lookup.patch
fs-mark-link_path_walk-static.patch
fs-remove-path_walk-export.patch
git-dvb.patch
git-ubi.patch
gdth-remove-redundant-pci-stuff.patch
gdth-remove-redundant-pci-stuff-update.patch
git-xfs.patch
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
