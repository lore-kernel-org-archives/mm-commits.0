From: akpm@linux-foundation.org
Subject: + nfs-fix-nfs_remount-oops-when-rebooting.patch added to -mm tree
Date: Sat, 26 Jul 2008 00:16:12 -0700
Message-ID: <200807260716.m6Q7GCSC021711@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784AbYGZHRG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 03:17:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maz@misterjones.org, bfields@fieldses.org, jlayton@redhat.com, marc.zyngier@altran.com, trond.myklebust@fys.uio.no


The patch titled
     nfs: fix nfs_remount oops when rebooting
has been added to the -mm tree.  Its filename is
     nfs-fix-nfs_remount-oops-when-rebooting.patch

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
Subject: nfs: fix nfs_remount oops when rebooting
From: Marc Zyngier <maz@misterjones.org>

The commit

    commit 48b605f83c920d8daa50e43fc2c7f718e04c7bfa
    Author: Jeff Layton <jlayton@redhat.com>
    Date:   Tue Jun 10 15:38:39 2008 -0400

        NFS: implement option checking when remounting NFS filesystems (resend)

generates an Oops on my platform when rebooting while its root FS on an
NFS share (NFSv3, TCP).

The new super.c:nfs_remount function doesn't check the validity of the
options/options4 pointers.  Unfortunately, this seems to happen.  The
obvious patch seems to check the pointers, and not to do anything if the
happend to be NULL.

Signed-off-by: Marc Zyngier <marc.zyngier@altran.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/nfs/super.c~nfs-fix-nfs_remount-oops-when-rebooting fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-fix-nfs_remount-oops-when-rebooting
+++ a/fs/nfs/super.c
@@ -1718,9 +1718,10 @@ nfs_remount(struct super_block *sb, int 
 	 * ones were explicitly specified. Fall back to legacy behavior and
 	 * just return success.
 	 */
-	if ((nfsvers == 4 && options4->version == 1) ||
-	    (nfsvers <= 3 && options->version >= 1 &&
-	     options->version <= 6))
+
+	if ((nfsvers == 4 && (!options4 || options4->version == 1)) ||
+	    (nfsvers <= 3 && (!options || (options->version >= 1 &&
+					   options->version <= 6))))
 		return 0;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
_

Patches currently in -mm which might be from maz@misterjones.org are

origin.patch
linux-next.patch
nfs-fix-nfs_remount-oops-when-rebooting.patch

