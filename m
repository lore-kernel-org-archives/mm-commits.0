From: akpm@linux-foundation.org
Subject: [merged] nfs-fix-oops-in-nfs_rename.patch removed from -mm tree
Date: Fri, 08 Jan 2010 13:02:30 -0800
Message-ID: <201001082102.o08L2UMY013937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752931Ab0AHVDO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2010 16:03:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, marvin24@gmx.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     nfs: fix oops in nfs_rename()
has been removed from the -mm tree.  Its filename was
     nfs-fix-oops-in-nfs_rename.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nfs: fix oops in nfs_rename()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Recent change is missing to update "rehash".  With that change, it will
become the cause of adding dentry to hash twice.

This explains the reason of Oops (dereference the freed dentry in
__d_lookup()) on my machine.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: Marvin <marvin24@gmx.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/dir.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/nfs/dir.c~nfs-fix-oops-in-nfs_rename fs/nfs/dir.c
--- a/fs/nfs/dir.c~nfs-fix-oops-in-nfs_rename
+++ a/fs/nfs/dir.c
@@ -1615,6 +1615,7 @@ static int nfs_rename(struct inode *old_
 				goto out;
 
 			new_dentry = dentry;
+			rehash = NULL;
 			new_inode = NULL;
 		}
 	}
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch
rtc_cmos-convert-shutdown-to-new-pnp_driver-shutdown.patch
tpm_infineon-fix-suspend-resume-handler-for-pnp_driver.patch

