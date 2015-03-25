From: akpm@linux-foundation.org
Subject: + hfs-incorrect-return-values.patch added to -mm tree
Date: Wed, 25 Mar 2015 14:45:33 -0700
Message-ID: <55132c7d.fYDtbr4kUiQOQJnI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbbCYVpd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 17:45:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: csong84@gatech.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: hfs: incorrect return values
has been added to the -mm tree.  Its filename is
     hfs-incorrect-return-values.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfs-incorrect-return-values.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfs-incorrect-return-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-incorrect-check-for-debugfs-returns.patch
hfs-incorrect-return-values.patch
hfsplus-incorrect-return-value.patch

