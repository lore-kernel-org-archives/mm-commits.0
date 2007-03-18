From: akpm@linux-foundation.org
Subject: - nfs-fix-congestion-control-v4.patch removed from -mm tree
Date: Sun, 18 Mar 2007 01:09:50 -0800
Message-ID: <200703180909.l2I99oLs020042@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60462 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146AbXCRJKD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 05:10:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, clameter@engr.sgi.com, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     nfs: fix congestion control
has been removed from the -mm tree.  Its filename was
     nfs-fix-congestion-control-v4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nfs: fix congestion control
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

The current NFS client congestion logic is severly broken, it marks the
backing device congested during each nfs_writepages() call but doesn't
mirror this in nfs_writepage() which makes for deadlocks.  Also it
implements its own waitqueue.

Replace this by a more regular congestion implementation that puts a cap on
the number of active writeback pages and uses the bdi congestion waitqueue.

Also always use an interruptible wait since it makes sense to be able to
SIGKILL the process even for mounts without 'intr'.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c              |    4 -
 fs/nfs/sysctl.c             |    8 ++
 fs/nfs/write.c              |  116 +++++++++++++++++++++-------------
 include/linux/backing-dev.h |    1 
 include/linux/nfs_fs.h      |    1 
 include/linux/nfs_fs_sb.h   |    1 
 mm/backing-dev.c            |   16 ++++
 7 files changed, 103 insertions(+), 44 deletions(-)

diff -puN fs/nfs/super.c~nfs-fix-congestion-control-v4 fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-fix-congestion-control-v4
+++ a/fs/nfs/super.c
@@ -151,10 +151,10 @@ int __init register_nfs_fs(void)
 	if (ret < 0)
 		goto error_0;
 
-#ifdef CONFIG_NFS_V4
 	ret = nfs_register_sysctl();
 	if (ret < 0)
 		goto error_1;
+#ifdef CONFIG_NFS_V4
 	ret = register_filesystem(&nfs4_fs_type);
 	if (ret < 0)
 		goto error_2;
@@ -165,9 +165,9 @@ int __init register_nfs_fs(void)
 #ifdef CONFIG_NFS_V4
 error_2:
 	nfs_unregister_sysctl();
+#endif
 error_1:
 	unregister_filesystem(&nfs_fs_type);
-#endif
 error_0:
 	return ret;
 }
diff -puN fs/nfs/sysctl.c~nfs-fix-congestion-control-v4 fs/nfs/sysctl.c
--- a/fs/nfs/sysctl.c~nfs-fix-congestion-control-v4
+++ a/fs/nfs/sysctl.c
@@ -50,6 +50,14 @@ static ctl_table nfs_cb_sysctls[] = {
 		.proc_handler	= &proc_dointvec_jiffies,
 		.strategy	= &sysctl_jiffies,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "nfs_congestion_kb",
+		.data		= &nfs_congestion_kb,
+		.maxlen		= sizeof(nfs_congestion_kb),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 	{ .ctl_name = 0 }
 };
 
diff -puN fs/nfs/write.c~nfs-fix-congestion-control-v4 fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-fix-congestion-control-v4
+++ a/fs/nfs/write.c
@@ -12,6 +12,7 @@
 #include <linux/pagemap.h>
 #include <linux/file.h>
 #include <linux/writeback.h>
+#include <linux/swap.h>
 
 #include <linux/sunrpc/clnt.h>
 #include <linux/nfs_fs.h>
@@ -38,7 +39,6 @@ static struct nfs_page * nfs_update_requ
 					    struct page *,
 					    unsigned int, unsigned int);
 static void nfs_mark_request_dirty(struct nfs_page *req);
-static int nfs_wait_on_write_congestion(struct address_space *, int);
 static long nfs_flush_mapping(struct address_space *mapping, struct writeback_control *wbc, int how);
 static const struct rpc_call_ops nfs_write_partial_ops;
 static const struct rpc_call_ops nfs_write_full_ops;
