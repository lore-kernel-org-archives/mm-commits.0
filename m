Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A68423E9D
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816304; cv=none; b=ZkaPELbiv55FhR7AY0o8vJRwGGPNmJ0L679EVgNR7XV9vu1245b+Sg4i9cRsofb1kURtYhYQzCyKHkJMQCFtd8ubMa9re9dazKLhavPcezFRwk/29Vx0ADeuaO58YX0/TrX9GahxFEWtLSGp+K9Mh3UL2JPhd56mZ4hlHu20lok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816304; c=relaxed/simple;
	bh=Ka/xBWgx65sOtBL3bnYvJ6e4PKkE3F0CtVXeChndKZI=;
	h=Date:To:From:Subject:Message-Id; b=gG5dwQts682B6c/iPkr6VS4X86/3plAbigyPVUd96jCXcgZxezSacRCeUsjTFbMlj7zhBdVENP7huHVh5Zu4tfzUs8v1OlvkMORvokoajax+XTEXdVc1LFCQkzYwf4pqR57HWhM15qZsERllPcTgzb+H48pBiXOnmr4PKm1qQJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a53CRSAl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a53CRSAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18E01F000E9;
	Tue,  4 Aug 2026 04:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816303;
	bh=X9qlNCEop+0COm4qdwGzgKShiDKIc6YYhTaUNHCqai4=;
	h=Date:To:From:Subject;
	b=a53CRSAleme24Q8xIg1b7NcQ3ZFYnsppTmiElMdDCcfOcrj0xHcDGB4tqpNHmQ/sX
	 E0NL4puSpZHYi5yOgdy8BBk3wxEe+QOB5qcJfatYkXGNRshuWtk9qbR+FjZBYSPRVC
	 l5ZDqW27PgbOQZLBH2MdQHJKrdh1RQPYEjLv5wyY=
Date: Mon, 03 Aug 2026 21:05:02 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,r772577952@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-fix-hung-task-in-orphan-recovery.patch removed from -mm tree
Message-Id: <20260804040502.E18E01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix hung task in orphan recovery
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-hung-task-in-orphan-recovery.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1867,6 +1867,7 @@ static int ocfs2_dir_foreach_blk_el(stru
 	struct super_block * sb = inode->i_sb;
 	unsigned int ra_sectors = 16;
 	int stored = 0;
+	int ret;
 
 	bh = NULL;
 
@@ -1874,9 +1875,13 @@ static int ocfs2_dir_foreach_blk_el(stru
 
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
 
@@ -1970,8 +1975,7 @@ static int ocfs2_dir_foreach_blk(struct
 int ocfs2_dir_foreach(struct inode *inode, struct dir_context *ctx)
 {
 	u64 version = inode_query_iversion(inode);
-	ocfs2_dir_foreach_blk(inode, &version, ctx, true);
-	return 0;
+	return ocfs2_dir_foreach_blk(inode, &version, ctx, true);
 }
 
 /*
@@ -2168,7 +2172,7 @@ out:
 /*
  * routine to check that the specified directory is empty (for rmdir)
  *
- * Returns 1 if dir is empty, zero otherwise.
+ * Returns 1 if dir is empty, zero if not, and a negative errno on error.
  *
  * XXX: This is a performance problem for unindexed directories.
  */
@@ -2181,8 +2185,10 @@ int ocfs2_empty_dir(struct inode *inode)
 
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
@@ -2190,8 +2196,10 @@ int ocfs2_empty_dir(struct inode *inode)
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


