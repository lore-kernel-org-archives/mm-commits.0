From: akpm@linux-foundation.org
Subject: [patch 032/102] autofs: fix autofs4_fill_super() error exit
 handling
Date: Tue, 11 Oct 2016 13:52:33 -0700
Message-ID: <57fd5111.p3yuyuVolg0CoC85%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37954 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753135AbcJKUxF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, raven@themaw.net, kusumi.tomohiro@gmail.com

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
