From: akpm@linux-foundation.org
Subject: + nilfs2-remove-inode-i_version-initialization.patch added to -mm tree
Date: Tue, 07 Nov 2017 12:12:28 -0800
Message-ID: <5a0213ac.d4KJN20NystgLyeG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56066 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932356AbdKGUM3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Nov 2017 15:12:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: remove inode->i_version initialization
has been added to the -mm tree.  Its filename is
     nilfs2-remove-inode-i_version-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-remove-inode-i_version-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-remove-inode-i_version-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from jlayton@redhat.com are

nilfs2-remove-inode-i_version-initialization.patch

