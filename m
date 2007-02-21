From: akpm@linux-foundation.org
Subject: + nfs-fix-congestion-control-use-atomic_longs.patch added to -mm tree
Date: Wed, 21 Feb 2007 15:31:42 -0800
Message-ID: <200702212331.l1LNVgaa030033@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57501 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423086AbXBUXcI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 18:32:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, trond.myklebust@fys.uio.no


The patch titled
     nfs: fix congestion control: use atomic_longs
has been added to the -mm tree.  Its filename is
     nfs-fix-congestion-control-use-atomic_longs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -224,7 +224,7 @@ static void nfs_set_page_writeback(struc
 		struct inode *inode = page->mapping->host;
 		struct nfs_server *nfss = NFS_SERVER(inode);
 
-		if (atomic_inc_return(&nfss->writeback) >
+		if (atomic_long_inc_return(&nfss->writeback) >
 				NFS_CONGESTION_ON_THRESH)
 			set_bdi_congested(&nfss->backing_dev_info, WRITE);
 	}
@@ -236,7 +236,7 @@ static void nfs_end_page_writeback(struc
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

nfs-fix-congestion-control-v4.patch
lumpy-reclaim-v2.patch
lumpy-reclaim-v2-page_to_pfn-fix.patch
lumpy-reclaim-v2-tidy.patch
nfs-fix-congestion-control-use-atomic_longs.patch
