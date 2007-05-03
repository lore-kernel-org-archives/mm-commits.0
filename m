From: akpm@linux-foundation.org
Subject: - reiserfs-suppress-lockdep-warning.patch removed from -mm tree
Date: Thu, 03 May 2007 12:30:14 -0700
Message-ID: <200705031930.l43JUEYs018174@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767866AbXECTdf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:33:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeffm@suse.de, adaplas@pol.net, stable@kernel.org, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     reiserfs: suppress lockdep warning
has been removed from the -mm tree.  Its filename was
     reiserfs-suppress-lockdep-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiserfs: suppress lockdep warning
From: Jeff Mahoney <jeffm@suse.de>

We're getting lockdep warnings due to a post-2.6.21-rc7 bugfix.

The xattr_sem can never be taken in the manner described. Internal inodes
are protected by I_PRIVATE.  Add the appropriate annotation.

Cc: <stable@kernel.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/xattr.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/reiserfs/xattr.c~reiserfs-suppress-lockdep-warning fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~reiserfs-suppress-lockdep-warning
+++ a/fs/reiserfs/xattr.c
@@ -68,7 +68,7 @@ static struct dentry *get_xa_root(struct
 	if (!privroot)
 		return ERR_PTR(-ENODATA);
 
-	mutex_lock(&privroot->d_inode->i_mutex);
+	mutex_lock_nested(&privroot->d_inode->i_mutex, I_MUTEX_XATTR);
 	if (REISERFS_SB(sb)->xattr_root) {
 		xaroot = dget(REISERFS_SB(sb)->xattr_root);
 		goto out;
_

Patches currently in -mm which might be from jeffm@suse.de are

origin.patch
