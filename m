From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-minix-check-return-value-of-sb_getblk.patch added to
 -mm tree
Date: Tue, 07 Jul 2020 12:25:20 -0700
Message-ID: <20200707192520.xzI6h4lyD%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbgGGTZW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Jul 2020 15:25:22 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anenbupt@gmail.com, ebiggers@google.com, mm-commits@vger.kernel.org, stable@vger.kernel.org, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/minix: check return value of sb_getblk()
has been added to the -mm tree.  Its filename is
     fs-minix-check-return-value-of-sb_getblk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-minix-check-return-value-of-sb_getblk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-minix-check-return-value-of-sb_getblk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: fs/minix: check return value of sb_getblk()

Patch series "fs/minix: fix syzbot bugs and set s_maxbytes".

This series fixes all syzbot bugs in the minix filesystem:

	KASAN: null-ptr-deref Write in get_block
	KASAN: use-after-free Write in get_block
	KASAN: use-after-free Read in get_block
	WARNING in inc_nlink
	KMSAN: uninit-value in get_block
	WARNING in drop_nlink

It also fixes the minix filesystem to set s_maxbytes correctly, so that
userspace sees the correct behavior when exceeding the max file size.


This patch (of 6):

sb_getblk() can fail, so check its return value.

This fixes a NULL pointer dereference.

Originally from Qiujun Huang.

Link: http://lkml.kernel.org/r/20200628060846.682158-1-ebiggers@kernel.org
Link: http://lkml.kernel.org/r/20200628060846.682158-2-ebiggers@kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reported-by: syzbot+4a88b2b9dc280f47baf4@syzkaller.appspotmail.com
Cc: Qiujun Huang <anenbupt@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/itree_common.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/minix/itree_common.c~fs-minix-check-return-value-of-sb_getblk
+++ a/fs/minix/itree_common.c
@@ -75,6 +75,7 @@ static int alloc_branch(struct inode *in
 	int n = 0;
 	int i;
 	int parent = minix_new_block(inode);
+	int err = -ENOSPC;
 
 	branch[0].key = cpu_to_block(parent);
 	if (parent) for (n = 1; n < num; n++) {
@@ -85,6 +86,11 @@ static int alloc_branch(struct inode *in
 			break;
 		branch[n].key = cpu_to_block(nr);
 		bh = sb_getblk(inode->i_sb, parent);
+		if (!bh) {
+			minix_free_block(inode, nr);
+			err = -ENOMEM;
+			break;
+		}
 		lock_buffer(bh);
 		memset(bh->b_data, 0, bh->b_size);
 		branch[n].bh = bh;
@@ -103,7 +109,7 @@ static int alloc_branch(struct inode *in
 		bforget(branch[i].bh);
 	for (i = 0; i < n; i++)
 		minix_free_block(inode, block_to_cpu(branch[i].key));
-	return -ENOSPC;
+	return err;
 }
 
 static inline int splice_branch(struct inode *inode,
_

Patches currently in -mm which might be from ebiggers@google.com are

fs-minix-check-return-value-of-sb_getblk.patch
fs-minix-dont-allow-getting-deleted-inodes.patch
fs-minix-reject-too-large-maximum-file-size.patch
fs-minix-set-s_maxbytes-correctly.patch
fs-minix-fix-block-limit-check-for-v1-filesystems.patch
fs-minix-remove-expected-error-message-in-block_to_path.patch
