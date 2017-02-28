From: akpm@linux-foundation.org
Subject: [merged] nilfs2-use-nilfs_btree_node_size.patch removed from -mm
 tree
Date: Tue, 28 Feb 2017 12:51:01 -0800
Message-ID: <58b5e2b5./HzXz3W1aa6DmEA6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52596 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751840AbdB1Uvf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: use nilfs_btree_node_size()
has been removed from the -mm tree.  Its filename was
     nilfs2-use-nilfs_btree_node_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: nilfs2: use nilfs_btree_node_size()

Use nilfs_btree_node_size() instead of open-coding.

Link: http://lkml.kernel.org/r/1485184655-3895-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/btree.c~nilfs2-use-nilfs_btree_node_size fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-use-nilfs_btree_node_size
+++ a/fs/nilfs2/btree.c
@@ -1870,7 +1870,7 @@ int nilfs_btree_convert_and_insert(struc
 		di = &dreq;
 		ni = NULL;
 	} else if ((n + 1) <= NILFS_BTREE_NODE_NCHILDREN_MAX(
-			   1 << btree->b_inode->i_blkbits)) {
+			   nilfs_btree_node_size(btree))) {
 		di = &dreq;
 		ni = &nreq;
 	} else {
_

Patches currently in -mm which might be from geliangtang@gmail.com are


