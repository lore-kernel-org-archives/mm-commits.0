From: akpm@linux-foundation.org
Subject: + omfs-set-error-return-when-d_make_root-fails.patch added to -mm tree
Date: Tue, 19 May 2015 16:20:15 -0700
Message-ID: <555bc52f.N+OS5XaodvtUQ7Cx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbbESXUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 May 2015 19:20:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: me@bobcopeland.com, dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: omfs: set error return when d_make_root() fails
has been added to the -mm tree.  Its filename is
     omfs-set-error-return-when-d_make_root-fails.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/omfs-set-error-return-when-d_make_root-fails.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/omfs-set-error-return-when-d_make_root-fails.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bob Copeland <me@bobcopeland.com>
Subject: omfs: set error return when d_make_root() fails

A static checker found the following issue in the error path for
omfs_fill_super:

	fs/omfs/inode.c:552 omfs_fill_super()
	warn: missing error code here? 'd_make_root()' failed. 'ret' = '0'

Fix by returning -ENOMEM in this case.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/omfs/inode.c~omfs-set-error-return-when-d_make_root-fails fs/omfs/inode.c
--- a/fs/omfs/inode.c~omfs-set-error-return-when-d_make_root-fails
+++ a/fs/omfs/inode.c
@@ -549,8 +549,10 @@ static int omfs_fill_super(struct super_
 	}
 
 	sb->s_root = d_make_root(root);
-	if (!sb->s_root)
+	if (!sb->s_root) {
+		ret = -ENOMEM;
 		goto out_brelse_bh2;
+	}
 	printk(KERN_DEBUG "omfs: Mounted volume %s\n", omfs_rb->r_name);
 
 	ret = 0;
_

Patches currently in -mm which might be from me@bobcopeland.com are

fs-omfs-add-null-terminator-in-the-end-up-the-token-list.patch
omfs-set-error-return-when-d_make_root-fails.patch
omfs-fix-sign-confusion-for-bitmap-loop-counter.patch
omfs-fix-potential-integer-overflow-in-allocator.patch
linux-next.patch

