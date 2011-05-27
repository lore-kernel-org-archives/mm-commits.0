From: akpm@linux-foundation.org
Subject: + xattr-fix-error-results-for-non-existent-invisible-attributes.patch added to -mm tree
Date: Fri, 27 May 2011 15:30:06 -0700
Message-ID: <201105272230.p4RMU6AT025227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753396Ab1E0Wa2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 18:30:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agruen@kernel.org, eparis@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     xattr: fix error results for non-existent / invisible attributes
has been added to the -mm tree.  Its filename is
     xattr-fix-error-results-for-non-existent-invisible-attributes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

block-improve-the-bio_add_page-and-bio_add_pc_page-descriptions.patch
xattr-fix-error-results-for-non-existent-invisible-attributes.patch

