From: akpm@linux-foundation.org
Subject: - vfs-fix-err_ptr-abuse-in-generic_readlink.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:47:33 -0700
Message-ID: <200807020747.m627lXE8005657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbYGBH4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:56:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, hch@lst.de, miklos@szeredi.hu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: fix ERR_PTR abuse in generic_readlink
has been removed from the -mm tree.  Its filename was
     vfs-fix-err_ptr-abuse-in-generic_readlink.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: fix ERR_PTR abuse in generic_readlink
From: Marcin Slusarz <marcin.slusarz@gmail.com>

generic_readlink calls ERR_PTR for negative and positive values
(vfs_readlink returns length of "link"), but it should not
(not an errno) and does not need to.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Acked-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN fs/namei.c~vfs-fix-err_ptr-abuse-in-generic_readlink fs/namei.c
--- a/fs/namei.c~vfs-fix-err_ptr-abuse-in-generic_readlink
+++ a/fs/namei.c
@@ -2857,16 +2857,17 @@ int generic_readlink(struct dentry *dent
 {
 	struct nameidata nd;
 	void *cookie;
+	int res;
 
 	nd.depth = 0;
 	cookie = dentry->d_inode->i_op->follow_link(dentry, &nd);
-	if (!IS_ERR(cookie)) {
-		int res = vfs_readlink(dentry, buffer, buflen, nd_get_link(&nd));
-		if (dentry->d_inode->i_op->put_link)
-			dentry->d_inode->i_op->put_link(dentry, &nd, cookie);
-		cookie = ERR_PTR(res);
-	}
-	return PTR_ERR(cookie);
+	if (IS_ERR(cookie))
+		return PTR_ERR(cookie);
+
+	res = vfs_readlink(dentry, buffer, buflen, nd_get_link(&nd));
+	if (dentry->d_inode->i_op->put_link)
+		dentry->d_inode->i_op->put_link(dentry, &nd, cookie);
+	return res;
 }
 
 int vfs_follow_link(struct nameidata *nd, const char *link)
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
linux-next.patch
usb-fix-possible-memory-leak-in-pxa27x_udc.patch

