From: akpm@linux-foundation.org
Subject: - nfs-fix-congestion-control-use-atomic_longs.patch removed from -mm tree
Date: Tue, 08 May 2007 19:55:53 -0700
Message-ID: <200705090255.l492trmZ009979@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032390AbXEIC4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:56:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     nfs: fix congestion control: use atomic_longs
has been removed from the -mm tree.  Its filename was
     nfs-fix-congestion-control-use-atomic_longs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfs: fix congestion control: use atomic_longs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Change the atomic_t in struct nfs_server to atomic_long_t in anticipation
of machines that can handle 8+TB of (4K) pages under writeback.

However I suspect other things in NFS will start going *bang* by then.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/write.c            |    4 ++--
 include/linux/nfs_fs_sb.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/nfs/write.c~nfs-fix-congestion-control-use-atomic_longs fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-fix-congestion-control-use-atomic_longs
+++ a/fs/nfs/write.c
@@ -224,7 +224,7 @@ static int nfs_set_page_writeback(struct
 		struct inode *inode = page->mapping->host;
 		struct nfs_server *nfss = NFS_SERVER(inode);
 
-		if (atomic_inc_return(&nfss->writeback) >
+		if (atomic_long_inc_return(&nfss->writeback) >
 				NFS_CONGESTION_ON_THRESH)
 			set_bdi_congested(&nfss->backing_dev_info, WRITE);
 	}
@@ -237,7 +237,7 @@ static void nfs_end_page_writeback(struc
 	struct nfs_server *nfss = NFS_SERVER(inode);
 
 	end_page_writeback(page);
-	if (atomic_dec_return(&nfss->writeback) < NFS_CONGESTION_OFF_THRESH) {
+	if (atomic_long_dec_return(&nfss->writeback) < NFS_CONGESTION_OFF_THRESH) {
 		clear_bdi_congested(&nfss->backing_dev_info, WRITE);
 		congestion_end(WRITE);
 	}
diff -puN include/linux/nfs_fs_sb.h~nfs-fix-congestion-control-use-atomic_longs include/linux/nfs_fs_sb.h
--- a/include/linux/nfs_fs_sb.h~nfs-fix-congestion-control-use-atomic_longs
+++ a/include/linux/nfs_fs_sb.h
@@ -82,7 +82,7 @@ struct nfs_server {
 	struct rpc_clnt *	client_acl;	/* ACL RPC client handle */
 	struct nfs_iostats *	io_stats;	/* I/O statistics */
 	struct backing_dev_info	backing_dev_info;
-	atomic_t		writeback;	/* number of writeback pages */
+	atomic_long_t		writeback;	/* number of writeback pages */
 	int			flags;		/* various flags */
 	unsigned int		caps;		/* server capabilities */
 	unsigned int		rsize;		/* read size */
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
lazy-freeing-of-memory-through-madv_free.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
uml-turn-on-scsi-support.patch
