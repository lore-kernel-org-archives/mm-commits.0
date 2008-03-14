From: akpm@linux-foundation.org
Subject: + vfs-remove-lives_below_in_same_fs.patch added to -mm tree
Date: Fri, 14 Mar 2008 13:23:47 -0700
Message-ID: <200803142023.m2EKNldD017738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbYCNUYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 16:24:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, hch@lst.de, mszeredi@suse.cz, viro@zeniv.linux.org.uk


The patch titled
     vfs: remove lives_below_in_same_fs()
has been added to the -mm tree.  Its filename is
     vfs-remove-lives_below_in_same_fs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: remove lives_below_in_same_fs()
From: Jan Blunck <jblunck@suse.de>

Remove lives_below_in_same_fs() since is_subdir() from fs/dcache.c is
providing the same functionality.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN fs/namespace.c~vfs-remove-lives_below_in_same_fs fs/namespace.c
--- a/fs/namespace.c~vfs-remove-lives_below_in_same_fs
+++ a/fs/namespace.c
@@ -1137,17 +1137,6 @@ static int mount_is_safe(struct nameidat
 #endif
 }
 
-static int lives_below_in_same_fs(struct dentry *d, struct dentry *dentry)
-{
-	while (1) {
-		if (d == dentry)
-			return 1;
-		if (d == NULL || d == d->d_parent)
-			return 0;
-		d = d->d_parent;
-	}
-}
