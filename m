From: akpm@linux-foundation.org
Subject: [patch 023/119] ocfs2: nowait aio support
Date: Wed, 31 Jan 2018 16:15:25 -0800
Message-ID: <20180201001525.xQs1Wa5rE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33874 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754449AbeBAAP1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:15:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alex.chen@huawei.com, ge.changwei@h3c.com, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org, piaojun@huawei.com, torvalds@linux-foundation.org

From: Gang He <ghe@suse.com>
Subject: ocfs2: nowait aio support

Return EAGAIN if any of the following checks fail for direct I/O:

- Cannot get the related locks immediately

- Blocks are not allocated at the write location, it will trigger
  block allocation and block IO operations.

[ghe@suse.com: v4]
  Link: http://lkml.kernel.org/r/1516007283-29932-4-git-send-email-ghe@suse.com
[ghe@suse.com: v2]
  Link: http://lkml.kernel.org/r/1511944612-9629-4-git-send-email-ghe@suse.com
Link: http://lkml.kernel.org/r/1511775987-841-4-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Reviewed-by: Alex Chen <alex.chen@huawei.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c         |    2 
 fs/ocfs2/dlmglue.c     |   20 +++++--
 fs/ocfs2/dlmglue.h     |    2 
 fs/ocfs2/file.c        |  101 ++++++++++++++++++++++++++++++---------
 fs/ocfs2/mmap.c        |    2 
 fs/ocfs2/ocfs2_trace.h |   10 ++-
 6 files changed, 104 insertions(+), 33 deletions(-)

