From: akpm@linux-foundation.org
Subject: - fix-spufs-build-after-fault-changes.patch removed from -mm tree
Date: Thu, 19 Jul 2007 23:43:05 -0700
Message-ID: <200707200643.l6K6h5Ge011944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56276 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753466AbXGTGnk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 02:43:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, arnd@arndb.de, geoffrey.levand@am.sony.com, nickpiggin@yahoo.com.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     fix spufs build after ->fault changes
has been removed from the -mm tree.  Its filename was
     fix-spufs-build-after-fault-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix spufs build after ->fault changes
From: Christoph Hellwig <hch@lst.de>

83c54070ee1a2d05c89793884bea1a03f2851ed4 broke spufs by incorrectly
updating the code, this patch gets it to compile again.

It's probably still broken due to the scheduler changes, but this
at least makes sure cell kernels can still be built.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
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
gdth-remove-redundant-pci-stuff.patch
gdth-remove-redundant-pci-stuff-update.patch
git-xfs.patch
remove-handle_mm_fault-export.patch
sysv-convert-to-new-aops.patch
kill-declare_mutex_locked.patch
remove-unneded-lock_kernel-in-driver-block-loopc.patch
loop-use-unlocked_ioctl.patch
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
