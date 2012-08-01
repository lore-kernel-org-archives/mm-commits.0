From: akpm@linux-foundation.org
Subject: [merged] nfs-enable-swap-on-nfs.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:17:29 -0700
Message-ID: <20120801201730.67D03200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:42694 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950Ab2HAURe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:17:34 -0400
Received: by wibhr14 with SMTP id hr14so199066wib.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:17:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, Trond.Myklebust@netapp.com, davem@davemloft.net, dfeng@redhat.com, emunson@mgebm.net, eparis@redhat.com, hch@infradead.org, jmorris@namei.org, michaelc@cs.wisc.edu, neilb@suse.de, riel@redhat.com, sebastian@breakpoint.cc, mm-commits@vger.kernel.org


The patch titled
     Subject: nfs: enable swap on NFS
has been removed from the -mm tree.  Its filename was
     nfs-enable-swap-on-nfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: nfs: enable swap on NFS

Implement the new swapfile a_ops for NFS and hook up ->direct_IO.  This
will set the NFS socket to SOCK_MEMALLOC and run socket reconnect under
PF_MEMALLOC as well as reset SOCK_MEMALLOC before engaging the protocol
->connect() method.

PF_MEMALLOC should allow the allocation of struct socket and related
objects and the early (re)setting of SOCK_MEMALLOC should allow us to
receive the packets required for the TCP connection buildup.

[jlayton@redhat.com: Restore PF_MEMALLOC task flags in all cases]
[dfeng@redhat.com: Fix handling of multiple swap files]
[a.p.zijlstra@chello.nl: Original patch]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Xiaotian Feng <dfeng@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/Kconfig              |    8 +++
 fs/nfs/direct.c             |   82 ++++++++++++++++++++++------------
 fs/nfs/file.c               |   22 ++++++++-
 include/linux/nfs_fs.h      |    4 -
 include/linux/sunrpc/xprt.h |    3 +
 net/sunrpc/Kconfig          |    5 ++
 net/sunrpc/clnt.c           |    9 +++
 net/sunrpc/sched.c          |    7 ++
 net/sunrpc/xprtsock.c       |   43 +++++++++++++++++
 9 files changed, 149 insertions(+), 34 deletions(-)

diff -puN fs/nfs/Kconfig~nfs-enable-swap-on-nfs fs/nfs/Kconfig
--- a/fs/nfs/Kconfig~nfs-enable-swap-on-nfs
+++ a/fs/nfs/Kconfig
@@ -86,6 +86,14 @@ config NFS_V4
 
 	  If unsure, say Y.
 
+config NFS_SWAP
+	bool "Provide swap over NFS support"
+	default n
+	depends on NFS_FS
+	select SUNRPC_SWAP
+	help
+	  This option enables swapon to work on files located on NFS mounts.
+
 config NFS_V4_1
 	bool "NFS client support for NFSv4.1 (EXPERIMENTAL)"
 	depends on NFS_V4 && EXPERIMENTAL
diff -puN fs/nfs/direct.c~nfs-enable-swap-on-nfs fs/nfs/direct.c
--- a/fs/nfs/direct.c~nfs-enable-swap-on-nfs
+++ a/fs/nfs/direct.c
@@ -115,17 +115,28 @@ static inline int put_dreq(struct nfs_di
  * @nr_segs: size of iovec array
  *
  * The presence of this routine in the address space ops vector means
- * the NFS client supports direct I/O.  However, we shunt off direct
- * read and write requests before the VFS gets them, so this method
- * should never be called.
+ * the NFS client supports direct I/O. However, for most direct IO, we
+ * shunt off direct read and write requests before the VFS gets them,
+ * so this method is only ever called for swap.
  */
 ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_t pos, unsigned long nr_segs)
 {
+#ifndef CONFIG_NFS_SWAP
 	dprintk("NFS: nfs_direct_IO (%s) off/no(%Ld/%lu) EINVAL\n",
 			iocb->ki_filp->f_path.dentry->d_name.name,
 			(long long) pos, nr_segs);
 
 	return -EINVAL;
+#else
+	VM_BUG_ON(iocb->ki_left != PAGE_SIZE);
+	VM_BUG_ON(iocb->ki_nbytes != PAGE_SIZE);
+
+	if (rw == READ || rw == KERNEL_READ)
+		return nfs_file_direct_read(iocb, iov, nr_segs, pos,
+				rw == READ ? true : false);
+	return nfs_file_direct_write(iocb, iov, nr_segs, pos,
+				rw == WRITE ? true : false);
+#endif /* CONFIG_NFS_SWAP */
 }
 
 static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
