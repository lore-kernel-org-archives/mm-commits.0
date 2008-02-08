From: akpm@linux-foundation.org
Subject: - iget-introduce-a-function-to-register-iget-failure.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:07:08 -0800
Message-ID: <200802080806.m1886nha014484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34351 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761649AbYBHIUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     iget: introduce a function to register iget failure
has been removed from the -mm tree.  Its filename was
     iget-introduce-a-function-to-register-iget-failure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: introduce a function to register iget failure
From: David Howells <dhowells@redhat.com>

Introduce a function to register failure in an inode construction path.  This
includes marking the inode under construction as bad, unlocking it and
releasing it.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/porting |   18 +++++++++++++-----
 fs/bad_inode.c                    |   14 ++++++++++++++
 include/linux/fs.h                |    1 +
 3 files changed, 28 insertions(+), 5 deletions(-)

diff -puN Documentation/filesystems/porting~iget-introduce-a-function-to-register-iget-failure Documentation/filesystems/porting
--- a/Documentation/filesystems/porting~iget-introduce-a-function-to-register-iget-failure
+++ a/Documentation/filesystems/porting
@@ -184,11 +184,19 @@ just takes the superblock and inode numb
 test and set for you.
 
 e.g.
-       inode = iget_locked(sb, ino);
-       if (inode->i_state & I_NEW) {
-               read_inode_from_disk(inode);
-               unlock_new_inode(inode);
-       }
+	inode = iget_locked(sb, ino);
+	if (inode->i_state & I_NEW) {
+		err = read_inode_from_disk(inode);
+		if (err < 0) {
+			iget_failed(inode);
+			return err;
+		}
+		unlock_new_inode(inode);
+	}
+
+Note that if the process of setting up a new inode fails, then iget_failed()
+should be called on the inode to render it dead, and an appropriate error
+should be passed back to the caller.
 
 ---
 [recommended]
diff -puN fs/bad_inode.c~iget-introduce-a-function-to-register-iget-failure fs/bad_inode.c
--- a/fs/bad_inode.c~iget-introduce-a-function-to-register-iget-failure
+++ a/fs/bad_inode.c
@@ -359,3 +359,17 @@ int is_bad_inode(struct inode *inode)
 }
 
 EXPORT_SYMBOL(is_bad_inode);
+
+/**
+ * iget_failed - Mark an under-construction inode as dead and release it
+ * @inode: The inode to discard
+ *
+ * Mark an under-construction inode as dead and release it.
+ */
+void iget_failed(struct inode *inode)
+{
+	make_bad_inode(inode);
+	unlock_new_inode(inode);
+	iput(inode);
+}
+EXPORT_SYMBOL(iget_failed);
diff -puN include/linux/fs.h~iget-introduce-a-function-to-register-iget-failure include/linux/fs.h
--- a/include/linux/fs.h~iget-introduce-a-function-to-register-iget-failure
+++ a/include/linux/fs.h
@@ -1780,6 +1780,7 @@ static inline struct inode *iget(struct 
 }
 
 extern void __iget(struct inode * inode);
+extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);
 extern void destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
tty-let-architectures-override-the-user-kernel-macros.patch
aout-move-stack_top-to-asm-processorh.patch
aout-mark-arches-that-support-aout-format.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
mn10300-add-platform-mtd-support-for-the-asb2303-board.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
procfs-constify-function-pointer-tables.patch
avoid-overflows-in-kernel-timec.patch
mount-options-fix-afs.patch
remove-aout-interpreter-support-in-elf-loader.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
