From: akpm@osdl.org
Subject: + 9p-fix-rename-return-code.patch added to -mm tree
Date: Tue, 23 Jan 2007 23:13:41 -0800
Message-ID: <200701240713.l0O7DfwS011318@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55656 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965491AbXAXHNn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 02:13:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ericvh@gmail.com


The patch titled
     9p: fix rename return code
has been added to the -mm tree.  Its filename is
     9p-fix-rename-return-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: 9p: fix rename return code
From: Eric Van Hensbergen <ericvh@gmail.com>

9p doesn't handle renames between directories -- however, we were returning
EPERM instead of EXDEV when we detected this case.

Signed-off-by: Eric Van Hensbergren <ericvh@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/9p/vfs_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/9p/vfs_inode.c~9p-fix-rename-return-code fs/9p/vfs_inode.c
--- a/fs/9p/vfs_inode.c~9p-fix-rename-return-code
+++ a/fs/9p/vfs_inode.c
@@ -767,7 +767,7 @@ v9fs_vfs_rename(struct inode *old_dir, s
 	/* 9P can only handle file rename in the same directory */
 	if (memcmp(&olddirfid->qid, &newdirfid->qid, sizeof(newdirfid->qid))) {
 		dprintk(DEBUG_ERROR, "old dir and new dir are different\n");
-		retval = -EPERM;
+		retval = -EXDEV;
 		goto FreeFcallnBail;
 	}
 
_

Patches currently in -mm which might be from ericvh@gmail.com are

9p-fix-bogus-return-code-checks-during-initialization.patch
9p-fix-rename-return-code.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
