From: akpm@linux-foundation.org
Subject: - reiserfs-fix-build-breakage.patch removed from -mm tree
Date: Mon, 30 Mar 2009 14:17:33 -0700
Message-ID: <200903302117.n2ULHXTB021042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752056AbZC3VUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 17:20:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.beregalov@gmail.com, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: fix build breakage
has been removed from the -mm tree.  Its filename was
     reiserfs-fix-build-breakage.patch

This patch was dropped because i don't have those changes yet...

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: fix build breakage
From: Alexander Beregalov <a.beregalov@gmail.com>

fs/reiserfs/inode.c: In function 'reiserfs_new_inode':
fs/reiserfs/inode.c:1919: warning: passing argument 1 of
'reiserfs_inherit_default_acl' from incompatible pointer type
fs/reiserfs/inode.c:1919: warning: passing argument 2 of
'reiserfs_inherit_default_acl' from incompatible pointer type
fs/reiserfs/inode.c:1919: warning: passing argument 3 of
'reiserfs_inherit_default_acl' from incompatible pointer type
fs/reiserfs/inode.c:1919: error: too many arguments to function
'reiserfs_inherit_default_acl'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/reiserfs_acl.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/reiserfs_acl.h~reiserfs-fix-build-breakage include/linux/reiserfs_acl.h
--- a/include/linux/reiserfs_acl.h~reiserfs-fix-build-breakage
+++ a/include/linux/reiserfs_acl.h
@@ -91,7 +91,8 @@ static inline int reiserfs_acl_chmod(str
 }
 
 static inline int
-reiserfs_inherit_default_acl(const struct inode *dir, struct dentry *dentry,
+reiserfs_inherit_default_acl(struct reiserfs_transaction_handle *th,
+			     const struct inode *dir, struct dentry *dentry,
 			     struct inode *inode)
 {
 	return 0;
_

Patches currently in -mm which might be from a.beregalov@gmail.com are

origin.patch
reiserfs-fix-build-breakage.patch
linux-next.patch

