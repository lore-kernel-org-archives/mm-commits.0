From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-remove-is_rdonly-from-permission.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:33:47 -0800
Message-ID: <200702150833.l1F8XlLs024667@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39637 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965311AbXBOIhR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:37:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hansendc@us.ibm.com, haveblue@us.ibm.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: remove IS_RDONLY() from permission()
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-remove-is_rdonly-from-permission.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: r/o bind mounts: remove IS_RDONLY() from permission()
From: Dave Hansen <hansendc@us.ibm.com>

All callers of permission() should be updated now to use the
mnt_want/drop_write() functions.  It is now safe to remove this check.

We'll put a BUG_ON() in here for now just in case some user manages to get in
here by code that gets added in the future but forgets its
mnt_want/drop_write() pair.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/namei.c~r-o-bind-mounts-remove-is_rdonly-from-permission fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-remove-is_rdonly-from-permission
+++ a/fs/namei.c
@@ -231,13 +231,12 @@ int permission(struct inode *inode, int 
 	int retval, submask;
 
 	if (mask & MAY_WRITE) {
-
 		/*
-		 * Nobody gets write access to a read-only fs.
+		 * Nobody should have been able to get here with
+		 * a r/o filesystem.
 		 */
-		if (IS_RDONLY(inode) &&
-		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
-			return -EROFS;
+		BUG_ON(IS_RDONLY(inode) &&
+                       (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)));
 
 		/*
 		 * Nobody gets write access to an immutable file.
_

Patches currently in -mm which might be from hansendc@us.ibm.com are

r-o-bind-mounts-remove-is_rdonly-from-permission.patch
r-o-bind-mounts-reiser4-remove-is_rdonly-checks.patch
