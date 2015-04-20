From: akpm@linux-foundation.org
Subject: [merged] hfsplus-incorrect-return-value.patch removed from -mm
 tree
Date: Mon, 20 Apr 2015 12:19:14 -0700
Message-ID: <55355132.+MDwuujSq89x9ofF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbbDTTMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: csong84@gatech.edu, saproj@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hfsplus: incorrect return value
has been removed from the -mm tree.  Its filename was
     hfsplus-incorrect-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

