From: akpm@linux-foundation.org
Subject: + ocfs2-nowait-aio-support.patch added to -mm tree
Date: Mon, 27 Nov 2017 15:36:47 -0800
Message-ID: <5a1ca18f.zj9MHf9AQy8zjGP/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46372 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752912AbdK0Xgs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Nov 2017 18:36:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ghe@suse.com, ge.changwei@h3c.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@versity.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: nowait aio support
has been added to the -mm tree.  Its filename is
     ocfs2-nowait-aio-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-nowait-aio-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-nowait-aio-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gang He <ghe@suse.com>
Subject: ocfs2: nowait aio support

Return EAGAIN if any of the following checks fail for direct I/O:

- Cannot get the related locks immediately

- Blocks are not allocated at the write location, it will trigger
  block allocation and block IO operations.

Link: http://lkml.kernel.org/r/1511775987-841-4-git-send-email-ghe@suse.com
Signed-off-by: Gang He <ghe@suse.com>
Cc: Mark Fasheh <mfasheh@versity.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c         |    2 -
 fs/ocfs2/dlmglue.c     |   20 +++++++---
 fs/ocfs2/dlmglue.h     |    2 -
 fs/ocfs2/file.c        |   74 ++++++++++++++++++++++++++++-----------
 fs/ocfs2/mmap.c        |    2 -
 fs/ocfs2/ocfs2_trace.h |   10 +++--
 6 files changed, 79 insertions(+), 31 deletions(-)

