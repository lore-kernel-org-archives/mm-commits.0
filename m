From: akpm@linux-foundation.org
Subject: + fs-use-hlist_unhashed.patch added to -mm tree
Date: Mon, 26 Nov 2007 00:03:21 -0800
Message-ID: <200711260803.lAQ83LLs023512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52164 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753214AbXKZID0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 03:03:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     fs: use hlist_unhashed
has been added to the -mm tree.  Its filename is
     fs-use-hlist_unhashed.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fs-use-hlist_unhashed.patch
power-use-kasprintf.patch
partitions-use-kasprintf.patch
