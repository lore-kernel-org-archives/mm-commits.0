From: akpm@linux-foundation.org
Subject: [patch 61/94] nilfs2: remove inode->i_version
 initialization
Date: Fri, 17 Nov 2017 15:29:50 -0800
Message-ID: <20171117232950.Sn22knNHj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55902 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965833AbdKQX3w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:29:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jlayton@redhat.com, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Jeff Layton <jlayton@redhat.com>
Subject: nilfs2: remove inode->i_version initialization

It's never used in nilfs2.

Link: http://lkml.kernel.org/r/1510064486-1728-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/nilfs2/super.c~nilfs2-remove-inode-i_version-initialization fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-remove-inode-i_version-initialization
+++ a/fs/nilfs2/super.c
@@ -160,7 +160,6 @@ struct inode *nilfs_alloc_inode(struct s
 	ii->i_bh = NULL;
 	ii->i_state = 0;
 	ii->i_cno = 0;
-	ii->vfs_inode.i_version = 1;
 	nilfs_mapping_init(&ii->i_btnode_cache, &ii->vfs_inode);
 	return &ii->vfs_inode;
 }
_
