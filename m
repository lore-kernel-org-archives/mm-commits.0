Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703BD3B47CB
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 23:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783034067; cv=none; b=TXkFAcxfhzUcYvPnbls9Zqb14a6pw9dKCluFaUhLXzG80doLy3jKHnIUGgdBiO7O/zJ1r/L6eJvydnqqGyxK1LEBw5HOsacITx4pDN/aDJ9UDhpK0RHVS3qWHtTL7IIK0jYwiSBOwTN1d5rxOkvnTq6celx5c030owh++w+xZhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783034067; c=relaxed/simple;
	bh=y1jdSj2Hsks39R4KH1flbIsoAwB1rN7fb5IBjns3ciI=;
	h=Date:To:From:Subject:Message-Id; b=j8JJUaPc3qyuvsL5Q9FA8GHJ3Xma49OeMfjNGtbKfMhWaMiqn1pkiyndpYdjEoLHB1Fin6a1C8N8Ke39zCLGz0490vhykPSfZgWIsl3xkIS07eXygBQmNBloKvqcYkSbKCFZ3SZNNPi8NIjNsy2IlzHrdpNIRzwORE0iREP6nhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lf3+S8cU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lf3+S8cU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26AE91F000E9;
	Thu,  2 Jul 2026 23:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783034066;
	bh=SeKJwwLbS4OcxUa78l6GBjuqJjd2PIAM4efSjK9M9YY=;
	h=Date:To:From:Subject;
	b=lf3+S8cU/g3d0KzLkg66qWtjYLQ6vjGoY3mkPjKq7BmcACeWgxenzSe4TCrMloNNU
	 lhegTJnoJwZSV0TThoIHIP05W2YDB5jx3vPopFuI3w1hKt93yajZVdsOHO0SDfwDM6
	 2vbSCIRW1x5noQpE/AAn1/E4zSY2C3Kh4ip77he4=
Date: Thu, 02 Jul 2026 16:14:25 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,r772577952@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-fix-hung-task-in-orphan-recovery.patch added to mm-nonmm-unstable branch
Message-Id: <20260702231426.26AE91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: fix hung task in orphan recovery
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-fix-hung-task-in-orphan-recovery.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-fix-hung-task-in-orphan-recovery.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Jiaming Zhang <r772577952@gmail.com>
Subject: ocfs2: fix hung task in orphan recovery
Date: Thu, 2 Jul 2026 17:05:07 +0800

A crafted OCFS2 image with corrupted orphan-directory extent metadata can
make umount hang.

During unmount, ocfs2_recovery_disable() waits for the
ocfs2_complete_recovery work item to finish.  The worker scans the orphan
directory through ocfs2_queue_orphans() and ocfs2_dir_foreach().  If
ocfs2_read_dir_block() fails on a corrupted directory block,
ocfs2_dir_foreach_blk_el() skips the block and continues walking.  On a
badly corrupted directory this can keep orphan recovery busy for a long
time, leaving umount blocked while flushing osb->ocfs2_wq.

Return the read error immediately for full directory scans and propagate
the error from ocfs2_dir_foreach().  When ocfs2_empty_dir() receives such
an error, report the directory as non-empty so unlink/rmdir does not
proceed on an unreadable directory.

Link: https://lore.kernel.org/20260702090507.446517-1-r772577952@gmail.com
Closes: https://lore.kernel.org/lkml/CANypQFbWH76Y6LWHEwAvTP7aQL04uMJ=dDyL6YDmxa3fv3Tyjg@mail.gmail.com/
Assisted-by: Codex:gpt-5.5-xhigh
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dir.c   |   20 ++++++++++++++------
 fs/ocfs2/namei.c |   11 ++++++++---
 2 files changed, 22 insertions(+), 9 deletions(-)

