From: akpm@linux-foundation.org
Subject: + fs-inodec-add-dev-id-and-inode-number-for-debugging-in-init_special_inode.patch added to -mm tree
Date: Wed, 01 Apr 2009 14:50:58 -0700
Message-ID: <200904012150.n31LowaN031752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbZDAVxf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 17:53:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mkatiyar@gmail.com, adilger@sun.com, viro@zeniv.linux.org.uk


The patch titled
     fs/inode.c: add dev-id and inode number for debugging in init_special_inode()
has been added to the -mm tree.  Its filename is
     fs-inodec-add-dev-id-and-inode-number-for-debugging-in-init_special_inode.patch

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
Subject: fs/inode.c: add dev-id and inode number for debugging in init_special_inode()
From: Manish Katiyar <mkatiyar@gmail.com>

Add device-id and inode number for better debugging.  This was suggested
by Andreas in one of the threads
http://article.gmane.org/gmane.comp.file-systems.ext4/12062 .

"If anyone has a chance, fixing this error message to be not-useless would
be good...  Including the device name and the inode number would help
track down the source of the problem."

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/inode.c~fs-inodec-add-dev-id-and-inode-number-for-debugging-in-init_special_inode fs/inode.c
--- a/fs/inode.c~fs-inodec-add-dev-id-and-inode-number-for-debugging-in-init_special_inode
+++ a/fs/inode.c
@@ -1588,7 +1588,8 @@ void init_special_inode(struct inode *in
 	else if (S_ISSOCK(mode))
 		inode->i_fop = &bad_sock_fops;
 	else
-		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o)\n",
-		       mode);
+		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o) for"
+				  " inode %s:%lu\n", mode, inode->i_sb->s_id,
+				  inode->i_ino);
 }
 EXPORT_SYMBOL(init_special_inode);
_

Patches currently in -mm which might be from mkatiyar@gmail.com are

origin.patch
linux-next.patch
kernel-kallsymsc-replace-deprecated-__initcall-with-device_initcall-and-fix-whitespace.patch
fs-inodec-add-dev-id-and-inode-number-for-debugging-in-init_special_inode.patch

