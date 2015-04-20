From: akpm@linux-foundation.org
Subject: [merged] hfs-incorrect-return-values.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:18:59 -0700
Message-ID: <55355123.Btm5TiuezXG7QiAL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbbDTTMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: csong84@gatech.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: incorrect return values
has been removed from the -mm tree.  Its filename was
     hfs-incorrect-return-values.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chengyu Song <csong84@gatech.edu>
Subject: hfs: incorrect return values

In case of memory allocation error, the return should be -ENOMEM, instead
of -ENOSPC.

Signed-off-by: Chengyu Song <csong84@gatech.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/hfs/dir.c~hfs-incorrect-return-values fs/hfs/dir.c
--- a/fs/hfs/dir.c~hfs-incorrect-return-values
+++ a/fs/hfs/dir.c
@@ -197,7 +197,7 @@ static int hfs_create(struct inode *dir,
 
 	inode = hfs_new_inode(dir, &dentry->d_name, mode);
 	if (!inode)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	res = hfs_cat_create(inode->i_ino, dir, &dentry->d_name, inode);
 	if (res) {
@@ -226,7 +226,7 @@ static int hfs_mkdir(struct inode *dir,
 
 	inode = hfs_new_inode(dir, &dentry->d_name, S_IFDIR | mode);
 	if (!inode)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	res = hfs_cat_create(inode->i_ino, dir, &dentry->d_name, inode);
 	if (res) {
_

Patches currently in -mm which might be from csong84@gatech.edu are

origin.patch
linux-next.patch

