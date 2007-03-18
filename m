From: akpm@linux-foundation.org
Subject: - nfs-nfs_getattr-cant-call-nfs_sync_mapping_range-for-non-regular-files.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:09:53 -0800
Message-ID: <200703180909.l2I99rg1020045@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60541 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189AbXCRJLV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:11:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: trond.myklebust@fys.uio.no, Trond.Myklebust@netapp.com, olof@lixom.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     nfs: nfs_getattr() can't call nfs_sync_mapping_range() for non-regular files
has been removed from the -mm tree.  Its filename was
     nfs-nfs_getattr-cant-call-nfs_sync_mapping_range-for-non-regular-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfs: nfs_getattr() can't call nfs_sync_mapping_range() for non-regular files
From: Trond Myklebust <trond.myklebust@fys.uio.no>

Looks like we need a check in nfs_getattr() for a regular file. It makes
no sense to call nfs_sync_mapping_range() on anything else. I think that
should fix your problem: it will stop the NFS client from interfering
with dirty pages on that inode's mapping.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Olof Johansson <olof@lixom.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/nfs/inode.c~nfs-nfs_getattr-cant-call-nfs_sync_mapping_range-for-non-regular-files fs/nfs/inode.c
--- a/fs/nfs/inode.c~nfs-nfs_getattr-cant-call-nfs_sync_mapping_range-for-non-regular-files
+++ a/fs/nfs/inode.c
@@ -429,7 +429,8 @@ int nfs_getattr(struct vfsmount *mnt, st
 	int err;
 
 	/* Flush out writes to the server in order to update c/mtime */
-	nfs_sync_mapping_range(inode->i_mapping, 0, 0, FLUSH_NOCOMMIT);
+	if (S_ISREG(inode->i_mode))
+		nfs_sync_mapping_range(inode->i_mapping, 0, 0, FLUSH_NOCOMMIT);
 
 	/*
 	 * We may force a getattr if the user cares about atime.
_

Patches currently in -mm which might be from trond.myklebust@fys.uio.no are

origin.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
nfs-fix-congestion-control-use-atomic_longs.patch
restore-rogue-readahead-printk.patch
