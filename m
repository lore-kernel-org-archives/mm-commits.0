From: akpm@linux-foundation.org
Subject: + romfs-fix-returm-err-while-getting-inode-in-fill_super.patch
 added to -mm tree
Date: Mon, 16 Dec 2013 11:55:57 -0800
Message-ID: <52af5acd.qHv+FQna/P+GIaYG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab3LPT4G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:56:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rui.xiang@huawei.com

Subject: + romfs-fix-returm-err-while-getting-inode-in-fill_super.patch added to -mm tree
To: rui.xiang@huawei.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:57 -0800


The patch titled
     Subject: romfs: fix returm err while getting inode in fill_super
has been added to the -mm tree.  Its filename is
     romfs-fix-returm-err-while-getting-inode-in-fill_super.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/romfs-fix-returm-err-while-getting-inode-in-fill_super.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/romfs-fix-returm-err-while-getting-inode-in-fill_super.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rui Xiang <rui.xiang@huawei.com>
Subject: romfs: fix returm err while getting inode in fill_super

Getting an inode by romfs_iget may lead to an err in fill_super, and the
err value should be return.

And it should return -ENOMEM instead while d_make_root fails, fix it too.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/super.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/romfs/super.c~romfs-fix-returm-err-while-getting-inode-in-fill_super fs/romfs/super.c
--- a/fs/romfs/super.c~romfs-fix-returm-err-while-getting-inode-in-fill_super
+++ a/fs/romfs/super.c
@@ -533,16 +533,14 @@ static int romfs_fill_super(struct super
 
 	root = romfs_iget(sb, pos);
 	if (IS_ERR(root))
-		goto error;
+		return PTR_ERR(root);
 
 	sb->s_root = d_make_root(root);
 	if (!sb->s_root)
-		goto error;
+		return -ENOMEM;
 
 	return 0;
 
-error:
-	return -EINVAL;
 error_rsb_inval:
 	ret = -EINVAL;
 error_rsb:
_

Patches currently in -mm which might be from rui.xiang@huawei.com are

autofs-fix-the-return-value-of-autofs4_fill_super.patch
autofs-use-is_root-to-replace-root-dentry-checks.patch
proc-set-attributes-of-pde-using-accessor-functions.patch
romfs-fix-returm-err-while-getting-inode-in-fill_super.patch

