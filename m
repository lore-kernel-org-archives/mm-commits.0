From: akpm@osdl.org
Subject: - have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode.patch removed from -mm tree
Date: Tue, 30 Jan 2007 16:53:36 -0800
Message-ID: <200701310053.l0V0raof003035@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59736 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbXAaAxv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:53:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     inode numbering: have pipefs ensure i_ino uniqueness by calling iunique and hashing the inode
has been removed from the -mm tree.  Its filename was
     have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: inode numbering: have pipefs ensure i_ino uniqueness by calling iunique and hashing the inode
From: Jeff Layton <jlayton@redhat.com>

This converts pipefs to use the new scheme.  Here we're calling iunique to get
a unique i_ino value for the new inode, and then hashing it afterward.  We
call iunique with a max_reserved value of 1 to avoid collision with the root
inode.  Since the inode is now hashed, we need to take care that we end up in
generic_delete_inode rather than generic_forget_inode or we'll create a nasty
leak, so we clear_nlink when we destroy the pipe info.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/pipe.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/pipe.c~have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode fs/pipe.c
--- a/fs/pipe.c~have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode
+++ a/fs/pipe.c
@@ -871,6 +871,8 @@ static struct inode * get_pipe_inode(voi
 	inode->i_uid = current->fsuid;
 	inode->i_gid = current->fsgid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_ino = iunique(pipe_mnt->mnt_sb, 1);
+	insert_inode_hash(inode);
 
 	return inode;
 
@@ -1003,6 +1005,11 @@ int do_pipe(int *fd)
 	return error;
 }
 
+static struct super_operations pipefs_sops = {
+	.statfs		= simple_statfs,
+	.drop_inode	= generic_delete_inode,
+};
+
 /*
  * pipefs should _never_ be mounted by userland - too much of security hassle,
  * no real gain from having the whole whorehouse mounted. So we don't need
@@ -1013,7 +1020,7 @@ static int pipefs_get_sb(struct file_sys
 			 int flags, const char *dev_name, void *data,
 			 struct vfsmount *mnt)
 {
-	return get_sb_pseudo(fs_type, "pipe:", NULL, PIPEFS_MAGIC, mnt);
+	return get_sb_pseudo(fs_type, "pipe:", &pipefs_sops, PIPEFS_MAGIC, mnt);
 }
 
 static struct file_system_type pipe_fs_type = {
_

Patches currently in -mm which might be from jlayton@redhat.com are

make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode.patch
