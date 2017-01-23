From: akpm@linux-foundation.org
Subject: + fs-affs-make-export-work-with-cold-dcache-fix.patch added to
 -mm tree
Date: Mon, 23 Jan 2017 15:51:19 -0800
Message-ID: <588696f7.BbzpMpDp0IscZi3+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47618 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750758AbdAWXvU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jan 2017 18:51:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyongjun1@huawei.com, fabf@skynet.be, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: fix return value check in affs_get_parent()
has been added to the -mm tree.  Its filename is
     fs-affs-make-export-work-with-cold-dcache-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-affs-make-export-work-with-cold-dcache-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-affs-make-export-work-with-cold-dcache-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: fs/affs: fix return value check in affs_get_parent()

In case of error, the function affs_bread() returns NULL pointer not
ERR_PTR().  The IS_ERR() test in the return value check should be replaced
with NULL test.

Fixes: e393e82a7d09 ("fs/affs: make export work with cold dcache")
Link: http://lkml.kernel.org/r/20170123141018.2331-1-weiyj.lk@gmail.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/namei.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/affs/namei.c~fs-affs-make-export-work-with-cold-dcache-fix fs/affs/namei.c
--- a/fs/affs/namei.c~fs-affs-make-export-work-with-cold-dcache-fix
+++ a/fs/affs/namei.c
@@ -453,8 +453,8 @@ static struct dentry *affs_get_parent(st
 	struct buffer_head *bh;
 
 	bh = affs_bread(child->d_sb, d_inode(child)->i_ino);
-	if (IS_ERR(bh))
-		return ERR_CAST(bh);
+	if (!bh)
+		return ERR_PTR(-EIO);
 
 	parent = affs_iget(child->d_sb,
 			   be32_to_cpu(AFFS_TAIL(child->d_sb, bh)->parent));
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are

fs-affs-make-export-work-with-cold-dcache-fix.patch

