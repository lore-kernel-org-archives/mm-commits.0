From: akpm@linux-foundation.org
Subject: - autofs4-fix-var-shadowed-by-local-delaration.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:42 -0800
Message-ID: <200901072218.n07MIgkO018152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932370AbZAGWcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:32:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: fix var shadowed by local delaration
has been removed from the -mm tree.  Its filename was
     autofs4-fix-var-shadowed-by-local-delaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

