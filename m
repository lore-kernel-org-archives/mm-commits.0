From: akpm@linux-foundation.org
Subject: [merged] efs-remove-unneeded-cast.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:49:03 -0700
Message-ID: <5591af3f.ULO/+w12Zvh3E+cj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbbF2UtD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:49:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: firogm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/efs: femove unneeded cast
has been removed from the -mm tree.  Its filename was
     efs-remove-unneeded-cast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Firo Yang <firogm@gmail.com>
Subject: fs/efs: femove unneeded cast

kmem_cache_alloc() returns void*.

Signed-off-by: Firo Yang <firogm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/efs/super.c~efs-remove-unneeded-cast fs/efs/super.c
--- a/fs/efs/super.c~efs-remove-unneeded-cast
+++ a/fs/efs/super.c
@@ -67,7 +67,7 @@ static struct kmem_cache * efs_inode_cac
 static struct inode *efs_alloc_inode(struct super_block *sb)
 {
 	struct efs_inode_info *ei;
-	ei = (struct efs_inode_info *)kmem_cache_alloc(efs_inode_cachep, GFP_KERNEL);
+	ei = kmem_cache_alloc(efs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
_

Patches currently in -mm which might be from firogm@gmail.com are

origin.patch
adfs-remove-unneeded-cast.patch
linux-next.patch

