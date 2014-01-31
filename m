From: akpm@linux-foundation.org
Subject: [merged]
 documentation-filesystems-vfstxt-update-file_operations-documentation.patch removed from -mm tree
Date: Fri, 31 Jan 2014 11:16:44 -0800
Message-ID: <52ebf69c.n1VGi0U4gj8bymCZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50666 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862AbaAaTQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ryao@gentoo.org

Subject: [merged] documentation-filesystems-vfstxt-update-file_operations-documentation.patch removed from -mm tree
To: ryao@gentoo.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:44 -0800


The patch titled
     Subject: Documentation/filesystems/vfs.txt: update file_operations documentation
has been removed from the -mm tree.  Its filename was
     documentation-filesystems-vfstxt-update-file_operations-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Richard Yao <ryao@gentoo.org>
Subject: Documentation/filesystems/vfs.txt: update file_operations documentation

->readv, ->writev and ->sendfile have been removed while ->show_fdinfo
has been added. The documentation should reflect this.

Signed-off-by: Richard Yao <ryao@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfs.txt |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN Documentation/filesystems/vfs.txt~documentation-filesystems-vfstxt-update-file_operations-documentation Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~documentation-filesystems-vfstxt-update-file_operations-documentation
+++ a/Documentation/filesystems/vfs.txt
@@ -782,7 +782,7 @@ struct file_operations
 ----------------------
 
 This describes how the VFS can manipulate an open file. As of kernel
-3.5, the following members are defined:
+3.12, the following members are defined:
 
 struct file_operations {
 	struct module *owner;
@@ -803,9 +803,6 @@ struct file_operations {
 	int (*aio_fsync) (struct kiocb *, int datasync);
 	int (*fasync) (int, struct file *, int);
 	int (*lock) (struct file *, int, struct file_lock *);
-	ssize_t (*readv) (struct file *, const struct iovec *, unsigned long, loff_t *);
-	ssize_t (*writev) (struct file *, const struct iovec *, unsigned long, loff_t *);
-	ssize_t (*sendfile) (struct file *, loff_t *, size_t, read_actor_t, void *);
 	ssize_t (*sendpage) (struct file *, struct page *, int, size_t, loff_t *, int);
 	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 	int (*check_flags)(int);
@@ -814,6 +811,7 @@ struct file_operations {
 	ssize_t (*splice_read)(struct file *, struct pipe_inode_info *, size_t, unsigned int);
 	int (*setlease)(struct file *, long arg, struct file_lock **);
 	long (*fallocate)(struct file *, int mode, loff_t offset, loff_t len);
+	int (*show_fdinfo)(struct seq_file *m, struct file *f);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -864,12 +862,6 @@ otherwise noted.
   lock: called by the fcntl(2) system call for F_GETLK, F_SETLK, and F_SETLKW
   	commands
 
-  readv: called by the readv(2) system call
-
-  writev: called by the writev(2) system call
-
-  sendfile: called by the sendfile(2) system call
