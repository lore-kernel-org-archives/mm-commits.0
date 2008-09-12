From: akpm@linux-foundation.org
Subject: + fs-9p-use-an-is_err-test-rather-than-a-null-test.patch added to -mm tree
Date: Fri, 12 Sep 2008 14:59:31 -0700
Message-ID: <200809122159.m8CLxVDH006511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756560AbYILV7n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Sep 2008 17:59:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: brunel@diku.dk, ericvh@gmail.com, julia@diku.dk, lucho@ionkov.net, rminnich@sandia.gov


The patch titled
     fs/9p: use an IS_ERR test rather than a NULL test
has been added to the -mm tree.  Its filename is
     fs-9p-use-an-is_err-test-rather-than-a-null-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/9p: use an IS_ERR test rather than a NULL test
From: Julien Brunel <brunel@diku.dk>

In case of error, the function p9_client_walk returns an ERR pointer, but
never returns a NULL pointer.  So a NULL test that comes after an IS_ERR
test should be deleted.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@match_bad_null_test@
expression x, E;
statement S1,S2;
@@
x = p9_client_walk(...)
... when != x = E
*  if (x != NULL)
S1 else S2
// </smpl>

Signed-off-by: Julien Brunel <brunel@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/vfs_inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/9p/vfs_inode.c~fs-9p-use-an-is_err-test-rather-than-a-null-test fs/9p/vfs_inode.c
--- a/fs/9p/vfs_inode.c~fs-9p-use-an-is_err-test-rather-than-a-null-test
+++ a/fs/9p/vfs_inode.c
@@ -626,8 +626,7 @@ static struct dentry *v9fs_vfs_lookup(st
 	return NULL;
 
 error:
-	if (fid)
-		p9_client_clunk(fid);
+	p9_client_clunk(fid);
 
 	return ERR_PTR(result);
 }
_

Patches currently in -mm which might be from brunel@diku.dk are

origin.patch
linux-next.patch
fs-gfs2-use-an-is_err-test-rather-than-a-null-test.patch
drivers-usb-misc-use-an-is_err-test-rather-than-a-null-test.patch
fs-9p-use-an-is_err-test-rather-than-a-null-test.patch
checkpatch-suppress-errors-triggered-by-short-patch.patch
fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch

