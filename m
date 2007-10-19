From: akpm@linux-foundation.org
Subject: - nfs-if-attr_kill_sid-bits-are-set-then-skip-mode-change.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:42:24 -0700
Message-ID: <200710190342.l9J3gO9X012894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42692 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966520AbXJSD5A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:57:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, bfields@fieldses.org, hch@lst.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     NFS: if ATTR_KILL_S*ID bits are set, then skip mode change
has been removed from the -mm tree.  Its filename was
     nfs-if-attr_kill_sid-bits-are-set-then-skip-mode-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -357,6 +357,10 @@ nfs_setattr(struct dentry *dentry, struc
 
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

origin.patch
git-cifs.patch
unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch
