From: akpm@linux-foundation.org
Subject: + nameic-update-mnt-when-it-needed.patch added to -mm tree
Date: Fri, 16 Apr 2010 15:38:35 -0700
Message-ID: <201004162238.o3GMcZ3L030757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932649Ab0DPWih (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Apr 2010 18:38:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com, viro@zeniv.linux.org.uk, xiyou.wangcong@gmail.com


The patch titled
     namei.c: update mnt when it is needed
has been added to the -mm tree.  Its filename is
     nameic-update-mnt-when-it-needed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
nameic-update-mnt-when-it-needed.patch
shmem-remove-redundant-code.patch
readaheadc-fix-comment.patch

