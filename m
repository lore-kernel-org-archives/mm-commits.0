From: akpm@linux-foundation.org
Subject: - fs-gfs2-use-an-is_err-test-rather-than-a-null-test.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:45:41 -0700
Message-ID: <200809130745.m8D7jffL026785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754317AbYIMHqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:46:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brunel@diku.dk, julia@diku.dk, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fs/gfs2: use an IS_ERR test rather than a NULL test
has been removed from the -mm tree.  Its filename was
     fs-gfs2-use-an-is_err-test-rather-than-a-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/gfs2: use an IS_ERR test rather than a NULL test
From: Julien Brunel <brunel@diku.dk>

In case of error, the function gfs2_inode_lookup returns an
ERR pointer, but never returns a NULL pointer. So a NULL test that
necessarily comes after an IS_ERR test should be deleted, and a NULL
test that may come after a call to this function should be
strengthened by an IS_ERR test.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@match_bad_null_test@
expression x, E;
statement S1,S2;
@@
x = gfs2_inode_lookup(...)
... when != x = E
* if (x != NULL)
S1 else S2
// </smpl>

Signed-off-by: Julien Brunel <brunel@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/inode.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/gfs2/inode.c~fs-gfs2-use-an-is_err-test-rather-than-a-null-test fs/gfs2/inode.c
--- a/fs/gfs2/inode.c~fs-gfs2-use-an-is_err-test-rather-than-a-null-test
+++ a/fs/gfs2/inode.c
@@ -1033,13 +1033,11 @@ struct inode *gfs2_createi(struct gfs2_h
 
 	if (bh)
 		brelse(bh);
-	if (!inode)
-		return ERR_PTR(-ENOMEM);
 	return inode;
 
 fail_gunlock2:
 	gfs2_glock_dq_uninit(ghs + 1);
-	if (inode)
+	if (inode && !IS_ERR(inode))
 		iput(inode);
 fail_gunlock:
 	gfs2_glock_dq(ghs);
_

Patches currently in -mm which might be from brunel@diku.dk are

linux-next.patch
fs-9p-use-an-is_err-test-rather-than-a-null-test.patch
checkpatch-suppress-errors-triggered-by-short-patch.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch

