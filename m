From: akpm@linux-foundation.org
Subject: + autofs4-fix-var-shadowed-by-local-delaration.patch added to -mm tree
Date: Mon, 27 Oct 2008 22:00:42 -0700
Message-ID: <200810280500.m9S50g4w027202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbYJ1FBQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 01:01:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net


The patch titled
     autofs4: fix var shadowed by local delaration
has been added to the -mm tree.  Its filename is
     autofs4-fix-var-shadowed-by-local-delaration.patch

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
Subject: autofs4: fix var shadowed by local delaration
From: Ian Kent <raven@themaw.net>

A local definition of devid in autofs_dev_ioctl_ismountpoint() shadows
the fuction wide definition.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs4-fix-var-shadowed-by-local-delaration fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs4-fix-var-shadowed-by-local-delaration
+++ a/fs/autofs4/dev-ioctl.c
@@ -646,17 +646,17 @@ static int autofs_dev_ioctl_ismountpoint
 			magic = nd.path.dentry->d_inode->i_sb->s_magic;
 		}
 	} else {
-		dev_t devid = new_encode_dev(sbi->sb->s_dev);
+		dev_t dev = autofs4_get_dev(sbi);
 
 		err = path_lookup(path, LOOKUP_PARENT, &nd);
 		if (err)
 			goto out;
 
-		err = autofs_dev_ioctl_find_super(&nd, devid);
+		err = autofs_dev_ioctl_find_super(&nd, dev);
 		if (err)
 			goto out_release;
 
-		devid = autofs4_get_dev(sbi);
+		devid = dev;
 
 		err = have_submounts(nd.path.dentry);
 
_

Patches currently in -mm which might be from raven@themaw.net are

linux-next.patch
autofs4-correct-offset-mount-expire-check.patch
autofs4-collect-version-check-return.patch
autofs4-collect-version-check-return-checkpatch-fixes.patch
autofs4-improve-parameter-usage.patch
autofs4-fix-var-shadowed-by-local-delaration.patch

