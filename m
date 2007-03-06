From: akpm@linux-foundation.org
Subject: - fix-quadratic-behavior-of-shrink_dcache_parent-update.patch removed from -mm tree
Date: Mon, 05 Mar 2007 16:58:21 -0800
Message-ID: <200703060058.l260wLFs006913@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43643 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbXCFA6b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 19:58:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miklos@szeredi.hu, mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fix-quadratic-behavior-of-shrink_dcache_parent update
has been removed from the -mm tree.  Its filename was
     fix-quadratic-behavior-of-shrink_dcache_parent-update.patch

This patch was dropped because it was folded into fix-quadratic-behavior-of-shrink_dcache_parent.patch

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

fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-quadratic-behavior-of-shrink_dcache_parent-update.patch
