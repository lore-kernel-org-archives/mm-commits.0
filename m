From: akpm@linux-foundation.org
Subject: [merged] fs-romfs-correct-error-handling-code.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:37:14 -0700
Message-ID: <200909241937.n8OJbEec004155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754468AbZIXThd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:37:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     fs/romfs: correct error-handling code
has been removed from the -mm tree.  Its filename was
     fs-romfs-correct-error-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/romfs: correct error-handling code
From: Julia Lawall <julia@diku.dk>

romfs_iget returns an ERR_PTR value in an error case instead of NULL.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@match exists@
expression x, E;
statement S1, S2;
@@

x = romfs_iget(...)
... when != x = E
(
*  if (x == NULL || ...) S1 else S2
|
*  if (x == NULL && ...) S1 else S2
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/romfs/super.c~fs-romfs-correct-error-handling-code fs/romfs/super.c
--- a/fs/romfs/super.c~fs-romfs-correct-error-handling-code
+++ a/fs/romfs/super.c
@@ -528,7 +528,7 @@ static int romfs_fill_super(struct super
 	pos = (ROMFH_SIZE + len + 1 + ROMFH_PAD) & ROMFH_MASK;
 
 	root = romfs_iget(sb, pos);
-	if (!root)
+	if (IS_ERR(root))
 		goto error;
 
 	sb->s_root = d_alloc_root(root);
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-md-introduce-missing-kfree.patch

