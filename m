From: akpm@osdl.org
Subject: + have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode.patch added to -mm tree
Date: Tue, 23 Jan 2007 20:48:18 -0800
Message-ID: <200701240448.l0O4mIRO008683@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51186 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030189AbXAXEs2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 23:48:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     inode numbering: have pipefs ensure i_ino uniqueness by calling iunique and hashing the inode
has been added to the -mm tree.  Its filename is
     have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 fs/pipe.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/pipe.c~have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode fs/pipe.c
--- a/fs/pipe.c~have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode
+++ a/fs/pipe.c
@@ -825,6 +825,7 @@ void free_pipe_info(struct inode *inode)
 {
 	__free_pipe_info(inode->i_pipe);
 	inode->i_pipe = NULL;
+	clear_nlink(inode);
 }
 
 static struct vfsmount *pipe_mnt __read_mostly;
@@ -871,6 +872,8 @@ static struct inode * get_pipe_inode(voi
 	inode->i_uid = current->fsuid;
 	inode->i_gid = current->fsgid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_ino = iunique(pipe_mnt->mnt_sb, 1);
+	insert_inode_hash(inode);
 
 	return inode;
 
_

Patches currently in -mm which might be from jlayton@redhat.com are

make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch
have-pipefs-ensure-i_ino-uniqueness-by-calling-iunique-and-hashing-the-inode.patch
