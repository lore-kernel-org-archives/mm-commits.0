From: akpm@linux-foundation.org
Subject: [patch 035/102] autofs: use autofs4_free_ino() to kfree dentry
 data
Date: Tue, 11 Oct 2016 13:52:42 -0700
Message-ID: <57fd511a.0wzNUZnvv55k0wc2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37886 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753146AbcJKUxF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kusumi.tomohiro@gmail.com, raven@themaw.net

From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: autofs: use autofs4_free_ino() to kfree dentry data

kfree dentry data allocated by autofs4_new_ino() with autofs4_free_ino()
instead of raw kfree.  (since we have the interface to free autofs_info*)

This patch was modified to remove the need to set the dentry info field to
NULL dew to a change in the previous patch.

Link: http://lkml.kernel.org/r/20160812024805.12352.43650.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/inode.c~autofs-use-autofs4_free_ino-to-kfree-dentry-data fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs-use-autofs4_free_ino-to-kfree-dentry-data
+++ a/fs/autofs4/inode.c
@@ -340,7 +340,7 @@ fail_dput:
 	dput(root);
 	goto fail_free;
 fail_ino:
-	kfree(ino);
+	autofs4_free_ino(ino);
 fail_free:
 	kfree(sbi);
 	s->s_fs_info = NULL;
_
