From: akpm@osdl.org
Subject: + have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode-update.patch added to -mm tree
Date: Wed, 24 Jan 2007 21:53:22 -0800
Message-ID: <200701250553.l0P5rMPi007315@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48470 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965365AbXAYFxe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 00:53:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     replacement patch for pipefs and sockfs
has been added to the -mm tree.  Its filename is
     have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: replacement patch for pipefs and sockfs
From: Jeff Layton <jlayton@redhat.com>

pipefs declares its drop_inode function to be generic_delete_inode, which
obviates the need to have the fs make certain that i_nlink is properly set at
drop_inode time.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/pipe.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN fs/pipe.c~have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode-update fs/pipe.c
--- a/fs/pipe.c~have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode-update
+++ a/fs/pipe.c
@@ -825,7 +825,6 @@ void free_pipe_info(struct inode *inode)
 {
 	__free_pipe_info(inode->i_pipe);
 	inode->i_pipe = NULL;
-	clear_nlink(inode);
 }
 
 static struct vfsmount *pipe_mnt __read_mostly;
@@ -1006,6 +1005,11 @@ int do_pipe(int *fd)
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
@@ -1016,7 +1020,7 @@ static int pipefs_get_sb(struct file_sys
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
have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode-update.patch