@@ -48,8 +48,6 @@ static struct kmem_cache *nfs_wdata_cach
 static mempool_t *nfs_wdata_mempool;
 static mempool_t *nfs_commit_mempool;
 
-static DECLARE_WAIT_QUEUE_HEAD(nfs_write_congestion);
-
 struct nfs_write_data *nfs_commit_alloc(void)
 {
 	struct nfs_write_data *p = mempool_alloc(nfs_commit_mempool, GFP_NOFS);
@@ -211,6 +209,40 @@ static int wb_priority(struct writeback_
 }
 
 /*
+ * NFS congestion control
+ */
+
+int nfs_congestion_kb;
+
+#define NFS_CONGESTION_ON_THRESH 	(nfs_congestion_kb >> (PAGE_SHIFT-10))
+#define NFS_CONGESTION_OFF_THRESH	\
+	(NFS_CONGESTION_ON_THRESH - (NFS_CONGESTION_ON_THRESH >> 2))
+
+static void nfs_set_page_writeback(struct page *page)
+{
+	if (!test_set_page_writeback(page)) {
+		struct inode *inode = page->mapping->host;
+		struct nfs_server *nfss = NFS_SERVER(inode);
+
+		if (atomic_inc_return(&nfss->writeback) >
+				NFS_CONGESTION_ON_THRESH)
+			set_bdi_congested(&nfss->backing_dev_info, WRITE);
+	}
+}
+
+static void nfs_end_page_writeback(struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	struct nfs_server *nfss = NFS_SERVER(inode);
+
+	end_page_writeback(page);
+	if (atomic_dec_return(&nfss->writeback) < NFS_CONGESTION_OFF_THRESH) {
+		clear_bdi_congested(&nfss->backing_dev_info, WRITE);
+		congestion_end(WRITE);
+	}
+}
+
+/*
  * Find an associated nfs write request, and prepare to flush it out
  * Returns 1 if there was no write request, or if the request was
  * already tagged by nfs_set_page_dirty.Returns 0 if the request
@@ -247,7 +279,7 @@ static int nfs_page_mark_flush(struct pa
 	spin_unlock(req_lock);
 	if (test_and_set_bit(PG_FLUSHING, &req->wb_flags) == 0) {
 		nfs_mark_request_dirty(req);
-		set_page_writeback(page);
+		nfs_set_page_writeback(page);
 	}
 	ret = test_bit(PG_NEED_FLUSH, &req->wb_flags);
 	nfs_unlock_request(req);
@@ -302,13 +334,8 @@ int nfs_writepage(struct page *page, str
 	return err; 
 }
 
-/*
- * Note: causes nfs_update_request() to block on the assumption
- * 	 that the writeback is generated due to memory pressure.
- */
 int nfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
-	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	struct inode *inode = mapping->host;
 	int err;
 
@@ -317,20 +344,12 @@ int nfs_writepages(struct address_space 
 	err = generic_writepages(mapping, wbc);
 	if (err)
 		return err;
-	while (test_and_set_bit(BDI_write_congested, &bdi->state) != 0) {
-		if (wbc->nonblocking)
-			return 0;
-		nfs_wait_on_write_congestion(mapping, 0);
-	}
 	err = nfs_flush_mapping(mapping, wbc, wb_priority(wbc));
 	if (err < 0)
 		goto out;
 	nfs_add_stats(inode, NFSIOS_WRITEPAGES, err);
 	err = 0;
 out:
-	clear_bit(BDI_write_congested, &bdi->state);
-	wake_up_all(&nfs_write_congestion);
-	congestion_end(WRITE);
 	return err;
 }
 
@@ -360,7 +379,7 @@ static int nfs_inode_add_request(struct 
 }
 
 /*
- * Insert a write request into an inode
+ * Remove a write request from an inode
  */
 static void nfs_inode_remove_request(struct nfs_page *req)
 {
@@ -531,10 +550,10 @@ static inline int nfs_scan_commit(struct
 }
 #endif
 
-static int nfs_wait_on_write_congestion(struct address_space *mapping, int intr)
+static int nfs_wait_on_write_congestion(struct address_space *mapping)
 {
+	struct inode *inode = mapping->host;
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
-	DEFINE_WAIT(wait);
 	int ret = 0;
 
 	might_sleep();
@@ -542,31 +561,23 @@ static int nfs_wait_on_write_congestion(
 	if (!bdi_write_congested(bdi))
 		return 0;
 
-	nfs_inc_stats(mapping->host, NFSIOS_CONGESTIONWAIT);
+	nfs_inc_stats(inode, NFSIOS_CONGESTIONWAIT);
 
-	if (intr) {
-		struct rpc_clnt *clnt = NFS_CLIENT(mapping->host);
+	do {
+		struct rpc_clnt *clnt = NFS_CLIENT(inode);
 		sigset_t oldset;
 
 		rpc_clnt_sigmask(clnt, &oldset);
-		prepare_to_wait(&nfs_write_congestion, &wait, TASK_INTERRUPTIBLE);
-		if (bdi_write_congested(bdi)) {
-			if (signalled())
-				ret = -ERESTARTSYS;
-			else
-				schedule();
-		}
+		ret = congestion_wait_interruptible(WRITE, HZ/10);
 		rpc_clnt_sigunmask(clnt, &oldset);
-	} else {
-		prepare_to_wait(&nfs_write_congestion, &wait, TASK_UNINTERRUPTIBLE);
-		if (bdi_write_congested(bdi))
-			schedule();
-	}
-	finish_wait(&nfs_write_congestion, &wait);
+		if (ret == -ERESTARTSYS)
+			break;
+		ret = 0;
+	} while (bdi_write_congested(bdi));
+
 	return ret;
 }
 
-
 /*
  * Try to update any existing write request, or create one if there is none.
  * In order to match, the request's credentials must match those of
@@ -577,14 +588,15 @@ static int nfs_wait_on_write_congestion(
 static struct nfs_page * nfs_update_request(struct nfs_open_context* ctx,
 		struct page *page, unsigned int offset, unsigned int bytes)
 {
-	struct inode *inode = page->mapping->host;
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
 	struct nfs_inode *nfsi = NFS_I(inode);
 	struct nfs_page		*req, *new = NULL;
 	unsigned long		rqend, end;
 
 	end = offset + bytes;
 
-	if (nfs_wait_on_write_congestion(page->mapping, NFS_SERVER(inode)->flags & NFS_MOUNT_INTR))
+	if (nfs_wait_on_write_congestion(mapping))
 		return ERR_PTR(-ERESTARTSYS);
 	for (;;) {
 		/* Loop over all inode entries and see if we find
@@ -727,7 +739,7 @@ int nfs_updatepage(struct file *file, st
 
 static void nfs_writepage_release(struct nfs_page *req)
 {
-	end_page_writeback(req->wb_page);
+	nfs_end_page_writeback(req->wb_page);
 
 #if defined(CONFIG_NFS_V3) || defined(CONFIG_NFS_V4)
 	if (!PageError(req->wb_page)) {
@@ -1042,12 +1054,12 @@ static void nfs_writeback_done_full(stru
 		if (task->tk_status < 0) {
 			nfs_set_pageerror(page);
 			req->wb_context->error = task->tk_status;
-			end_page_writeback(page);
+			nfs_end_page_writeback(page);
 			nfs_inode_remove_request(req);
 			dprintk(", error = %d\n", task->tk_status);
 			goto next;
 		}
-		end_page_writeback(page);
+		nfs_end_page_writeback(page);
 
 #if defined(CONFIG_NFS_V3) || defined(CONFIG_NFS_V4)
 		if (data->args.stable != NFS_UNSTABLE || data->verf.committed == NFS_FILE_SYNC) {
@@ -1514,6 +1526,26 @@ int __init nfs_init_writepagecache(void)
 	if (nfs_commit_mempool == NULL)
 		return -ENOMEM;
 
+	/*
+	 * NFS congestion size, scale with available memory.
+	 *
+	 *  64MB:    8192k
+	 * 128MB:   11585k
+	 * 256MB:   16384k
+	 * 512MB:   23170k
+	 *   1GB:   32768k
+	 *   2GB:   46340k
+	 *   4GB:   65536k
+	 *   8GB:   92681k
+	 *  16GB:  131072k
+	 *
+	 * This allows larger machines to have larger/more transfers.
+	 * Limit the default to 256M
+	 */
+	nfs_congestion_kb = (16*int_sqrt(totalram_pages)) << (PAGE_SHIFT-10);
+	if (nfs_congestion_kb > 256*1024)
+		nfs_congestion_kb = 256*1024;
+
 	return 0;
 }
 
diff -puN include/linux/backing-dev.h~nfs-fix-congestion-control-v4 include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~nfs-fix-congestion-control-v4
+++ a/include/linux/backing-dev.h
@@ -93,6 +93,7 @@ static inline int bdi_rw_congested(struc
 void clear_bdi_congested(struct backing_dev_info *bdi, int rw);
 void set_bdi_congested(struct backing_dev_info *bdi, int rw);
 long congestion_wait(int rw, long timeout);
+long congestion_wait_interruptible(int rw, long timeout);
 void congestion_end(int rw);
 
 #define bdi_cap_writeback_dirty(bdi) \
diff -puN include/linux/nfs_fs.h~nfs-fix-congestion-control-v4 include/linux/nfs_fs.h
--- a/include/linux/nfs_fs.h~nfs-fix-congestion-control-v4
+++ a/include/linux/nfs_fs.h
@@ -415,6 +415,7 @@ extern void nfs_complete_unlink(struct d
 /*
  * linux/fs/nfs/write.c
  */
+extern int  nfs_congestion_kb;
 extern int  nfs_writepage(struct page *page, struct writeback_control *wbc);
 extern int  nfs_writepages(struct address_space *, struct writeback_control *);
 extern int  nfs_flush_incompatible(struct file *file, struct page *page);
diff -puN include/linux/nfs_fs_sb.h~nfs-fix-congestion-control-v4 include/linux/nfs_fs_sb.h
--- a/include/linux/nfs_fs_sb.h~nfs-fix-congestion-control-v4
+++ a/include/linux/nfs_fs_sb.h
@@ -82,6 +82,7 @@ struct nfs_server {
 	struct rpc_clnt *	client_acl;	/* ACL RPC client handle */
 	struct nfs_iostats *	io_stats;	/* I/O statistics */
 	struct backing_dev_info	backing_dev_info;
+	atomic_t		writeback;	/* number of writeback pages */
 	int			flags;		/* various flags */
 	unsigned int		caps;		/* server capabilities */
 	unsigned int		rsize;		/* read size */
diff -puN mm/backing-dev.c~nfs-fix-congestion-control-v4 mm/backing-dev.c
--- a/mm/backing-dev.c~nfs-fix-congestion-control-v4
+++ a/mm/backing-dev.c
@@ -55,6 +55,22 @@ long congestion_wait(int rw, long timeou
 }
 EXPORT_SYMBOL(congestion_wait);
 
+long congestion_wait_interruptible(int rw, long timeout)
+{
+	long ret;
+	DEFINE_WAIT(wait);
+	wait_queue_head_t *wqh = &congestion_wqh[rw];
+
+	prepare_to_wait(wqh, &wait, TASK_INTERRUPTIBLE);
+	if (signal_pending(current))
+		ret = -ERESTARTSYS;
+	else
+		ret = io_schedule_timeout(timeout);
+	finish_wait(wqh, &wait);
+	return ret;
+}
+EXPORT_SYMBOL(congestion_wait_interruptible);
+
 /**
  * congestion_end - wake up sleepers on a congested backing_dev_info
  * @rw: READ or WRITE
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
lumpy-reclaim-v4.patch
exec-fix-remove_arg_zero-add-comment.patch
lists-add-list-splice-tail.patch
nfs-fix-congestion-control-use-atomic_longs.patch
