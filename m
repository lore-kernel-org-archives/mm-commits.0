Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59619C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 27 Jan 2022 22:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244421AbiA0WnG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Jan 2022 17:43:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50870 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238592AbiA0WnC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jan 2022 17:43:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49F0261BFE
        for <mm-commits@vger.kernel.org>; Thu, 27 Jan 2022 22:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20847C340E6;
        Thu, 27 Jan 2022 22:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643323381;
        bh=YDEVKdHL6PiJm2Zskrc6WM5RpygqygiDMLV4tEuxy0E=;
        h=Date:From:To:Subject:From;
        b=azF3m85JhGK/71kdmF0mrx80vSQErutvAnNdOQ7JF14LJrom2eIoSiRFxte9KmnvS
         Gq8YSmjVVi+urk67WachV0t6QgdtLf0sMDsX2ey3FVqqgcx+q36ri+ilo4g5vwo0vE
         nUNqoxwMsEbelDegroPylyOdndhe/lOQAIyz0WyY=
Date:   Thu, 27 Jan 2022 14:43:00 -0800
From:   akpm@linux-foundation.org
To:     Anna.Schumaker@Netapp.com, axboe@kernel.dk, chao@kernel.org,
        david@fromorbit.com, djwong@kernel.org, hch@lst.de,
        idryomov@gmail.com, jaegeuk@kernel.org, jlayton@kernel.org,
        konishi.ryusuke@gmail.com, lars.ellenberg@linbit.com,
        miklos@szeredi.hu, mm-commits@vger.kernel.org, neilb@suse.de,
        paolo.valente@linaro.org, philipp.reisner@linbit.com,
        trond.myklebust@hammerspace.com
Subject:  + nfs-remove-congestion-control.patch added to -mm tree
Message-ID: <20220127224300.zCn75E1Rs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: NFS: remove congestion control
has been added to the -mm tree.  Its filename is
     nfs-remove-congestion-control.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nfs-remove-congestion-control.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nfs-remove-congestion-control.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: NFS: remove congestion control

Linux no longer uses the bdi congestion tracking framework.  So remove
code from bdi which tries to support it.

Also remove the "nfs_congestion_kb" sysctl.  This is a user-visible
change, but unlikely to be a problematic one.

Link: https://lkml.kernel.org/r/164325158959.29787.14903007819591774556.stgit@noble.brown
Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Paolo Valente <paolo.valente@linaro.org>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/sysctl.c           |    7 ----
 fs/nfs/write.c            |   53 ------------------------------------
 include/linux/nfs_fs.h    |    1 
 include/linux/nfs_fs_sb.h |    1 
 4 files changed, 1 insertion(+), 61 deletions(-)

--- a/fs/nfs/sysctl.c~nfs-remove-congestion-control
+++ a/fs/nfs/sysctl.c
@@ -22,13 +22,6 @@ static struct ctl_table nfs_cb_sysctls[]
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
-	{
-		.procname	= "nfs_congestion_kb",
-		.data		= &nfs_congestion_kb,
-		.maxlen		= sizeof(nfs_congestion_kb),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
 	{ }
 };
 
--- a/fs/nfs/write.c~nfs-remove-congestion-control
+++ a/fs/nfs/write.c
@@ -397,33 +397,8 @@ static int wb_priority(struct writeback_
 	return ret;
 }
 
