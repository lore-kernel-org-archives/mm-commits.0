From: akpm@linux-foundation.org
Subject: + devpts-remove-module-related-code.patch added to -mm tree
Date: Tue, 23 Jun 2009 14:08:38 -0700
Message-ID: <200906232108.n5NL8cib008367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754449AbZFWVIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 17:08:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hpa@zytor.com, viro@zeniv.linux.org.uk


The patch titled
     devpts: remove module-related code
has been added to the -mm tree.  Its filename is
     devpts-remove-module-related-code.patch

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
Subject: devpts: remove module-related code
From: "H. Peter Anvin" <hpa@zytor.com>

These days, the devpts filesystem is closely integrated with the pty
memory management, and cannot be built as a module, even less removed from
the kernel.  Accordingly, remove all module-related stuff from this
filesystem.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN fs/devpts/inode.c~devpts-remove-module-related-code fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-remove-module-related-code
+++ a/fs/devpts/inode.c
@@ -10,7 +10,6 @@
  *
  * ------------------------------------------------------------------------- */
 
-#include <linux/module.h>
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/sched.h>
@@ -423,7 +422,6 @@ static void devpts_kill_sb(struct super_
 }
 
 static struct file_system_type devpts_fs_type = {
-	.owner		= THIS_MODULE,
 	.name		= "devpts",
 	.get_sb		= devpts_get_sb,
 	.kill_sb	= devpts_kill_sb,
@@ -564,13 +562,3 @@ static int __init init_devpts_fs(void)
 	}
 	return err;
 }
-
-static void __exit exit_devpts_fs(void)
-{
-	unregister_filesystem(&devpts_fs_type);
-	mntput(devpts_mnt);
-}
