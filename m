From: akpm@linux-foundation.org
Subject: [folded-merged]
 nilfs2-fix-potential-memory-overrun-on-inode-fix.patch removed from -mm
 tree
Date: Fri, 27 Feb 2015 15:49:18 -0800
Message-ID: <54f1027e.pSXmtYUIAl6NjGh3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbbB0XtT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 18:49:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2-fix-potential-memory-overrun-on-inode-fix
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-potential-memory-overrun-on-inode-fix.patch

This patch was dropped because it was folded into nilfs2-fix-potential-memory-overrun-on-inode.patch

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2-fix-potential-memory-overrun-on-inode-fix

I've got a warning from 0day kernel testing backend:

    fs/nilfs2/btree.c: In function 'nilfs_btree_root_broken':
>> fs/nilfs2/btree.c:394:3: warning: format '%lu' expects argument of type 'long unsigned int', but argument 2 has type 'ino_t' [-Wformat=]
       pr_crit("NILFS: bad btree root (inode number=%lu): level = %d,
flags = 0x%x, nchildren = %d\n",
       ^

This is output for s390 arch since ino_t doesn't mean "unsigned long"
in s390.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nilfs2/btree.c~nilfs2-fix-potential-memory-overrun-on-inode-fix fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-fix-potential-memory-overrun-on-inode-fix
+++ a/fs/nilfs2/btree.c
@@ -378,7 +378,7 @@ static int nilfs_btree_node_broken(const
  * Return Value: If node is broken, 1 is returned. Otherwise, 0 is returned.
  */
 static int nilfs_btree_root_broken(const struct nilfs_btree_node *node,
-				   ino_t ino)
+				   unsigned long ino)
 {
 	int level, flags, nchildren;
 	int ret = 0;
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-fix-potential-memory-overrun-on-inode.patch

