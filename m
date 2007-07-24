From: akpm@linux-foundation.org
Subject: - spusched-fix-mismerge-in-spufsh.patch removed from -mm tree
Date: Tue, 24 Jul 2007 16:24:40 -0700
Message-ID: <200707242324.l6ONOegV006292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51464 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757392AbXGXXY6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 19:24:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, arnd.bergmann@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     spusched: fix mismerge in spufs.h
has been removed from the -mm tree.  Its filename was
     spusched-fix-mismerge-in-spufsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spusched: fix mismerge in spufs.h
From: Christoph Hellwig <hch@lst.de>

spufs.h now has two enums for the sched_flags leading to identical
values for SPU_SCHED_WAS_ACTIVE and SPU_SCHED_NOTIFY_ACTIVE.  Merge
them into a single enum as they were in the IBM development tree.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/spufs/spufs.h |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

diff -puN arch/powerpc/platforms/cell/spufs/spufs.h~spusched-fix-mismerge-in-spufsh arch/powerpc/platforms/cell/spufs/spufs.h
--- a/arch/powerpc/platforms/cell/spufs/spufs.h~spusched-fix-mismerge-in-spufsh
+++ a/arch/powerpc/platforms/cell/spufs/spufs.h
@@ -40,13 +40,10 @@ enum {
 struct spu_context_ops;
 struct spu_gang;
 
-enum {
-	SPU_SCHED_WAS_ACTIVE,	/* was active upon spu_acquire_saved()  */
-};
-
 /* ctx->sched_flags */
 enum {
 	SPU_SCHED_NOTIFY_ACTIVE,
+	SPU_SCHED_WAS_ACTIVE,	/* was active upon spu_acquire_saved()  */
 };
 
 struct spu_context {
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
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
