From: akpm@linux-foundation.org
Subject: + minix-fix-regression-in-minix_mkdir.patch added to -mm tree
Date: Fri, 03 Sep 2010 16:44:24 -0700
Message-ID: <201009032344.o83NiOmV019535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753034Ab0ICXoj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Sep 2010 19:44:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jorge@dti2.net, dmonakhov@openvz.org, stable@kernel.org, viro@zeniv.linux.org.uk


The patch titled
     minix: fix regression in minix_mkdir()
has been added to the -mm tree.  Its filename is
     minix-fix-regression-in-minix_mkdir.patch

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
Subject: minix: fix regression in minix_mkdir()
From: "Jorge Boncompte [DTI2]" <jorge@dti2.net>

Commit 9eed1fb721c ("minix: replace inode uid,gid,mode init with helper")
broke directory creation on minix filesystems.

Fix it by passing the needed mode flag to inode init helper.

Signed-off-by: Jorge Boncompte [DTI2] <jorge@dti2.net>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@kernel.org>		[2.6.35.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/minix/namei.c~minix-fix-regression-in-minix_mkdir fs/minix/namei.c
--- a/fs/minix/namei.c~minix-fix-regression-in-minix_mkdir
+++ a/fs/minix/namei.c
@@ -115,7 +115,7 @@ static int minix_mkdir(struct inode * di
 
 	inode_inc_link_count(dir);
 
-	inode = minix_new_inode(dir, mode, &err);
+	inode = minix_new_inode(dir, S_IFDIR | mode, &err);
 	if (!inode)
 		goto out_dir;
 
_

Patches currently in -mm which might be from jorge@dti2.net are

minix-fix-regression-in-minix_mkdir.patch

