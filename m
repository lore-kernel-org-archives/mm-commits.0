From: akpm@linux-foundation.org
Subject: [merged] vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:16:26 -0800
Message-ID: <200902191916.n1JJGQSx016252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbZBSTQl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:16:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pjt@google.com, adobriyan@gmail.com, ebiederm@xmission.com, stable@kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: separate FMODE_PREAD/FMODE_PWRITE into separate flags
has been removed from the -mm tree.  Its filename was
     vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: separate FMODE_PREAD/FMODE_PWRITE into separate flags
From: Paul Turner <pjt@google.com>

Separate FMODE_PREAD and FMODE_PWRITE into separate flags to reflect the
reality that the read and write paths may have independent restrictions.

A git grep verifies that these flags are always cleared together so this
new behavior will only apply to interfaces that change to clear flags
individually.

This is required for "seq_file: properly cope with pread", a post-2.6.25
regression fix.

[akpm@linux-foundation.org: add comment]
Signed-off-by: Paul Turner <pjt@google.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc:  Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>		[2.6.25.x, 2.6.26.x, 2.6.27.x, 2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff -puN include/linux/fs.h~vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags include/linux/fs.h
--- a/include/linux/fs.h~vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags
+++ a/include/linux/fs.h
@@ -54,24 +54,30 @@ struct inodes_stat_t {
 #define MAY_ACCESS 16
 #define MAY_OPEN 32
 
+/*
+ * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
+ * to O_WRONLY and O_RDWR via the strange trick in __dentry_open()
+ */
+
 /* file is open for reading */
 #define FMODE_READ		((__force fmode_t)1)
 /* file is open for writing */
 #define FMODE_WRITE		((__force fmode_t)2)
 /* file is seekable */
 #define FMODE_LSEEK		((__force fmode_t)4)
-/* file can be accessed using pread/pwrite */
+/* file can be accessed using pread */
 #define FMODE_PREAD		((__force fmode_t)8)
-#define FMODE_PWRITE		FMODE_PREAD	/* These go hand in hand */
+/* file can be accessed using pwrite */
+#define FMODE_PWRITE		((__force fmode_t)16)
 /* File is opened for execution with sys_execve / sys_uselib */
-#define FMODE_EXEC		((__force fmode_t)16)
+#define FMODE_EXEC		((__force fmode_t)32)
 /* File is opened with O_NDELAY (only set for block devices) */
-#define FMODE_NDELAY		((__force fmode_t)32)
+#define FMODE_NDELAY		((__force fmode_t)64)
 /* File is opened with O_EXCL (only set for block devices) */
-#define FMODE_EXCL		((__force fmode_t)64)
+#define FMODE_EXCL		((__force fmode_t)128)
 /* File is opened using open(.., 3, ..) and is writeable only for ioctls
    (specialy hack for floppy.c) */
-#define FMODE_WRITE_IOCTL	((__force fmode_t)128)
+#define FMODE_WRITE_IOCTL	((__force fmode_t)256)
 
 /*
  * Don't update ctime and mtime.
_

Patches currently in -mm which might be from pjt@google.com are

origin.patch