diff -puN fs/ocfs2/dir.c~ocfs2-nowait-aio-support fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-nowait-aio-support
+++ a/fs/ocfs2/dir.c
@@ -1958,7 +1958,7 @@ int ocfs2_readdir(struct file *file, str
 
 	trace_ocfs2_readdir((unsigned long long)OCFS2_I(inode)->ip_blkno);
 
-	error = ocfs2_inode_lock_atime(inode, file->f_path.mnt, &lock_level);
+	error = ocfs2_inode_lock_atime(inode, file->f_path.mnt, &lock_level, 1);
 	if (lock_level && error >= 0) {
 		/* We release EX lock which used to update atime
 		 * and get PR lock again to reduce contention
diff -puN fs/ocfs2/dlmglue.c~ocfs2-nowait-aio-support fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-nowait-aio-support
+++ a/fs/ocfs2/dlmglue.c
@@ -2546,13 +2546,18 @@ int ocfs2_inode_lock_with_page(struct in
 
 int ocfs2_inode_lock_atime(struct inode *inode,
 			  struct vfsmount *vfsmnt,
-			  int *level)
+			  int *level, int wait)
 {
 	int ret;
 
-	ret = ocfs2_inode_lock(inode, NULL, 0);
+	if (wait)
+		ret = ocfs2_inode_lock(inode, NULL, 0);
+	else
+		ret = ocfs2_try_inode_lock(inode, NULL, 0);
+
 	if (ret < 0) {
-		mlog_errno(ret);
+		if (ret != -EAGAIN)
+			mlog_errno(ret);
 		return ret;
 	}
 
@@ -2564,9 +2569,14 @@ int ocfs2_inode_lock_atime(struct inode
 		struct buffer_head *bh = NULL;
 
 		ocfs2_inode_unlock(inode, 0);
-		ret = ocfs2_inode_lock(inode, &bh, 1);
+		if (wait)
+			ret = ocfs2_inode_lock(inode, &bh, 1);
+		else
+			ret = ocfs2_try_inode_lock(inode, &bh, 1);
+
 		if (ret < 0) {
-			mlog_errno(ret);
+			if (ret != -EAGAIN)
+				mlog_errno(ret);
 			return ret;
 		}
 		*level = 1;
diff -puN fs/ocfs2/dlmglue.h~ocfs2-nowait-aio-support fs/ocfs2/dlmglue.h
--- a/fs/ocfs2/dlmglue.h~ocfs2-nowait-aio-support
+++ a/fs/ocfs2/dlmglue.h
@@ -146,7 +146,7 @@ int ocfs2_try_open_lock(struct inode *in
 void ocfs2_open_unlock(struct inode *inode);
 int ocfs2_inode_lock_atime(struct inode *inode,
 			  struct vfsmount *vfsmnt,
-			  int *level);
+			  int *level, int wait);
 int ocfs2_inode_lock_full_nested(struct inode *inode,
 			 struct buffer_head **ret_bh,
 			 int ex,
diff -puN fs/ocfs2/file.c~ocfs2-nowait-aio-support fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-nowait-aio-support
+++ a/fs/ocfs2/file.c
@@ -140,6 +140,8 @@ static int ocfs2_file_open(struct inode
 		spin_unlock(&oi->ip_lock);
 	}
 
+	file->f_mode |= FMODE_NOWAIT;
+
 leave:
 	return status;
 }
@@ -2132,12 +2134,12 @@ out:
 }
 
 static int ocfs2_prepare_inode_for_write(struct file *file,
-					 loff_t pos,
-					 size_t count)
+					 loff_t pos, size_t count, int wait)
 {
-	int ret = 0, meta_level = 0;
+	int ret = 0, meta_level = 0, overwrite_io = 0;
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = d_inode(dentry);
+	struct buffer_head *di_bh = NULL;
 	loff_t end;
 
 	/*
@@ -2145,13 +2147,40 @@ static int ocfs2_prepare_inode_for_write
 	 * if we need to make modifications here.
 	 */
 	for(;;) {
-		ret = ocfs2_inode_lock(inode, NULL, meta_level);
+		if (wait)
+			ret = ocfs2_inode_lock(inode, NULL, meta_level);
+		else
+			ret = ocfs2_try_inode_lock(inode,
+				overwrite_io ? NULL : &di_bh, meta_level);
 		if (ret < 0) {
 			meta_level = -1;
-			mlog_errno(ret);
+			if (ret != -EAGAIN)
+				mlog_errno(ret);
 			goto out;
 		}
 
+		/*
+		 * Check if IO will overwrite allocated blocks in case
+		 * IOCB_NOWAIT flag is set.
+		 */
+		if (!wait && !overwrite_io) {
+			overwrite_io = 1;
+			if (!down_read_trylock(&OCFS2_I(inode)->ip_alloc_sem)) {
+				ret = -EAGAIN;
+				goto out_unlock;
+			}
+
+			ret = ocfs2_overwrite_io(inode, di_bh, pos, count);
+			brelse(di_bh);
+			di_bh = NULL;
+			up_read(&OCFS2_I(inode)->ip_alloc_sem);
+			if (ret < 0) {
+				if (ret != -EAGAIN)
+					mlog_errno(ret);
+				goto out_unlock;
+			}
+		}
+
 		/* Clear suid / sgid if necessary. We do this here
 		 * instead of later in the write path because
 		 * remove_suid() calls ->setattr without any hint that
@@ -2199,7 +2228,9 @@ static int ocfs2_prepare_inode_for_write
 
 out_unlock:
 	trace_ocfs2_prepare_inode_for_write(OCFS2_I(inode)->ip_blkno,
-					    pos, count);
+					    pos, count, wait);
+
+	brelse(di_bh);
 
 	if (meta_level >= 0)
 		ocfs2_inode_unlock(inode, meta_level);
@@ -2211,7 +2242,7 @@ out:
 static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 				    struct iov_iter *from)
 {
-	int direct_io, rw_level;
+	int rw_level;
 	ssize_t written = 0;
 	ssize_t ret;
 	size_t count = iov_iter_count(from);
@@ -2223,6 +2254,8 @@ static ssize_t ocfs2_file_write_iter(str
 	void *saved_ki_complete = NULL;
 	int append_write = ((iocb->ki_pos + count) >=
 			i_size_read(inode) ? 1 : 0);
+	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
+	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
 
 	trace_ocfs2_file_aio_write(inode, file, file->f_path.dentry,
 		(unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -2230,12 +2263,17 @@ static ssize_t ocfs2_file_write_iter(str
 		file->f_path.dentry->d_name.name,
 		(unsigned int)from->nr_segs);	/* GRRRRR */
 
+	if (!direct_io && nowait)
+		return -EOPNOTSUPP;
+
 	if (count == 0)
 		return 0;
 
-	direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
-
-	inode_lock(inode);
+	if (nowait) {
+		if (!inode_trylock(inode))
+			return -EAGAIN;
+	} else
+		inode_lock(inode);
 
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
@@ -2244,9 +2282,13 @@ static ssize_t ocfs2_file_write_iter(str
 	 */
 	rw_level = (!direct_io || full_coherency || append_write);
 
-	ret = ocfs2_rw_lock(inode, rw_level);
+	if (nowait)
+		ret = ocfs2_try_rw_lock(inode, rw_level);
+	else
+		ret = ocfs2_rw_lock(inode, rw_level);
 	if (ret < 0) {
-		mlog_errno(ret);
+		if (ret != -EAGAIN)
+			mlog_errno(ret);
 		goto out_mutex;
 	}
 
@@ -2260,9 +2302,13 @@ static ssize_t ocfs2_file_write_iter(str
 		 * other nodes to drop their caches.  Buffered I/O
 		 * already does this in write_begin().
 		 */
-		ret = ocfs2_inode_lock(inode, NULL, 1);
+		if (nowait)
+			ret = ocfs2_try_inode_lock(inode, NULL, 1);
+		else
+			ret = ocfs2_inode_lock(inode, NULL, 1);
 		if (ret < 0) {
-			mlog_errno(ret);
+			if (ret != -EAGAIN)
+				mlog_errno(ret);
 			goto out;
 		}
 
@@ -2277,9 +2323,10 @@ static ssize_t ocfs2_file_write_iter(str
 	}
 	count = ret;
 
-	ret = ocfs2_prepare_inode_for_write(file, iocb->ki_pos, count);
+	ret = ocfs2_prepare_inode_for_write(file, iocb->ki_pos, count, !nowait);
 	if (ret < 0) {
-		mlog_errno(ret);
+		if (ret != -EAGAIN)
+			mlog_errno(ret);
 		goto out;
 	}
 
@@ -2355,6 +2402,8 @@ static ssize_t ocfs2_file_read_iter(stru
 	int ret = 0, rw_level = -1, lock_level = 0;
 	struct file *filp = iocb->ki_filp;
 	struct inode *inode = file_inode(filp);
+	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
+	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
 
 	trace_ocfs2_file_aio_read(inode, filp, filp->f_path.dentry,
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -2369,14 +2418,22 @@ static ssize_t ocfs2_file_read_iter(stru
 		goto bail;
 	}
 
+	if (!direct_io && nowait)
+		return -EOPNOTSUPP;
+
 	/*
 	 * buffered reads protect themselves in ->readpage().  O_DIRECT reads
 	 * need locks to protect pending reads from racing with truncate.
 	 */
-	if (iocb->ki_flags & IOCB_DIRECT) {
-		ret = ocfs2_rw_lock(inode, 0);
+	if (direct_io) {
+		if (nowait)
+			ret = ocfs2_try_rw_lock(inode, 0);
+		else
+			ret = ocfs2_rw_lock(inode, 0);
+
 		if (ret < 0) {
-			mlog_errno(ret);
+			if (ret != -EAGAIN)
+				mlog_errno(ret);
 			goto bail;
 		}
 		rw_level = 0;
@@ -2393,9 +2450,11 @@ static ssize_t ocfs2_file_read_iter(stru
 	 * like i_size. This allows the checks down below
 	 * generic_file_aio_read() a chance of actually working.
 	 */
-	ret = ocfs2_inode_lock_atime(inode, filp->f_path.mnt, &lock_level);
+	ret = ocfs2_inode_lock_atime(inode, filp->f_path.mnt, &lock_level,
+				     !nowait);
 	if (ret < 0) {
-		mlog_errno(ret);
+		if (ret != -EAGAIN)
+			mlog_errno(ret);
 		goto bail;
 	}
 	ocfs2_inode_unlock(inode, lock_level);
diff -puN fs/ocfs2/mmap.c~ocfs2-nowait-aio-support fs/ocfs2/mmap.c
--- a/fs/ocfs2/mmap.c~ocfs2-nowait-aio-support
+++ a/fs/ocfs2/mmap.c
@@ -184,7 +184,7 @@ int ocfs2_mmap(struct file *file, struct
 	int ret = 0, lock_level = 0;
 
 	ret = ocfs2_inode_lock_atime(file_inode(file),
-				    file->f_path.mnt, &lock_level);
+				    file->f_path.mnt, &lock_level, 1);
 	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
diff -puN fs/ocfs2/ocfs2_trace.h~ocfs2-nowait-aio-support fs/ocfs2/ocfs2_trace.h
--- a/fs/ocfs2/ocfs2_trace.h~ocfs2-nowait-aio-support
+++ a/fs/ocfs2/ocfs2_trace.h
@@ -1449,20 +1449,22 @@ DEFINE_OCFS2_ULL_ULL_ULL_EVENT(ocfs2_rem
 
 TRACE_EVENT(ocfs2_prepare_inode_for_write,
 	TP_PROTO(unsigned long long ino, unsigned long long saved_pos,
-		 unsigned long count),
-	TP_ARGS(ino, saved_pos, count),
+		 unsigned long count, int wait),
+	TP_ARGS(ino, saved_pos, count, wait),
 	TP_STRUCT__entry(
 		__field(unsigned long long, ino)
 		__field(unsigned long long, saved_pos)
 		__field(unsigned long, count)
+		__field(int, wait)
 	),
 	TP_fast_assign(
 		__entry->ino = ino;
 		__entry->saved_pos = saved_pos;
 		__entry->count = count;
+		__entry->wait = wait;
 	),
-	TP_printk("%llu %llu %lu", __entry->ino,
-		  __entry->saved_pos, __entry->count)
+	TP_printk("%llu %llu %lu %d", __entry->ino,
+		  __entry->saved_pos, __entry->count, __entry->wait)
 );
 
 DEFINE_OCFS2_INT_EVENT(generic_file_aio_read_ret);
_
