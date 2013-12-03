From: akpm@linux-foundation.org
Subject: + autofs-fix-the-return-value-of-autofs4_fill_super.patch added
 to -mm tree
Date: Tue, 03 Dec 2013 13:30:37 -0800
Message-ID: <529e4d7d.Q2EkL5sa0tXHKLET%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab3LCVai (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 16:30:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, raven@themaw.net, rui.xiang@huawei.com

Subject: + autofs-fix-the-return-value-of-autofs4_fill_super.patch added to -mm tree
To: rui.xiang@huawei.com,raven@themaw.net
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 13:30:37 -0800


The patch titled
     Subject: autofs: fix the return value of autofs4_fill_super
has been added to the -mm tree.  Its filename is
     autofs-fix-the-return-value-of-autofs4_fill_super.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-fix-the-return-value-of-autofs4_fill_super.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-fix-the-return-value-of-autofs4_fill_super.patch

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
Subject: autofs: fix the return value of autofs4_fill_super

While kzallocing sbi/ino fails, it should return -ENOMEM.

And it should return the err value from autofs_prepare_pipe.

Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/inode.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN fs/autofs4/inode.c~autofs-fix-the-return-value-of-autofs4_fill_super fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs-fix-the-return-value-of-autofs4_fill_super
+++ a/fs/autofs4/inode.c
@@ -212,10 +212,11 @@ int autofs4_fill_super(struct super_bloc
 	struct autofs_info *ino;
 	int pgrp;
 	bool pgrp_set = false;
+	int ret = -EINVAL;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
-		goto fail_unlock;
+		return -ENOMEM;
 	DPRINTK("starting up, sbi = %p",sbi);
 
 	s->s_fs_info = sbi;
@@ -249,8 +250,10 @@ int autofs4_fill_super(struct super_bloc
 	 * Get the root inode and dentry, but defer checking for errors.
 	 */
 	ino = autofs4_new_ino(sbi);
-	if (!ino)
+	if (!ino) {
+		ret = -ENOMEM;
 		goto fail_free;
+	}
 	root_inode = autofs4_get_inode(s, S_IFDIR | 0755);
 	root = d_make_root(root_inode);
 	if (!root)
@@ -308,7 +311,8 @@ int autofs4_fill_super(struct super_bloc
 		printk("autofs: could not open pipe file descriptor\n");
 		goto fail_dput;
 	}
-	if (autofs_prepare_pipe(pipe) < 0)
+	ret = autofs_prepare_pipe(pipe);
+	if (ret < 0)
 		goto fail_fput;
 	sbi->pipe = pipe;
 	sbi->pipefd = pipefd;
@@ -336,8 +340,7 @@ fail_free:
 	put_pid(sbi->oz_pgrp);
 	kfree(sbi);
 	s->s_fs_info = NULL;
-fail_unlock:
-	return -EINVAL;
+	return ret;
 }
 
 struct inode *autofs4_get_inode(struct super_block *sb, umode_t mode)
_

Patches currently in -mm which might be from rui.xiang@huawei.com are

autofs-fix-the-return-value-of-autofs4_fill_super.patch
autofs-use-is_root-to-replace-root-dentry-checks.patch

