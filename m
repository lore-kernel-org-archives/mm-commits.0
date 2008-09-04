From: akpm@linux-foundation.org
Subject: + fs-gfs2-use-an-is_err-test-rather-than-a-null-test.patch added to -mm tree
Date: Thu, 04 Sep 2008 13:12:46 -0700
Message-ID: <200809042012.m84KCk2A028570@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107AbYIDUO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 16:14:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: brunel@diku.dk, julia@diku.dk, swhiteho@redhat.com


The patch titled
     fs/gfs2: use an IS_ERR test rather than a NULL test
has been added to the -mm tree.  Its filename is
     fs-gfs2-use-an-is_err-test-rather-than-a-null-test.patch

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

origin.patch
linux-next.patch
fs-gfs2-use-an-is_err-test-rather-than-a-null-test.patch
checkpatch-suppress-errors-triggered-by-short-patch.patch