diff -puN fs/ocfs2/dir.c~ocfs2-nowait-aio-support fs/ocfs2/dir.c
--- a/fs/ocfs2/dir.c~ocfs2-nowait-aio-support
+++ a/fs/ocfs2/dir.c
@@ -1957,7 +1957,7 @@ int ocfs2_readdir(struct file *file, str
 
 	trace_ocfs2_readdir((unsigned long long)OCFS2_I(inode)->ip_blkno);
 
-	error = ocfs2_inode_lock_atime(inode, file->f_path.mnt, &lock_level);
+	error = ocfs2_inode_lock_atime(inode, file->f_path.mnt, &lock_level, 1);
 	if (lock_level && error >= 0) {
 		/* We release EX lock which used to update atime
 		 * and get PR lock again to reduce contention
diff -puN fs/ocfs2/dlmglue.c~ocfs2-nowait-aio-support fs/ocfs2/dlmglue.c
--- a/fs/ocfs2/dlmglue.c~ocfs2-nowait-aio-support
+++ a/fs/ocfs2/dlmglue.c
@@ -2516,13 +2516,18 @@ int ocfs2_inode_lock_with_page(struct in
 
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
 
@@ -2534,9 +2539,14 @@ int ocfs2_inode_lock_atime(struct inode
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
@@ -123,7 +123,7 @@ int ocfs2_try_open_lock(struct inode *in
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
@@ -2132,8 +2134,7 @@ out:
 }
 
 static int ocfs2_prepare_inode_for_write(struct file *file,
-					 loff_t pos,
-					 size_t count)
+					 loff_t pos, size_t count, int wait)
 {
 	int ret = 0, meta_level = 0;
 	struct dentry *dentry = file->f_path.dentry;
@@ -2145,10 +2146,14 @@ static int ocfs2_prepare_inode_for_write
 	 * if we need to make modifications here.
 	 */
 	for(;;) {
-		ret = ocfs2_inode_lock(inode, NULL, meta_level);
+		if (wait)
+			ret = ocfs2_inode_lock(inode, NULL, meta_level);
+		else
+			ret = ocfs2_try_inode_lock(inode, NULL, meta_level);
 		if (ret < 0) {
 			meta_level = -1;
-			mlog_errno(ret);
+			if (ret != -EAGAIN)
+				mlog_errno(ret);
 			goto out;
 		}
 
@@ -2199,7 +2204,7 @@ static int ocfs2_prepare_inode_for_write
 
 out_unlock:
 	trace_ocfs2_prepare_inode_for_write(OCFS2_I(inode)->ip_blkno,
-					    pos, count);
+					    pos, count, wait);
 
 	if (meta_level >= 0)
 		ocfs2_inode_unlock(inode, meta_level);
@@ -2211,7 +2216,7 @@ out:
 static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
 				    struct iov_iter *from)
 {
-	int direct_io, rw_level;
+	int rw_level;
 	ssize_t written = 0;
 	ssize_t ret;
 	size_t count = iov_iter_count(from);
@@ -2223,6 +2228,8 @@ static ssize_t ocfs2_file_write_iter(str
 	void *saved_ki_complete = NULL;
 	int append_write = ((iocb->ki_pos + count) >=
 			i_size_read(inode) ? 1 : 0);
+	int direct_io = iocb->ki_flags & IOCB_DIRECT ? 1 : 0;
+	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
 
 	trace_ocfs2_file_aio_write(inode, file, file->f_path.dentry,
 		(unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -2230,12 +2237,17 @@ static ssize_t ocfs2_file_write_iter(str
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
+	if (direct_io && nowait) {
+		if (!inode_trylock(inode))
+			return -EAGAIN;
+	} else
+		inode_lock(inode);
 
 	/*
 	 * Concurrent O_DIRECT writes are allowed with
@@ -2244,9 +2256,13 @@ static ssize_t ocfs2_file_write_iter(str
 	 */
 	rw_level = (!direct_io || full_coherency || append_write);
 
-	ret = ocfs2_rw_lock(inode, rw_level);
+	if (direct_io && nowait)
+		ret = ocfs2_try_rw_lock(inode, rw_level);
+	else
+		ret = ocfs2_rw_lock(inode, rw_level);
 	if (ret < 0) {
-		mlog_errno(ret);
+		if (ret != -EAGAIN)
+			mlog_errno(ret);
 		goto out_mutex;
 	}
 
@@ -2260,9 +2276,13 @@ static ssize_t ocfs2_file_write_iter(str
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
 
@@ -2277,9 +2297,17 @@ static ssize_t ocfs2_file_write_iter(str
 	}
 	count = ret;
 
-	ret = ocfs2_prepare_inode_for_write(file, iocb->ki_pos, count);
+	if (direct_io && nowait) {
+		if (!ocfs2_overwrite_io(inode, iocb->ki_pos, count, 0)) {
+			ret = -EAGAIN;
+			goto out;
+		}
+	}
+
+	ret = ocfs2_prepare_inode_for_write(file, iocb->ki_pos, count, !nowait);
 	if (ret < 0) {
-		mlog_errno(ret);
+		if (ret != -EAGAIN)
+			mlog_errno(ret);
 		goto out;
 	}
 
@@ -2355,6 +2383,7 @@ static ssize_t ocfs2_file_read_iter(stru
 	int ret = 0, rw_level = -1, lock_level = 0;
 	struct file *filp = iocb->ki_filp;
 	struct inode *inode = file_inode(filp);
+	int nowait = iocb->ki_flags & IOCB_NOWAIT ? 1 : 0;
 
 	trace_ocfs2_file_aio_read(inode, filp, filp->f_path.dentry,
 			(unsigned long long)OCFS2_I(inode)->ip_blkno,
@@ -2374,9 +2403,14 @@ static ssize_t ocfs2_file_read_iter(stru
 	 * need locks to protect pending reads from racing with truncate.
 	 */
 	if (iocb->ki_flags & IOCB_DIRECT) {
-		ret = ocfs2_rw_lock(inode, 0);
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
@@ -2393,9 +2427,11 @@ static ssize_t ocfs2_file_read_iter(stru
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

Patches currently in -mm which might be from ghe@suse.com are

ocfs2-get-rid-of-ocfs2_is_o2cb_active-function.patch
ocfs2-give-an-obvious-tip-for-dismatch-cluster-names.patch
ocfs2-give-an-obvious-tip-for-dismatch-cluster-names-v2.patch
ocfs2-move-some-definitions-to-header-file.patch
ocfs2-fix-some-small-problems.patch
ocfs2-add-kobject-for-online-file-check.patch
ocfs2-add-duplicative-ino-number-check.patch
ocfs2-add-ocfs2_try_rw_lock-and-ocfs2_try_inode_lock.patch
ocfs2-add-ocfs2_overwrite_io-function.patch
ocfs2-nowait-aio-support.patch

