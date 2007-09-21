From: akpm@linux-foundation.org
Subject: + vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch added to -mm tree
Date: Thu, 20 Sep 2007 23:34:13 -0700
Message-ID: <200709210634.l8L6YDdv022708@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34844 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129AbXIUGf0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 02:35:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, bfields@fieldses.org, chris.mason@oracle.com, hch@lst.de, jeffm@suse.com, jsipek@cs.sunysb.edu, mhalcrow@us.ibm.com, neilb@suse.de, sfrench@us.ibm.com, trond.myklebust@fys.uio.no, vs@namesys.com


The patch titled
     VFS: make notify_change pass ATTR_KILL_S*ID to setattr operations
has been added to the -mm tree.  Its filename is
     vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: VFS: make notify_change pass ATTR_KILL_S*ID to setattr operations
From: Jeff Layton <jlayton@redhat.com>

When an unprivileged process attempts to modify a file that has the setuid or
setgid bits set, the VFS will attempt to clear these bits.  The VFS will set
the ATTR_KILL_SUID or ATTR_KILL_SGID bits in the ia_valid mask, and then call
notify_change to clear these bits and set the mode accordingly.

With a networked filesystem (NFS and CIFS in particular but likely others),
the client machine or process may not have credentials that allow for setting
the mode.  In some situations, this can lead to file corruption, an operation
failing outright because the setattr fails, or to races that lead to a mode
change being reverted.

In this situation, we'd like to just leave the handling of this to the server
and ignore these bits.  The problem is that by the time the setattr op is
called, the VFS has already reinterpreted the ATTR_KILL_* bits into a mode
change.  The setattr operation has no way to know its intent.

The following patch fixes this by making notify_change no longer clear the
ATTR_KILL_SUID and ATTR_KILL_SGID bits in the ia_valid before handing it off
to the setattr inode op.  setattr can then check for the presence of these
bits, and if they're set it can assume that the mode change was only for the
purposes of clearing these bits.

This means that we now have an implicit assumption that notify_change is never
called with ATTR_MODE and either ATTR_KILL_S*ID bit set.  Nothing currently
enforces that, so this patch also adds a BUG() if that occurs.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Cc: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/attr.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN fs/attr.c~vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations fs/attr.c
--- a/fs/attr.c~vfs-make-notify_change-pass-attr_kill_sid-to-setattr-operations
+++ a/fs/attr.c
@@ -103,12 +103,11 @@ EXPORT_SYMBOL(inode_setattr);
 int notify_change(struct dentry * dentry, struct iattr * attr)
 {
 	struct inode *inode = dentry->d_inode;
-	mode_t mode;
+	mode_t mode = inode->i_mode;
 	int error;
 	struct timespec now;
 	unsigned int ia_valid = attr->ia_valid;
 
-	mode = inode->i_mode;
 	now = current_fs_time(inode->i_sb);
 
 	attr->ia_ctime = now;
@@ -125,18 +124,25 @@ int notify_change(struct dentry * dentry
 		if (error)
 			return error;
 	}
+
+	/*
+	 * We now pass ATTR_KILL_S*ID to the lower level setattr function so
+	 * that the function has the ability to reinterpret a mode change
+	 * that's due to these bits. This adds an implicit restriction that
+	 * no function will ever call notify_change with both ATTR_MODE and
+	 * ATTR_KILL_S*ID set.
+	 */
+	if ((ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID)) &&
+	    (ia_valid & ATTR_MODE))
+		BUG();
+
 	if (ia_valid & ATTR_KILL_SUID) {
-		attr->ia_valid &= ~ATTR_KILL_SUID;
 		if (mode & S_ISUID) {
-			if (!(ia_valid & ATTR_MODE)) {
-				ia_valid = attr->ia_valid |= ATTR_MODE;
-				attr->ia_mode = inode->i_mode;
-			}
-			attr->ia_mode &= ~S_ISUID;
+			ia_valid = attr->ia_valid |= ATTR_MODE;
+			attr->ia_mode = (inode->i_mode & ~S_ISUID);
 		}
 	}
 	if (ia_valid & ATTR_KILL_SGID) {
-		attr->ia_valid &= ~ ATTR_KILL_SGID;
 		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
 			if (!(ia_valid & ATTR_MODE)) {
 				ia_valid = attr->ia_valid |= ATTR_MODE;
@@ -145,7 +151,7 @@ int notify_change(struct dentry * dentry
 			attr->ia_mode &= ~S_ISGID;
 		}
 	}
-	if (!attr->ia_valid)
+	if (!(attr->ia_valid & ~(ATTR_KILL_SUID | ATTR_KILL_SGID)))
 		return 0;
 
 	if (ia_valid & ATTR_SIZE)
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
