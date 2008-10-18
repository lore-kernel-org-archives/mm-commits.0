From: akpm@linux-foundation.org
Subject: - fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:18:43 -0700
Message-ID: <200810182318.m9INIh5j029325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069AbYJRXS6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:18:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brunel@diku.dk, jack@ucw.cz, jeffm@suse.com, julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     fs/reiserfs: use an IS_ERR test rather than a NULL test
has been removed from the -mm tree.  Its filename was
     fs-reiserfs-use-an-is_err-test-rather-than-a-null-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/reiserfs: use an IS_ERR test rather than a NULL test
From: Julien Brunel <brunel@diku.dk>

In case of error, the function open_xa_dir returns an ERR pointer, but
never returns a NULL pointer.  So a NULL test that comes after an IS_ERR
test should be deleted.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@match_bad_null_test@
expression x, E;
statement S1,S2;
@@
x = open_xa_dir(...)
... when != x = E
(
*  if (x == NULL && ...) S1 else S2
|
*  if (x == NULL || ...) S1 else S2
)
// </smpl>

Signed-off-by: Julien Brunel <brunel@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Jan Kara <jack@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/xattr.c~fs-reiserfs-use-an-is_err-test-rather-than-a-null-test fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~fs-reiserfs-use-an-is_err-test-rather-than-a-null-test
+++ a/fs/reiserfs/xattr.c
@@ -155,7 +155,7 @@ static struct dentry *get_xa_file_dentry
 	xadir = open_xa_dir(inode, flags);
 	if (IS_ERR(xadir)) {
 		return ERR_CAST(xadir);
-	} else if (xadir && !xadir->d_inode) {
+	} else if (!xadir->d_inode) {
 		dput(xadir);
 		return ERR_PTR(-ENODATA);
 	}
_

Patches currently in -mm which might be from brunel@diku.dk are

origin.patch

