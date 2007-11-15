From: akpm@linux-foundation.org
Subject: - smbfs-fix-debug-builds.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:54 -0800
Message-ID: <200711152110.lAFLAs6h015698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45467 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760407AbXKOVRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, mm-commits@vger.kernel.org


The patch titled
     smbfs: fix debug builds
has been removed from the -mm tree.  Its filename was
     smbfs-fix-debug-builds.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: smbfs: fix debug builds
From: Jeff Layton <jlayton@redhat.com>

Fix some warnings with SMBFS_DEBUG_* builds.  This patch makes it so that
builds with -Werror don't fail.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/smbfs/file.c   |    7 ++++---
 fs/smbfs/inode.c  |    2 +-
 fs/smbfs/proc.c   |    2 +-
 fs/smbfs/smbiod.c |    2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff -puN fs/smbfs/file.c~smbfs-fix-debug-builds fs/smbfs/file.c
--- a/fs/smbfs/file.c~smbfs-fix-debug-builds
+++ a/fs/smbfs/file.c
@@ -234,7 +234,7 @@ smb_file_aio_read(struct kiocb *iocb, co
 
 	VERBOSE("before read, size=%ld, flags=%x, atime=%ld\n",
 		(long)dentry->d_inode->i_size,
-		dentry->d_inode->i_flags, dentry->d_inode->i_atime);
+		dentry->d_inode->i_flags, dentry->d_inode->i_atime.tv_sec);
 
 	status = generic_file_aio_read(iocb, iov, nr_segs, pos);
 out:
@@ -269,7 +269,7 @@ smb_file_splice_read(struct file *file, 
 	struct dentry *dentry = file->f_path.dentry;
 	ssize_t status;
 
-	VERBOSE("file %s/%s, pos=%Ld, count=%d\n",
+	VERBOSE("file %s/%s, pos=%Ld, count=%lu\n",
 		DENTRY_PATH(dentry), *ppos, count);
 
 	status = smb_revalidate_inode(dentry);
@@ -363,7 +363,8 @@ smb_file_aio_write(struct kiocb *iocb, c
 		result = generic_file_aio_write(iocb, iov, nr_segs, pos);
 		VERBOSE("pos=%ld, size=%ld, mtime=%ld, atime=%ld\n",
 			(long) file->f_pos, (long) dentry->d_inode->i_size,
-			dentry->d_inode->i_mtime, dentry->d_inode->i_atime);
+			dentry->d_inode->i_mtime.tv_sec,
+			dentry->d_inode->i_atime.tv_sec);
 	}
 out:
 	return result;
diff -puN fs/smbfs/inode.c~smbfs-fix-debug-builds fs/smbfs/inode.c
--- a/fs/smbfs/inode.c~smbfs-fix-debug-builds
+++ a/fs/smbfs/inode.c
@@ -536,7 +536,7 @@ static int smb_fill_super(struct super_b
 
 	/* Allocate the global temp buffer and some superblock helper structs */
 	/* FIXME: move these to the smb_sb_info struct */
-	VERBOSE("alloc chunk = %d\n", sizeof(struct smb_ops) +
+	VERBOSE("alloc chunk = %lu\n", sizeof(struct smb_ops) +
 		sizeof(struct smb_mount_data_kernel));
 	mem = kmalloc(sizeof(struct smb_ops) +
 		      sizeof(struct smb_mount_data_kernel), GFP_KERNEL);
diff -puN fs/smbfs/proc.c~smbfs-fix-debug-builds fs/smbfs/proc.c
--- a/fs/smbfs/proc.c~smbfs-fix-debug-builds
+++ a/fs/smbfs/proc.c
@@ -2593,7 +2593,7 @@ smb_proc_getattr_ff(struct smb_sb_info *
 	fattr->f_mtime.tv_sec = date_dos2unix(server, date, time);
 	fattr->f_mtime.tv_nsec = 0;
 	VERBOSE("name=%s, date=%x, time=%x, mtime=%ld\n",
-		mask, date, time, fattr->f_mtime);
+		mask, date, time, fattr->f_mtime.tv_sec);
 	fattr->f_size = DVAL(req->rq_data, 12);
 	/* ULONG allocation size */
 	fattr->attr = WVAL(req->rq_data, 20);
diff -puN fs/smbfs/smbiod.c~smbfs-fix-debug-builds fs/smbfs/smbiod.c
--- a/fs/smbfs/smbiod.c~smbfs-fix-debug-builds
+++ a/fs/smbfs/smbiod.c
@@ -227,7 +227,7 @@ int smbiod_retry(struct smb_sb_info *ser
 		printk(KERN_ERR "smb_retry: signal failed [%d]\n", result);
 		goto out;
 	}
-	VERBOSE("signalled pid %d\n", pid);
+	VERBOSE("signalled pid %d\n", pid_nr(pid));
 
 	/* FIXME: The retried requests should perhaps get a "time boost". */
 
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
git-cifs.patch
git-unionfs.patch
smbfs-fix-calculation-of-kernel_recvmsg-size-parameter-in-smb_receive.patch
