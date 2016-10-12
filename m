From: akpm@linux-foundation.org
Subject: [merged] autofs-use-autofs4_free_ino-to-kfree-dentry-data.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:23:47 -0700
Message-ID: <57fe8dc3.Q4FfpVPBnNyqQJwQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33283 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755915AbcJLTYg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: use autofs4_free_ino() to kfree dentry data
has been removed from the -mm tree.  Its filename was
     autofs-use-autofs4_free_ino-to-kfree-dentry-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from kusumi.tomohiro@gmail.com are


