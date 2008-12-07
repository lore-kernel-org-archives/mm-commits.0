From: akpm@linux-foundation.org
Subject: - vfs-document-fmode_-constants.patch removed from -mm tree
Date: Sat, 06 Dec 2008 16:05:41 -0800
Message-ID: <200812070005.mB705fsd021515@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753560AbYLGAFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 6 Dec 2008 19:05:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     vfs: document FMODE_ constants
has been removed from the -mm tree.  Its filename was
     vfs-document-fmode_-constants.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: document FMODE_ constants
From: Christoph Hellwig <hch@lst.de>

Ensure that all FMODE_ constants are documented, and ensure a coherent
style for the already existing comments.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff -puN include/linux/fs.h~vfs-document-fmode_-constants include/linux/fs.h
--- a/include/linux/fs.h~vfs-document-fmode_-constants
+++ a/include/linux/fs.h
@@ -54,21 +54,23 @@ struct inodes_stat_t {
 #define MAY_ACCESS 16
 #define MAY_OPEN 32
 
-#define FMODE_READ ((__force fmode_t)1)
-#define FMODE_WRITE ((__force fmode_t)2)
-
-/* Internal kernel extensions */
-#define FMODE_LSEEK	((__force fmode_t)4)
-#define FMODE_PREAD	((__force fmode_t)8)
-#define FMODE_PWRITE	FMODE_PREAD	/* These go hand in hand */
-
-/* File is being opened for execution. Primary users of this flag are
-   distributed filesystems that can use it to achieve correct ETXTBUSY
-   behavior for cross-node execution/opening_for_writing of files */
-#define FMODE_EXEC	((__force fmode_t)16)
-
-#define FMODE_NDELAY	((__force fmode_t)32)
-#define FMODE_EXCL	((__force fmode_t)64)
+/* file is open for reading */
+#define FMODE_READ		((__force fmode_t)1)
+/* file is open for writing */
+#define FMODE_WRITE		((__force fmode_t)2)
+/* file is seekable */
+#define FMODE_LSEEK		((__force fmode_t)4)
+/* file can be accessed using pread/pwrite */
+#define FMODE_PREAD		((__force fmode_t)8)
+#define FMODE_PWRITE		FMODE_PREAD	/* These go hand in hand */
+/* File is opened for execution with sys_execve / sys_uselib */
+#define FMODE_EXEC		((__force fmode_t)16)
+/* File is opened with O_NDELAY (only set for block devices) */
+#define FMODE_NDELAY		((__force fmode_t)32)
+/* File is opened with O_EXCL (only set for block devices) */
+#define FMODE_EXCL		((__force fmode_t)64)
+/* File is opened using open(.., 3, ..) and is writeable only for ioctls
+   (specialy hack for floppy.c) */
 #define FMODE_WRITE_IOCTL	((__force fmode_t)128)
 
 #define RW_MASK		1
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
linux-next.patch
x86-remove-init_mm-export-as-planned-for-2626.patch
vfs-fix-vfs_rename_dir-for-fs_rename_does_d_move-filesystems.patch
fs-namespacec-drop-code-after-return.patch
introduce-new-lsm-hooks-where-vfsmount-is-available.patch
vfs-expand-some-comments-d_path-seq_path.patch
vfs-lseekfd-0-seek_cur-race-condition.patch
block-do_mounts-add-device-info-to-mount-message.patch
loop-add-ioctl-to-resize-a-loop-device.patch
filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs.patch
filesystem-freeze-implement-generic-freeze-feature.patch
filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature.patch

