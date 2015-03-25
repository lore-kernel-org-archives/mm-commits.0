From: akpm@linux-foundation.org
Subject: + hfsplus-incorrect-return-value.patch added to -mm tree
Date: Wed, 25 Mar 2015 14:44:40 -0700
Message-ID: <55132c48.TF3zbeNf1ZYh7Vph%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbbCYVol (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Mar 2015 17:44:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: csong84@gatech.edu, saproj@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: incorrect return value
has been added to the -mm tree.  Its filename is
     hfsplus-incorrect-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-incorrect-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-incorrect-return-value.patch

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
Subject: hfsplus: incorrect return value

In case of memory allocation error, the return should be -ENOMEM, instead
of -ENOSPC.

Signed-off-by: Chengyu Song <csong84@gatech.edu>
Reviewed-by: Sergei Antonov <saproj@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/hfsplus/dir.c~hfsplus-incorrect-return-value fs/hfsplus/dir.c
--- a/fs/hfsplus/dir.c~hfsplus-incorrect-return-value
+++ a/fs/hfsplus/dir.c
@@ -434,7 +434,7 @@ static int hfsplus_symlink(struct inode
 {
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(dir->i_sb);
 	struct inode *inode;
-	int res = -ENOSPC;
+	int res = -ENOMEM;
 
 	mutex_lock(&sbi->vh_mutex);
 	inode = hfsplus_new_inode(dir->i_sb, S_IFLNK | S_IRWXUGO);
@@ -476,7 +476,7 @@ static int hfsplus_mknod(struct inode *d
 {
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(dir->i_sb);
 	struct inode *inode;
-	int res = -ENOSPC;
+	int res = -ENOMEM;
 
 	mutex_lock(&sbi->vh_mutex);
 	inode = hfsplus_new_inode(dir->i_sb, mode);
_

Patches currently in -mm which might be from csong84@gatech.edu are

ocfs2-incorrect-check-for-debugfs-returns.patch
hfsplus-incorrect-return-value.patch

