From: akpm@linux-foundation.org
Subject: + iget-introduce-a-function-to-register-iget-failure.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:43:19 -0700
Message-ID: <200710270743.l9R7hJgG003245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59816 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413AbXJ0Hnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:43:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     iget: introduce a function to register iget failure
has been added to the -mm tree.  Its filename is
     iget-introduce-a-function-to-register-iget-failure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: introduce a function to register iget failure
From: David Howells <dhowells@redhat.com>

Introduce a function to register failure in an inode construction path.  This
includes marking the inode under construction as bad, unlocking it and
releasing it.

Signed-off-by: David Howells <dhowells@redhat.com>
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
@@ -1769,6 +1769,7 @@ static inline struct inode *iget(struct 
 }
 
 extern void __iget(struct inode * inode);
+extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);
 extern void destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
mutex-subsystem-synchro-test-module.patch
