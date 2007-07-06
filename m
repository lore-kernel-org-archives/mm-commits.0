From: akpm@linux-foundation.org
Subject: - allow-file-system-to-configure-for-no-leases.patch removed from -mm tree
Date: Fri, 06 Jul 2007 02:53:03 -0700
Message-ID: <200707060953.l669r3mf020702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45098 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757261AbXGFJyC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 05:54:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: staubach@redhat.com, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     allow file system to configure for no leases
has been removed from the -mm tree.  Its filename was
     allow-file-system-to-configure-for-no-leases.patch

This patch was dropped because git-vfs-lease-api.patch wrecked it

------------------------------------------------------
Subject: allow file system to configure for no leases
From: Peter Staubach <staubach@redhat.com>

Allow file systems to inform the file system independent layers that they
don't support file leases.

The problem is that some file system such as NFSv2 and NFSv3 do not have
sufficient support to be able to support leases correctly.  In particular
for these two file systems, there is no over the wire protocol support.

Currently, these two file systems fail the fcntl(F_SETLEASE) call
accidently, due to a reference counting difference.  These file systems
should fail more consciously, with a proper error to indicate that the call
is invalid for them.

Acked-by: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Peter Staubach <staubach@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/locks.c         |    2 ++
 fs/nfs/super.c     |    2 ++
 include/linux/fs.h |    2 ++
 3 files changed, 6 insertions(+)

diff -puN fs/locks.c~allow-file-system-to-configure-for-no-leases fs/locks.c
--- a/fs/locks.c~allow-file-system-to-configure-for-no-leases
+++ a/fs/locks.c
@@ -1476,6 +1476,8 @@ int fcntl_setlease(unsigned int fd, stru
 	error = security_file_lock(filp, arg);
 	if (error)
 		return error;
+	if (IS_NO_LEASES(inode))
+		return -EINVAL;
 
 	locks_init_lock(&fl);
 	error = lease_init(filp, arg, &fl);
diff -puN fs/nfs/super.c~allow-file-system-to-configure-for-no-leases fs/nfs/super.c
--- a/fs/nfs/super.c~allow-file-system-to-configure-for-no-leases
+++ a/fs/nfs/super.c
@@ -558,6 +558,8 @@ static inline void nfs_initialise_sb(str
 
 	sb->s_magic = NFS_SUPER_MAGIC;
 
+	sb->s_flags |= MS_NO_LEASES;
+
 	/* We probably want something more informative here */
 	snprintf(sb->s_id, sizeof(sb->s_id),
 		 "%x:%x", MAJOR(sb->s_dev), MINOR(sb->s_dev));
diff -puN include/linux/fs.h~allow-file-system-to-configure-for-no-leases include/linux/fs.h
--- a/include/linux/fs.h~allow-file-system-to-configure-for-no-leases
+++ a/include/linux/fs.h
@@ -123,6 +123,7 @@ extern int dir_notify_enable;
 #define MS_SLAVE	(1<<19)	/* change to slave */
 #define MS_SHARED	(1<<20)	/* change to shared */
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
+#define MS_NO_LEASES	(1<<22)	/* fs does not support leases */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
@@ -182,6 +183,7 @@ extern int dir_notify_enable;
 #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
 #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
 #define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
+#define IS_NO_LEASES(inode)	__IS_FLG(inode, MS_NO_LEASES)
 
 /* the read-only stuff doesn't really belong here, but any other place is
    probably as bad and I don't want to create yet another include file. */
_

Patches currently in -mm which might be from staubach@redhat.com are

git-vfs-lease-api.patch
allow-file-system-to-configure-for-no-leases.patch
