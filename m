From: akpm@linux-foundation.org
Subject: [patch 39/78] nilfs2: use nilfs_btree_node_size()
Date: Mon, 27 Feb 2017 14:28:35 -0800
Message-ID: <58b4a813.rqg6z8juLLPvBjFk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45678 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751607AbdB0Wp1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:45:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, geliangtang@gmail.com, konishi.ryusuke@lab.ntt.co.jp

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
