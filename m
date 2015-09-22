From: akpm@linux-foundation.org
Subject: + nilfs2-drop-null-test-before-destroy-functions.patch added to
 -mm tree
Date: Tue, 22 Sep 2015 13:25:08 -0700
Message-ID: <5601b924.OuYzv2o7bslF9rJI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934337AbbIVUZJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Sep 2015 16:25:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: drop null test before destroy functions
has been added to the -mm tree.  Its filename is
     nilfs2-drop-null-test-before-destroy-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-drop-null-test-before-destroy-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-drop-null-test-before-destroy-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

nilfs2-drop-null-test-before-destroy-functions.patch

