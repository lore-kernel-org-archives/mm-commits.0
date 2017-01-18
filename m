From: akpm@linux-foundation.org
Subject: + fs-affs-remove-reference-to-affs_parent_ino.patch added to -mm
 tree
Date: Wed, 18 Jan 2017 13:44:29 -0800
Message-ID: <587fe1bd.rFpK9/oOkqHSfQJt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752171AbdARVoa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 16:44:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: remove reference to affs_parent_ino()
has been added to the -mm tree.  Its filename is
     fs-affs-remove-reference-to-affs_parent_ino.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-remove-reference-to-affs_parent_ino.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-remove-reference-to-affs_parent_ino.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from fabf@skynet.be are

documentation-filesystems-proctxt-add-vmpin.patch
fs-affs-remove-reference-to-affs_parent_ino.patch
fs-affs-add-validation-block-function.patch
fs-affs-make-affs-exportable.patch
fs-affs-use-octal-for-permissions.patch
fs-affs-add-prefix-to-some-functions.patch
fs-affs-nameic-forward-declarations-clean-up.patch
fs-affs-make-export-work-with-cold-dcache.patch
fs-add-i_blocksize.patch

