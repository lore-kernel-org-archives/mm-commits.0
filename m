From: akpm@linux-foundation.org
Subject: - fat-kill-d_invalidate-in-vfat_lookup.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:33:29 -0800
Message-ID: <200811102033.mAAKXTms024530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438AbYKJUeD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:34:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     fat: Kill d_invalidate() in vfat_lookup()
has been removed from the -mm tree.  Its filename was
     fat-kill-d_invalidate-in-vfat_lookup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fat: Kill d_invalidate() in vfat_lookup()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

d_invalidate() for positive dentry doesn't work in some cases
(vfsmount, nfsd, and maybe others). shrink_dcache_parent() by
d_invalidate() is pointless for vfat usage at all.

So, this kills it, and intead of it uses d_move().

To save old behavior, this returns alias simply for directory (don't
change pwd, etc..). the directory lookup shouldn't be important for
performance.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_vfat.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN fs/fat/namei_vfat.c~fat-kill-d_invalidate-in-vfat_lookup fs/fat/namei_vfat.c
--- a/fs/fat/namei_vfat.c~fat-kill-d_invalidate-in-vfat_lookup
+++ a/fs/fat/namei_vfat.c
@@ -745,13 +745,12 @@ static struct dentry *vfat_lookup(struct
 		 *
 		 * Switch to new one for reason of locality if possible.
 		 */
-		if (d_invalidate(alias) == 0)
-			dput(alias);
-		else {
-			iput(inode);
-			unlock_super(sb);
-			return alias;
-		}
+		BUG_ON(d_unhashed(alias));
+		if (!S_ISDIR(inode->i_mode))
+			d_move(alias, dentry);
+		iput(inode);
+		unlock_super(sb);
+		return alias;
 	}
 out:
 	unlock_super(sb);
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch

