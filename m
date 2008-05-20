From: akpm@linux-foundation.org
Subject: + vfs-fix-err_ptr-abuse-in-generic_readlink.patch added to -mm tree
Date: Tue, 20 May 2008 00:36:02 -0700
Message-ID: <200805200736.m4K7a2Ek011228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56629 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754762AbYETHgX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 03:36:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, hch@lst.de, miklos@szeredi.hu, viro@ZenIV.linux.org.uk


The patch titled
     vfs: fix ERR_PTR abuse in generic_readlink
has been added to the -mm tree.  Its filename is
     vfs-fix-err_ptr-abuse-in-generic_readlink.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Miklos Szeredi <miklos@szeredi.hu>
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

linux-next.patch
drm-radeon-radeon_enable_vblank-should-return-negative-error.patch
net-s2io-set_rxd_buffer_pointer-returns-enomem-not-enomem.patch
vfs-fix-err_ptr-abuse-in-generic_readlink.patch
ntfs-le_add_cpu-conversion.patch

