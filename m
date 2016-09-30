From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-remove-unused-have_submounts-function.patch
 removed from -mm tree
Date: Fri, 30 Sep 2016 11:38:52 -0700
Message-ID: <57eeb13c.JCVuT5ZhDumi4K5m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41131 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932348AbcI3Six (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Sep 2016 14:38:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, ebiederm@xmission.com, osandov@osandov.com, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: remove unused have_submounts() function
has been removed from the -mm tree.  Its filename was
     fs-remove-unused-have_submounts-function.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: fs: remove unused have_submounts() function

Having added the have_local_submounts() function there are no remaining
users of have_submounts() so remove it.

Link: http://lkml.kernel.org/r/20160914061450.24714.99912.stgit@pluto.themaw.net
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c            |   33 ---------------------------------
 include/linux/dcache.h |    1 -
 2 files changed, 34 deletions(-)

diff -puN fs/dcache.c~fs-remove-unused-have_submounts-function fs/dcache.c
--- a/fs/dcache.c~fs-remove-unused-have_submounts-function
+++ a/fs/dcache.c
@@ -1279,39 +1279,6 @@ rename_retry:
  * list is non-empty and continue searching.
  */
 
-static enum d_walk_ret check_mount(void *data, struct dentry *dentry)
-{
-	int *ret = data;
-	if (d_mountpoint(dentry)) {
-		*ret = 1;
-		return D_WALK_QUIT;
-	}
-	return D_WALK_CONTINUE;
-}
-
-/**
- * have_submounts - check for mounts over a dentry
- * @parent: dentry to check.
- *
- * Return true if the parent or its subdirectories contain
- * a mount point
- */
-int have_submounts(struct dentry *parent)
-{
-	int ret = 0;
-
-	d_walk(parent, &ret, check_mount, NULL);
-
-	return ret;
-}
-EXPORT_SYMBOL(have_submounts);
-
-/*
- * Search for at least 1 mount point in the dentry's subdirs.
- * We descend to the next level whenever the d_subdirs
- * list is non-empty and continue searching.
- */