@@ -303,7 +314,7 @@ static const struct nfs_pgio_completion_
  */
 static ssize_t nfs_direct_read_schedule_segment(struct nfs_pageio_descriptor *desc,
 						const struct iovec *iov,
-						loff_t pos)
+						loff_t pos, bool uio)
 {
 	struct nfs_direct_req *dreq = desc->pg_dreq;
 	struct nfs_open_context *ctx = dreq->ctx;
@@ -331,12 +342,20 @@ static ssize_t nfs_direct_read_schedule_
 					  GFP_KERNEL);
 		if (!pagevec)
 			break;
-		down_read(&current->mm->mmap_sem);
-		result = get_user_pages(current, current->mm, user_addr,
+		if (uio) {
+			down_read(&current->mm->mmap_sem);
+			result = get_user_pages(current, current->mm, user_addr,
 					npages, 1, 0, pagevec, NULL);
-		up_read(&current->mm->mmap_sem);
-		if (result < 0)
-			break;
+			up_read(&current->mm->mmap_sem);
+			if (result < 0)
+				break;
+		} else {
+			WARN_ON(npages != 1);
+			result = get_kernel_page(user_addr, 1, pagevec);
+			if (WARN_ON(result != 1))
+				break;
+		}
+
 		if ((unsigned)result < npages) {
 			bytes = result * PAGE_SIZE;
 			if (bytes <= pgbase) {
@@ -386,7 +405,7 @@ static ssize_t nfs_direct_read_schedule_
 static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 					      const struct iovec *iov,
 					      unsigned long nr_segs,
-					      loff_t pos)
+					      loff_t pos, bool uio)
 {
 	struct nfs_pageio_descriptor desc;
 	ssize_t result = -EINVAL;
@@ -400,7 +419,7 @@ static ssize_t nfs_direct_read_schedule_
 
 	for (seg = 0; seg < nr_segs; seg++) {
 		const struct iovec *vec = &iov[seg];
-		result = nfs_direct_read_schedule_segment(&desc, vec, pos);
+		result = nfs_direct_read_schedule_segment(&desc, vec, pos, uio);
 		if (result < 0)
 			break;
 		requested_bytes += result;
@@ -426,7 +445,7 @@ static ssize_t nfs_direct_read_schedule_
 }
 
 static ssize_t nfs_direct_read(struct kiocb *iocb, const struct iovec *iov,
-			       unsigned long nr_segs, loff_t pos)
+			       unsigned long nr_segs, loff_t pos, bool uio)
 {
 	ssize_t result = -ENOMEM;
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
@@ -444,7 +463,7 @@ static ssize_t nfs_direct_read(struct ki
 	if (!is_sync_kiocb(iocb))
 		dreq->iocb = iocb;
 
-	result = nfs_direct_read_schedule_iovec(dreq, iov, nr_segs, pos);
+	result = nfs_direct_read_schedule_iovec(dreq, iov, nr_segs, pos, uio);
 	if (!result)
 		result = nfs_direct_wait(dreq);
 	NFS_I(inode)->read_io += result;
@@ -610,7 +629,7 @@ static void nfs_direct_write_complete(st
  */
 static ssize_t nfs_direct_write_schedule_segment(struct nfs_pageio_descriptor *desc,
 						 const struct iovec *iov,
-						 loff_t pos)
+						 loff_t pos, bool uio)
 {
 	struct nfs_direct_req *dreq = desc->pg_dreq;
 	struct nfs_open_context *ctx = dreq->ctx;
@@ -638,12 +657,19 @@ static ssize_t nfs_direct_write_schedule
 		if (!pagevec)
 			break;
 
-		down_read(&current->mm->mmap_sem);
-		result = get_user_pages(current, current->mm, user_addr,
-					npages, 0, 0, pagevec, NULL);
-		up_read(&current->mm->mmap_sem);
-		if (result < 0)
-			break;
+		if (uio) {
+			down_read(&current->mm->mmap_sem);
+			result = get_user_pages(current, current->mm, user_addr,
+						npages, 0, 0, pagevec, NULL);
+			up_read(&current->mm->mmap_sem);
+			if (result < 0)
+				break;
+		} else {
+			WARN_ON(npages != 1);
+			result = get_kernel_page(user_addr, 0, pagevec);
+			if (WARN_ON(result != 1))
+				break;
+		}
 
 		if ((unsigned)result < npages) {
 			bytes = result * PAGE_SIZE;
@@ -774,7 +800,7 @@ static const struct nfs_pgio_completion_
 static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 					       const struct iovec *iov,
 					       unsigned long nr_segs,
-					       loff_t pos)
+					       loff_t pos, bool uio)
 {
 	struct nfs_pageio_descriptor desc;
 	struct inode *inode = dreq->inode;
@@ -790,7 +816,7 @@ static ssize_t nfs_direct_write_schedule
 
 	for (seg = 0; seg < nr_segs; seg++) {
 		const struct iovec *vec = &iov[seg];
-		result = nfs_direct_write_schedule_segment(&desc, vec, pos);
+		result = nfs_direct_write_schedule_segment(&desc, vec, pos, uio);
 		if (result < 0)
 			break;
 		requested_bytes += result;
@@ -818,7 +844,7 @@ static ssize_t nfs_direct_write_schedule
 
 static ssize_t nfs_direct_write(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos,
-				size_t count)
+				size_t count, bool uio)
 {
 	ssize_t result = -ENOMEM;
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
@@ -836,7 +862,7 @@ static ssize_t nfs_direct_write(struct k
 	if (!is_sync_kiocb(iocb))
 		dreq->iocb = iocb;
 
-	result = nfs_direct_write_schedule_iovec(dreq, iov, nr_segs, pos);
+	result = nfs_direct_write_schedule_iovec(dreq, iov, nr_segs, pos, uio);
 	if (!result)
 		result = nfs_direct_wait(dreq);
 out_release:
@@ -867,7 +893,7 @@ out:
  * cache.
  */
 ssize_t nfs_file_direct_read(struct kiocb *iocb, const struct iovec *iov,
-				unsigned long nr_segs, loff_t pos)
+				unsigned long nr_segs, loff_t pos, bool uio)
 {
 	ssize_t retval = -EINVAL;
 	struct file *file = iocb->ki_filp;
@@ -892,7 +918,7 @@ ssize_t nfs_file_direct_read(struct kioc
 
 	task_io_account_read(count);
 
-	retval = nfs_direct_read(iocb, iov, nr_segs, pos);
+	retval = nfs_direct_read(iocb, iov, nr_segs, pos, uio);
 	if (retval > 0)
 		iocb->ki_pos = pos + retval;
 
@@ -923,7 +949,7 @@ out:
  * is no atomic O_APPEND write facility in the NFS protocol.
  */
 ssize_t nfs_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
-				unsigned long nr_segs, loff_t pos)
+				unsigned long nr_segs, loff_t pos, bool uio)
 {
 	ssize_t retval = -EINVAL;
 	struct file *file = iocb->ki_filp;
@@ -955,7 +981,7 @@ ssize_t nfs_file_direct_write(struct kio
 
 	task_io_account_write(count);
 
-	retval = nfs_direct_write(iocb, iov, nr_segs, pos, count);
+	retval = nfs_direct_write(iocb, iov, nr_segs, pos, count, uio);
 	if (retval > 0) {
 		struct inode *inode = mapping->host;
 
diff -puN fs/nfs/file.c~nfs-enable-swap-on-nfs fs/nfs/file.c
--- a/fs/nfs/file.c~nfs-enable-swap-on-nfs
+++ a/fs/nfs/file.c
@@ -175,7 +175,7 @@ nfs_file_read(struct kiocb *iocb, const 
 	ssize_t result;
 
 	if (iocb->ki_filp->f_flags & O_DIRECT)
-		return nfs_file_direct_read(iocb, iov, nr_segs, pos);
+		return nfs_file_direct_read(iocb, iov, nr_segs, pos, true);
 
 	dprintk("NFS: read(%s/%s, %lu@%lu)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name,
@@ -482,6 +482,20 @@ static int nfs_launder_page(struct page 
 	return nfs_wb_page(inode, page);
 }
 
+#ifdef CONFIG_NFS_SWAP
+static int nfs_swap_activate(struct swap_info_struct *sis, struct file *file,
+						sector_t *span)
+{
+	*span = sis->pages;
+	return xs_swapper(NFS_CLIENT(file->f_mapping->host)->cl_xprt, 1);
+}
+
+static void nfs_swap_deactivate(struct file *file)
+{
+	xs_swapper(NFS_CLIENT(file->f_mapping->host)->cl_xprt, 0);
+}
+#endif
+
 const struct address_space_operations nfs_file_aops = {
 	.readpage = nfs_readpage,
 	.readpages = nfs_readpages,
@@ -496,6 +510,10 @@ const struct address_space_operations nf
 	.migratepage = nfs_migrate_page,
 	.launder_page = nfs_launder_page,
 	.error_remove_page = generic_error_remove_page,
+#ifdef CONFIG_NFS_SWAP
+	.swap_activate = nfs_swap_activate,
+	.swap_deactivate = nfs_swap_deactivate,
+#endif
 };
 
 /*
@@ -570,7 +588,7 @@ ssize_t nfs_file_write(struct kiocb *ioc
 	size_t count = iov_length(iov, nr_segs);
 
 	if (iocb->ki_filp->f_flags & O_DIRECT)
-		return nfs_file_direct_write(iocb, iov, nr_segs, pos);
+		return nfs_file_direct_write(iocb, iov, nr_segs, pos, true);
 
 	dprintk("NFS: write(%s/%s, %lu@%Ld)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name,
diff -puN include/linux/nfs_fs.h~nfs-enable-swap-on-nfs include/linux/nfs_fs.h
--- a/include/linux/nfs_fs.h~nfs-enable-swap-on-nfs
+++ a/include/linux/nfs_fs.h
@@ -473,10 +473,10 @@ extern ssize_t nfs_direct_IO(int, struct
 			unsigned long);
 extern ssize_t nfs_file_direct_read(struct kiocb *iocb,
 			const struct iovec *iov, unsigned long nr_segs,
-			loff_t pos);
+			loff_t pos, bool uio);
 extern ssize_t nfs_file_direct_write(struct kiocb *iocb,
 			const struct iovec *iov, unsigned long nr_segs,
-			loff_t pos);
+			loff_t pos, bool uio);
 
 /*
  * linux/fs/nfs/dir.c
diff -puN include/linux/sunrpc/xprt.h~nfs-enable-swap-on-nfs include/linux/sunrpc/xprt.h
--- a/include/linux/sunrpc/xprt.h~nfs-enable-swap-on-nfs
+++ a/include/linux/sunrpc/xprt.h
@@ -174,6 +174,8 @@ struct rpc_xprt {
 	unsigned long		state;		/* transport state */
 	unsigned char		shutdown   : 1,	/* being shut down */
 				resvport   : 1; /* use a reserved port */
+	unsigned int		swapper;	/* we're swapping over this
+						   transport */
 	unsigned int		bind_index;	/* bind function index */
 
 	/*
@@ -316,6 +318,7 @@ void			xprt_release_rqst_cong(struct rpc
 void			xprt_disconnect_done(struct rpc_xprt *xprt);
 void			xprt_force_disconnect(struct rpc_xprt *xprt);
 void			xprt_conditional_disconnect(struct rpc_xprt *xprt, unsigned int cookie);
+int			xs_swapper(struct rpc_xprt *xprt, int enable);
 
 /*
  * Reserved bit positions in xprt->state
diff -puN net/sunrpc/Kconfig~nfs-enable-swap-on-nfs net/sunrpc/Kconfig
--- a/net/sunrpc/Kconfig~nfs-enable-swap-on-nfs
+++ a/net/sunrpc/Kconfig
@@ -21,6 +21,11 @@ config SUNRPC_XPRT_RDMA
 
 	  If unsure, say N.
 
+config SUNRPC_SWAP
+	bool
+	depends on SUNRPC
+	select NETVM
+
 config RPCSEC_GSS_KRB5
 	tristate "Secure RPC: Kerberos V mechanism"
 	depends on SUNRPC && CRYPTO
diff -puN net/sunrpc/clnt.c~nfs-enable-swap-on-nfs net/sunrpc/clnt.c
--- a/net/sunrpc/clnt.c~nfs-enable-swap-on-nfs
+++ a/net/sunrpc/clnt.c
@@ -717,6 +717,15 @@ void rpc_task_set_client(struct rpc_task
 		atomic_inc(&clnt->cl_count);
 		if (clnt->cl_softrtry)
 			task->tk_flags |= RPC_TASK_SOFT;
+		if (sk_memalloc_socks()) {
+			struct rpc_xprt *xprt;
+
+			rcu_read_lock();
+			xprt = rcu_dereference(clnt->cl_xprt);
+			if (xprt->swapper)
+				task->tk_flags |= RPC_TASK_SWAPPER;
+			rcu_read_unlock();
+		}
 		/* Add to the client's list of all tasks */
 		spin_lock(&clnt->cl_lock);
 		list_add_tail(&task->tk_task, &clnt->cl_tasks);
diff -puN net/sunrpc/sched.c~nfs-enable-swap-on-nfs net/sunrpc/sched.c
--- a/net/sunrpc/sched.c~nfs-enable-swap-on-nfs
+++ a/net/sunrpc/sched.c
@@ -812,7 +812,10 @@ static void rpc_async_schedule(struct wo
 void *rpc_malloc(struct rpc_task *task, size_t size)
 {
 	struct rpc_buffer *buf;
-	gfp_t gfp = RPC_IS_SWAPPER(task) ? GFP_ATOMIC : GFP_NOWAIT;
+	gfp_t gfp = GFP_NOWAIT;
+
+	if (RPC_IS_SWAPPER(task))
+		gfp |= __GFP_MEMALLOC;
 
 	size += sizeof(struct rpc_buffer);
 	if (size <= RPC_BUFFER_MAXSIZE)
@@ -886,7 +889,7 @@ static void rpc_init_task(struct rpc_tas
 static struct rpc_task *
 rpc_alloc_task(void)
 {
-	return (struct rpc_task *)mempool_alloc(rpc_task_mempool, GFP_NOFS);
+	return (struct rpc_task *)mempool_alloc(rpc_task_mempool, GFP_NOIO);
 }
 
 /*
diff -puN net/sunrpc/xprtsock.c~nfs-enable-swap-on-nfs net/sunrpc/xprtsock.c
--- a/net/sunrpc/xprtsock.c~nfs-enable-swap-on-nfs
+++ a/net/sunrpc/xprtsock.c
@@ -1927,6 +1927,45 @@ out:
 	xprt_wake_pending_tasks(xprt, status);
 }
 
+#ifdef CONFIG_SUNRPC_SWAP
+static void xs_set_memalloc(struct rpc_xprt *xprt)
+{
+	struct sock_xprt *transport = container_of(xprt, struct sock_xprt,
+			xprt);
+
+	if (xprt->swapper)
+		sk_set_memalloc(transport->inet);
+}
+
+/**
+ * xs_swapper - Tag this transport as being used for swap.
+ * @xprt: transport to tag
+ * @enable: enable/disable
+ *
+ */
+int xs_swapper(struct rpc_xprt *xprt, int enable)
+{
+	struct sock_xprt *transport = container_of(xprt, struct sock_xprt,
+			xprt);
+	int err = 0;
+
+	if (enable) {
+		xprt->swapper++;
+		xs_set_memalloc(xprt);
+	} else if (xprt->swapper) {
+		xprt->swapper--;
+		sk_clear_memalloc(transport->inet);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(xs_swapper);
+#else
+static void xs_set_memalloc(struct rpc_xprt *xprt)
+{
+}
+#endif
+
 static void xs_udp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 {
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
@@ -1951,6 +1990,8 @@ static void xs_udp_finish_connecting(str
 		transport->sock = sock;
 		transport->inet = sk;
 
+		xs_set_memalloc(xprt);
+
 		write_unlock_bh(&sk->sk_callback_lock);
 	}
 	xs_udp_do_set_buffer_size(xprt);
@@ -2075,6 +2116,8 @@ static int xs_tcp_finish_connecting(stru
 	if (!xprt_bound(xprt))
 		goto out;
 
+	xs_set_memalloc(xprt);
+
 	/* Tell the socket layer to start connecting... */
 	xprt->stat.connect_count++;
 	xprt->stat.connect_start = jiffies;
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch

