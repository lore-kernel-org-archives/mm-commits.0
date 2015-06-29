From: akpm@linux-foundation.org
Subject: [merged] reiserfs-avoid-pointless-casts-in-alloc-codes.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:49:17 -0700
Message-ID: <5591af4d.2aiZ0ZVkeg6sNo9A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51018 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbbF2UtR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:49:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: firogm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/reiserfs: remove unneeded cast
has been removed from the -mm tree.  Its filename was
     reiserfs-avoid-pointless-casts-in-alloc-codes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Firo Yang <firogm@gmail.com>
Subject: fs/reiserfs: remove unneeded cast

kmem_cache_alloc() returns void*.

Signed-off-by: Firo Yang <firogm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/reiserfs/super.c~reiserfs-avoid-pointless-casts-in-alloc-codes fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-avoid-pointless-casts-in-alloc-codes
+++ a/fs/reiserfs/super.c
@@ -588,8 +588,7 @@ static struct kmem_cache *reiserfs_inode
 static struct inode *reiserfs_alloc_inode(struct super_block *sb)
 {
 	struct reiserfs_inode_info *ei;
-	ei = (struct reiserfs_inode_info *)
-	    kmem_cache_alloc(reiserfs_inode_cachep, GFP_KERNEL);
+	ei = kmem_cache_alloc(reiserfs_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
 	atomic_set(&ei->openers, 0);
_

Patches currently in -mm which might be from firogm@gmail.com are

origin.patch
adfs-remove-unneeded-cast.patch
linux-next.patch

