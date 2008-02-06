From: akpm@linux-foundation.org
Subject: - autofs4-reinstate-negatitive-timeout-of-mount-fails-fix.patch removed from -mm tree
Date: Tue, 05 Feb 2008 23:10:35 -0800
Message-ID: <200802060710.m167AGQq031092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35403 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756342AbYBFHKX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 02:10:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4-reinstate-negatitive-timeout-of-mount-fails fix
has been removed from the -mm tree.  Its filename was
     autofs4-reinstate-negatitive-timeout-of-mount-fails-fix.patch

This patch was dropped because it was folded into autofs4-reinstate-negatitive-timeout-of-mount-fails.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4-reinstate-negatitive-timeout-of-mount-fails fix
From: Ian Kent <raven@themaw.net>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/inode.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN fs/autofs4/inode.c~autofs4-reinstate-negatitive-timeout-of-mount-fails-fix fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~autofs4-reinstate-negatitive-timeout-of-mount-fails-fix
+++ a/fs/autofs4/inode.c
@@ -108,9 +108,7 @@ static void autofs4_force_release(struct
 	spin_lock(&sbi->rehash_lock);
 	list_for_each_safe(p, next, &sbi->rehash_list) {
 		struct autofs_info *ino;
-		struct dentry *dentry;
 		ino = list_entry(p, struct autofs_info, rehash);
-		dentry = ino->dentry;
 		spin_unlock(&sbi->rehash_lock);
 		dput(ino->dentry);
 		spin_lock(&sbi->rehash_lock);
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-reinstate-negatitive-timeout-of-mount-fails.patch
autofs4-reinstate-negatitive-timeout-of-mount-fails-fix.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
mount-options-fix-autofs4.patch
