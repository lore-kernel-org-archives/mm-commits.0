From: akpm@linux-foundation.org
Subject: [merged] xfs-dont-reallocate-sxp-variable-passed-into-xfs_swapext.patch removed from -mm tree
Date: Mon, 02 Feb 2009 11:37:05 -0800
Message-ID: <200902021937.n12Jb5kQ013705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756776AbZBBTh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 14:37:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@sandeen.net, felixb@sgi.com, hch@lst.de, pm@debian.org, xfs-masters@oss.sgi.com, mm-commits@vger.kernel.org


The patch titled
     xfs: don't reallocate sxp variable passed into xfs_swapext
has been removed from the -mm tree.  Its filename was
     xfs-dont-reallocate-sxp-variable-passed-into-xfs_swapext.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
