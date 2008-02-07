From: akpm@linux-foundation.org
Subject: - fs-use-hlist_unhashed.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:57 -0800
Message-ID: <200802070022.m170McBq006448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50813 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765108AbYBGAoH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs: use hlist_unhashed
has been removed from the -mm tree.  Its filename was
     fs-use-hlist_unhashed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: use hlist_unhashed
From: Akinobu Mita <akinobu.mita@gmail.com>

Use hlist_unhashed() instead of opencoded equivalent.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/dcache.c~fs-use-hlist_unhashed fs/dcache.c
--- a/fs/dcache.c~fs-use-hlist_unhashed
+++ a/fs/dcache.c
@@ -89,7 +89,7 @@ static void d_free(struct dentry *dentry
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 	/* if dentry was never inserted into hash, immediate free is OK */
-	if (dentry->d_hash.pprev == NULL)
+	if (hlist_unhashed(&dentry->d_hash))
 		__d_free(dentry);
 	else
 		call_rcu(&dentry->d_u.d_rcu, d_callback);
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-dvb.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
