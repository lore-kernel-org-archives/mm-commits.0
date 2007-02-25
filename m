From: akpm@linux-foundation.org
Subject: + nfs-nfs_getattr-cant-call-nfs_sync_mapping_range-for-non-regular-files.patch added to -mm tree
Date: Sun, 25 Feb 2007 05:06:03 -0800
Message-ID: <200702251306.l1PD65lU029898@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35747 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964924AbXBYNG3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 08:06:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: trond.myklebust@fys.uio.no, Trond.Myklebust@netapp.com, olof@lixom.net


The patch titled
     NFS: nfs_getattr() can't call nfs_sync_mapping_range() for non-regular files
has been added to the -mm tree.  Its filename is
     nfs-nfs_getattr-cant-call-nfs_sync_mapping_range-for-non-regular-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: NFS: nfs_getattr() can't call nfs_sync_mapping_range() for non-regular files
From: Trond Myklebust <trond.myklebust@fys.uio.no>

Looks like we need a check in nfs_getattr() for a regular file. It makes
no sense to call nfs_sync_mapping_range() on anything else. I think that
should fix your problem: it will stop the NFS client from interfering
with dirty pages on that inode's mapping.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Acked-by: Olof Johansson <olof@lixom.net>
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

nfs-fix-congestion-control-v4.patch
nfs-nfs_getattr-cant-call-nfs_sync_mapping_range-for-non-regular-files.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
nfs-fix-congestion-control-use-atomic_longs.patch
restore-rogue-readahead-printk.patch
