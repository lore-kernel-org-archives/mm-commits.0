From: akpm@osdl.org
Subject: - fuse-minor-cleanup-in-fuse_dentry_revalidate.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:01:38 -0800
Message-ID: <200612072301.kB7N1cAp029781@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51627 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163769AbWLGXCI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:02:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     fuse: minor cleanup in fuse_dentry_revalidate
has been removed from the -mm tree.  Its filename was
     fuse-minor-cleanup-in-fuse_dentry_revalidate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fuse: minor cleanup in fuse_dentry_revalidate
From: Miklos Szeredi <miklos@szeredi.hu>

Remove unneeded code from fuse_dentry_revalidate().  This made some sense
while the validity time could wrap around, but now it's a very obvious no-op.

Signed-off-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/fuse/dir.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/fuse/dir.c~fuse-minor-cleanup-in-fuse_dentry_revalidate fs/fuse/dir.c
--- a/fs/fuse/dir.c~fuse-minor-cleanup-in-fuse_dentry_revalidate
+++ a/fs/fuse/dir.c
@@ -141,9 +141,6 @@ static int fuse_dentry_revalidate(struct
 		struct fuse_req *forget_req;
 		struct dentry *parent;
 
-		/* Doesn't hurt to "reset" the validity timeout */
-		fuse_invalidate_entry_cache(entry);
-
 		/* For negative dentries, always do a fresh lookup */
 		if (!inode)
 			return 0;
_

Patches currently in -mm which might be from miklos@szeredi.hu are

origin.patch

