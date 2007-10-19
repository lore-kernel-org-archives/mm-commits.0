From: akpm@linux-foundation.org
Subject: - knfsd-only-set-attr_kill_sid-if-attr_mode-isnt-being-explicitly-set.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:42:16 -0700
Message-ID: <200710190342.l9J3gGcR012885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36688 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966492AbXJSD4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, bfields@fieldses.org, hch@lst.de, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: only set ATTR_KILL_S*ID if ATTR_MODE isn't being explicitly set
has been removed from the -mm tree.  Its filename was
     knfsd-only-set-attr_kill_sid-if-attr_mode-isnt-being-explicitly-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: only set ATTR_KILL_S*ID if ATTR_MODE isn't being explicitly set
From: Jeff Layton <jlayton@redhat.com>

It's theoretically possible for a single SETATTR call to come in that sets the
mode and the uid/gid.  In that case, don't set the ATTR_KILL_S*ID bits since
that would trip the BUG() in notify_change.  Just fix up the mode to have the
same effect.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/vfs.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN fs/nfsd/vfs.c~knfsd-only-set-attr_kill_sid-if-attr_mode-isnt-being-explicitly-set fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-only-set-attr_kill_sid-if-attr_mode-isnt-being-explicitly-set
+++ a/fs/nfsd/vfs.c
@@ -364,14 +364,23 @@ nfsd_setattr(struct svc_rqst *rqstp, str
 	if (iap->ia_valid & ATTR_MODE) {
 		iap->ia_mode &= S_IALLUGO;
 		imode = iap->ia_mode |= (imode & ~S_IALLUGO);
+		/* if changing uid/gid revoke setuid/setgid in mode */
+		if ((iap->ia_valid & ATTR_UID) && iap->ia_uid != inode->i_uid) {
+			iap->ia_valid |= ATTR_KILL_PRIV;
+			iap->ia_mode &= ~S_ISUID;
+		}
+		if ((iap->ia_valid & ATTR_GID) && iap->ia_gid != inode->i_gid)
+			iap->ia_mode &= ~S_ISGID;
+	} else {
+		/*
+		 * Revoke setuid/setgid bit on chown/chgrp
+		 */
+		if ((iap->ia_valid & ATTR_UID) && iap->ia_uid != inode->i_uid)
+			iap->ia_valid |= ATTR_KILL_SUID | ATTR_KILL_PRIV;
+		if ((iap->ia_valid & ATTR_GID) && iap->ia_gid != inode->i_gid)
+			iap->ia_valid |= ATTR_KILL_SGID;
 	}
 
-	/* Revoke setuid/setgid bit on chown/chgrp */
-	if ((iap->ia_valid & ATTR_UID) && iap->ia_uid != inode->i_uid)
-		iap->ia_valid |= ATTR_KILL_SUID | ATTR_KILL_PRIV;
-	if ((iap->ia_valid & ATTR_GID) && iap->ia_gid != inode->i_gid)
-		iap->ia_valid |= ATTR_KILL_SGID;
-
 	/* Change the attributes. */
 
 	iap->ia_valid |= ATTR_CTIME;
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
git-cifs.patch
unionfs-fix-unionfs_setattr-to-handle-attr_kill_sid.patch
