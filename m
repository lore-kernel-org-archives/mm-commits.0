From: akpm@linux-foundation.org
Subject: [folded-merged]
 nilfs2-add-bmap-function-to-seek-a-valid-key-fix.patch removed from -mm
 tree
Date: Thu, 16 Apr 2015 12:07:32 -0700
Message-ID: <55300874.V58bffsRywbeQ5x/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbbDPTHd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 15:07:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2-add-bmap-function-to-seek-a-valid-key-fix
has been removed from the -mm tree.  Its filename was
     nilfs2-add-bmap-function-to-seek-a-valid-key-fix.patch

This patch was dropped because it was folded into nilfs2-add-bmap-function-to-seek-a-valid-key.patch

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2-add-bmap-function-to-seek-a-valid-key-fix


I've got a report from Dan Carpenter that this range check causes a
warning:

 fs/nilfs2/btree.c:1611 nilfs_btree_seek_key() warn: impossible condition '(start > (~0)) => (0-u64max > u64max)'

A range check was needed there in a wip patch, but we no longer need
it.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/nilfs2/btree.c~nilfs2-add-bmap-function-to-seek-a-valid-key-fix fs/nilfs2/btree.c
--- a/fs/nilfs2/btree.c~nilfs2-add-bmap-function-to-seek-a-valid-key-fix
+++ a/fs/nilfs2/btree.c
@@ -1608,9 +1608,6 @@ static int nilfs_btree_seek_key(const st
 	const int minlevel = NILFS_BTREE_LEVEL_NODE_MIN;
 	int ret;
 
-	if (start > NILFS_BTREE_KEY_MAX)
-		return -ENOENT;