--- a/fs/ocfs2/dir.c~ocfs2-fix-hung-task-in-orphan-recovery
+++ a/fs/ocfs2/dir.c
@@ -1866,6 +1866,7 @@ static int ocfs2_dir_foreach_blk_el(stru
 	struct super_block * sb = inode->i_sb;
 	unsigned int ra_sectors = 16;
 	int stored = 0;
+	int ret;
 
 	bh = NULL;
 
@@ -1873,9 +1874,13 @@ static int ocfs2_dir_foreach_blk_el(stru
 
 	while (ctx->pos < i_size_read(inode)) {
 		blk = ctx->pos >> sb->s_blocksize_bits;
-		if (ocfs2_read_dir_block(inode, blk, &bh, 0)) {
+		ret = ocfs2_read_dir_block(inode, blk, &bh, 0);
+		if (ret) {
+			if (persist)
+				return ret;
 			/* Skip the corrupt dirblock and keep trying */
 			ctx->pos += sb->s_blocksize - offset;
+			offset = 0;
 			continue;
 		}
 
@@ -1969,8 +1974,7 @@ static int ocfs2_dir_foreach_blk(struct
 int ocfs2_dir_foreach(struct inode *inode, struct dir_context *ctx)
 {
 	u64 version = inode_query_iversion(inode);
-	ocfs2_dir_foreach_blk(inode, &version, ctx, true);
-	return 0;
+	return ocfs2_dir_foreach_blk(inode, &version, ctx, true);
 }
 
 /*
@@ -2167,7 +2171,7 @@ out:
 /*
  * routine to check that the specified directory is empty (for rmdir)
  *
- * Returns 1 if dir is empty, zero otherwise.
+ * Returns 1 if dir is empty, zero if not, and a negative errno on error.
  *
  * XXX: This is a performance problem for unindexed directories.
  */
@@ -2180,8 +2184,10 @@ int ocfs2_empty_dir(struct inode *inode)
 
 	if (ocfs2_dir_indexed(inode)) {
 		ret = ocfs2_empty_dir_dx(inode, &priv);
-		if (ret)
+		if (ret) {
 			mlog_errno(ret);
+			return ret;
+		}
 		/*
 		 * We still run ocfs2_dir_foreach to get the checks
 		 * for "." and "..".
@@ -2189,8 +2195,10 @@ int ocfs2_empty_dir(struct inode *inode)
 	}
 
 	ret = ocfs2_dir_foreach(inode, &priv.ctx);
-	if (ret)
+	if (ret) {
 		mlog_errno(ret);
+		return ret;
+	}
 
 	if (!priv.seen_dot || !priv.seen_dot_dot) {
 		mlog(ML_ERROR, "bad directory (dir #%llu) - no `.' or `..'\n",
--- a/fs/ocfs2/namei.c~ocfs2-fix-hung-task-in-orphan-recovery
+++ a/fs/ocfs2/namei.c
@@ -945,7 +945,10 @@ static int ocfs2_unlink(struct inode *di
 	child_locked = 1;
 
 	if (S_ISDIR(inode->i_mode)) {
-		if (inode->i_nlink != 2 || !ocfs2_empty_dir(inode)) {
+		status = ocfs2_empty_dir(inode);
+		if (status < 0)
+			goto leave;
+		if (inode->i_nlink != 2 || !status) {
 			status = -ENOTEMPTY;
 			goto leave;
 		}
@@ -1499,8 +1502,10 @@ static int ocfs2_rename(struct mnt_idmap
 
 	if (target_exists) {
 		if (S_ISDIR(new_inode->i_mode)) {
-			if (new_inode->i_nlink != 2 ||
-			    !ocfs2_empty_dir(new_inode)) {
+			status = ocfs2_empty_dir(new_inode);
+			if (status < 0)
+				goto bail;
+			if (new_inode->i_nlink != 2 || !status) {
 				status = -ENOTEMPTY;
 				goto bail;
 			}
_

Patches currently in -mm which might be from r772577952@gmail.com are

ocfs2-fix-hung-task-in-orphan-recovery.patch

