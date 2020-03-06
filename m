From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 4/7] fat: fix uninit-memory access for partial
 initialized inode
Date: Thu, 05 Mar 2020 22:28:36 -0800
Message-ID: <20200306062836.JsWi6MsBE%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbgCFG2h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Mar 2020 01:28:37 -0500
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp, linux-mm@kvack.org, mm-commits@vger.kernel.org, stable@vger.kernel.org, torvalds@linux-foundation.org

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: fat: fix uninit-memory access for partial initialized inode

When get an error in the middle of reading an inode, some fields in the
inode might be still not initialized.  And then the evict_inode path may
access those fields via iput().

To fix, this makes sure that inode fields are initialized.

Link: http://lkml.kernel.org/r/871rqnreqx.fsf@mail.parknet.co.jp
Reported-by: syzbot+9d82b8de2992579da5d0@syzkaller.appspotmail.com
Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/fs/fat/inode.c~fat-fix-uninit-memory-access-for-partial-initialized-inode
+++ a/fs/fat/inode.c
@@ -750,6 +750,13 @@ static struct inode *fat_alloc_inode(str
 		return NULL;
 
 	init_rwsem(&ei->truncate_lock);
+	/* Zeroing to allow iput() even if partial initialized inode. */
+	ei->mmu_private = 0;
+	ei->i_start = 0;
+	ei->i_logstart = 0;
+	ei->i_attrs = 0;
+	ei->i_pos = 0;
+
 	return &ei->vfs_inode;
 }
 
@@ -1374,16 +1381,6 @@ out:
 	return 0;
 }
 
-static void fat_dummy_inode_init(struct inode *inode)
-{
-	/* Initialize this dummy inode to work as no-op. */
-	MSDOS_I(inode)->mmu_private = 0;
-	MSDOS_I(inode)->i_start = 0;
-	MSDOS_I(inode)->i_logstart = 0;
-	MSDOS_I(inode)->i_attrs = 0;
-	MSDOS_I(inode)->i_pos = 0;
-}
