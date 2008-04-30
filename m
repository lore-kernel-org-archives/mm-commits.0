From: akpm@linux-foundation.org
Subject: - vfs-remove-lives_below_in_same_fs.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:41:27 -0700
Message-ID: <200804300541.m3U5fRPf029056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760507AbYD3GMV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:12:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jblunck@suse.de, hch@lst.de, mszeredi@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: remove lives_below_in_same_fs()
has been removed from the -mm tree.  Its filename was
     vfs-remove-lives_below_in_same_fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: remove lives_below_in_same_fs()
From: Jan Blunck <jblunck@suse.de>

Remove lives_below_in_same_fs() since is_subdir() from fs/dcache.c is
providing the same functionality.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN fs/namespace.c~vfs-remove-lives_below_in_same_fs fs/namespace.c
--- a/fs/namespace.c~vfs-remove-lives_below_in_same_fs
+++ a/fs/namespace.c
@@ -1176,17 +1176,6 @@ static int mount_is_safe(struct nameidat
 #endif
 }
 
-static int lives_below_in_same_fs(struct dentry *d, struct dentry *dentry)
-{
-	while (1) {
-		if (d == dentry)
-			return 1;
-		if (d == NULL || d == d->d_parent)
-			return 0;
-		d = d->d_parent;
-	}
-}
