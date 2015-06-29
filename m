From: akpm@linux-foundation.org
Subject: [merged]
 minix-no-need-to-cast-alloction-return-value-in-minix.patch removed from
 -mm tree
Date: Mon, 29 Jun 2015 13:49:10 -0700
Message-ID: <5591af46.+li9bBNpNLk7BS+T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbbF2UtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:49:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: firogm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/minix: remove unneeded cast
has been removed from the -mm tree.  Its filename was
     minix-no-need-to-cast-alloction-return-value-in-minix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Firo Yang <firogm@gmail.com>
Subject: fs/minix: remove unneeded cast

kmem_cache_alloc() returns void*.

Signed-off-by: Firo Yang <firogm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/minix/inode.c~minix-no-need-to-cast-alloction-return-value-in-minix fs/minix/inode.c
--- a/fs/minix/inode.c~minix-no-need-to-cast-alloction-return-value-in-minix
+++ a/fs/minix/inode.c
@@ -62,7 +62,7 @@ static struct kmem_cache * minix_inode_c
 static struct inode *minix_alloc_inode(struct super_block *sb)
 {
 	struct minix_inode_info *ei;
-	ei = (struct minix_inode_info *)kmem_cache_alloc(minix_inode_cachep, GFP_KERNEL);
+	ei = kmem_cache_alloc(minix_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	return &ei->vfs_inode;
_

Patches currently in -mm which might be from firogm@gmail.com are

origin.patch
adfs-remove-unneeded-cast.patch
linux-next.patch

