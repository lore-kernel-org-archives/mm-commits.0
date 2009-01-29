From: akpm@linux-foundation.org
Subject: + xfs-dont-reallocate-sxp-variable-passed-into-xfs_swapext.patch added to -mm tree
Date: Wed, 28 Jan 2009 16:59:06 -0800
Message-ID: <200901290059.n0T0x6OV020414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45668 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943AbZA2A7v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Jan 2009 19:59:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@sandeen.net, felixb@sgi.com, hch@lst.de, pm@debian.org, xfs-masters@oss.sgi.com


The patch titled
     xfs: don't reallocate sxp variable passed into xfs_swapext
has been added to the -mm tree.  Its filename is
     xfs-dont-reallocate-sxp-variable-passed-into-xfs_swapext.patch

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
Subject: xfs: don't reallocate sxp variable passed into xfs_swapext
From: Eric Sandeen <sandeen@sandeen.net>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=12538, "xfs_fsr fails
on 2.6.29-rc kernels"

Regression caused by 743bb4650da9e2595d6cedd01c680b5b9398c74a ("[XFS] Move
copy_from_user calls out of ioctl helpers into ioctl switch").

This was an embarrasing mistake, reallocating the sxp pointer passed in
from the main ioctl switch.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net
Reported-by: Paul Martin <pm@debian.org>
Tested-by: Paul Martin <pm@debian.org>
Reviewed-by Felix Blyakher <felixb@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: <xfs-masters@oss.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_dfrag.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff -puN fs/xfs/xfs_dfrag.c~xfs-dont-reallocate-sxp-variable-passed-into-xfs_swapext fs/xfs/xfs_dfrag.c
--- a/fs/xfs/xfs_dfrag.c~xfs-dont-reallocate-sxp-variable-passed-into-xfs_swapext
+++ a/fs/xfs/xfs_dfrag.c
@@ -55,17 +55,11 @@ xfs_swapext(
 	struct file	*file, *target_file;
 	int		error = 0;
 
-	sxp = kmem_alloc(sizeof(xfs_swapext_t), KM_MAYFAIL);
-	if (!sxp) {
-		error = XFS_ERROR(ENOMEM);
-		goto out;
-	}
-
 	/* Pull information for the target fd */
 	file = fget((int)sxp->sx_fdtarget);
 	if (!file) {
 		error = XFS_ERROR(EINVAL);
-		goto out_free_sxp;
+		goto out;
 	}
 
 	if (!(file->f_mode & FMODE_WRITE) || (file->f_flags & O_APPEND)) {
@@ -109,8 +103,6 @@ xfs_swapext(
 	fput(target_file);
  out_put_file:
 	fput(file);
- out_free_sxp:
-	kmem_free(sxp);
  out:
 	return error;
 }
_

Patches currently in -mm which might be from sandeen@sandeen.net are

linux-next.patch
xfs-dont-reallocate-sxp-variable-passed-into-xfs_swapext.patch

