From: akpm@linux-foundation.org
Subject: [merged] autofs-fix-autofs4_fill_super-error-exit-handling.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:23:41 -0700
Message-ID: <57fe8dbd.W4/MIBb3CyTv5oy6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33281 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755899AbcJLTYe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, kusumi.tomohiro@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: fix autofs4_fill_super() error exit handling
has been removed from the -mm tree.  Its filename was
     autofs-fix-autofs4_fill_super-error-exit-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs: fix autofs4_fill_super() error exit handling

Somewhere along the line the error handling gotos have become incorrect.

Link: http://lkml.kernel.org/r/20160812024749.12352.15100.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/autofs4/inode.c~autofs-fix-autofs4_fill_super-error-exit-handling fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs-fix-autofs4_fill_super-error-exit-handling
+++ a/fs/autofs4/inode.c
@@ -313,7 +313,7 @@ int autofs4_fill_super(struct super_bloc
 
 	if (!pipe) {
 		pr_err("could not open pipe file descriptor\n");
-		goto fail_dput;
+		goto fail_put_pid;
 	}
 	ret = autofs_prepare_pipe(pipe);
 	if (ret < 0)
@@ -334,14 +334,14 @@ int autofs4_fill_super(struct super_bloc
 fail_fput:
 	pr_err("pipe file descriptor does not contain proper ops\n");
 	fput(pipe);
-	/* fall through */
+fail_put_pid:
+	put_pid(sbi->oz_pgrp);
 fail_dput:
 	dput(root);
 	goto fail_free;
 fail_ino:
 	kfree(ino);
 fail_free:
-	put_pid(sbi->oz_pgrp);
 	kfree(sbi);
 	s->s_fs_info = NULL;
 	return ret;
_

Patches currently in -mm which might be from raven@themaw.net are


