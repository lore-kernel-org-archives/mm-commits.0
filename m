From: akpm@linux-foundation.org
Subject: + unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch added to -mm tree
Date: Thu, 20 Sep 2007 23:34:12 -0700
Message-ID: <200709210634.l8L6YCEx022705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40896 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751499AbXIUGeq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 02:34:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, hch@lst.de, jsipek@cs.sunysb.edu


The patch titled
     unionfs: fix unionfs_setattr to handle ATTR_KILL_S*ID
has been added to the -mm tree.  Its filename is
     unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unionfs: fix unionfs_setattr to handle ATTR_KILL_S*ID
From: Jeff Layton <jlayton@redhat.com>

Don't allow unionfs_setattr to trip the BUG() in notify_change. Clear
ATTR_MODE if the either ATTR_KILL_S*ID is set. This also allows the
lower filesystem to interpret these bits in its own way.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unionfs/inode.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/unionfs/inode.c~unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid fs/unionfs/inode.c
--- a/fs/unionfs/inode.c~unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid
+++ a/fs/unionfs/inode.c
@@ -1021,6 +1021,13 @@ static int unionfs_setattr(struct dentry
 	bend = dbend(dentry);
 	inode = dentry->d_inode;
 
+	/*
+	 * mode change is for clearing setuid/setgid. Allow lower filesystem
+	 * to reinterpret it in its own way.
+	 */
+	if (ia->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
+		ia->ia_valid &= ~ATTR_MODE;
+
 	for (bindex = bstart; (bindex <= bend) || (bindex == bstart);
 	     bindex++) {
 		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
_

Patches currently in -mm which might be from jlayton@redhat.com are

git-cifs.patch
git-nfs.patch
ecryptfs-allow-lower-fs-to-interpret-attr_kill_sid.patch
knfsd-only-set-attr_kill_sid-if-attr_mode-isnt-being-explicitly-set.patch
reiserfs-turn-of-attr_kill_sid-at-beginning-of-reiserfs_setattr.patch
unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch
vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch
nfs-if-attr_kill_sid-bits-are-set-then-skip-mode-change.patch
cifs-ignore-mode-change-if-its-just-for-clearing-setuid-setgid-bits.patch
