From: akpm@linux-foundation.org
Subject: + nfs-if-attr_kill_sid-bits-are-set-then-skip-mode-change.patch added to -mm tree
Date: Thu, 20 Sep 2007 23:34:15 -0700
Message-ID: <200709210634.l8L6YF2g022713@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54322 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756152AbXIUGfO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 02:35:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, bfields@fieldses.org, hch@lst.de, trond.myklebust@fys.uio.no


The patch titled
     NFS: if ATTR_KILL_S*ID bits are set, then skip mode change
has been added to the -mm tree.  Its filename is
     nfs-if-attr_kill_sid-bits-are-set-then-skip-mode-change.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: if ATTR_KILL_S*ID bits are set, then skip mode change
From: Jeff Layton <jlayton@redhat.com>

If the ATTR_KILL_S*ID bits are set then any mode change is only for clearing
the setuid/setgid bits.  For NFS, skip the mode change and let the server
handle it.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/nfs/inode.c~nfs-if-attr_kill_sid-bits-are-set-then-skip-mode-change fs/nfs/inode.c
--- a/fs/nfs/inode.c~nfs-if-attr_kill_sid-bits-are-set-then-skip-mode-change
+++ a/fs/nfs/inode.c
@@ -327,6 +327,10 @@ nfs_setattr(struct dentry *dentry, struc
 
 	nfs_inc_stats(inode, NFSIOS_VFSSETATTR);
 
+	/* skip mode change if it's just for clearing setuid/setgid */
+	if (attr->ia_valid & (ATTR_KILL_SUID | ATTR_KILL_SGID))
+		attr->ia_valid &= ~ATTR_MODE;
+
 	if (attr->ia_valid & ATTR_SIZE) {
 		if (!S_ISREG(inode->i_mode) || attr->ia_size == i_size_read(inode))
 			attr->ia_valid &= ~ATTR_SIZE;
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
