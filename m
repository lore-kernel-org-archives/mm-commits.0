From: akpm@linux-foundation.org
Subject: - fs-smbfs-inodec-fix-warning-message-deprecating-smbfs.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:23:01 -0500
Message-ID: <200802150226.m1F2QKoe015216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42029 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758394AbYBOC1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:27:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergio@uece.br, akpm@linux-foundation.org, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fs/smbfs/inode.c: fix warning message deprecating smbfs
has been removed from the -mm tree.  Its filename was
     fs-smbfs-inodec-fix-warning-message-deprecating-smbfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/smbfs/inode.c: fix warning message deprecating smbfs
From: Sergio Luis <sergio@uece.br>

Fix the warning message regarding smbfs to

"smbfs is deprecated and will be removed from the 2.6.27 kernel. Please migrate to cifs"

instead of

"smbfs is deprecated and will be removedfrom the 2.6.27 kernel.  Please migrate to cifs"

Signed-off-by: Sergio Luis <sergio@uece.br>
Screwed-up-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/smbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/smbfs/inode.c~fs-smbfs-inodec-fix-warning-message-deprecating-smbfs fs/smbfs/inode.c
--- a/fs/smbfs/inode.c~fs-smbfs-inodec-fix-warning-message-deprecating-smbfs
+++ a/fs/smbfs/inode.c
@@ -505,7 +505,7 @@ static int smb_fill_super(struct super_b
 	if (warn_count < 5) {
 		warn_count++;
 		printk(KERN_EMERG "smbfs is deprecated and will be removed"
-			"from the 2.6.27 kernel.  Please migrate to cifs\n");
+			" from the 2.6.27 kernel. Please migrate to cifs\n");
 	}
 
 	if (!raw_data)
_

Patches currently in -mm which might be from sergio@uece.br are

origin.patch
git-net.patch
