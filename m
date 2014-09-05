From: akpm@linux-foundation.org
Subject: + ufs-fix-deadlocks-introduced-by-sb-mutex-merge.patch added to
 -mm tree
Date: Fri, 05 Sep 2014 14:24:29 -0700
Message-ID: <540a2a0d.XeNULPV1h7GxMRE0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaIEVYa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2014 17:24:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khoroshilov@ispras.ru, dushistov@mail.ru, fabf@skynet.be, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ufs: fix deadlocks introduced by sb mutex merge
has been added to the -mm tree.  Its filename is
     ufs-fix-deadlocks-introduced-by-sb-mutex-merge.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ufs-fix-deadlocks-introduced-by-sb-mutex-merge.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ufs-fix-deadlocks-introduced-by-sb-mutex-merge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: ufs: fix deadlocks introduced by sb mutex merge

Commit 0244756edc4b ("ufs: sb mutex merge + mutex_destroy") introduces
deadlocks in ufs_new_inode() and ufs_free_inode().

Most callers of those functions acquire the mutex by themselves and
ufs_{new,free}_inode() do that via lock_ufs(), i.e we have an unavoidable
double lock.

The patch resolves the issue by making sure that ufs_{new,free}_inode()
are not called with the mutex held.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/inode.c |    7 ++-----
 fs/ufs/namei.c |   14 ++++++--------
 2 files changed, 8 insertions(+), 13 deletions(-)

diff -puN fs/ufs/inode.c~ufs-fix-deadlocks-introduced-by-sb-mutex-merge fs/ufs/inode.c
--- a/fs/ufs/inode.c~ufs-fix-deadlocks-introduced-by-sb-mutex-merge
+++ a/fs/ufs/inode.c
@@ -902,9 +902,6 @@ void ufs_evict_inode(struct inode * inod
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
-	if (want_delete) {
-		lock_ufs(inode->i_sb);
-		ufs_free_inode (inode);
-		unlock_ufs(inode->i_sb);
-	}
+	if (want_delete)
+		ufs_free_inode(inode);
 }
diff -puN fs/ufs/namei.c~ufs-fix-deadlocks-introduced-by-sb-mutex-merge fs/ufs/namei.c
--- a/fs/ufs/namei.c~ufs-fix-deadlocks-introduced-by-sb-mutex-merge
+++ a/fs/ufs/namei.c
@@ -126,12 +126,12 @@ static int ufs_symlink (struct inode * d
 	if (l > sb->s_blocksize)
 		goto out_notlocked;
 
-	lock_ufs(dir->i_sb);
 	inode = ufs_new_inode(dir, S_IFLNK | S_IRWXUGO);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
-		goto out;
+		goto out_notlocked;
 
+	lock_ufs(dir->i_sb);
 	if (l > UFS_SB(sb)->s_uspi->s_maxsymlinklen) {
 		/* slow symlink */
 		inode->i_op = &ufs_symlink_inode_operations;
@@ -181,13 +181,9 @@ static int ufs_mkdir(struct inode * dir,
 	struct inode * inode;
 	int err;
 
-	lock_ufs(dir->i_sb);
-	inode_inc_link_count(dir);
-
 	inode = ufs_new_inode(dir, S_IFDIR|mode);
-	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
-		goto out_dir;
+		return PTR_ERR(inode);
 
 	inode->i_op = &ufs_dir_inode_operations;
 	inode->i_fop = &ufs_dir_operations;
@@ -195,6 +191,9 @@ static int ufs_mkdir(struct inode * dir,
 
 	inode_inc_link_count(inode);
 
+	lock_ufs(dir->i_sb);
+	inode_inc_link_count(dir);
+
 	err = ufs_make_empty(inode, dir);
 	if (err)
 		goto out_fail;
@@ -212,7 +211,6 @@ out_fail:
 	inode_dec_link_count(inode);
 	inode_dec_link_count(inode);
 	iput (inode);
-out_dir:
 	inode_dec_link_count(dir);
 	unlock_ufs(dir->i_sb);
 	goto out;
_

Patches currently in -mm which might be from khoroshilov@ispras.ru are

ufs-fix-deadlocks-introduced-by-sb-mutex-merge.patch
linux-next.patch

