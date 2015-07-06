From: akpm@linux-foundation.org
Subject: [merged] adfs-remove-unneeded-cast.patch removed from -mm tree
Date: Mon, 06 Jul 2015 12:46:52 -0700
Message-ID: <559adb2c.oVYSTwBU4OenW5qP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbbGFTqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:46:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: firogm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/adfs: remove unneeded cast
has been removed from the -mm tree.  Its filename was
     adfs-remove-unneeded-cast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Firo Yang <firogm@gmail.com>
Subject: fs/adfs: remove unneeded cast

kmem_cache_alloc() returns void*.

Signed-off-by: Firo Yang <firogm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/adfs/super.c~adfs-remove-unneeded-cast fs/adfs/super.c
--- a/fs/adfs/super.c~adfs-remove-unneeded-cast
+++ a/fs/adfs/super.c
@@ -242,7 +242,7 @@ static struct kmem_cache *adfs_inode_cac
 static struct inode *adfs_alloc_inode(struct super_block *sb)
 {
 	struct adfs_inode_info *ei;
-	ei = (struct adfs_inode_info *)kmem_cache_alloc(adfs_inode_cachep, GFP_KERNEL);
+	ei = kmem_cache_alloc(adfs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
_

Patches currently in -mm which might be from firogm@gmail.com are


