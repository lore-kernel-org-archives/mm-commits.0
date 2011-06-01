From: akpm@linux-foundation.org
Subject: [merged] xattr-fix-error-results-for-non-existent-invisible-attributes.patch removed from -mm tree
Date: Wed, 01 Jun 2011 13:34:07 -0700
Message-ID: <201106012033.p51KXePe008111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759180Ab1FAUds (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 16:33:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agruen@kernel.org, eparis@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     xattr: fix error results for non-existent / invisible attributes
has been removed from the -mm tree.  Its filename was
     xattr-fix-error-results-for-non-existent-invisible-attributes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xattr: fix error results for non-existent / invisible attributes
From: Andreas Gruenbacher <agruen@kernel.org>

Return -ENODATA when trying to read a user.* attribute which cannot exist:
user space otherwise does not have a reasonable way to distinguish between
non-existent and inaccessible attributes.

Likewise, return -ENODATA when an unprivileged process tries to read a
trusted.* attribute: to unprivileged processes, those attributes are
invisible (listxattr() won't include them).

Related to this bug report: https://bugzilla.redhat.com/660613

Signed-off-by: Andreas Gruenbacher <agruen@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xattr.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN fs/xattr.c~xattr-fix-error-results-for-non-existent-invisible-attributes fs/xattr.c
--- a/fs/xattr.c~xattr-fix-error-results-for-non-existent-invisible-attributes
+++ a/fs/xattr.c
@@ -46,18 +46,22 @@ xattr_permission(struct inode *inode, co
 		return 0;
 
 	/*
-	 * The trusted.* namespace can only be accessed by a privileged user.
+	 * The trusted.* namespace can only be accessed by privileged users.
 	 */
-	if (!strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN))
-		return (capable(CAP_SYS_ADMIN) ? 0 : -EPERM);
+	if (!strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN)) {
+		if (!capable(CAP_SYS_ADMIN))
+			return (mask & MAY_WRITE) ? -EPERM : -ENODATA;
+		return 0;
+	}
 
-	/* In user.* namespace, only regular files and directories can have
+	/*
+	 * In the user.* namespace, only regular files and directories can have
 	 * extended attributes. For sticky directories, only the owner and
-	 * privileged user can write attributes.
+	 * privileged users can write attributes.
 	 */
 	if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)) {
 		if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
-			return -EPERM;
+			return (mask & MAY_WRITE) ? -EPERM : -ENODATA;
 		if (S_ISDIR(inode->i_mode) && (inode->i_mode & S_ISVTX) &&
 		    (mask & MAY_WRITE) && !inode_owner_or_capable(inode))
 			return -EPERM;
_

Patches currently in -mm which might be from agruen@kernel.org are

linux-next.patch