-/*
- * NFS congestion control
- */
-
-int nfs_congestion_kb;
-
-#define NFS_CONGESTION_ON_THRESH 	(nfs_congestion_kb >> (PAGE_SHIFT-10))
-#define NFS_CONGESTION_OFF_THRESH	\
-	(NFS_CONGESTION_ON_THRESH - (NFS_CONGESTION_ON_THRESH >> 2))
-
-static void nfs_set_page_writeback(struct page *page)
-{
-	struct inode *inode = page_file_mapping(page)->host;
-	struct nfs_server *nfss = NFS_SERVER(inode);
-	int ret = test_set_page_writeback(page);
-
-	WARN_ON_ONCE(ret != 0);
-
-	if (atomic_long_inc_return(&nfss->writeback) >
-			NFS_CONGESTION_ON_THRESH)
-		set_bdi_congested(inode_to_bdi(inode), BLK_RW_ASYNC);
-}
-
 static void nfs_end_page_writeback(struct nfs_page *req)
 {
-	struct inode *inode = page_file_mapping(req->wb_page)->host;
-	struct nfs_server *nfss = NFS_SERVER(inode);
 	bool is_done;
 
 	is_done = nfs_page_group_sync_on_bit(req, PG_WB_END);
@@ -432,8 +407,6 @@ static void nfs_end_page_writeback(struc
 		return;
 
 	end_page_writeback(req->wb_page);
-	if (atomic_long_dec_return(&nfss->writeback) < NFS_CONGESTION_OFF_THRESH)
-		clear_bdi_congested(inode_to_bdi(inode), BLK_RW_ASYNC);
 }
 
 /*
@@ -617,7 +590,7 @@ static int nfs_page_async_flush(struct n
 	if (IS_ERR(req))
 		goto out;
 
-	nfs_set_page_writeback(page);
+	set_page_writeback(page);
 	WARN_ON_ONCE(test_bit(PG_CLEAN, &req->wb_flags));
 
 	/* If there is a fatal error that covers this write, just exit */
@@ -1850,7 +1823,6 @@ static void nfs_commit_release_pages(str
 	struct nfs_page	*req;
 	int status = data->task.tk_status;
 	struct nfs_commit_info cinfo;
-	struct nfs_server *nfss;
 
 	while (!list_empty(&data->pages)) {
 		req = nfs_list_entry(data->pages.next);
@@ -1891,9 +1863,6 @@ static void nfs_commit_release_pages(str
 		/* Latency breaker */
 		cond_resched();
 	}
-	nfss = NFS_SERVER(data->inode);
-	if (atomic_long_read(&nfss->writeback) < NFS_CONGESTION_OFF_THRESH)
-		clear_bdi_congested(inode_to_bdi(data->inode), BLK_RW_ASYNC);
 
 	nfs_init_cinfo(&cinfo, data->inode, data->dreq);
 	nfs_commit_end(cinfo.mds);
@@ -2162,26 +2131,6 @@ int __init nfs_init_writepagecache(void)
 	if (nfs_commit_mempool == NULL)
 		goto out_destroy_commit_cache;
 
-	/*
-	 * NFS congestion size, scale with available memory.
-	 *
-	 *  64MB:    8192k
-	 * 128MB:   11585k
-	 * 256MB:   16384k
-	 * 512MB:   23170k
-	 *   1GB:   32768k
-	 *   2GB:   46340k
-	 *   4GB:   65536k
-	 *   8GB:   92681k
-	 *  16GB:  131072k
-	 *
-	 * This allows larger machines to have larger/more transfers.
-	 * Limit the default to 256M
-	 */
-	nfs_congestion_kb = (16*int_sqrt(totalram_pages())) << (PAGE_SHIFT-10);
-	if (nfs_congestion_kb > 256*1024)
-		nfs_congestion_kb = 256*1024;
-
 	return 0;
 
 out_destroy_commit_cache:
--- a/include/linux/nfs_fs.h~nfs-remove-congestion-control
+++ a/include/linux/nfs_fs.h
@@ -569,7 +569,6 @@ extern void nfs_complete_unlink(struct d
 /*
  * linux/fs/nfs/write.c
  */
-extern int  nfs_congestion_kb;
 extern int  nfs_writepage(struct page *page, struct writeback_control *wbc);
 extern int  nfs_writepages(struct address_space *, struct writeback_control *);
 extern int  nfs_flush_incompatible(struct file *file, struct page *page);
--- a/include/linux/nfs_fs_sb.h~nfs-remove-congestion-control
+++ a/include/linux/nfs_fs_sb.h
@@ -137,7 +137,6 @@ struct nfs_server {
 	struct rpc_clnt *	client_acl;	/* ACL RPC client handle */
 	struct nlm_host		*nlm_host;	/* NLM client handle */
 	struct nfs_iostats __percpu *io_stats;	/* I/O statistics */
-	atomic_long_t		writeback;	/* number of writeback pages */
 	unsigned int		flags;		/* various flags */
 
 /* The following are for internal use only. Also see uapi/linux/nfs_mount.h */
_

Patches currently in -mm which might be from neilb@suse.de are

remove-inode_congested.patch
remove-bdi_congested-and-wb_congested-and-related-functions.patch
f2fs-change-retry-waiting-for-f2fs_write_single_data_page.patch
f2f2-replace-some-congestion_wait-calls-with-io_schedule_timeout.patch
cephfs-dont-set-clear-bdi_congestion.patch
fuse-dont-set-clear-bdi_congested.patch
nfs-remove-congestion-control.patch
block-bfq-ioschedc-use-false-rather-than-blk_rw_async.patch
remove-congestion-tracking-framework.patch
mm-discard-__gfp_atomic.patch

