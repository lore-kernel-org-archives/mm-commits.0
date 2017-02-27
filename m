From: akpm@linux-foundation.org
Subject: [patch 21/78] fs/affs: remove reference to affs_parent_ino()
Date: Mon, 27 Feb 2017 14:27:43 -0800
Message-ID: <58b4a7df.4TOy8zVXpUYKhpQo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45538 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751906AbdB0WgF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:36:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, fabf@skynet.be, viro@zeniv.linux.org.uk

From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: remove reference to affs_parent_ino()

Patch series "make FS exportable plus some clean-up", v7.

This small patchset makes AFFS work with NFS for standard operations.


THis patch (of 7):

affs_parent_ino() was removed a long time ago.

Link: http://lkml.kernel.org/r/20170109191208.6085-2-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/affs/affs.h~fs-affs-remove-reference-to-affs_parent_ino fs/affs/affs.h
--- a/fs/affs/affs.h~fs-affs-remove-reference-to-affs_parent_ino
+++ a/fs/affs/affs.h
@@ -178,7 +178,6 @@ extern int	affs_rename(struct inode *old
 
 /* inode.c */
 
-extern unsigned long		 affs_parent_ino(struct inode *dir);
 extern struct inode		*affs_new_inode(struct inode *dir);
 extern int			 affs_notify_change(struct dentry *dentry, struct iattr *attr);
 extern void			 affs_evict_inode(struct inode *inode);
_
