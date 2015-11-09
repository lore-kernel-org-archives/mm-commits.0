From: akpm@linux-foundation.org
Subject: [merged] nilfs2-drop-null-test-before-destroy-functions.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 12:12:56 -0800
Message-ID: <5640fe48.ocgKTsakCqgpwgJP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbKIUM4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:12:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: drop null test before destroy functions
has been removed from the -mm tree.  Its filename was
     nilfs2-drop-null-test-before-destroy-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: nilfs2: drop null test before destroy functions

Remove unneeded NULL test.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ expression x; @@
-if (x != NULL)
  \(kmem_cache_destroy\|mempool_destroy\|dma_pool_destroy\)(x);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN fs/nilfs2/super.c~nilfs2-drop-null-test-before-destroy-functions fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-drop-null-test-before-destroy-functions
+++ a/fs/nilfs2/super.c
@@ -1405,14 +1405,10 @@ static void nilfs_destroy_cachep(void)
 	 */
 	rcu_barrier();
 
-	if (nilfs_inode_cachep)
-		kmem_cache_destroy(nilfs_inode_cachep);
-	if (nilfs_transaction_cachep)
-		kmem_cache_destroy(nilfs_transaction_cachep);
-	if (nilfs_segbuf_cachep)
-		kmem_cache_destroy(nilfs_segbuf_cachep);
-	if (nilfs_btree_path_cache)
-		kmem_cache_destroy(nilfs_btree_path_cache);
+	kmem_cache_destroy(nilfs_inode_cachep);
+	kmem_cache_destroy(nilfs_transaction_cachep);
+	kmem_cache_destroy(nilfs_segbuf_cachep);
+	kmem_cache_destroy(nilfs_btree_path_cache);
 }
 
 static int __init nilfs_init_cachep(void)
_

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are


