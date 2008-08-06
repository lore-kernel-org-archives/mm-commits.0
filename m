From: akpm@linux-foundation.org
Subject: + vfs-make-security_inode_setattr-calling-consistent.patch added to -mm tree
Date: Tue, 05 Aug 2008 17:01:53 -0700
Message-ID: <200808060001.m7601rKD030351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758715AbYHFACM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 20:02:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, jmorris@namei.org, sds@tycho.nsa.gov, viro@zeniv.linux.org.uk


The patch titled
     vfs: make security_inode_setattr() calling consistent
has been added to the -mm tree.  Its filename is
     vfs-make-security_inode_setattr-calling-consistent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: make security_inode_setattr() calling consistent
From: Miklos Szeredi <mszeredi@suse.cz>

Call security_inode_setattr() consistently before inode_change_ok().  It
doesn't make sense to try to "optimize" the i_op->setattr == NULL case, as
most filesystem do define their own setattr function.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: James Morris <jmorris@namei.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/attr.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/attr.c~vfs-make-security_inode_setattr-calling-consistent fs/attr.c
--- a/fs/attr.c~vfs-make-security_inode_setattr-calling-consistent
+++ a/fs/attr.c
@@ -159,17 +159,17 @@ int notify_change(struct dentry * dentry
 	if (!(attr->ia_valid & ~(ATTR_KILL_SUID | ATTR_KILL_SGID)))
 		return 0;
 
+	error = security_inode_setattr(dentry, attr);
+	if (error)
+		return error;
+
 	if (ia_valid & ATTR_SIZE)
 		down_write(&dentry->d_inode->i_alloc_sem);
 
 	if (inode->i_op && inode->i_op->setattr) {
-		error = security_inode_setattr(dentry, attr);
-		if (!error)
-			error = inode->i_op->setattr(dentry, attr);
+		error = inode->i_op->setattr(dentry, attr);
 	} else {
 		error = inode_change_ok(inode, attr);
-		if (!error)
-			error = security_inode_setattr(dentry, attr);
 		if (!error) {
 			if ((ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
 			    (ia_valid & ATTR_GID && attr->ia_gid != inode->i_gid))
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
vfs-make-security_inode_setattr-calling-consistent.patch

