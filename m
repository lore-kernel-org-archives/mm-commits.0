From: akpm@linux-foundation.org
Subject: + autofs4-fix-compilation-warning.patch added to -mm tree
Date: Mon, 13 Sep 2010 15:48:45 -0700
Message-ID: <201009132248.o8DMmjNF025710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751708Ab0IMWsu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Sep 2010 18:48:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: felipe.contreras@gmail.com, raven@themaw.net


The patch titled
     ] autofs4: fix compilation warning
has been added to the -mm tree.  Its filename is
     autofs4-fix-compilation-warning.patch

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
Subject: ] autofs4: fix compilation warning
From: Felipe Contreras <felipe.contreras@gmail.com>

fs/autofs4/root.c:31: warning: `autofs4_root_compat_ioctl' declared `static' but never defined

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/autofs4/root.c~autofs4-fix-compilation-warning fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-fix-compilation-warning
+++ a/fs/autofs4/root.c
@@ -28,7 +28,9 @@ static int autofs4_dir_unlink(struct ino
 static int autofs4_dir_rmdir(struct inode *,struct dentry *);
 static int autofs4_dir_mkdir(struct inode *,struct dentry *,int);
 static long autofs4_root_ioctl(struct file *,unsigned int,unsigned long);
+#ifdef CONFIG_COMPAT
 static long autofs4_root_compat_ioctl(struct file *,unsigned int,unsigned long);
+#endif
 static int autofs4_dir_open(struct inode *inode, struct file *file);
 static struct dentry *autofs4_lookup(struct inode *,struct dentry *, struct nameidata *);
 static void *autofs4_follow_link(struct dentry *, struct nameidata *);
_

Patches currently in -mm which might be from felipe.contreras@gmail.com are

autofs4-fix-compilation-warning.patch

