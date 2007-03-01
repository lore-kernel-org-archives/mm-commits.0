From: akpm@linux-foundation.org
Subject: + fix-quadratic-behavior-of-shrink_dcache_parent-update.patch added to -mm tree
Date: Wed, 28 Feb 2007 22:49:35 -0800
Message-ID: <200703010649.l216nZte006788@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57992 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711AbXCAGtp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 01:49:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miklos@szeredi.hu, mszeredi@suse.cz


The patch titled
     fix-quadratic-behavior-of-shrink_dcache_parent update
has been added to the -mm tree.  Its filename is
     fix-quadratic-behavior-of-shrink_dcache_parent-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix-quadratic-behavior-of-shrink_dcache_parent update
From: Miklos Szeredi <miklos@szeredi.hu>

 o dput already checks dentry == NULL, so remove check
   from prune_one_dentry()

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/dcache.c~fix-quadratic-behavior-of-shrink_dcache_parent-update fs/dcache.c
--- a/fs/dcache.c~fix-quadratic-behavior-of-shrink_dcache_parent-update
+++ a/fs/dcache.c
@@ -392,8 +392,7 @@ static void prune_one_dentry(struct dent
 	__d_drop(dentry);
 	dentry = d_kill(dentry);
 	if (!prune_parents) {
-		if (dentry)
-			dput(dentry);
+		dput(dentry);
 		spin_lock(&dcache_lock);
 		return;
 	}
_

Patches currently in -mm which might be from miklos@szeredi.hu are

fix-quadratic-behavior-of-shrink_dcache_parent-update.patch
