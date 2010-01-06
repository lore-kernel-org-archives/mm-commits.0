From: akpm@linux-foundation.org
Subject: + nfs-fix-oops-in-nfs_rename.patch added to -mm tree
Date: Wed, 06 Jan 2010 15:42:36 -0800
Message-ID: <201001062342.o06Ngaes025383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932831Ab0AFXmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 18:42:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp, marvin24@gmx.de, trond.myklebust@fys.uio.no


The patch titled
     nfs: fix oops in nfs_rename()
has been added to the -mm tree.  Its filename is
     nfs-fix-oops-in-nfs_rename.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

rtc_cmos-convert-shutdown-to-new-pnp_driver-shutdown.patch
nfs-fix-oops-in-nfs_rename.patch
tpm_infineon-fix-suspend-resume-handler-for-pnp_driver.patch

