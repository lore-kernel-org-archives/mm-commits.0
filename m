From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 fat-fix-uninit-memory-access-for-partial-initialized-inode.patch added to
 -mm tree
Date: Sun, 23 Feb 2020 19:53:13 -0800
Message-ID: <20200224035313.g57L75EAv%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727166AbgBXDxQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 23 Feb 2020 22:53:16 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org, stable@vger.kernel.org


The patch titled
     Subject: fat: fix uninit-memory access for partial initialized inode
has been added to the -mm tree.  Its filename is
     fat-fix-uninit-memory-access-for-partial-initialized-inode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-fix-uninit-memory-access-for-partial-initialized-inode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-fix-uninit-memory-access-for-partial-initialized-inode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
