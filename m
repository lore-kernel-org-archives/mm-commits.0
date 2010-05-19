From: akpm@linux-foundation.org
Subject: [merged] nameic-update-mnt-when-it-needed.patch removed from -mm tree
Date: Wed, 19 May 2010 10:31:35 -0400
Message-ID: <201005191733.o4JHX1el025787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57831 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754337Ab0ESRdE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 13:33:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shijie8@gmail.com, viro@zeniv.linux.org.uk, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     namei.c: update mnt when it is needed
has been removed from the -mm tree.  Its filename was
     nameic-update-mnt-when-it-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: namei.c: update mnt when it is needed
From: Huang Shijie <shijie8@gmail.com>

Update the mnt of the path when it is not equal to the new one.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/namei.c~nameic-update-mnt-when-it-needed fs/namei.c
--- a/fs/namei.c~nameic-update-mnt-when-it-needed
+++ a/fs/namei.c
@@ -523,9 +523,10 @@ static void path_put_conditional(struct 
 static inline void path_to_nameidata(struct path *path, struct nameidata *nd)
 {
 	dput(nd->path.dentry);
-	if (nd->path.mnt != path->mnt)
+	if (nd->path.mnt != path->mnt) {
 		mntput(nd->path.mnt);
-	nd->path.mnt = path->mnt;
+		nd->path.mnt = path->mnt;
+	}
 	nd->path.dentry = path->dentry;
 }
 
_

Patches currently in -mm which might be from shijie8@gmail.com are

linux-next.patch
shmem-remove-redundant-code.patch
readaheadc-fix-comment.patch

